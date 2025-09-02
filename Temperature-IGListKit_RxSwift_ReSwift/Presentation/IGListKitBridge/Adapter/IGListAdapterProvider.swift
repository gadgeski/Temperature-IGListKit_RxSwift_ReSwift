//
//  IGListAdapterProvider.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/29.
//

import IGListKit
import UIKit

enum IGListAdapterProvider {
    static func makeAdapter(updater: ListUpdatingDelegate = ListAdapterUpdater(),
                            viewController: UIViewController?,
                            workingRangeSize: Int = 0 // 修正箇所:IGListAdapterProvider を生成時指定に変更
                        ) -> ListAdapter {
                            // ← 生成時に渡す
                            return ListAdapter(
                                updater: updater,
                                viewController: viewController,
                                workingRangeSize: workingRangeSize
                            )
                        }
                    }
