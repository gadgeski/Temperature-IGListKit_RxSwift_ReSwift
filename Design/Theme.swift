//
//  Theme.swift
//  Temperature_IGListKit_RxSwift_ReSwift.entitlements
//
//  Created by Dev Tech on 2025/09/03.
//

// Design/Theme.swift
import SwiftUI
import UIKit

enum Theme {
    enum Hex {
        // ヘッダー用（緑グラデ）
        static let greenStart = "#4CAF50"    // CHANGED(ref)
        static let greenEnd   = "#45A049"    // CHANGED(ref)

        // 寒色（涼しい/寒波）
        static let blueStart  = "#2196F3"    // CHANGED(ref)
        static let blueEnd    = "#1976D2"    // CHANGED(ref)

        // 暖色（21–28℃の“暖かい”）
        static let warmOrange = "#FF9800"    // CHANGED(ref)

        // 暑い/非常に暑い
        static let hotRed     = "#F44336"    // CHANGED(ref)
        static let hotDeepRed = "#D32F2F"    // CHANGED(ref)

        // 背景（カード下の薄い灰）
        static let cardBg     = "#FFFFFF"
    }

    // Hex → UIColor/Color
    static func uiColor(_ hex: String) -> UIColor {
        var h = hex.replacingOccurrences(of: "#", with: "")
        if h.count == 3 { h = h.map { "\($0)\($0)" }.joined() } // 3桁対応
        var rgb: UInt64 = 0; Scanner(string: h).scanHexInt64(&rgb)
        let r = CGFloat((rgb >> 16) & 0xFF) / 255
        let g = CGFloat((rgb >> 8) & 0xFF) / 255
        let b = CGFloat(rgb & 0xFF) / 255
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
    static func color(_ hex: String) -> Color { Color(uiColor(hex)) }

    // 斜めグラデ
    static func gradientLayer(startHex: String, endHex: String) -> CAGradientLayer {
        let gl = CAGradientLayer()
        gl.colors = [uiColor(startHex).cgColor, uiColor(endHex).cgColor]
        gl.startPoint = CGPoint(x: 0, y: 0)
        gl.endPoint = CGPoint(x: 1, y: 1)
        return gl
    }
}
