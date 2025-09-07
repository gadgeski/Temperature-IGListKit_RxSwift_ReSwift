//
//  MockWeatherDataService.swift
//  Temperature_IGListKit_RxSwift_ReSwift.entitlements
//
//  Created by Dev Tech on 2025/09/05.
//

import Foundation
import RxSwift // ADDED: RxSwiftをインポート

// API通信をシミュレートし、天気データを返すサービス
final class MockWeatherDataService {

    // 様々な気温データセットを擬似的に用意
    private static let heatwaveTemperatures: [Temperature] = [
        .init(region: "東京", celsius: 36.2, date: .now),
        .init(region: "大阪", celsius: 35.5, date: .now),
        .init(region: "名古屋", celsius: 37.0, date: .now)
    ]

    private static let coldwaveTemperatures: [Temperature] = [
        .init(region: "札幌", celsius: -5.1, date: .now),
        .init(region: "旭川", celsius: -8.3, date: .now),
        .init(region: "青森", celsius: -2.0, date: .now)
    ]

    private static let normalTemperatures: [Temperature] = [
        .init(region: "東京", celsius: 25.4, date: .now),
        .init(region: "大阪", celsius: 26.1, date: .now),
        .init(region: "福岡", celsius: 24.8, date: .now)
    ]

    // 呼び出されるたびにシナリオを切り替えるためのインデックス
    private var scenarioIndex = 0

    // CHANGED: 戻り値を async -> Single に変更
    /// 天気データを非同期で取得する（という想定の）関数
    func fetchWeatherData() -> Single<(temperatures: [Temperature], condition: WeatherCondition)> {
        // Single.create を使って、非同期処理をRxのストリームにラップします
        return Single.create { single in
            // 擬似的に0.5秒待つ
            // async/awaitのコードをTaskで包むことで、Rxの世界で共存させています
            Task {
                try? await Task.sleep(nanoseconds: 500_000_000)

                // シナリオを順番に切り替える
                let scenario = self.scenarioIndex % 3
                self.scenarioIndex += 1

                switch scenario {
                case 0:
                    // 成功した場合は .success で値を流します
                    single(.success((Self.heatwaveTemperatures, .sunny)))
                case 1:
                    // 寒波なので曇りアイコンに
                    single(.success((Self.coldwaveTemperatures, .cloudy)))
                default:
                    single(.success((Self.normalTemperatures, .sunny)))
                }
            }
            // お作法として、購読解除時の処理を返します (今回は何もしません)
            return Disposables.create()
        }
    }
}
