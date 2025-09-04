//
//  AlertBannerSectionController.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/31.
//

// Presentation/IGListKitBridge/SectionControllers/AlertBannerSectionController.swift
import UIKit
import IGListKit

final class AlertBannerSectionController: ListSectionController {
    private var item: AlertBannerItem?

    override init() {
        super.init()
        inset = UIEdgeInsets(top: 8, left: 16, bottom: 4, right: 16)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
    }

    override func numberOfItems() -> Int { 1 }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let ctx = collectionContext else { return .zero }
        let width = ctx.containerSize.width - (inset.left + inset.right)
        return CGSize(width: width, height: 72)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let ctx = collectionContext else { fatalError("Missing collectionContext") }
        let cell = ctx.dequeueReusableCell(of: AlertBannerCell.self, for: self, at: index) as! AlertBannerCell
        if let item {
            // CHANGED: kind も渡す
            cell.configure(title: item.title, subtitle: item.subtitle, kind: item.kind)
        }
        return cell
    }

    override func didUpdate(to object: Any) { self.item = object as? AlertBannerItem }
}
