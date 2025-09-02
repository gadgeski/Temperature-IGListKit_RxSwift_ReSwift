//
//  WeatherEvent.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/31.
//

import Foundation

public enum WeatherEventKind: String, Codable {
    case heatwave
    case coldwave
}

public struct WeatherEvent: Equatable {
    public let kind: WeatherEventKind
    public let region: String
    public let date: Date

    public init(kind: WeatherEventKind, region: String, date: Date) {
        self.kind = kind
        self.region = region
        self.date = date
    }
}
