//
//  IGLRxBinder.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/30.
//

#if canImport(RxSwift)
import RxSwift
import IGListKit

/// Rx binder (optional): Observable<[Domain]> → [ListDiffable]
final class IGLRxBinder<Domain> {
    private let disposeBag = DisposeBag()
    typealias Selector = ([Domain]) -> [ListDiffable]

    init(observable: Observable<[Domain]>, selector: @escaping Selector, sink: @escaping ([ListDiffable]) -> Void) {
        observable
            .map(selector)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: sink)
            .disposed(by: disposeBag)
    }
}
#endif
