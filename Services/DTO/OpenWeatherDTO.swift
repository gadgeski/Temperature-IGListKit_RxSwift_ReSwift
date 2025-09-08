//
//  OpenWeatherDTO.swift
//  Temperature_IGListKit_RxSwift_ReSwift.entitlements
//
//  Created by Dev Tech on 2025/09/07.
//

// ADDED: このファイルは新規作成です
import Foundation

// APIのレスポンス全体に対応する構造体
struct OpenWeatherResponse: Codable {
    let weather: [WeatherInfo]
    let main: MainInfo
    let wind: WindInfo
    let name: String // 都市名
}

struct WeatherInfo: Codable {
    let main: String // "Clear", "Clouds", "Rain" など
}

struct MainInfo: Codable {
    let temp: Double // 気温 (ケルビン)
    let humidity: Int // 湿度 (%)
}

struct WindInfo: Codable {
    let speed: Double // 風速 (m/s)
}
