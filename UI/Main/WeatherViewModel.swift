// ADDED: このファイルは新規作成です
import Foundation
import RxSwift
import Combine

final class WeatherViewModel: ObservableObject {
    // MARK: - Output to View (Viewへの出力)
    @Published var currentWeather: WeatherData = .empty
    @Published var marketData: MarketData = .empty
    @Published var isLoading: Bool = true

    // MARK: - Input from View (Viewからの入力)
    let refreshTrigger = PublishSubject<Void>()

    // MARK: - Private properties
    private let weatherService = MockWeatherDataService()
    private let thresholds = Thresholds()
    private let disposeBag = DisposeBag()

    init() {
        refreshTrigger
            .startWith(())
            .flatMapLatest { [unowned self] _ -> Observable<([Temperature], WeatherCondition)> in
                self.isLoading = true
                return self.weatherService.fetchWeatherData()
                    .asObservable()
                    // ADDED: この一行を追加して、ラベル付きタプルをラベルなしタプルに変換します
                    .map { ($0.temperatures, $0.condition) }
                    .catchAndReturn(([], .sunny))
            }
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .default))
            .map { [unowned self] temps, condition -> (WeatherData, MarketData) in
                // --- 以前ContentView内にあったロジックをここに移植 ---
                let detectedEvent = WeatherAlertsProvider.detectExtreme(from: temps, thresholds: self.thresholds)

                var weatherAlerts: [WeatherAlert] = []
                if let event = detectedEvent {
                    weatherAlerts.append(self.createWeatherAlert(from: event))
                    AlertNotificationScheduler.schedule(event: event)
                }

                let featuredSectors = self.createFeaturedSectors(from: detectedEvent)

                let weather = WeatherData(
                    temperature: temps.first?.celsius ?? 0,
                    condition: condition,
                    humidity: 65,
                    windSpeed: 12.5,
                    location: temps.first?.region ?? "取得中...",
                    hourlyForecast: self.createSampleHourlyForecast(condition: condition),
                    alerts: weatherAlerts
                )
                let market = MarketData(featuredSectors: featuredSectors)

                return (weather, market)
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] weather, market in
                self.currentWeather = weather
                self.marketData = market
                self.isLoading = false
            })
            .disposed(by: disposeBag)
    }

    /// Viewからデータ更新をトリガーするためのメソッドです
    func refresh() {
        refreshTrigger.onNext(())
    }

    // --- ContentViewから持ってきたヘルパーメソッド群 ---
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
    
    private func createSampleHourlyForecast(condition: WeatherCondition) -> [HourlyWeather] {
        return [
            HourlyWeather(time: "14:00", temperature: 28.5, condition: condition),
            HourlyWeather(time: "15:00", temperature: 29.2, condition: condition)
        ]
    }
}
