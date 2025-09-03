//
//  SectorChipSectionController.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/31.
//

import UIKit
import IGListKit

final class SectorChipSectionController: ListSectionController {
    private var item: SectorChipItem?

    override func sizeForItem(at index: Int) -> CGSize {
        guard let ctx = collectionContext else { return .zero }
        return .init(width: ctx.containerSize.width, height: 40)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let ctx = collectionContext else { fatalError("missing context") }
        let cell = ctx.dequeueReusableCell(of: SectorChipCell.self, for: self, at: index) as! SectorChipCell
        if let item { cell.configure(sectorName: item.sectorName, count: item.count) }
        return cell
    }

    override func didUpdate(to object: Any) { self.item = object as? SectorChipItem }
}
