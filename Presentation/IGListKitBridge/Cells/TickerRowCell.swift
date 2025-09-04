//
//  TickerRowCell.swift
//  Temperature_IGListKit_RxSwift_ReSwift.entitlements
//
//  Created by Dev Tech on 2025/09/04.
//

// Presentation/IGListKitBridge/Cells/TickerRowCell.swift
import UIKit
import IGListKit // CHANGED(fix-to:): セクションコントローラを同ファイルに置く場合に必要

// 小さなスパークライン描画ビュー
final class SparklineView: UIView {
    private let line = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        line.fillColor = UIColor.clear.cgColor
        line.lineWidth = 2
        line.lineJoin = .round
        line.lineCap = .round
        layer.addSublayer(line)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func setData(_ values: [Double], color: UIColor) {
        guard values.count >= 2 else {
            line.path = nil
            return
        }
        let minV = values.min() ?? 0
        let maxV = values.max() ?? 1
        let w = bounds.width
        let h = bounds.height

        let path = UIBezierPath()
        for (i, v) in values.enumerated() {
            let t = CGFloat(Double(i) / Double(values.count - 1))
            let x = t * w
            let denom = max(1e-9, maxV - minV) // 0除算回避
            let norm = (v - minV) / denom
            let y = h - CGFloat(norm) * h
            let pt = CGPoint(x: x, y: y)

            if i == 0 {
                path.move(to: pt)          // CHANGED(fix-to:): 三項演算子をやめて明示分岐
            } else {
                path.addLine(to: pt)       // CHANGED(fix-to:)
            }
        }

        line.strokeColor = color.cgColor
        line.path = path.cgPath
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        line.frame = bounds
        // サイズが変わったら再描画を呼ぶ側で setData(...) を再度呼ぶのが理想です
    }
}

// 銘柄1行セル
final class TickerRowCell: UICollectionViewCell {
    private let symbol = UILabel()
    private let price  = UILabel()
    private let change = UILabel()
    private let spark  = SparklineView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true

        symbol.font = .preferredFont(forTextStyle: .headline)
        price.font  = .preferredFont(forTextStyle: .subheadline)
        change.font = .preferredFont(forTextStyle: .subheadline)

        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 2
        v.addArrangedSubview(symbol)
        let h = UIStackView(arrangedSubviews: [price, change])
        h.spacing = 8
        v.addArrangedSubview(h)

        let root = UIStackView(arrangedSubviews: [v, spark])
        root.spacing = 12
        root.alignment = .center
        root.translatesAutoresizingMaskIntoConstraints = false
        spark.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(root)

        NSLayoutConstraint.activate([
            root.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            root.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            root.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            root.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            spark.widthAnchor.constraint(equalToConstant: 100),
            spark.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(symbol sym: String, last: Double, change1d: Double, sparkline: [Double]) {
        symbol.text = sym
        price.text  = String(format: "%.2f", last)
        let sign = change1d >= 0 ? "+" : ""
        change.text = "\(sign)\(String(format: "%.2f", change1d * 100))%"
        change.textColor = change1d >= 0 ? .systemGreen : .systemRed

        // スパークライン色も騰落に合わせる
        spark.setData(sparkline, color: change1d >= 0 ? .systemGreen : .systemRed)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // 影をきれいに
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.06
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
}

// セクションコントローラ（同ファイルに置く場合）
final class TickerRowSectionController: ListSectionController {
    private var item: TickerRowItem?

    override init() {
        super.init()
        inset = .init(top: 6, left: 16, bottom: 0, right: 16)
    }

    override func numberOfItems() -> Int { 1 }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let ctx = collectionContext else { return .zero }
        let w = ctx.containerSize.width - inset.left - inset.right
        return .init(width: w, height: 68)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(of: TickerRowCell.self, for: self, at: index) as! TickerRowCell
        if let it = item {
            cell.configure(symbol: it.symbol, last: it.last, change1d: it.change1dPct, sparkline: it.spark)
        }
        return cell
    }

    override func didUpdate(to object: Any) {
        item = object as? TickerRowItem
    }
}
