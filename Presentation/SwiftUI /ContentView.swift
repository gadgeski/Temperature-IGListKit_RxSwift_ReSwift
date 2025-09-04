//
//  ContentView.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/29.
//

// Presentation/SwiftUI/ContentView.swift
import SwiftUI

// 🎨 COMPLETELY NEW: 拡張されたカラーシステム
extension Color {
    // Dynamic colors based on weather conditions
    static let sunnyGradientTop = Color(red: 1.0, green: 0.8, blue: 0.4)
    static let sunnyGradientBottom = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let rainyGradientTop = Color(red: 0.4, green: 0.5, blue: 0.7)
    static let rainyGradientBottom = Color(red: 0.2, green: 0.3, blue: 0.5)
    static let cloudyGradientTop = Color(red: 0.7, green: 0.7, blue: 0.8)
    static let cloudyGradientBottom = Color(red: 0.5, green: 0.5, blue: 0.6)
    
    // Glass morphism colors
    static let glassMorphism = Color.white.opacity(0.2)
    static let glassStroke = Color.white.opacity(0.3)
}

// 🎨 NEW: Weather data model
struct WeatherData {
    let temperature: Double
    let condition: WeatherCondition
    let humidity: Int
    let windSpeed: Double
    let location: String
    let hourlyForecast: [HourlyWeather]
    let alerts: [WeatherAlert]
}

enum WeatherCondition: String, CaseIterable {
    case sunny = "sun.max.fill"
    case cloudy = "cloud.fill"
    case rainy = "cloud.rain.fill"
    case stormy = "cloud.bolt.fill"
    
    var gradientColors: [Color] {
        switch self {
        case .sunny: return [.sunnyGradientTop, .sunnyGradientBottom]
        case .cloudy: return [.cloudyGradientTop, .cloudyGradientBottom]
        case .rainy, .stormy: return [.rainyGradientTop, .rainyGradientBottom]
        }
    }
}

struct HourlyWeather {
    let time: String
    let temperature: Double
    let condition: WeatherCondition
}

struct WeatherAlert {
    let title: String
    let severity: AlertSeverity
    let description: String
}

enum AlertSeverity {
    case low, medium, high
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
}

struct ContentView: View {
    // 🎨 CHANGED: より豊富な状態管理
    @State private var currentWeather = WeatherData(
        temperature: 28.5,
        condition: .sunny,
        humidity: 65,
        windSpeed: 12.5,
        location: "東京, 日本",
        hourlyForecast: [
            HourlyWeather(time: "14:00", temperature: 28.5, condition: .sunny),
            HourlyWeather(time: "15:00", temperature: 29.2, condition: .sunny),
            HourlyWeather(time: "16:00", temperature: 27.8, condition: .cloudy),
            HourlyWeather(time: "17:00", temperature: 26.1, condition: .rainy)
        ],
        alerts: [
            WeatherAlert(title: "熱中症注意", severity: .medium, description: "気温が高くなっています")
        ]
    )
    
    @State private var selectedView: ViewMode = .dashboard
    @State private var showingSearch = false
    @State private var animateBackground = false
    
    enum ViewMode: String, CaseIterable {
        case dashboard = "ダッシュボード"
        case hourly = "時間別予報"
        case alerts = "アラート"
        case settings = "設定"
        
        var icon: String {
            switch self {
            case .dashboard: return "house.fill"
            case .hourly: return "clock.fill"
            case .alerts: return "exclamationmark.triangle.fill"
            case .settings: return "gearshape.fill"
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // 🎨 NEW: Dynamic animated background based on weather
                dynamicBackground
                
                // 🎨 NEW: Modern card-based layout
                ScrollView {
                    LazyVStack(spacing: 20) {
                        // Hero weather card
                        heroWeatherCard
                        
                        // Content based on selected view
                        switch selectedView {
                        case .dashboard:
                            dashboardContent
                        case .hourly:
                            hourlyForecastContent
                        case .alerts:
                            alertsContent
                        case .settings:
                            settingsContent
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100) // Space for floating tab bar
                }
                .refreshable {
                    // 🎨 NEW: Pull to refresh functionality
                    await refreshWeatherData()
                }
                
                // 🎨 NEW: Floating navigation bar
                VStack {
                    Spacer()
                    floatingTabBar
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                startBackgroundAnimation()
            }
        }
    }
    
    // 🎨 NEW: Dynamic animated background
    private var dynamicBackground: some View {
        ZStack {
            // Animated gradient background
            LinearGradient(
                colors: currentWeather.condition.gradientColors,
                startPoint: animateBackground ? .topLeading : .bottomTrailing,
                endPoint: animateBackground ? .bottomTrailing : .topLeading
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 8).repeatForever(autoreverses: true), value: animateBackground)
            
            // Floating particles/shapes for weather effect
            weatherParticles
        }
    }
    
