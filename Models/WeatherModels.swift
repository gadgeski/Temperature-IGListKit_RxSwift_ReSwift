//
//  WeatherModels.swift
//  Temperature_IGListKit_RxSwift_ReSwift.entitlements
//
//  Created by Dev Tech on 2025/09/05.
//

import SwiftUI

// 🌦️ 天気データモデル群
public struct WeatherData {
    public let temperature: Double
    public let condition: WeatherCondition
    public let humidity: Int
    public let windSpeed: Double
    public let location: String
    public let hourlyForecast: [HourlyWeather]
    public let alerts: [WeatherAlert]

    public init(
        temperature: Double,
        condition: WeatherCondition,
        humidity: Int,
        windSpeed: Double,
        location: String,
        hourlyForecast: [HourlyWeather],
        alerts: [WeatherAlert]
    ) {
        self.temperature = temperature
        self.condition = condition
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.location = location
        self.hourlyForecast = hourlyForecast
        self.alerts = alerts
    }
}

public enum WeatherCondition: String, CaseIterable {
    case sunny  = "sun.max.fill"
    case cloudy = "cloud.fill"
    case rainy  = "cloud.rain.fill"
    case stormy = "cloud.bolt.fill"

    public var gradientColors: [Color] {
        switch self {
        case .sunny:  return [.sunnyGradientTop,  .sunnyGradientBottom]
        case .cloudy: return [.cloudyGradientTop, .cloudyGradientBottom]
        case .rainy, .stormy:
            return [.rainyGradientTop,  .rainyGradientBottom]
        }
    }
}

public struct HourlyWeather {
    public let time: String
    public let temperature: Double
    public let condition: WeatherCondition

    public init(time: String, temperature: Double, condition: WeatherCondition) {
        self.time = time
        self.temperature = temperature
        self.condition = condition
    }
}

public struct WeatherAlert {
    public let title: String
    public let severity: AlertSeverity
    public let description: String

    public init(title: String, severity: AlertSeverity, description: String) {
        self.title = title
        self.severity = severity
        self.description = description
    }
}

public enum AlertSeverity {
    case low, medium, high

    // NOTE: モデルからUI（Color）を返すのは責務が重くなります。
    // 既存API互換のため残していますが、将来は View 側にマッピングを逃がすのがよりSRPです。
    public var color: Color {
        switch self {
        case .low:    return .green
        case .medium: return .orange
        case .high:   return .red
        }
    }
}
