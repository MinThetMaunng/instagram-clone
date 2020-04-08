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
    var data: User?
    var token: String?
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

struct GetUserProfileResponse: Codable {
    var status: Int
    var msg: String?
    var data: UserProfileData?
    var total: Int?
}

struct GetUserPostsResponse: Codable {
    var status: Int
    var msg: String?
    var data: [UserPost]?
    var total: Int?
}

struct GetUsersResponse: Codable {
    var status: Int
    var msg: String?
    var error: [String:String]?
    var total: Int?
    var data: [User]?
    var followStatus: Bool?
}

struct FollowOrUnfollowResponse: Codable {
    var status: Int
    var msg: String?
    var error: FollowErrorMessage?
}

struct ChatBox: Codable {
    var _id: String
    var createdAt: String?
    var user1: User?
    var user2: User?
    var lastMessage: String
    var updatedAt: String
    var __v: Int?
}


struct UserPost: Codable {
    var _id: String
    var status: String?
    var photo: String
    var updatedAt: String?
}

struct UserProfileData: Codable {
    var noOfFollowers: Int
    var noOfFollowings: Int
    var noOfPosts: Int
    var user: User?
    var followStatus: Bool?
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

struct FollowErrorMessage: Codable {
    var whoFollow: [String]?
    var toWhom: [String]?
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

struct Follow: Codable {
    var _id: String?
    var whoFollow: String?
    var toWhom: String?
    var __v: Int?
}
