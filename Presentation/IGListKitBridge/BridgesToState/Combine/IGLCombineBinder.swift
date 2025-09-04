//
//  IGLCombineBinder.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/30.
//

import Combine
import IGListKit

/// Maps a Combine publisher of Domain models → ListDiffable via provided selector.
final class IGLCombineBinder<Domain>: ObservableObject {
    private var cancellable: AnyCancellable?

    typealias Selector = ([Domain]) -> [ListDiffable]

    init(publisher: AnyPublisher<[Domain], Never>, selector: @escaping Selector, sink: @escaping ([ListDiffable]) -> Void) {
        cancellable = publisher
            .map(selector)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: sink)
    }
}