    // 🎨 NEW: Weather particles animation
    private var weatherParticles: some View {
        ZStack {
            ForEach(0..<15, id: \.self) { index in
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: CGFloat.random(in: 10...30))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .animation(
                        .easeInOut(duration: Double.random(in: 3...6))
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.2),
                        value: animateBackground
                    )
            }
        }
    }
    
    // 🎨 NEW: Hero weather display card
    private var heroWeatherCard: some View {
        VStack(spacing: 16) {
            // Location and search
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(currentWeather.location)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text("今日")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                Button {
                    showingSearch.toggle()
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.white)
                }
            }
            
            // Main temperature display
            VStack(spacing: 8) {
                Image(systemName: currentWeather.condition.rawValue)
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 10)
                
                Text("\(Int(currentWeather.temperature))°")
                    .font(.system(size: 72, weight: .thin, design: .rounded))
                    .foregroundColor(.white)
                
                Text(weatherDescription)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.9))
            }
            
            // Weather stats row
            HStack(spacing: 30) {
                weatherStat("湿度", "\(currentWeather.humidity)%", "humidity.fill")
                weatherStat("風速", "\(Int(currentWeather.windSpeed))km/h", "wind")
                weatherStat("体感", "\(Int(currentWeather.temperature + 2))°", "thermometer")
            }
        }
        .padding(24)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
        .padding(.top, 50)
    }
    
    // 🎨 NEW: Weather stat component
    private func weatherStat(_ title: String, _ value: String, _ icon: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.white.opacity(0.8))
            
            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
    }
    
    // 🎨 NEW: Dashboard content with rich cards
    private var dashboardContent: some View {
        VStack(spacing: 16) {
            // Quick stats cards
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                quickStatCard("UV指数", "7", "高", .orange, "sun.max")
                quickStatCard("降水確率", "20%", "低", .blue, "cloud.rain")
                quickStatCard("気圧", "1013", "hPa", .green, "barometer")
                quickStatCard("視程", "15km", "良好", .purple, "eye")
            }
            
            // 🎨 NEW: Weekly forecast card
            weeklyForecastCard
        }
    }
    
    // 🎨 NEW: Quick stat card component
    private func quickStatCard(_ title: String, _ value: String, _ status: String, _ color: Color, _ icon: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
                
                Text(status)
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(color.opacity(0.2))
                    .clipShape(Capsule())
                    .foregroundColor(color)
            }
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    // 🎨 NEW: Weekly forecast card
    private var weeklyForecastCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("7日間の予報")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                ForEach(0..<5, id: \.self) { index in
                    weeklyForecastRow(
                        day: ["今日", "明日", "水曜日", "木曜日", "金曜日"][index],
                        high: [29, 31, 28, 26, 27][index],
                        low: [22, 24, 21, 19, 20][index],
                        condition: [.sunny, .sunny, .cloudy, .rainy, .cloudy][index]
                    )
                }
            }
        }
        .padding(24)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
    
    // 🎨 NEW: Weekly forecast row
    private func weeklyForecastRow(day: String, high: Int, low: Int, condition: WeatherCondition) -> some View {
        HStack {
            Text(day)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .frame(width: 60, alignment: .leading)
            
            Spacer()
            
            Image(systemName: condition.rawValue)
                .font(.title3)
                .foregroundColor(.white.opacity(0.8))
                .frame(width: 30)
            
            Spacer()
            
            Text("\(low)°")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.6))
            
            Text("\(high)°")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: 35, alignment: .trailing)
        }
        .padding(.vertical, 4)
    }
    
    // 🎨 NEW: Hourly forecast content
    private var hourlyForecastContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("24時間予報")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(currentWeather.hourlyForecast.indices, id: \.self) { index in
                        let forecast = currentWeather.hourlyForecast[index]
                        hourlyForecastCard(forecast)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.horizontal, -20)
    }
    
    // 🎨 NEW: Hourly forecast card
    private func hourlyForecastCard(_ forecast: HourlyWeather) -> some View {
        VStack(spacing: 12) {
            Text(forecast.time)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.7))
            
            Image(systemName: forecast.condition.rawValue)
                .font(.title2)
                .foregroundColor(.white)
            
            Text("\(Int(forecast.temperature))°")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .frame(width: 80)
    }
    
    // 🎨 NEW: Alerts content
    private var alertsContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("気象警報・注意報")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            if currentWeather.alerts.isEmpty {
                emptyAlertsView
            } else {
                ForEach(currentWeather.alerts.indices, id: \.self) { index in
                    alertCard(currentWeather.alerts[index])
                }
            }
        }
    }
    
    // 🎨 NEW: Empty alerts view
    private var emptyAlertsView: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.shield.fill")
                .font(.system(size: 50))
                .foregroundColor(.green)
            
            Text("現在、警報・注意報はありません")
                .font(.headline)
                .fontWeight(.medium)
                .foregroundColor(.white)
            
            Text("安全な気象状況です")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(32)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
    
    // 🎨 NEW: Alert card
    private func alertCard(_ alert: WeatherAlert) -> some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.title2)
                .foregroundColor(alert.severity.color)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(alert.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text(alert.description)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(alert.severity.color.opacity(0.3), lineWidth: 1)
        )
    }
    
    // 🎨 NEW: Advanced settings content
    private var settingsContent: some View {
        VStack(spacing: 16) {
            settingsSection("表示設定", [
                ("温度単位", "摂氏 (°C)", "thermometer"),
                ("風速単位", "km/h", "wind"),
                ("時刻表示", "24時間制", "clock")
            ])
            
            settingsSection("通知設定", [
                ("気象警報", "オン", "bell.badge"),
                ("雨の通知", "オン", "cloud.rain"),
                ("紫外線警告", "オフ", "sun.max")
            ])
            
            settingsSection("データ", [
                ("位置情報", "許可", "location"),
                ("バックグラウンド更新", "オン", "arrow.clockwise"),
                ("データ使用量", "Wi-Fi優先", "wifi")
            ])
        }
    }
    
    // 🎨 NEW: Settings section
    private func settingsSection(_ title: String, _ items: [(String, String, String)]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 4)
            
            VStack(spacing: 1) {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    settingsRow(item.0, item.1, item.2, isLast: index == items.count - 1)
                }
            }
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
    
    // 🎨 NEW: Settings row
    private func settingsRow(_ title: String, _ value: String, _ icon: String, isLast: Bool) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.8))
                    .frame(width: 24)
                
                Text(title)
                    .font(.body)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(value)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.6))
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.4))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
            if !isLast {
                Divider()
                    .background(.white.opacity(0.1))
                    .padding(.leading, 60)
            }
        }
    }
    
    // 🎨 NEW: Floating tab bar with glass morphism
    private var floatingTabBar: some View {
        HStack {
            ForEach(ViewMode.allCases, id: \.self) { mode in
                tabBarButton(mode)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(.ultraThinMaterial)
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(.white.opacity(0.3), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
    }
    
    // 🎨 NEW: Advanced tab bar button with haptic feedback
    private func tabBarButton(_ mode: ViewMode) -> some View {
        Button {
            // 🎨 NEW: Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedView = mode
            }
        } label: {
            VStack(spacing: 6) {
                Image(systemName: mode.icon)
                    .font(.title3)
                    .scaleEffect(selectedView == mode ? 1.2 : 1.0)
                
                Text(mode.rawValue)
                    .font(.caption2)
                    .fontWeight(.medium)
            }
            .foregroundColor(selectedView == mode ? .white : .white.opacity(0.6))
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
    
    // 🎨 NEW: Helper computed properties
    private var weatherDescription: String {
        switch currentWeather.condition {
        case .sunny: return "晴れ"
        case .cloudy: return "曇り"
        case .rainy: return "雨"
        case .stormy: return "嵐"
        }
    }
    
    // 🎨 NEW: Animation functions
    private func startBackgroundAnimation() {
        withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
            animateBackground = true
        }
    }
    
    private func refreshWeatherData() async {
        // Simulate network request
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Update weather data here
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            // Refresh logic would go here
        }
    }
}

// 🎨 NEW: Preview with sample data
#Preview("Modern Weather App") {
    ContentView()
}
