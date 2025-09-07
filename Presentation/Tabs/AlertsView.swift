//
//  AlertsView.swift
//  Temperature_IGListKit_RxSwift_ReSwift.entitlements
//
//  Created by Dev Tech on 2025/09/04.
//

import SwiftUI

/// アラートタブのコンテンツ
struct AlertsView: View {
    let alerts: [WeatherAlert]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("気象警報・注意報")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            if alerts.isEmpty {
                emptyAlertsView
            } else {
                ForEach(alerts.indices, id: \.self) { index in
                    alertCard(alerts[index])
                }
            }
        }
    }
    
    private var emptyAlertsView: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.shield.fill")
                .font(.system(size: 50)).foregroundColor(.green)
            Text("現在、警報・注意報はありません")
                .font(.headline).fontWeight(.medium)
            Text("安全な気象状況です")
                .font(.subheadline).opacity(0.7)
        }
        .foregroundColor(.white)
        .padding(32)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
    
    private func alertCard(_ alert: WeatherAlert) -> some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.title2)
                .foregroundColor(alert.severity.color)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(alert.title)
                    .font(.headline).fontWeight(.semibold)
                Text(alert.description)
                    .font(.subheadline).opacity(0.8)
                    .multilineTextAlignment(.leading)
            }
            .foregroundColor(.white)
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
}
