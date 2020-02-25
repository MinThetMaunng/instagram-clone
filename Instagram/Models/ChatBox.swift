//
//  ChatBox.swift
//  Instagram
//
//  Created by Min Thet Maung on 25/02/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import Foundation

struct ChatBox: Codable {
    var id: String?
    var lastMin: String?
    var chatUserName: String
    var chatUserImage: String?
    var lastMessage: String?
}
