//
//  SectorSuggestion.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/31.
//

import Foundation

public struct SectorSuggestion: Equatable {
    public let kind: WeatherEventKind
    public let sectorName: String
    public let tickers: [String]      // 例: ["2503.T", "KO"]

    public init(kind: WeatherEventKind, sectorName: String, tickers: [String]) {
        self.kind = kind
        self.sectorName = sectorName
        self.tickers = tickers
    }
}
