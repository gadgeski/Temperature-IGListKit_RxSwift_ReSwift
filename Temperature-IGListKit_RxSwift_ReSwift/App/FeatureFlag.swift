//
//  FeatureFlag.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/29.
//


import Foundation

enum FeatureFlags {
    static let useIGListKitFeed: Bool = true // flip to false to rollback to legacy SwiftUI list
}

#if DEBUG
extension FeatureFlags {
    static let previewLowerThresholds = true
    static var previewThresholds: Thresholds { .init(heatwaveMaxCelsius: 30.0, coldwaveMaxCelsius: 5.0) }
}
#endif
