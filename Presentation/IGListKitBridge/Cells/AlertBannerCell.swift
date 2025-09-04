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
    private var backgroundGradient: CAGradientLayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 14
        contentView.layer.masksToBounds = true

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.06
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 2)

        titleLabel.font = .preferredFont(forTextStyle: .headline)
        subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        subtitleLabel.numberOfLines = 2

        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(subtitleLabel)

        contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // CHANGED(ref): 種別により配色
    func configure(title: String, subtitle: String, kind: WeatherEventKind) {
        titleLabel.text = title
        subtitleLabel.text = subtitle

        let colors = TemperatureColorProvider.bannerColors(forHeatwave: kind == .heatwave)
        if let gl = backgroundGradient {
            gl.colors = colors
        } else {
            let gl = CAGradientLayer()
            gl.startPoint = CGPoint(x: 0, y: 0)
            gl.endPoint   = CGPoint(x: 1, y: 1)
            gl.cornerRadius = contentView.layer.cornerRadius
            gl.colors = colors
            contentView.layer.insertSublayer(gl, at: 0)
            backgroundGradient = gl
        }
        // 文字は白でコントラスト確保
        titleLabel.textColor = .white            // CHANGED(ref)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.85) // CHANGED(ref)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundGradient?.frame = contentView.bounds
        backgroundGradient?.cornerRadius = contentView.layer.cornerRadius
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
}
