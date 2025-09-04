//
//  SectorChipSectionController.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/31.
//

// Presentation/IGListKitBridge/SectionControllers/SectorChipSectionController.swift
import UIKit
import IGListKit

final class SectorChipSectionController: ListSectionController {
    private var item: SectorChipItem?

    override init() {
        super.init()
        minimumLineSpacing = 4
        inset = UIEdgeInsets(top: 2, left: 16, bottom: 0, right: 16)
    }

    override func numberOfItems() -> Int { 1 }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let ctx = collectionContext else { return .zero }
        let width = ctx.containerSize.width - (inset.left + inset.right)
        return CGSize(width: width, height: 36)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let ctx = collectionContext else { fatalError("Missing collectionContext") }
        let cell = ctx.dequeueReusableCell(of: SectorChipCell.self, for: self, at: index) as! SectorChipCell
        if let item {
            let text = "\(item.sectorName) (\(item.count))"
            cell.configure(text: text, preferred: nil) // ✅ 修正ポイント: Intを渡さず、nilを渡す
        }
        return cell
    }

    override func didUpdate(to object: Any) {
        self.item = object as? SectorChipItem
    }
}
