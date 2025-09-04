//
//  SectorChipItem.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/31.
//

import Foundation
import IGListKit

/// セクタ名を“チップ”として縦並びで表示（最小実装）
final class SectorChipItem: NSObject, ListDiffable {
    let sectorName: String
    let count: Int

    init(sectorName: String, count: Int) {
        self.sectorName = sectorName
        self.count = count
    }

    func diffIdentifier() -> NSObjectProtocol { sectorName as NSString }
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let o = object as? SectorChipItem else { return false }
        return sectorName == o.sectorName && count == o.count
    }
}
