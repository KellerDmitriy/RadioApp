//
//  NotificationsService.swift
//  RadioApp
//
//  Created by Келлер Дмитрий on 08.08.2024.
//

import SwiftUI
import Foundation
import UserNotifications

// MARK: - NotificationsService
// A service class responsible for handling user notifications
final class NotificationsService {
    
    // MARK: - Properties
    
    // Singleton instance of NotificationsService
    public static let shared = NotificationsService()
    
    // User's selected language for localization
    @AppStorage("selectedLanguage") private var language = LocalizationService.shared.language
    
    // Tracks whether the app has requested notification permissions
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
    
    // Private initializer to enforce singleton pattern
    private init() {}
    
    // MARK: - Methods
    
    // Saves the user's notification preference to UserDefaults
    private func saveNotificationPreference(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: "hasRequestedNotifications")
    }
    
    // Requests notification authorization from the user
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
    
    // Sends a test notification to the user
    func sendTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = Resources.Text.notificationTitle
        content.body = getRandomNotificationBody()
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // Returns a random notification body text based on the selected language
    private func getRandomNotificationBody() -> String {
        let notifications = [
            Resources.Text.notificationBody.localized(language),
            Resources.Text.notificationBody2.localized(language),
            Resources.Text.notificationBody3.localized(language),
            Resources.Text.notificationBody4.localized(language)
        ]
        return notifications.randomElement() ?? Resources.Text.notificationBody1
    }
    
    // Cancels all pending and delivered notifications
    func cancelNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}
