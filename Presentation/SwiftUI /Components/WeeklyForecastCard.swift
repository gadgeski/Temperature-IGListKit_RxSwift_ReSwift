//
//  WeeklyForecastCard.swift
//  Temperature_IGListKit_RxSwift_ReSwift.entitlements
//
//  Created by Dev Tech on 2025/09/04.
//

import SwiftUI

/// 週間予報カード
struct WeeklyForecastCard: View {
    // ADDED: 週間予報データも外部から受け取るように変更（将来的な拡張のため）
    let forecasts: [WeeklyForecastItem] // 仮のデータ構造
    
    // ADDED: データが空かどうかを判定するプロパティ
    private var isDataEmpty: Bool {
        forecasts.isEmpty
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("7日間の予報")
                .font(.headline).fontWeight(.semibold)
                .foregroundColor(.white)
            
            // CHANGED: isDataEmptyがtrueの場合、ダミーの行をスケルトン表示する
            if isDataEmpty {
                VStack(spacing: 12) {
                    // ダミーデータを5行表示して、スケルトンUIを見せる
                    ForEach(0..<5, id: \.self) { _ in
                        weeklyForecastRow(day: "曜日", high: 0, low: 0, condition: .sunny)
                    }
                }
            } else {
                // データがある場合の表示
                VStack(spacing: 12) {
                    ForEach(forecasts) { forecast in
                        weeklyForecastRow(
                            day: forecast.day,
                            high: forecast.high,
                            low: forecast.low,
                            condition: forecast.condition
                        )
                    }
                }
            }
        }
        .padding(24)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        // ADDED: データが空ならスケルトンUIを表示
        .redacted(reason: isDataEmpty ? .placeholder : [])
    }
    
    private func weeklyForecastRow(day: String, high: Int, low: Int, condition: WeatherCondition) -> some View {
        HStack {
            Text(day)
                .font(.subheadline).fontWeight(.medium)
                .frame(width: 60, alignment: .leading)
            Spacer()
            Image(systemName: condition.rawValue)
                .font(.title3).opacity(0.8)
                .frame(width: 30)
            Spacer()
            // CHANGED: 気温が0の場合、"--" と表示するように修正
            Text(isDataEmpty ? "--°" : "\(low)°").opacity(0.6)
            Text(isDataEmpty ? "--°" : "\(high)°").fontWeight(.semibold)
        }
        .font(.subheadline)
        .foregroundColor(.white)
        .padding(.vertical, 4)
    }
}

// ADDED: WeeklyForecastCardに渡すためのデータ構造を定義
struct WeeklyForecastItem: Identifiable {
    let id = UUID()
    let day: String
    let high: Int
    let low: Int
    let condition: WeatherCondition
    
    // ADDED: プレビューやダミーデータ用のサンプル
    static let sample: [WeeklyForecastItem] = [
        .init(day: "今日", high: 29, low: 22, condition: .sunny),
        .init(day: "明日", high: 31, low: 24, condition: .sunny),
        .init(day: "水曜日", high: 28, low: 21, condition: .cloudy),
        .init(day: "木曜日", high: 26, low: 19, condition: .rainy),
        .init(day: "金曜日", high: 27, low: 20, condition: .cloudy)
    ]
}

// ADDED: プレビューで動作確認できるように修正
#Preview("WeeklyForecastCard - With Data") {
    WeeklyForecastCard(forecasts: WeeklyForecastItem.sample)
        .padding()
        .background(Color.blue)
}

#Preview("WeeklyForecastCard - Empty") {
    WeeklyForecastCard(forecasts: [])
        .padding()
        .background(Color.blue)
}
