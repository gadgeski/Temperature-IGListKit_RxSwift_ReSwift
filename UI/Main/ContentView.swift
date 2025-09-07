//
//  ContentView.swift
//  Temperature_IGListKit_RxSwift_ReSwift.entitlements
//
//  Created by Dev Tech on 2025/09/05.
//

import SwiftUI

/// 画面全体を司るコンテナ：
/// - ViewModelと連携し、UIの状態を更新します
public struct ContentView: View {

    // MARK: - State
    
    // CHANGED: @StateObject を使ってViewModelをインスタンス化します。
    // これがViewの状態とビジネスロジックの唯一の接続点になります。
    @StateObject private var viewModel = WeatherViewModel()

    // CHANGED: UIの状態に関するプロパティのみをViewに残します
    @State private var selectedView: ViewMode = .dashboard
    @State private var showingSearch = false
    
    // REMOVED: 以下のプロパティはViewModelに移動したため、ContentViewからは削除します
    // @State private var currentWeather: WeatherData
    // @State private var marketData: MarketData
    // @State private var isLoading = true
    // private let weatherService = MockWeatherDataService()
    // private let thresholds = Thresholds()
    
    // CHANGED: initはViewModelを使うようにシンプルになります
    public init() {}

    // MARK: - Body

    public var body: some View {
        NavigationStack {
            ZStack {
                // ViewModelが持つプロパティを監視してUIを更新します
                AnimatedGradientBackground(colors: viewModel.currentWeather.condition.gradientColors)

                if viewModel.isLoading {
                    ProgressView("Loading Weather...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .foregroundColor(.white)
                } else {
                    MainContent(
                        weather: viewModel.currentWeather,
                        market: viewModel.marketData,
                        showingSearch: $showingSearch,
                        selectedView: selectedView,
                        refreshAction: {
                            // Pull-to-refreshのアクションとしてViewModelのrefreshメソッドを呼び出します
                            viewModel.refresh()
                        }
                    )
                }

                VStack {
                    Spacer()
                    FloatingTabBar(selectedView: $selectedView)
                }
                .opacity(viewModel.isLoading ? 0 : 1)
            }
            .navigationBarHidden(true)
            // REMOVED: .taskによるデータ取得はViewModelのinitで行われるため不要になります
            // .task { await refreshWeatherData() }
        }
    }

    // REMOVED: データ処理に関するメソッドは全てViewModelに移動したため、ContentViewからは完全に削除します
    // private func refreshWeatherData() async { ... }
    // private func createWeatherAlert(from event: WeatherEvent) -> WeatherAlert { ... }
    // private func createFeaturedSectors(from event: WeatherEvent?) -> [SectorImpact] { ... }
    // private static var emptyWeatherData: WeatherData { ... }
    // private static var emptyMarketData: MarketData { ... }
    // private func createSampleHourlyForecast(condition: WeatherCondition) -> [HourlyWeather] { ... }
}

#Preview("Modern Weather App") {
    ContentView()
}
