//
//  NotificationsService.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 08.08.2024.
//

import SwiftUI
import Foundation
import UserNotifications

final class NotificationsService {
    // MARK: - Properties
    public static let shared = NotificationsService()
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
    var hasRequestedNotifications: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "hasRequestedNotifications")
        }
        set {
            if newValue != hasRequestedNotifications {
                if newValue {
                    requestNotificationAuthorization()
                }
            }
        }
    }
    
    // MARK: - Init
    private init() {}
    
    // MARK: - Methods
    
    private func saveNotificationPreference(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: "hasRequestedNotifications")
    }
    
    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                self.sendTestNotification()
                print("Notifications authorized")
            } else if let error = error {
                print("Authorization failed: \(error.localizedDescription)")
            }
        }
        
    }
    
    func sendTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = Resources.Text.notificationTitle
        content.body = getRandomNotificationBody()
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    private func getRandomNotificationBody() -> String {
            let notifications = [
                Resources.Text.notificationBody.localized(language),
                Resources.Text.notificationBody2.localized(language),
                Resources.Text.notificationBody3.localized(language),
                Resources.Text.notificationBody4.localized(language)
            ]
        return notifications.randomElement() ?? Resources.Text.notificationBody1
        }
}
