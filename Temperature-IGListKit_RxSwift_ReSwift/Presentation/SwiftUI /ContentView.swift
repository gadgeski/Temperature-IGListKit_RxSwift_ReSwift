//
//  ContentView.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/29.
//

// Presentation/SwiftUI/ContentView.swift
import SwiftUI

// CHANGED: 下部タブの識別子（シンプルな3タブ例）
private enum RootTab: String {
    case feed, sectors, settings
}

struct ContentView: View {
    // CHANGED: DEBUG限定のシナリオ保持（B案：@AppStorage連携）
    #if DEBUG
    @AppStorage("debug.weatherScenario") private var scenarioRaw: String = WeatherScenario.normal.rawValue
    private var scenario: WeatherScenario { WeatherScenario(rawValue: scenarioRaw) ?? .normal }
    #endif

    // CHANGED: タブ選択状態
    @State private var selectedTab: RootTab = .feed

    var body: some View {
        // CHANGED: 背景グラデ + TabView + Navigation の基本骨組み
        NavigationStack {
            ZStack {
                // 背景（軽いグラデで“手触り”を改善）
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(.systemBackground),
                        Color(.secondarySystemBackground)
                    ]),
                    startPoint: .top, endPoint: .bottom
                )
                .ignoresSafeArea()

                TabView(selection: $selectedTab) {
                    // ——— フィード（IGListKit）: ここがスクロールビュー（IGListKit側） ———
                    feedView
                        .tabItem { Label("フィード", systemImage: "list.bullet.rectangle") } // CHANGED
                        .tag(RootTab.feed)

                    // ——— 関連セクタ（プレースホルダ） ———
                    sectorsView
                        .tabItem { Label("セクタ", systemImage: "chart.bar") } // CHANGED
                        .tag(RootTab.sectors)

                    // ——— 設定（プレースホルダ） ———
                    settingsView
                        .tabItem { Label("設定", systemImage: "gearshape") } // CHANGED
                        .tag(RootTab.settings)
                }
                .tint(.orange) // CHANGED: ほんの少し色味を追加（必要ならAssetでブランド色に）
            }
            .navigationTitle(title(for: selectedTab)) // CHANGED: タブに応じたタイトル
            #if DEBUG
            .toolbar {
                // CHANGED: 右上にシナリオ切替メニュー（DEBUGのみ表示）
                ToolbarItem(placement: .topBarTrailing) {
                    Menu(scenario.label) {
                        ForEach(WeatherScenario.allCases) { s in
                            Button(s.label) { scenarioRaw = s.rawValue }
                        }
                    }
                }
            }
            #endif
        }
    }

    // MARK: - タブ毎の中身

    @ViewBuilder
    private var feedView: some View {
        if FeatureFlags.useIGListKitFeed {
            #if DEBUG
            // CHANGED: B案の注入（プレビューやデバッグで“確実に出す”）
            TemperatureFeedViewIGL(
                thresholds: scenario.thresholds, // nilでなければ閾値を上書き
                forced: scenario.forced          // 強制イベント（猛暑/寒波etc）
            )
            #else
            TemperatureFeedViewIGL()            // 本番は従来どおり（A案の既定に従う）
            #endif
        } else {
            Text("Legacy SwiftUI List (FeatureFlags off)")
                .padding()
        }
    }

    // プレースホルダ：関連セクタ（今後IGListKitで独立リストにしてもOK）
    private var sectorsView: some View {
        VStack(spacing: 12) {
            Text("関連セクタ")
                .font(.headline)
            Text("天候に応じて注目されやすい業種をここに一覧表示します。")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // プレースホルダ：設定
    private var settingsView: some View {
        Form {
            Section("表示") {
                Toggle("IGListKitを使用", isOn: .constant(FeatureFlags.useIGListKitFeed))
                    .disabled(true) // デモのため固定
                ColorPicker("アクセントカラー", selection: .constant(.orange))
                    .disabled(true) // デモのため固定
            }
            Section("通知") {
                Text("ローカル通知はアラート検知時に送信（デモ）")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }

    // CHANGED: ナビゲーションタイトル（タブごとに切替）
    private func title(for tab: RootTab) -> String {
        switch tab {
        case .feed:    return "天気フィード"
        case .sectors: return "関連セクタ"
        case .settings:return "設定"
        }
    }
}

// ——————————————————————————————————————————————
// 既存のデフォルトプレビューは残す（削らない）
// ——————————————————————————————————————————————
#Preview("ContentView – Default") {
    ContentView()
}

// CHANGED: シナリオ別プレビューを“同ファイル”にも併置（任意）
#if DEBUG
#Preview("ContentView – Heatwave") {
    ContentView()
        .onAppear { UserDefaults.standard.set(WeatherScenario.heatwave.rawValue, forKey: "debug.weatherScenario") }
}
#Preview("ContentView – Coldwave") {
    ContentView()
        .onAppear { UserDefaults.standard.set(WeatherScenario.coldwave.rawValue, forKey: "debug.weatherScenario") }
}
#endif
