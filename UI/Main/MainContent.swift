//
//  MainContent.swift
//  Temperature_IGListKit_RxSwift_ReSwift.entitlements
//
//  Created by Dev Tech on 2025/09/05.
//

import SwiftUI

/// スクロール領域のメインコンテンツ（上部ヒーロー＋切替領域）
/// - Note: `HeroWeatherCard` / 各サブ画面は既存実装がある前提。
public struct MainContent: View {
    public let weather: WeatherData
    public let market: MarketData
    @Binding public var showingSearch: Bool
    public let selectedView: ViewMode
    public let refreshAction: () async -> Void

    public init(
        weather: WeatherData,
        market: MarketData,
        showingSearch: Binding<Bool>,
        selectedView: ViewMode,
        refreshAction: @escaping () async -> Void
    ) {
        self.weather = weather
        self.market = market
        self._showingSearch = showingSearch
        self.selectedView = selectedView
        self.refreshAction = refreshAction
    }

    public var body: some View {
        ScrollView {
            // 既存：ヒーローカード
            HeroWeatherCard(weather: weather, showingSearch: $showingSearch)

            Group {
                switch selectedView {
                case .dashboard:
                    DashboardView(weather: weather, market: market)
                case .hourly:
                    HourlyForecastView(forecasts: weather.hourlyForecast)
                case .alerts:
                    AlertsView(alerts: weather.alerts)
                case .settings:
                    SettingsView()
                }
            }
            .padding(.bottom, 100)
        }
        .padding(.horizontal, 20)
        .refreshable { await refreshAction() } // Pull-to-refresh
    }
}
