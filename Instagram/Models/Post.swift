//
//  Post.swift
//  Instagram
//
//  Created by Min Thet Maung on 25/02/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import Foundation

struct Post: Codable {
    let userName: String
    let profileImage: String?
    let postImage: String?
    let status: String?
    let createdDate: String
}
