//
//  WeatherAlertsProvider.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/31.
//

// Services/WeatherAlertsProvider.swift
import Foundation

/// 温度配列から極端気温イベント（猛暑/寒波）を検知する
enum WeatherAlertsProvider {

    /// - Parameters:
    ///   - temps: 地点ごとの気温配列
    ///   - thresholds: 猛暑/寒波のしきい値
    /// - Returns: 該当イベントがあれば WeatherEvent（無ければ nil）
    static func detectExtreme(from temps: [Temperature], thresholds: Thresholds) -> WeatherEvent? {
        guard !temps.isEmpty else { return nil }

        // CHANGED(2-2): 猛暑は「気温が最も高い地点」を採用し、しきい値以上なら発火
        if let hottest = temps.max(by: { $0.celsius < $1.celsius }),
           hottest.celsius >= thresholds.heatwaveMaxCelsius {
            return WeatherEvent(kind: .heatwave, region: hottest.region, date: Date())
        }

        // CHANGED(2-2): 寒波は「気温が最も低い地点」を採用し、しきい値以下なら発火
        if let coldest = temps.min(by: { $0.celsius < $1.celsius }),
           coldest.celsius <= thresholds.coldwaveMaxCelsius {
            return WeatherEvent(kind: .coldwave, region: coldest.region, date: Date())
        }

        return nil
    }
}
