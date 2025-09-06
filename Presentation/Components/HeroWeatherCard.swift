//
//  HeroWeatherCard.swift
//  Temperature_IGListKit_RxSwift_ReSwift.entitlements
//
//  Created by Dev Tech on 2025/09/04.
//

import SwiftUI

/// ヒーロー（メイン）天気カード
struct HeroWeatherCard: View {
    let weather: WeatherData
    @Binding var showingSearch: Bool
    
    // ADDED: データが空（初期状態）かどうかを判定するためのプロパティ
    private var isDataEmpty: Bool {
        // locationが初期値 "..." かどうかで判定する
        weather.location == "..."
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // 地名と検索ボタン
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(weather.location)
                        .font(.title2).fontWeight(.semibold)
                    Text("今日")
                        .font(.subheadline).opacity(0.8)
                }
                Spacer()
                Button { showingSearch.toggle() } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                }
            }
            .foregroundColor(.white)
            
            // 気温と天気アイコン
            VStack(spacing: 8) {
                Image(systemName: weather.condition.rawValue)
                    .font(.system(size: 80))
                    .shadow(color: .black.opacity(0.3), radius: 10)
                Text("\(Int(weather.temperature))°")
                    .font(.system(size: 72, weight: .thin, design: .rounded))
                Text(weatherDescription)
                    .font(.title3).fontWeight(.medium)
            }
            .foregroundColor(.white)
            
            // 湿度・風速・体感温度
            HStack(spacing: 30) {
                weatherStat("湿度", "\(weather.humidity)%", "humidity.fill")
                weatherStat("風速", "\(Int(weather.windSpeed))km/h", "wind")
                weatherStat("体感", "\(Int(weather.temperature + 2))°", "thermometer")
            }
        }
        .padding(24)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
        .padding(.top, 50)
        // ADDED: isDataEmptyがtrueの場合、View全体に.redactedを適用してスケルトンUIにする
        .redacted(reason: isDataEmpty ? .placeholder : [])
    }
    
    // 詳細ステータス表示
    private func weatherStat(_ title: String, _ value: String, _ icon: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon).font(.title3).opacity(0.8)
            Text(value).font(.headline).fontWeight(.semibold)
            Text(title).font(.caption).opacity(0.7)
        }
        .foregroundColor(.white)
    }
    
    private var weatherDescription: String {
        switch weather.condition {
        case .sunny: return "晴れ"
        case .cloudy: return "曇り"
        case .rainy: return "雨"
        case .stormy: return "嵐"
        }
    }
}
