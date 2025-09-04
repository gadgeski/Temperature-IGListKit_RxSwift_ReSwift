//
//  Thresholds.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/31.
//

import Foundation

public struct Thresholds {
    public var heatwaveMaxCelsius: Double = 35.0   // 例: 猛暑
    public var coldwaveMaxCelsius: Double = 0.0    // 例: 寒波

    public init(heatwaveMaxCelsius: Double = 35.0, coldwaveMaxCelsius: Double = 0.0) {
        self.heatwaveMaxCelsius = heatwaveMaxCelsius
        self.coldwaveMaxCelsius = coldwaveMaxCelsius
    }
}
