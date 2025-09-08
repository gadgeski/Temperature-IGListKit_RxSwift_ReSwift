//
//  RealWeatherDataService.swift
//  Temperature_IGListKit_RxSwift_ReSwift.entitlements
//
//  Created by Dev Tech on 2025/09/07.
//

// CHANGED: このファイルは、既存のエラーハンドリングにデバッグログ出力を追加しています
import Foundation
import RxSwift
import RxCocoa

// ユーザーが定義したNetworkErrorをここに配置します
enum NetworkError: Error {
    case unauthorized         // 401 認証エラー（APIキー無効など）
    case requestFailed        // ステータスコード不正など包括的失敗
    case decodingFailed       // JSON デコード失敗
    case invalidURL           // URL 構築失敗
    case transport(URLError)  // 下層の URLError を内包
    case httpStatus(Int)      // 任意の HTTP ステータスコードを保持
}

/// 外部の天気予報APIとの通信に関する責務を持つクラス
final class RealWeatherDataService {
    
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    
    init() {}
    
    /// 指定された緯度経度の天気情報を取得する
    func fetchWeatherData(latitude: Double, longitude: Double) -> Single<OpenWeatherResponse> {
        guard var urlComponents = URLComponents(string: baseURL) else {
            return .error(NetworkError.invalidURL)
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "lat", value: "\(latitude)"),
            URLQueryItem(name: "lon", value: "\(longitude)"),
            URLQueryItem(name: "appid", value: APIKeys.openWeatherMap),
            URLQueryItem(name: "units", value: "metric")
        ]
        
        guard let url = urlComponents.url else {
            return .error(NetworkError.invalidURL)
        }
        
        let request = URLRequest(url: url)
        
        return URLSession.shared.rx.response(request: request)
            // ADDED: .do()オペレータを使って、ストリームに影響を与えずに中身を覗き見します
            .do(
                onNext: { (response: HTTPURLResponse, data: Data) in
                    // --- この部分がコンソールに出力されます ---
                    print("--- 📬 API Response Received ---")
                    print("URL: \(response.url?.absoluteString ?? "N/A")")
                    print("Status Code: \(response.statusCode)")
                    print("Response Body:\n\(String(data: data, encoding: .utf8) ?? "Could not print body")")
                    print("-----------------------------")
                },
                onError: { error in
                    print("--- 🚨 API Request Error ---")
                    print(error)
                    print("-------------------------")
                }
            )
            // CHANGED: エラー処理を一つのmapに集約してシンプルにします
            .map { (response: HTTPURLResponse, data: Data) -> Data in
                if response.statusCode == 401 {
                    throw NetworkError.unauthorized
                }
                guard 200..<300 ~= response.statusCode else {
                    throw NetworkError.httpStatus(response.statusCode)
                }
                return data
            }
            .map { data -> OpenWeatherResponse in
                do {
                    let decoder = JSONDecoder()
                    return try decoder.decode(OpenWeatherResponse.self, from: data)
                } catch {
                    // デコードに失敗した場合、詳細なエラーを出力します
                    print("--- 🔍 Decoding Error ---")
                    print(error)
                    print("----------------------")
                    throw NetworkError.decodingFailed
                }
            }
            .asSingle()
    }
}
