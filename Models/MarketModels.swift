//
//  MarketModels.swift
//  Temperature_IGListKit_RxSwift_ReSwift.entitlements
//
//  Created by Dev Tech on 2025/09/05.
//

import Foundation

// 📈 市場データモデル群
public struct MarketData {
    public let featuredSectors: [SectorImpact]

    public init(featuredSectors: [SectorImpact]) {
        self.featuredSectors = featuredSectors
    }
}

public struct SectorImpact {
    public let sectorName: String
    public let changePercentage: Double
    public let tickers: [String]

    public init(sectorName: String, changePercentage: Double, tickers: [String]) {
        self.sectorName = sectorName
        self.changePercentage = changePercentage
        self.tickers = tickers
    }
}
