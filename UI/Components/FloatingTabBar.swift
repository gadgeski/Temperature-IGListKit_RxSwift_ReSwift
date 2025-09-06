//
//  FloatingTabBar.swift
//  Temperature_IGListKit_RxSwift_ReSwift.entitlements
//
//  Created by Dev Tech on 2025/09/05.
//

import SwiftUI

/// 画面下のフローティングタブバー（Home / Hourly / Alerts / Settings）
public struct FloatingTabBar: View {
    @Binding private var selectedView: ViewMode

    public init(selectedView: Binding<ViewMode>) {
        self._selectedView = selectedView
    }

    public var body: some View {
        HStack(spacing: 8) {
            tabButton(.dashboard, systemName: "house.fill", label: "Home")
            tabButton(.hourly,    systemName: "clock.fill", label: "Hourly")
            tabButton(.alerts,    systemName: "exclamationmark.triangle.fill", label: "Alerts")
            tabButton(.settings,  systemName: "gearshape.fill", label: "Settings")
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.2), radius: 12)
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
        .accessibilityElement(children: .contain)
    }

    @ViewBuilder
    private func tabButton(_ mode: ViewMode, systemName: String, label: String) -> some View {
        Button {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                selectedView = mode
            }
            #if os(iOS)
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            #endif
        } label: {
            VStack(spacing: 4) {
                Image(systemName: systemName)
                    .font(.system(size: 16, weight: .semibold))
                Text(label)
                    .font(.caption2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
            .foregroundStyle(selectedView == mode ? Color.white : Color.white.opacity(0.7))
            .background(
                Group {
                    if selectedView == mode {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(Color.white.opacity(0.15))
                            .transition(.opacity.combined(with: .scale))
                    }
                }
            )
            .contentShape(Rectangle())
            .accessibilityLabel(Text(label))
            .accessibilityAddTraits(selectedView == mode ? .isSelected : [])
        }
        .buttonStyle(.plain)
    }
}
