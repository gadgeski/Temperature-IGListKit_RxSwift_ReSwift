//
//  MarketModels.swift
//  Temperature_IGListKit_RxSwift_ReSwift.entitlements
//
//  Created by Dev Tech on 2025/09/04.
//

import Foundation
import IGListKit

// セクタ影響カード
final class MarketImpactItem: NSObject, ListDiffable {
    let sector: String
    let change1dPct: Double   // 例: 0.012 = +1.2%
    init(sector: String, change1dPct: Double) {
        self.sector = sector; self.change1dPct = change1dPct
    }
    func diffIdentifier() -> NSObjectProtocol { (sector as NSString) }
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let o = object as? MarketImpactItem else { return false }
        return sector == o.sector && change1dPct == o.change1dPct
    }
}

// 銘柄行（スパークライン用の簡易履歴）
final class TickerRowItem: NSObject, ListDiffable {
    let symbol: String
    let last: Double
    let change1dPct: Double
    let spark: [Double]      // 正規化前の数値でもOK
    init(symbol: String, last: Double, change1dPct: Double, spark: [Double]) {
        self.symbol = symbol; self.last = last; self.change1dPct = change1dPct; self.spark = spark
    }
    func diffIdentifier() -> NSObjectProtocol { (symbol as NSString) }
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let o = object as? TickerRowItem else { return false }
        return symbol == o.symbol && last == o.last && change1dPct == o.change1dPct && spark == o.spark
    }
}
