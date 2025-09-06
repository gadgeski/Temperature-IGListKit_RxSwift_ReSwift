//
//  ContentView.swift
//  Temperature_IGListKit_RxSwift_ReSwift.entitlements
//
//  Created by Dev Tech on 2025/09/05.
//

import SwiftUI

/// 画面全体を司るコンテナ：
/// - 背景アニメ
/// - ローディング制御
/// - データ取得と状態反映
/// - タブ切替
public struct ContentView: View {

    // MARK: - State

    @State private var currentWeather: WeatherData
    @State private var marketData: MarketData

    @State private var selectedView: ViewMode = .dashboard
    @State private var showingSearch = false
    @State private var isLoading = true

    // NOTE: 既存のインフラ／サービス（別実装想定）
    private let weatherService = MockWeatherDataService()
    private let thresholds = Thresholds()

    // 初期状態
    public init() {
        _currentWeather = State(initialValue: Self.emptyWeatherData)
        _marketData     = State(initialValue: Self.emptyMarketData)
    }

    // MARK: - Body

    public var body: some View {
        NavigationStack {
            ZStack {
                AnimatedGradientBackground(colors: currentWeather.condition.gradientColors)

                if isLoading {
                    ProgressView("Loading Weather...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .foregroundColor(.white)
                } else {
                    MainContent(
                        weather: currentWeather,
                        market: marketData,
                        showingSearch: $showingSearch,
                        selectedView: selectedView,
                        refreshAction: refreshWeatherData
                    )
                }

                VStack {
                    Spacer()
                    FloatingTabBar(selectedView: $selectedView)
                }
                .opacity(isLoading ? 0 : 1)
            }
            .navigationBarHidden(true)
            .task { await refreshWeatherData() }
        }
    }

    // MARK: - Data Logic

    private func refreshWeatherData() async {
        // 1) 最新の天気データ取得（疑似サービス想定）
        let (temps, condition) = await weatherService.fetchWeatherData()

        // 2) 極端気象イベントを検知
        let detectedEvent = WeatherAlertsProvider.detectExtreme(from: temps, thresholds: thresholds)

        // 3) UI表示用アラートへ変換
        var weatherAlerts: [WeatherAlert] = []
        if let event = detectedEvent {
            let alert = createWeatherAlert(from: event)
            weatherAlerts.append(alert)

            // 4) 通知スケジュール（既存想定）
            AlertNotificationScheduler.schedule(event: event)
        }

        // 5) マーケットの注目セクター
        let featuredSectors = createFeaturedSectors(from: detectedEvent)

        // 6) UI更新（メインスレッド）
        await MainActor.run {
            self.currentWeather = WeatherData(
                temperature: temps.first?.celsius ?? 0,
                condition: condition,
                humidity: 65,
                windSpeed: 12.5,
                location: temps.first?.region ?? "取得中...",
                hourlyForecast: createSampleHourlyForecast(condition: condition),
                alerts: weatherAlerts
            )
            self.marketData = MarketData(featuredSectors: featuredSectors)
            self.isLoading = false
        }
    }

    private func createWeatherAlert(from event: WeatherEvent) -> WeatherAlert {
        switch event.kind {
        case .heatwave:
            return WeatherAlert(
                title: "猛暑アラート (\(event.region))",
                severity: .high,
                description: "熱中症に警戒し、関連セクターに注目が集まる可能性があります。"
            )
        case .coldwave:
            return WeatherAlert(
                title: "寒波アラート (\(event.region))",
                severity: .medium,
                description: "インフラや衣料関連セクターに注目が集まる可能性があります。"
            )
        }
    }

    private func createFeaturedSectors(from event: WeatherEvent?) -> [SectorImpact] {
        guard let event = event else { return [] }
        let suggestions = SectorMappingProvider.shared.suggestions(for: event)
        return suggestions.map { s in
            let randomChange = Double.random(in: -2.5...5.0)
            return SectorImpact(sectorName: s.sectorName, changePercentage: randomChange, tickers: s.tickers)
        }
    }

    // MARK: - Initial / Empty

    private static var emptyWeatherData: WeatherData {
        .init(
            temperature: 0,
            condition: .sunny,
            humidity: 0,
            windSpeed: 0,
            location: "...",
            hourlyForecast: [],
            alerts: []
        )
    }

    private static var emptyMarketData: MarketData {
        .init(featuredSectors: [])
    }

    // サンプルの時間別データ
    private func createSampleHourlyForecast(condition: WeatherCondition) -> [HourlyWeather] {
        return [
            HourlyWeather(time: "14:00", temperature: 28.5, condition: condition),
            HourlyWeather(time: "15:00", temperature: 29.2, condition: condition)
        ]
    }
}

#Preview("Modern Weather App") {
    ContentView()
}
