//
//  ReminderManager.swift
//  Kuttaib
//
//  Created by mco on 05/11/26.
//


import Foundation
import UserNotifications

struct ReminderSetting: Codable {
    let isEnabled: Bool
    let hour: Int
    let minute: Int
    let selectedDays: [Weekday]

}

enum NotificationPermissionStatus {
    case authorized
    case denied
    case notDetermined
}


final class ReminderManager {

    static let shared = ReminderManager()

    private let key = "kuttaib_reminder"

    private init() {}
    
    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current()
            .requestAuthorization(
                options: [.alert, .sound, .badge]
            ) { granted, _ in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
    }
    
    func save(_ setting: ReminderSetting) {
        do {
            let data = try JSONEncoder().encode(setting)
            UserDefaults.standard.set(data, forKey: key)
            
            scheduleNotifications()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func load() -> ReminderSetting? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(ReminderSetting.self, from: data)
    }
    
    func scheduleNotifications() {
        guard let setting = load() else { return }

        removeNotifications()
        
        guard setting.isEnabled else { return }
        
        setting.selectedDays.forEach { weekday in
            let content = UNMutableNotificationContent()
            
            content.title = "Waktunya Menghafal 📖"
            content.body = "Jangan lewatkan target hafalan hari ini."
            content.sound = .default
            
            var dateComponents = DateComponents()
            
            dateComponents.weekday = weekday.rawValue
            dateComponents.hour = setting.hour
            dateComponents.minute = setting.minute
            
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: dateComponents,
                repeats: true
            )
            
            let request = UNNotificationRequest(
                identifier: "hafalan_\(weekday.rawValue)",
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current()
                .add(request) { error in
                    if let error {
                        print(error.localizedDescription)
                    }
                }
        }
    }
    
    func removeNotifications() {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(
                withIdentifiers: [
                    "hafalan_1",
                    "hafalan_2",
                    "hafalan_3",
                    "hafalan_4",
                    "hafalan_5",
                    "hafalan_6",
                    "hafalan_7"
                ]
            )
    }
    
    func fetchStatus(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current()
            .getNotificationSettings { settings in
                DispatchQueue.main.async {
                    completion(
                        settings.authorizationStatus == .authorized
                    )
                }
            }
    }
    
    func syncNotificationsIfNeeded() {
        guard let setting = load(), setting.isEnabled else { return }

        UNUserNotificationCenter.current()
            .getPendingNotificationRequests { requests in
                if requests.isEmpty {
                    self.scheduleNotifications()
                }
            }
    }
    
    func checkPermissionStatus(completion: @escaping (NotificationPermissionStatus) -> Void) {
        
        UNUserNotificationCenter.current()
            .getNotificationSettings { setting in
                let status: NotificationPermissionStatus
                
                switch setting.authorizationStatus {
                case .authorized, .provisional, .ephemeral:
                    status = .authorized
                case .notDetermined:
                    status = .notDetermined
                case .denied:
                    status = .denied
                @unknown default:
                    status = .denied
                }

                DispatchQueue.main.async {
                    completion(status)
                }
            }
    }
}
