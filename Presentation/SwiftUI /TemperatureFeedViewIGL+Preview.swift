//
//  TemperatureFeedViewIGL+Preview.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/31.
//

#if DEBUG && canImport(SwiftUI)
import SwiftUI

// ADD: シナリオ別に“確実に出す”プレビュー（B案の注入を利用）
#Preview("IGL – Heatwave forced") { // 猛暑バナー＋チップを強制表示
    TemperatureFeedViewIGL(
        thresholds: .init(heatwaveMaxCelsius: 35, coldwaveMaxCelsius: 0), // CHANGED: 明示注入
        forced: WeatherEvent(kind: .heatwave, region: "Tokyo", date: .now) // CHANGED: 強制イベント
    )
    .frame(height: 420)
}

#Preview("IGL – Coldwave forced") { // 寒波バナー＋チップを強制表示
    TemperatureFeedViewIGL(
        thresholds: .init(heatwaveMaxCelsius: 35, coldwaveMaxCelsius: 0), // CHANGED
        forced: WeatherEvent(kind: .coldwave, region: "Sapporo", date: .now) // CHANGED
    )
    .frame(height: 420)
}

#Preview("IGL – Normal (no alert)") { // アラートが出ない通常ケース
    TemperatureFeedViewIGL(
        thresholds: .init(heatwaveMaxCelsius: 100, coldwaveMaxCelsius: -100), // CHANGED: 事実上無効化
        forced: nil
    )
    .frame(height: 420)
}
#endif
