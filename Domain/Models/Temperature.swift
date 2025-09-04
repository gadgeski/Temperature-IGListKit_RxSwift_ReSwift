//
//  Temperature.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/29.
//

import Foundation

public struct Temperature: Identifiable, Equatable {
    public let id: String
    public let region: String
    public let celsius: Double
    public let date: Date

    public init(id: String = UUID().uuidString, region: String, celsius: Double, date: Date) {
        self.id = id
        self.region = region
        self.celsius = celsius
        self.date = date
    }
}
