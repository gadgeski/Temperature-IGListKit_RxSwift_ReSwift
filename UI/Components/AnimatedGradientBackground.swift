//
//  AnimatedGradientBackground.swift
//  Temperature_IGListKit_RxSwift_ReSwift.entitlements
//
//  Created by Dev Tech on 2025/09/05.
//

import SwiftUI
import struct SwiftUI.Color

/// 現在の天気に応じてグラデーションが往復アニメする背景
public struct AnimatedGradientBackground: View {
    private let colors: [Color]
    @State private var animate: Bool = false

    public init(colors: [Color]) {
        self.colors = colors
    }

    public var body: some View {
        LinearGradient(
            colors: colors,
            startPoint: animate ? .topLeading    : .bottomTrailing,
            endPoint:   animate ? .bottomTrailing : .topLeading
        )
        .ignoresSafeArea()
        .onAppear {
            animate = false
            withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}
