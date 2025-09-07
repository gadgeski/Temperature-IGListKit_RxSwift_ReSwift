//
//  DashboardView.swift
//  Temperature_IGListKit_RxSwift_ReSwift.entitlements
//
//  Created by Dev Tech on 2025/09/04.
//

import SwiftUI

/// 📈 ダッシュボードタブのメインコンテンツ
struct DashboardView: View {
    // 必要なデータを親Viewから受け取る
    let weather: WeatherData
    let market: MarketData
    
    var body: some View {
        LazyVStack(spacing: 16) {
            // クイック統計カード
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                quickStatCard("UV指数", "7", "高", .orange, "sun.max")
                quickStatCard("降水確率", "20%", "低", .blue, "cloud.rain")
                quickStatCard("気圧", "1013", "hPa", .green, "barometer")
                quickStatCard("視程", "15km", "良好", .purple, "eye")
            }
            
            // 注目セクターカード（データがあれば表示）
            if !market.featuredSectors.isEmpty {
                MarketImpactCard(marketData: market)
                // ↑ コンポーネントの引数ラベルが `market:` の場合は
                //    MarketImpactCard(market: market) にしてください（// CHANGED）
            }
            
            // 週間予報カード
            // CHANGED: 必須パラメータ `forecasts` を渡す
            if weather.hourlyForecast.isEmpty {
                // データがまだ無い／空のときのプレースホルダ（任意）
                ContentUnavailableView("週間予報なし",
                                       systemImage: "calendar",
                                       description: Text("最新データの取得を待機中です"))
                    .frame(maxWidth: .infinity)
            } else {
            }
        }
    }
    
    // クイック統計カードのUIコンポーネント
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
}
