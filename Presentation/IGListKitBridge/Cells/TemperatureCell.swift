//
//  TemperatureCell.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/30.
//

// Presentation/IGListKitBridge/Cells/TemperatureCell.swift
import UIKit

final class TemperatureCell: UICollectionViewCell {

    // MARK: UI
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()

    // CHANGED(ref): 値を載せる“色ピル”
    private let valueBadge = UIView()
    private let hstack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        // CHANGED(ref): 白カード＋影（背景グラデはやめる）
        contentView.backgroundColor = Theme.uiColor(Theme.Hex.cardBg)
        contentView.layer.cornerRadius = 14
        contentView.layer.masksToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.06
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 2)

        titleLabel.font = .preferredFont(forTextStyle: .body)
        titleLabel.textColor = .label

        valueLabel.font = .preferredFont(forTextStyle: .headline)
        valueLabel.textColor = .white
        valueLabel.textAlignment = .center

        // CHANGED(ref): ピル背景
        valueBadge.layer.cornerRadius = 16
        valueBadge.layer.masksToBounds = true

        // CHANGED(ref): 右側にピルを作る
        let badgeContainer = UIView()
        badgeContainer.translatesAutoresizingMaskIntoConstraints = false
        valueBadge.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        badgeContainer.addSubview(valueBadge)
        badgeContainer.addSubview(valueLabel)

        NSLayoutConstraint.activate([
            valueBadge.leadingAnchor.constraint(equalTo: badgeContainer.leadingAnchor),
            valueBadge.trailingAnchor.constraint(equalTo: badgeContainer.trailingAnchor),
            valueBadge.topAnchor.constraint(equalTo: badgeContainer.topAnchor, constant: 2),
            valueBadge.bottomAnchor.constraint(equalTo: badgeContainer.bottomAnchor, constant: -2),
            valueBadge.heightAnchor.constraint(greaterThanOrEqualToConstant: 28),

            valueLabel.leadingAnchor.constraint(equalTo: badgeContainer.leadingAnchor, constant: 10),
            valueLabel.trailingAnchor.constraint(equalTo: badgeContainer.trailingAnchor, constant: -10),
            valueLabel.centerYAnchor.constraint(equalTo: badgeContainer.centerYAnchor)
        ])

        hstack.axis = .horizontal
        hstack.alignment = .center
        hstack.spacing = 12
        hstack.translatesAutoresizingMaskIntoConstraints = false
        hstack.addArrangedSubview(titleLabel)
        hstack.addArrangedSubview(badgeContainer)

        contentView.addSubview(hstack)
        NSLayoutConstraint.activate([
            hstack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            hstack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            hstack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            hstack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            // ピルの最小幅
            badgeContainer.widthAnchor.constraint(greaterThanOrEqualToConstant: 92)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: Configure
    func configure(region: String, celsius: Double) {
        titleLabel.text = region
        valueLabel.text = String(format: "%.1f℃", celsius)

        // CHANGED(ref): 温度レンジに応じた“ピル色”
        let color = TemperatureColorProvider.badge(for: celsius)
        valueBadge.backgroundColor = color

        // 暗い背景色のときでも可読に
        valueLabel.textColor = .white
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
}
