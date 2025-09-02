//
//  SectorChipCell.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/31.
//

import UIKit

final class SectorChipCell: UICollectionViewCell {
    private let label = PaddingLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .body)
        label.layer.cornerRadius = 14
        label.layer.masksToBounds = true
        label.backgroundColor = .tertiarySystemFill

        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(sectorName: String, count: Int) {
        label.text = "\(sectorName)（\(count)）"
    }
}

/// 内側パディング付きラベル（最小実装）
final class PaddingLabel: UILabel {
    var insets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }
    override var intrinsicContentSize: CGSize {
        let s = super.intrinsicContentSize
        return CGSize(width: s.width + insets.left + insets.right,
                      height: s.height + insets.top + insets.bottom)
    }
}
