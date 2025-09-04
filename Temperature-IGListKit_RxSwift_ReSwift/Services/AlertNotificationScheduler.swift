//
//  AlertNotificationScheduler.swift
//  Tenperature-IGListKit_RxSwift_ReSwift
//
//  Created by Dev Tech on 2025/08/31.
//

import Foundation
import UserNotifications

enum AlertNotificationScheduler {
    static func requestAuthorizationIfNeeded() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            guard settings.authorizationStatus != .authorized else { return }
            center.requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
        }
    }

    static func schedule(event: WeatherEvent) {
        requestAuthorizationIfNeeded()

        let content = UNMutableNotificationContent()
        switch event.kind {
        case .heatwave:
            content.title = "猛暑見込み（\(event.region)）"
            content.body  = "飲料・空調・UV関連に注目が集まる可能性があります。"
        case .coldwave:
            content.title = "寒波見込み（\(event.region)）"
            content.body  = "暖房器具・衣料・ガス関連に注目が集まる可能性があります。"
        }
        content.sound = .default

        // デモ: 即時(2秒後)に1回。運用では時間帯を制御してください。
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let req = UNNotificationRequest(identifier: "weather.\(event.kind).\(UUID().uuidString)", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
    }
}
