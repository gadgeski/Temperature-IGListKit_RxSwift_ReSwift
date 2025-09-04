//
//  IGListContainerViewRepresentable.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/29.
//

// Presentation/IGListKitBridge/Bridge/IGListContainerViewRepresentable.swift
import SwiftUI
import Combine
import UIKit
import IGListKit

/// Bridge: SwiftUI ↔️ UIKit（IGListKitはUIKit側で動かす）
struct IGListContainerViewRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = IGListHostingViewController

    /// 上流（Domain側）からの温度配列ストリーム
    let publisher: AnyPublisher<[Temperature], Never>

    // 依存注入（B案）。デフォルトは A案（DEBUGで閾値↓）に追随
    let thresholds: Thresholds
    let debugForcedEvent: WeatherEvent?

    init(
        publisher: AnyPublisher<[Temperature], Never>,
        thresholds: Thresholds? = nil,
        debugForcedEvent: WeatherEvent? = nil
    ) {
        self.publisher = publisher
        #if DEBUG
        if let t = thresholds {
            self.thresholds = t
        } else if FeatureFlags.previewLowerThresholds {
            self.thresholds = FeatureFlags.previewThresholds
        } else {
            self.thresholds = Thresholds()
        }
        #else
        self.thresholds = thresholds ?? Thresholds()
        #endif
        self.debugForcedEvent = debugForcedEvent
    }

    func makeUIViewController(context: Context) -> IGListHostingViewController {
        let vc = IGListHostingViewController()
        context.coordinator.bind(
            publisher: publisher,
            to: vc,
            thresholds: thresholds,
            forced: debugForcedEvent
        )
        return vc
    }

    func updateUIViewController(_ uiViewController: IGListHostingViewController, context: Context) {
        // no-op（更新はCombine経由で流れてくる）
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    // MARK: - Coordinator

    final class Coordinator {
        private var cancellable: AnyCancellable?
        private var lastNotified: WeatherEventKind?    // 連発抑止（簡易）

        /// 既存の“温度一覧”をIGList表示用に変換
        // CHANGED(any): 戻り値を [any ListDiffable] に
        private func baseItems(_ temps: [Temperature]) -> [any ListDiffable] {
            if temps.isEmpty {
                // CHANGED(any): 要素を any でキャスト
                return [LoadingItem(state: .empty) as any ListDiffable]
            }
            // CHANGED(any): 変数・配列要素とも any を明示
            let header: any ListDiffable = HeaderItem(title: "Temperatures")
            let rows: [any ListDiffable] = temps.map { TemperatureItem($0) as any ListDiffable }
            return [header] + rows
        }

        /// PublisherをVCに結線し、イベント検知→セクタ提案→IGList差し込み＋通知までを注入
        // CHANGED(any): map の戻り型を [any ListDiffable] に
        func bind(
            publisher: AnyPublisher<[Temperature], Never>,
            to vc: IGListHostingViewController,
            thresholds: Thresholds,
            forced: WeatherEvent?
        ) {
            cancellable = publisher
                .map { (temps: [Temperature]) -> [any ListDiffable] in
                    // 1) 通常の温度リスト
                    // CHANGED(any): items の型を [any ListDiffable] に
                    var items: [any ListDiffable] = self.baseItems(temps)

                    // 2) 猛暑/寒波イベントの検知（強制イベントがあればそれを優先）
                    let detected = forced ?? WeatherAlertsProvider.detectExtreme(from: temps, thresholds: thresholds)
                    if let event = detected {
                        // 3) セクタ提案を生成
                        let suggestions = SectorMappingProvider.shared.suggestions(for: event)

                        // 4) バナーと「気になる銘柄」見出し＋チップ群を先頭に差し込む
                        let bannerTitle: String
                        let bannerSubtitle: String
                        switch event.kind {
                        case .heatwave:
                            bannerTitle = "猛暑の見込み（\(event.region)）"
                            bannerSubtitle = "飲料・空調・UV関連に注目の可能性"
                        case .coldwave:
                            bannerTitle = "寒波の見込み（\(event.region)）"
                            bannerSubtitle = "暖房器具・衣料・ガス関連に注目の可能性"
                        }

                        // CHANGED(any): バナー・見出し・チップに any を付与
                        let banner: any ListDiffable = AlertBannerItem(
                            title: bannerTitle,
                            subtitle: bannerSubtitle,
                            kind: event.kind
                        ) as any ListDiffable

                        let chips: [any ListDiffable] = suggestions.map {
                            SectorChipItem(sectorName: $0.sectorName, count: $0.tickers.count) as any ListDiffable
                        }

                        let picksHeader: any ListDiffable = HeaderItem(title: "気になる銘柄")

                        // CHANGED(any): 配列結合の型も [any ListDiffable]
                        let preface: [any ListDiffable] = [banner, picksHeader] + chips
                        items.insert(contentsOf: preface.reversed(), at: 0)

                        // 5) 通知（簡易な連発防止つき）
                        if self.lastNotified != event.kind {
                            self.lastNotified = event.kind
                            AlertNotificationScheduler.schedule(event: event)
                        }
                    }

                    return items
                }
                .receive(on: DispatchQueue.main) // 実行ディスパッチ（型のアクター隔離は別途）
                // CHANGED(any): sink の引数型も [any ListDiffable]
                .sink { (viewItems: [any ListDiffable]) in
                    // updateは@MainActor隔離なので明示ホップ
                    Task { @MainActor in
                        vc.update(objects: viewItems) // ← Swift 6 では update の引数も [any ListDiffable] に合わせてください
                    }
                }
        }
    }
}
