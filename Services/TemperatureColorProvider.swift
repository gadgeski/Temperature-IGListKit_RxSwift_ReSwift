//
//  TemperatureColorProvider.swift
//  Temperature_IGListKit_RxSwift_ReSwift.entitlements
//
//  Created by Dev Tech on 2025/09/03.
//

// Services/TemperatureColorProvider.swift
import UIKit

enum TemperatureColorProvider {
    /// 背景：白カード、値ピル：色付き（スクショ準拠）
    static func badge(for celsius: Double) -> UIColor {   // CHANGED(ref)
        switch celsius {
        case ..<20:                     // 涼しい(≤20) → 青
            return Theme.uiColor(Theme.Hex.blueStart)
        case 20...28:                   // 暖かい(21–28) → 橙
            return Theme.uiColor(Theme.Hex.warmOrange)
        case 28...35:                   // 暑い(29–35) → 赤
            return Theme.uiColor(Theme.Hex.hotRed)
        default:                        // 非常に暑い(≥36) → 濃赤
            return Theme.uiColor(Theme.Hex.hotDeepRed)
        }
    }

    /// バナー：寒波=青グラデ／猛暑=赤〜橙グラデ
    static func bannerColors(forHeatwave isHeat: Bool) -> [CGColor] { // CHANGED(ref)
        if isHeat {
            return [Theme.uiColor(Theme.Hex.warmOrange).cgColor,
                    Theme.uiColor(Theme.Hex.hotRed).cgColor]
        } else {
            return [Theme.uiColor(Theme.Hex.blueStart).cgColor,
                    Theme.uiColor(Theme.Hex.blueEnd).cgColor]
        }
    }
}
