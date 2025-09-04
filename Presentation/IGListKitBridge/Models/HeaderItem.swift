//
//  HeaderItem.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/29.
//

import Foundation
import IGListKit

/// Simple header (title-only) item.
final class HeaderItem: NSObject, ListDiffable {
    let title: String
    init(title: String) { self.title = title }

    func diffIdentifier() -> NSObjectProtocol { return title as NSString }
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let other = object as? HeaderItem else { return false }
        return self.title == other.title
    }
}
