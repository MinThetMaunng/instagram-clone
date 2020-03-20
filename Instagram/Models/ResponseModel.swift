//
//  LoginResult.swift
//  Instagram
//
//  Created by Min Thet Maung on 05/03/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit

struct LoginResponse: Codable {
    var status: Int
    var token: String?
    var msg: String?
    var data: User?
    var error: ErrorMessage?
}

struct SignupResponse: Codable {
    var status: Int
    var msg: String?
    var error: ErrorMessage?
}

struct CreatePostResponse: Codable {
    var status: Int
    var msg: String?
    var data: String?
    var error: PostErrorMessage?
}

struct GetAllPostResponse: Codable {
    var status: Int
    var msg: String?
    var data: [Post]?
    var error: PostErrorMessage?
    var total: Int?
}

struct PostErrorMessage: Codable {
    var user: [String]?
    var status: [String]?
}

struct ErrorMessage: Codable {
    var email: [String]?
    var username: [String]?
    var password: [String]?
}

struct Post: Codable {
    var _id: String
    var status: String?
    var photo: String?
    var createdAt: String?
    var updatedAt: String?
    var user: User?
    var __v: Int?
}


struct User: Codable {
    var _id: String
    var photo: String?
    var username: String?
    var email: String?
    var password: String?
    var profileImage: String?
    var __v: Int?
}