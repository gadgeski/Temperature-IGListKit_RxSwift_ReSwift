//
//  HourlyForecastView.swift
//  Temperature_IGListKit_RxSwift_ReSwift.entitlements
//
//  Created by Dev Tech on 2025/09/04.
//

import SwiftUI

/// 時間別予報タブのコンテンツ
struct HourlyForecastView: View {
    let forecasts: [HourlyWeather]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("24時間予報")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(forecasts.indices, id: \.self) { index in
                        hourlyForecastCard(forecasts[index])
                    }
                }
            }
        }
    }
    
    private func hourlyForecastCard(_ forecast: HourlyWeather) -> some View {
        VStack(spacing: 12) {
            Text(forecast.time)
                .font(.caption).fontWeight(.medium).opacity(0.7)
            Image(systemName: forecast.condition.rawValue)
                .font(.title2)
            Text("\(Int(forecast.temperature))°")
                .font(.headline).fontWeight(.semibold)
        }
        .foregroundColor(.white)
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .frame(width: 80)
    }
}
