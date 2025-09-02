//
//  IGListHostingViewController+Preview.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/31.
//

// Presentation/IGListKitBridge/Bridge/IGListHostingViewController+Preview.swift
#if DEBUG && canImport(SwiftUI)
import SwiftUI
import IGListKit

// NOTE: UIViewControllerPreview は PreviewHelpers.swift に定義済みの共通ヘルパを使用

// 基本（通常）シナリオ – バナー無し / 温度のみ
#Preview("VC – Base temperatures") {
    UIViewControllerPreview {
        let vc = IGListHostingViewController()
        vc.loadViewIfNeeded()

        let header: ListDiffable = HeaderItem(title: "Preview – Temperatures")
        let rows: [ListDiffable] = [
            TemperatureItem(Temperature(region: "Tokyo",   celsius: 33.4, date: .now)) as ListDiffable,
            TemperatureItem(Temperature(region: "Osaka",   celsius: 34.1, date: .now)) as ListDiffable,
            TemperatureItem(Temperature(region: "Fukuoka", celsius: 32.0, date: .now)) as ListDiffable
        ]

        Task { @MainActor in
            vc.update(objects: [header] + rows, animated: false)
        }
        return vc
    }
    .frame(width: 393, height: 600)
}

// 猛暑シナリオ – バナー + セクタチップ + 温度
#Preview("VC – Heatwave scenario") {
    UIViewControllerPreview {
        let vc = IGListHostingViewController()
        vc.loadViewIfNeeded()

        // バナー（kind を必ず渡す）
        let banner: ListDiffable = AlertBannerItem(
            title: "猛暑の見込み（Tokyo）",
            subtitle: "飲料・空調・UV関連に注目の可能性",
            kind: .heatwave                // CHANGED(kind)
        ) as ListDiffable

        // セクタチップ
        let chips: [ListDiffable] = [
            SectorChipItem(sectorName: "飲料",    count: 3),
            SectorChipItem(sectorName: "空調",    count: 2),
            SectorChipItem(sectorName: "UV/冷感", count: 2)
        ].map { $0 as ListDiffable }

        // 温度リスト
        let header: ListDiffable = HeaderItem(title: "Preview – Temperatures")
        let rows: [ListDiffable] = [
            TemperatureItem(Temperature(region: "Tokyo", celsius: 36.5, date: .now)) as ListDiffable
        ]

        Task { @MainActor in
            vc.update(objects: [banner] + chips + [header] + rows, animated: false)
        }
        return vc
    }
    .frame(width: 393, height: 600)
}

// 寒波シナリオ – バナー + セクタチップ + 温度
#Preview("VC – Coldwave scenario") {
    UIViewControllerPreview {
        let vc = IGListHostingViewController()
        vc.loadViewIfNeeded()

        // バナー（kind を必ず渡す）
        let banner: ListDiffable = AlertBannerItem(
            title: "寒波の見込み（Sapporo）",
            subtitle: "暖房器具・衣料・ガス関連に注目の可能性",
            kind: .coldwave               // CHANGED(kind)
        ) as ListDiffable

        // セクタチップ
        let chips: [ListDiffable] = [
            SectorChipItem(sectorName: "暖房器具", count: 2),
            SectorChipItem(sectorName: "衣料",   count: 1),
            SectorChipItem(sectorName: "ガス",   count: 2)
        ].map { $0 as ListDiffable }

        // 温度リスト
        let header: ListDiffable = HeaderItem(title: "Preview – Temperatures")
        let rows: [ListDiffable] = [
            TemperatureItem(Temperature(region: "Sapporo", celsius: -3.0, date: .now)) as ListDiffable
        ]

        Task { @MainActor in
            vc.update(objects: [banner] + chips + [header] + rows, animated: false)
        }
        return vc
    }
    .frame(width: 393, height: 600)
}
#endif
