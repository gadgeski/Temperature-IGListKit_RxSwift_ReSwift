//
//  MockWeatherDataService.swift
//  Temperature_IGListKit_RxSwift_ReSwift.entitlements
//
//  Created by Dev Tech on 2025/09/05.
//

import Foundation

// API通信をシミュレートし、天気データを返すサービス
final class MockWeatherDataService {

    // 様々な気温データセットを擬似的に用意
    private static let heatwaveTemperatures: [Temperature] = [
        .init(region: "東京", celsius: 36.2, date: .now),
        .init(region: "大阪", celsius: 35.5, date: .now),
        .init(region: "名古屋", celsius: 37.0, date: .now)
    ]

    private static let coldwaveTemperatures: [Temperature] = [
        .init(region: "札幌", celsius: -5.1, date: .now),
        .init(region: "旭川", celsius: -8.3, date: .now),
        .init(region: "青森", celsius: -2.0, date: .now)
    ]

    private static let normalTemperatures: [Temperature] = [
        .init(region: "東京", celsius: 25.4, date: .now),
        .init(region: "大阪", celsius: 26.1, date: .now),
        .init(region: "福岡", celsius: 24.8, date: .now)
    ]

    // 呼び出されるたびにシナリオを切り替えるためのインデックス
    private var scenarioIndex = 0

    /// 天気データを非同期で取得する（という想定の）関数
    func fetchWeatherData() async -> (temperatures: [Temperature], condition: WeatherCondition) {
        // 擬似的に0.5秒待つ
        try? await Task.sleep(nanoseconds: 500_000_000)

        // シナリオを順番に切り替える
        let scenario = scenarioIndex % 3
        scenarioIndex += 1

        switch scenario {
        case 0:
            return (Self.heatwaveTemperatures, .sunny)
        case 1:
            return (Self.coldwaveTemperatures, .cloudy) // 寒波なので曇りアイコンに
        default:
            return (Self.normalTemperatures, .sunny)
        }
    }
}
