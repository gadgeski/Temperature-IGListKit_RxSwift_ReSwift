//
//  TemperatureFeedViewIGL.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/29.
//

// Presentation/SwiftUI/TemperatureFeedViewIGL.swift
import SwiftUI
import Combine

struct TemperatureFeedViewIGL: View {
    private let subject = PassthroughSubject<[Temperature], Never>()

    // 依存注入（B案）— しきい値＆強制イベント（未指定なら従来挙動/A案に委ねる）
    let thresholds: Thresholds?
    let forced: WeatherEvent?

    init(thresholds: Thresholds? = nil, forced: WeatherEvent? = nil) {
        self.thresholds = thresholds
        self.forced = forced
    }

    // プレビュー/実機でも一度だけデモデータを流すためのフラグ
    @State private var didSeedDemo = false

    var body: some View {
        IGListContainerViewRepresentable(
            publisher: subject.eraseToAnyPublisher(),
            thresholds: thresholds,          // B案注入（nilならA案既定に従う）
            debugForcedEvent: forced         // 強制イベント（猛暑/寒波など）
        )
        .ignoresSafeArea(edges: .bottom)
        .task {
            guard !didSeedDemo else { return }
            didSeedDemo = true
            let now = Date()
            subject.send([
                .init(region: "Tokyo",    celsius: 33.4, date: now),
                .init(region: "Osaka",    celsius: 34.1, date: now),
                .init(region: "Fukuoka",  celsius: 32.0, date: now),
                .init(region: "Shizuoka", celsius: 31.2, date: now), // CHANGED(2-1): 追加
                .init(region: "Nagoya",   celsius: 35.0, date: now), // CHANGED(2-1): 追加
                .init(region: "Kyoto",    celsius: 34.6, date: now)  // CHANGED(2-1): 追加
            ])
        }
    }
}
