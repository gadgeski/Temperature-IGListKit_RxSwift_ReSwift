//
//  SettingsView.swift
//  Temperature_IGListKit_RxSwift_ReSwift.entitlements
//
//  Created by Dev Tech on 2025/09/04.
//

import SwiftUI

/// 設定タブのコンテンツ
struct SettingsView: View {
    var body: some View {
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
    
    private func settingsRow(_ title: String, _ value: String, _ icon: String, isLast: Bool) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3).opacity(0.8).frame(width: 24)
                Text(title)
                    .font(.body)
                Spacer()
                Text(value)
                    .font(.subheadline).opacity(0.6)
                Image(systemName: "chevron.right")
                    .font(.caption).opacity(0.4)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
            if !isLast {
                Divider().background(.white.opacity(0.1)).padding(.leading, 60)
            }
        }
    }
}
