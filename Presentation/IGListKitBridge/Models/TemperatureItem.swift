//
//  TemperatureItem.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/29.
//

import Foundation
import IGListKit

/// View model for Temperature row, conforming to ListDiffable.
final class TemperatureItem: NSObject, ListDiffable {
    let id: String
    let region: String
    let celsius: Double
    let date: Date

    init(_ model: Temperature) {
        self.id = model.id
        self.region = model.region
        self.celsius = model.celsius
        self.date = model.date
    }

    func diffIdentifier() -> NSObjectProtocol { id as NSString }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let other = object as? TemperatureItem else { return false }
        return region == other.region && celsius == other.celsius && date == other.date
    }
}
