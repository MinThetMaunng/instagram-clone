//
//  NotificationService.swift
//  Instagram
//
//  Created by Min Thet Maung on 16/04/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import Foundation
import UserNotifications


class NotificationService: NSObject, UNUserNotificationCenterDelegate {
    
    public static var instance = NotificationService()
    var center: UNUserNotificationCenter?
    
    override init() {
        super.init()
    }
    
    func requestAuthorization() {
        center = UNUserNotificationCenter.current()
        
        UNUserNotificationCenter.current().delegate = self
        center?.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (granted, error) in
            if granted {
            }
        })
    }
    
    func receiveNotification(username: String, message: String) {
        
        center?.getNotificationSettings(completionHandler: { (settings) in
            guard settings.authorizationStatus == .authorized else { return }
            
            if settings.alertSetting == .enabled && settings.badgeSetting == .enabled && settings.soundSetting == .enabled {
                let content = UNMutableNotificationContent()
                content.title = username
                content.body = message
                content.sound = .default
                
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
                self.center?.add(request, withCompletionHandler: { (error) in
                    
                    if error != nil {
                        print("Error in noti")
                        print(error)
                        return
                    }
                })
            }
        })
    }
           
}
