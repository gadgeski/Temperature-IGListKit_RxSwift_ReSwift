//
//  LoadingItem.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/29.
//

import Foundation
import IGListKit

final class LoadingItem: NSObject, ListDiffable {
    enum State { case loading, empty, error(String) }
    let state: State
    init(state: State) { self.state = state }

    func diffIdentifier() -> NSObjectProtocol {
        switch state {
        case .loading: return "loading" as NSString
        case .empty:   return "empty" as NSString
        case .error(let msg): return ("error:" + msg) as NSString
        }
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let other = object as? LoadingItem else { return false }
        switch (state, other.state) {
        case (.loading, .loading), (.empty, .empty): return true
        case (.error(let a), .error(let b)): return a == b
        default: return false
        }
    }
}
