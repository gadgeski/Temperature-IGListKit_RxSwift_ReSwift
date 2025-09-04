//
//  LoadingSectionController.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/30.
//

import UIKit
import IGListKit

final class LoadingSectionController: ListSectionController {
    private var item: LoadingItem?

    override func sizeForItem(at index: Int) -> CGSize {
        guard let ctx = collectionContext else { return .zero }
        let width = ctx.containerSize.width
        return CGSize(width: width, height: 60)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let ctx = collectionContext else { fatalError("Missing context") }
        let cell = ctx.dequeueReusableCell(of: LoadingCell.self, for: self, at: index) as! LoadingCell
        if let item { cell.configure(state: item.state) }
        return cell
    }

    override func didUpdate(to object: Any) {
        self.item = object as? LoadingItem
    }
}
