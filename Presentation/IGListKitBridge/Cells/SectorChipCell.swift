//
//  SectorChipCell.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/31.
//

// Presentation/IGListKitBridge/Cells/SectorChipCell.swift
import UIKit

final class SectorChipCell: UICollectionViewCell {

    // MARK: - UI

    private let label = UILabel()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        // CHANGED(6): ピル型の“色バッジ”スタイル
        contentView.backgroundColor = UIColor.white.withAlphaComponent(0.85) // 明るく見せる
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 0        // 既定は枠線なし
        contentView.layer.borderColor = UIColor.clear.cgColor

        // ラベル
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])

        // アクセシビリティ
        isAccessibilityElement = true
        accessibilityTraits = .button
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Configure

    /// テキストと推奨種別（色分け用）を設定
    /// - Parameters:
    ///   - text: 表示テキスト（例: "飲料 (3)"）
    ///   - preferred: 色分け対象のイベント種別（nilなら無色のチップ）
    func configure(text: String, preferred: WeatherEventKind?) {
        label.text = text
        accessibilityLabel = text

        // CHANGED(6): 種別が分かるときは枠線カラーを付ける
        if let k = preferred {
            let color: UIColor
            switch k {
            case .heatwave:
                color = .systemRed       // 猛暑：赤系
            case .coldwave:
                color = Theme.uiColor(Theme.Hex.blueEnd) // 寒波：青系（リポ準拠）
            }
            contentView.layer.borderColor = color.withAlphaComponent(0.6).cgColor
            contentView.layer.borderWidth = 1.0
        } else {
            contentView.layer.borderColor = UIColor.clear.cgColor
            contentView.layer.borderWidth = 0.0
        }
    }

    // MARK: - Reuse

    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        contentView.layer.borderColor = UIColor.clear.cgColor   // CHANGED(6): リセット
        contentView.layer.borderWidth = 0.0                     // CHANGED(6): リセット
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        // ピル感を維持するため角丸は固定でOK（必要なら高さの半分にしても良い）
        // contentView.layer.cornerRadius = min(contentView.bounds.height / 2, 16)
    }
}
