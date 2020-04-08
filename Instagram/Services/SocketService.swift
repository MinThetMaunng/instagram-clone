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
    
    func fetchChatboxes(completion: @escaping (Result<[ChatBox], Error>) -> ()) {
        
//        createChatbox(user1: "5e84499235db99002470420d", user2: "5e844a8b35db990024704213") { (complete) in
//            print(complete)
//        }

        socket.emit(SocketEvents.RETRIEVE_CHATBOXES.rawValue, AuthService.instance.jwtToken) {
    
            self.socket.on(SocketEvents.SEND_CHATBOXES.rawValue) { (dataArray, ack) in
               
                guard let data = dataArray[0] as? [[String: Any]] else { return }
                    
                do {
                    let DataJson = try JSONSerialization.data(withJSONObject: data, options: .init())
                    let json = try JSONDecoder().decode([ChatBox].self, from: DataJson)
                    completion(.success(json))
                } catch(let err) {
                    print("error")
                    completion(.failure(err))
                }
            }
            
            
        }
        
        
    }
    
    func createChatbox(user1: String, user2: String, completion: @escaping (Bool) -> ()) {
        socket.emit(SocketEvents.CREATE_CHAT_BOX.rawValue, user1, user2) {
            self.socket.on(SocketEvents.RETRIEVE_MESSAGES.rawValue) { (data, ack) in
                print("data")
                print(data)
            }
        }
    }
    
    func connect() {
        print("Connected")
        socket.connect()
    }
    
    func disconnect() {
        print("Disconnected")
        socket.disconnect()
    }
}
