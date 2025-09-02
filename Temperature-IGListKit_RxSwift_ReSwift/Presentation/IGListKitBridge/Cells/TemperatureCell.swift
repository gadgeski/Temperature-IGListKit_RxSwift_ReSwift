//
//  TemperatureCell.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/30.
//

import UIKit

final class TemperatureCell: UICollectionViewCell {
    private let regionLabel = UILabel()
    private let valueLabel = UILabel()
    private let dateLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        regionLabel.font = .preferredFont(forTextStyle: .body)
        valueLabel.font = .monospacedDigitSystemFont(ofSize: 17, weight: .medium)
        dateLabel.font = .preferredFont(forTextStyle: .caption1)
        dateLabel.textColor = .secondaryLabel

        let v = UIStackView(arrangedSubviews: [regionLabel, valueLabel, dateLabel])
        v.axis = .vertical
        v.alignment = .leading
        v.spacing = 2
        contentView.addSubview(v)
        v.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            v.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            v.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            v.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            v.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(region: String, celsius: Double, date: Date) {
        regionLabel.text = region
        valueLabel.text = String(format: "%.1f℃", celsius)
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        dateLabel.text = f.string(from: date)
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI

#Preview("TemperatureCell") {
    UIViewPreview {
        let cell = TemperatureCell(frame: .init(x: 0, y: 0, width: 375, height: 56))
        cell.configure(region: "Tokyo", celsius: 33.4, date: .now)
        return cell
    }
    .frame(width: 375, height: 56)
}
#endif

