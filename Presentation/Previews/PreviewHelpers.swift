//
//  PreviewHelpers.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/31.
//

import SwiftUI
import UIKit

// 任意の UIView を SwiftUI プレビューで表示する簡易ブリッジ
struct UIViewPreview<V: UIView>: UIViewRepresentable {
    let builder: () -> V
    func makeUIView(context: Context) -> V { builder() }
    func updateUIView(_ uiView: V, context: Context) {}
}

// 既存の UIViewPreview に加えて UIViewController 用も用意
struct UIViewControllerPreview<V: UIViewController>: UIViewControllerRepresentable {
    let builder: () -> V
    func makeUIViewController(context: Context) -> V { builder() }
    func updateUIViewController(_ uiViewController: V, context: Context) {}
}
