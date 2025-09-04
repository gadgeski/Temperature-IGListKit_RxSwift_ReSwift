//
//  SectorMappingProvider.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/31.
//

import Foundation

/// sector_mapping.json を読み、イベント種別→セクタ一覧を返す
final class SectorMappingProvider {
    struct Mapping: Decodable {
        let heatwave: [String: [String]]
        let coldwave: [String: [String]]
    }

    static let shared = SectorMappingProvider()
    private var cached: Mapping?

    private init() {}

    func load() throws -> Mapping {
        if let cached { return cached }
        guard let url = Bundle.main.url(forResource: "sector_mapping", withExtension: "json") else {
            throw NSError(domain: "SectorMappingProvider", code: 1, userInfo: [NSLocalizedDescriptionKey: "sector_mapping.json not found in bundle"])
        }
        let data = try Data(contentsOf: url)
        let mapping = try JSONDecoder().decode(Mapping.self, from: data)
        self.cached = mapping
        return mapping
    }

    func suggestions(for event: WeatherEvent) -> [SectorSuggestion] {
        guard let mapping = try? load() else { return [] }
        let dict: [String: [String]]
        switch event.kind {
        case .heatwave: dict = mapping.heatwave
        case .coldwave: dict = mapping.coldwave
        }
        return dict.map { SectorSuggestion(kind: event.kind, sectorName: $0.key, tickers: $0.value) }
                   .sorted { $0.sectorName < $1.sectorName }
    }
}
