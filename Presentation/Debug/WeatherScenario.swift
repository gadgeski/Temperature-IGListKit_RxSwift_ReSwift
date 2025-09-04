//
//  WeatherScenario.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/31.
//

#if DEBUG
import Foundation

enum WeatherScenario: String, CaseIterable, Identifiable {
    case normal, heatwave, coldwave
    var id: String { rawValue }
}

extension WeatherScenario {
    // ContentView → TemperatureFeedViewIGL に渡す値
    var thresholds: Thresholds? {
        switch self {
        case .normal:
            // 事実上“検知しない”設定（A案がONでもここが優先）
            return .init(heatwaveMaxCelsius: 100, coldwaveMaxCelsius: -100)
        case .heatwave:
            return .init(heatwaveMaxCelsius: 35, coldwaveMaxCelsius: 0)
        case .coldwave:
            return .init(heatwaveMaxCelsius: 35, coldwaveMaxCelsius: 0)
        }
    }

    var forced: WeatherEvent? {
        switch self {
        case .normal:
            return nil
        case .heatwave:
            return WeatherEvent(kind: .heatwave, region: "Tokyo", date: .now)
        case .coldwave:
            return WeatherEvent(kind: .coldwave, region: "Sapporo", date: .now)
        }
    }

    var label: String {
        switch self {
        case .normal:  return "通常"
        case .heatwave:return "猛暑"
        case .coldwave:return "寒波"
        }
    }
}
#endif
