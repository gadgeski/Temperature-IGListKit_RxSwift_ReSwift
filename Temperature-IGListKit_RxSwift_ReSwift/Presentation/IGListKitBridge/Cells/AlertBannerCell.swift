//
//  AlertBannerCell.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/31.
//

// Presentation/IGListKitBridge/Cells/AlertBannerCell.swift
import UIKit

final class AlertBannerCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let stack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true

        titleLabel.font = .preferredFont(forTextStyle: .headline)
        subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 2

        stack.axis = .vertical
        stack.spacing = 4
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(subtitleLabel)

        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // CHANGED: 種別で配色
    func configure(title: String, subtitle: String, kind: WeatherEventKind) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        switch kind {
        case .heatwave:
            contentView.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.22)
        case .coldwave:
            contentView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.20)
        }
    }
}
