//
//  MarketImpactCardCell.swift
//  Temperature_IGListKit_RxSwift_ReSwift.entitlements
//
//  Created by Dev Tech on 2025/09/04.
//

// Presentation/IGListKitBridge/Cells/MarketImpactCardCell.swift
import UIKit
import IGListKit   // CHANGED(fix)

final class MarketImpactCardCell: UICollectionViewCell {
    private let title = UILabel()
    private let value = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 14
        contentView.layer.masksToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.06
        layer.shadowRadius = 6
        layer.shadowOffset = .init(width: 0, height: 2)

        title.font = .preferredFont(forTextStyle: .subheadline)
        value.font = .preferredFont(forTextStyle: .title3)

        let v = UIStackView(arrangedSubviews: [title, value])
        v.axis = .vertical; v.spacing = 6
        v.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(v)
        NSLayoutConstraint.activate([
            v.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            v.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            v.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            v.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(sector: String, change1dPct: Double) {
        title.text = sector
        let sign = change1dPct >= 0 ? "+" : ""
        value.text = "\(sign)\(String(format: "%.1f", change1dPct * 100))%"
        value.textColor = change1dPct >= 0 ? .systemGreen : .systemRed
    }
}

final class MarketImpactCardSectionController: ListSectionController {
    private var item: MarketImpactItem?

    override init() {
        super.init()
        inset = .init(top: 6, left: 16, bottom: 0, right: 16)
    }

    override func numberOfItems() -> Int { 1 }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let ctx = collectionContext else { return .zero }
        let w = ctx.containerSize.width - inset.left - inset.right
        return .init(width: w, height: 72)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(
            of: MarketImpactCardCell.self, for: self, at: index
        ) as! MarketImpactCardCell
        if let it = item {
            cell.configure(sector: it.sector, change1dPct: it.change1dPct)
        }
        return cell
    }

    override func didUpdate(to object: Any) {
        item = object as? MarketImpactItem
    }
}
