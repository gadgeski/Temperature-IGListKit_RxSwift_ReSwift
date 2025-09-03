//
//  HeaderSectionController.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/29.
//

import UIKit
import IGListKit

final class HeaderSectionController: ListSectionController {
    private var item: HeaderItem?

    override func sizeForItem(at index: Int) -> CGSize {
        guard let ctx = collectionContext else { return .zero }
        let width = ctx.containerSize.width
        return CGSize(width: width, height: 44)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let ctx = collectionContext else { fatalError("Missing context") }
        let cell = ctx.dequeueReusableCell(of: HeaderCell.self, for: self, at: index) as! HeaderCell
        if let item { cell.configure(title: item.title) }
        return cell
    }

    override func didUpdate(to object: Any) {
        self.item = object as? HeaderItem
    }
}
