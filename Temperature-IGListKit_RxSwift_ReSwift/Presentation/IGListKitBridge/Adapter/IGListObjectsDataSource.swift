//
//  IGListObjectsDataSource.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/29.
//

import UIKit
import IGListKit

/// Single Responsibility:
/// - 保持している [ListDiffable] を返す
/// - 各オブジェクト型に対応する SectionController をマッピングする
final class IGListObjectsDataSource: NSObject, ListAdapterDataSource {

    // 現在の表示オブジェクト
    private var objects: [ListDiffable] = []

    /// 外部から差し替え（adapter.performUpdates で反映）
    func set(objects: [ListDiffable]) {
        self.objects = objects
    }

    // MARK: - ListAdapterDataSource

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return objects
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case is AlertBannerItem:
            return AlertBannerSectionController()
        case is SectorChipItem:
            return SectorChipSectionController()
        case is HeaderItem:
            return HeaderSectionController()
        case is TemperatureItem:
            return TemperatureSectionController()
        case is LoadingItem:
            return LoadingSectionController()
        default:
            // 未知の型は一旦 Loading として受ける（安全側）
            return LoadingSectionController()
        }
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
