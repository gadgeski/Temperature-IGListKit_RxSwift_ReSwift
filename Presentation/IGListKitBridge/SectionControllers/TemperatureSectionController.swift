//
//  TemperatureSectionController.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/30.
//

import UIKit
import IGListKit

final class TemperatureSectionController: ListSectionController {
    private var item: TemperatureItem?

    override func sizeForItem(at index: Int) -> CGSize {
        guard let ctx = collectionContext else { return .zero }
        let width = ctx.containerSize.width
        return CGSize(width: width, height: 56)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let ctx = collectionContext else { fatalError("Missing context") }
        let cell = ctx.dequeueReusableCell(of: TemperatureCell.self, for: self, at: index) as! TemperatureCell
        if let item { cell.configure(region: item.region, celsius: item.celsius) }
        return cell
    }

    override func didUpdate(to object: Any) {
        self.item = object as? TemperatureItem
    }
}
