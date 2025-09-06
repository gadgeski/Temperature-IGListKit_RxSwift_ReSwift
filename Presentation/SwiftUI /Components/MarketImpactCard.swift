//
//  MarketImpactCard.swift
//  Temperature_IGListKit_RxSwift_ReSwift.entitlements
//
//  Created by Dev Tech on 2025/09/04.
//

import SwiftUI

/// 📈 注目セクターカード
struct MarketImpactCard: View {
    let marketData: MarketData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                Text("注目セクター")
            }
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(.white)

            // CHANGED: featuredSectorsが空かどうかで表示を分岐
            if marketData.featuredSectors.isEmpty {
                // ADDED: データが空の場合の「Empty State」表示
                Text("現在、特に注目すべきセクターはありません。")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical)
            } else {
                // データが存在する場合の表示
                VStack(spacing: 12) {
                    ForEach(marketData.featuredSectors.indices, id: \.self) { index in
                        let sector = marketData.featuredSectors[index]
                        sectorImpactRow(sector)
                    }
                }
            }
        }
        .padding(24)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
    
    // 📈 セクターごとの行表示
    private func sectorImpactRow(_ sector: SectorImpact) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(sector.sectorName)
                    .font(.subheadline).fontWeight(.bold)
                Text(sector.tickers.joined(separator: ", "))
                    .font(.caption).opacity(0.7)
            }
            .foregroundColor(.white)
            
            Spacer()
            
            Text(String(format: "%+.1f%%", sector.changePercentage))
                .font(.headline).fontWeight(.semibold)
                .foregroundColor(sector.changePercentage >= 0 ? .green : .red)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background((sector.changePercentage >= 0 ? Color.green : Color.red).opacity(0.15))
                .clipShape(Capsule())
        }
    }
}
