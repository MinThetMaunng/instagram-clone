//
//  SocketService.swift
//  Instagram
//
//  Created by Min Thet Maung on 06/04/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit
import SocketIO
import UserNotifications


class SocketService: NSObject {
    
    public static let instance = SocketService()
    
    let manager: SocketManager
    let socket: SocketIOClient
    var center: UNUserNotificationCenter
    
    override init() {
        self.manager = SocketManager(socketURL: URL(string: BASE_URL)!)
        self.socket = manager.defaultSocket
        self.center = UNUserNotificationCenter.current()
        super.init()
        self.requestAuthorization()
    }
    
    
    func joinRooms() {
        guard AuthService.instance.jwtToken != "" else { return }
        
        socket.emit( SocketEvents.JOIN_ROOMS.rawValue, AuthService.instance.jwtToken) {
            
            self.socket.on(SocketEvents.JOIN_STATUS.rawValue) { (dataArray, ack) in
                guard let data = dataArray[0] as? [String: Bool] else { return }
                if data["success"] == true {
                    print("JOIN SUCCESS")
                } else {
                    print("Connecting rooms error")
                }
            }
        }
    }
    
    
    func fetchChatboxes(completion: @escaping (Result<[ChatBox], Error>) -> ()) {
        socket.emit(SocketEvents.GET_CHATBOXES.rawValue, AuthService.instance.jwtToken) {

            self.socket.on(SocketEvents.RECEIVE_CHATBOXES.rawValue) { (dataArray, ack) in

                guard let data = dataArray[0] as? [[String: Any]] else { return }
                    
                do {
                    let dataJson = try JSONSerialization.data(withJSONObject: data, options: .init())
                    let json = try JSONDecoder().decode([ChatBox].self, from: dataJson)
                  
                    completion(.success(json))
                    
                } catch(let err) {
                    completion(.failure(err))
                }
            }
        }
        
    }
    
    func createChatbox(user2: String, completion: @escaping (Result<ChatBox, Error>) -> ()) {
        
        socket.emit(SocketEvents.CREATE_CHAT_BOX.rawValue, AuthService.instance.jwtToken, AuthService.instance.userId, user2) {
    
            self.socket.on(SocketEvents.GET_CHATBOX.rawValue) { (dataArray, ack) in
               
                guard let data = dataArray[0] as? [String: Any] else { return }

                do {
                    let dataJson = try JSONSerialization.data(withJSONObject: data, options: .init())
                    let json = try JSONDecoder().decode(ChatBox.self, from: dataJson)
                    completion(.success(json))
                    
                } catch(let err) {
                    print("ERR in create chatbox= \(err)")
                    completion(.failure(err))
                }
            }
        }
        
    }
    
    func sendMessage(message: String, chatboxId: String, completion: @escaping (Bool) -> ()) {
        socket.emit(SocketEvents.SEND_NEW_MESSAGE.rawValue, AuthService.instance.jwtToken, message, chatboxId) {
            completion(true)
        }
    }
    
    func listenNewMessage(completion: @escaping (Result<Message, Error>) -> ()) {
        
        socket.on(SocketEvents.RECEIVE_NEW_MESSAGE.rawValue) { (dataArray, ack) in
            guard let data = dataArray[0] as? [String: Any] else { return }
            do {
                let dataJson = try JSONSerialization.data(withJSONObject: data, options: .init())
                let json = try JSONDecoder().decode(Message.self, from: dataJson)
               
                completion(.success(json))
            } catch (let err) {
                completion(.failure(err))
            }

        }
    }
    
    func fetchMessages(chatbox: String, completion: @escaping (Result<[Message], Error>) -> ()) {
        
        socket.emit(SocketEvents.GET_MESSAGES.rawValue, AuthService.instance.jwtToken, chatbox) {
            
            self.socket.on(SocketEvents.RECEIVE_MESSAGES.rawValue) { (dataArray, ack) in
                guard let data = dataArray[0] as? [[String: Any]] else { return }
                do {
                    let dataJson = try JSONSerialization.data(withJSONObject: data, options: .init())
                    let json = try JSONDecoder().decode([Message].self, from: dataJson)
                    completion(.success(json))
                } catch(let err) {
                    print("Error in fetching messages.")
                    completion(.failure(err))
                }
            }
        }
    }
    
    func connect() {
        socket.connect()
        print("CONNECTED")
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    
    private func requestAuthorization() {
        UNUserNotificationCenter.current().delegate = self
        center.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (granted, error) in
            if granted {
            }
        })
    }
    
    func receiveNotification(username: String, message: String) {
        
        center.getNotificationSettings(completionHandler: { (settings) in
            guard settings.authorizationStatus == .authorized else { return }
            
            if settings.alertSetting == .enabled && settings.badgeSetting == .enabled && settings.soundSetting == .enabled {
                let content = UNMutableNotificationContent()
                content.title = username
                content.body = message
                content.sound = .default
                
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
                self.center.add(request, withCompletionHandler: { (error) in
                    
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


extension SocketService: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse, withCompletionHandler
        completionHandler: @escaping () -> Void) {

        // do something with the notification
        print(response.notification.request.content.userInfo)

        // the docs say you should execute this asap
        return completionHandler()
    }

    // called if app is running in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent
        notification: UNNotification, withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void) {

        // show alert while app is running in foreground
        return completionHandler([.sound, .alert, .badge])
    }
}
