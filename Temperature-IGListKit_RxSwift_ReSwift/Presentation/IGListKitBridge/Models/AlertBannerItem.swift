//
//  AlertBannerItem.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/31.
//

// Presentation/IGListKitBridge/Models/AlertBannerItem.swift
import Foundation
import IGListKit

final class AlertBannerItem: NSObject, ListDiffable {
    let title: String
    let subtitle: String
    // CHANGED: 種別を保持（配色・識別に使う）
    let kind: WeatherEventKind

    // CHANGED: init も更新
    init(title: String, subtitle: String, kind: WeatherEventKind) {
        self.title = title
        self.subtitle = subtitle
        self.kind = kind
    }

    func diffIdentifier() -> NSObjectProtocol {
        // CHANGED: kind も含めて識別（色だけ変わる場合の再描画にも効く）
        return (kind.rawValue + "|" + title + "|" + subtitle) as NSString
    }
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let o = object as? AlertBannerItem else { return false }
        return title == o.title && subtitle == o.subtitle && kind == o.kind
    }
}
