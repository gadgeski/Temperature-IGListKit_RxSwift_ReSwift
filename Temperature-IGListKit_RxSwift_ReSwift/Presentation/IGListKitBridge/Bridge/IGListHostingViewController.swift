//
//  IGListHostingViewController.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/29.
//

import UIKit
import IGListKit

/// Hosts UICollectionView + ListAdapter and exposes `update(objects:)`.
final class IGListHostingViewController: UIViewController {

    // MARK: - UI

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    // MARK: - Adapter / DataSource

    private let dataSource = IGListObjectsDataSource()

    /// Create adapter with working range enabled (set 0 to disable).
    private lazy var adapter: ListAdapter = {
        let updater = ListAdapterUpdater()
        let adapter = IGListAdapterProvider.makeAdapter(
            updater: updater,
            viewController: self,
            workingRangeSize: 1   // ← 先読みしたくなければ 0
        )
        adapter.collectionView = collectionView
        adapter.dataSource = dataSource
        return adapter
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // instantiate lazy adapter now that collectionView is ready
        _ = adapter
    }

    // MARK: - Public API

    /// Push new diffable objects to the adapter.
    /// - Parameters:
    ///   - objects: Array of ListDiffable
    ///   - animated: Whether to animate the transition
    @MainActor
    func update(objects: [ListDiffable], animated: Bool = true) {
        dataSource.set(objects: objects)
        Task { [weak self] in
            guard let self else { return }
            _ = await self.adapter.performUpdates(animated: animated)
        }
    }
}
