//
//  SocketService.swift
//  Instagram
//
//  Created by Min Thet Maung on 06/04/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {
    static let instance = SocketService()
    
    let manager: SocketManager
    let socket: SocketIOClient
    
    override init() {
        self.manager = SocketManager(socketURL: URL(string: BASE_URL)!)
        self.socket = manager.defaultSocket
        
        super.init()
    }
    
    
    func joinRooms() {
        guard AuthService.instance.jwtToken != "" else { return }
        
        socket.emit(SocketEvents.JOIN_ROOMS.rawValue, AuthService.instance.jwtToken) {
            
            self.socket.on(SocketEvents.JOIN_STATUS.rawValue) { (dataArray, ack) in
                guard let data = dataArray[0] as? [String: Bool] else { return }

                if data["success"] == true {
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
        joinRooms()
    }
    
    func disconnect() {
        socket.disconnect()
    }
}
