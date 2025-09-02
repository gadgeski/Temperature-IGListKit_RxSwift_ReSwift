//
//  LoadingCell.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/30.
//

import UIKit

final class LoadingCell: UICollectionViewCell {
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(state: LoadingItem.State) {
        switch state {
        case .loading: label.text = "Loading…"
        case .empty:   label.text = "No data"
        case .error(let msg): label.text = "Error: \(msg)"
        }
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI

#Preview("LoadingCell – loading") {
    UIViewPreview {
        let cell = LoadingCell(frame: .init(x: 0, y: 0, width: 375, height: 60))
        cell.configure(state: .loading)
        return cell
    }
    .frame(width: 375, height: 60)
}

#Preview("LoadingCell – empty") {
    UIViewPreview {
        let cell = LoadingCell(frame: .init(x: 0, y: 0, width: 375, height: 60))
        cell.configure(state: .empty)
        return cell
    }
    .frame(width: 375, height: 60)
}

#Preview("LoadingCell – error") {
    UIViewPreview {
        let cell = LoadingCell(frame: .init(x: 0, y: 0, width: 375, height: 60))
        cell.configure(state: .error("Network error"))
        return cell
    }
    .frame(width: 375, height: 60)
}
#endif
