//
//  IGLReSwiftSubscriber.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/30.
//

#if canImport(ReSwift)
import ReSwift
import IGListKit

/// ReSwift subscriber (optional): AppState → [ListDiffable]
final class IGLReSwiftSubscriber<AppState, Domain>: StoreSubscriber where Domain: Equatable {
    typealias StoreSubscriberStateType = AppState

    private let selector: (AppState) -> [Domain]
    private let mapper: ([Domain]) -> [ListDiffable]
    private let sink: ([ListDiffable]) -> Void

    init(selector: @escaping (AppState) -> [Domain], mapper: @escaping ([Domain]) -> [ListDiffable], sink: @escaping ([ListDiffable]) -> Void) {
        self.selector = selector
        self.mapper = mapper
        self.sink = sink
    }

    func newState(state: AppState) {
        let domainSlice = selector(state)
        let items = mapper(domainSlice)
        sink(items)
    }
}
#endif
