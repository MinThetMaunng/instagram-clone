//
//  Constants.swift
//  Instagram
//
//  Created by Min Thet Maung on 25/02/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit

typealias Parameters = [String: String]

let primaryColor = #colorLiteral(red: 0.7647058824, green: 0.2156862745, blue: 0.3921568627, alpha: 1)
let secondaryColor = #colorLiteral(red: 0.1137254902, green: 0.1490196078, blue: 0.4431372549, alpha: 1)

let CHANGE_TO_DARK = Notification.Name("CHANGE_TO_DARK")
let CHANGE_TO_LIGHT = Notification.Name("CHANGE_TO_LIGHT")

let BASE_URL = "http://172.20.10.11:3000"
//let BASE_URL = "https://instagramnode.herokuapp.com"

let GET_All_USERS = "\(BASE_URL)/users"
let GET_PROFILE = "\(BASE_URL)/users/"
let LOGIN_URL = "\(BASE_URL)/users/login"
let SIGNUP_URL = "\(BASE_URL)/users/signup"
let IMAGE_UPLOAD_URL = "\(BASE_URL)/images/upload"

let GET_ALL_POST_URL = "\(BASE_URL)/posts"
let CREATE_POST_URL = "\(BASE_URL)/posts"

let FOLLOW_OR_UNFOLLOW_URL = "\(BASE_URL)/follows"

let PROFILE_IMAGE_URL = "\(BASE_URL)/profileimage/"
let PHOTO_IMAGE_URL = "\(BASE_URL)/photos/"

enum UserDefaultsKey : String {
    case USER_ID = "userId"
    case JWT_TOKEN = "jwtToken"
    case IS_LOGGED_IN = "isLoggedIn"
}

enum SocketEvents : String {
    case CONNECTION = "connection"
    
    case GET_CHATBOX = "getChatbox"
    case GET_CHATBOXES = "getChatboxes"
    case RECEIVE_CHATBOXES = "receiveChatboxes"
    case CREATE_CHAT_BOX = "createChatboxes"
    
    case JOIN_ROOMS = "joinRooms"
    case JOIN_STATUS = "joinStatus"

    case GET_MESSAGES = "getMessages"
    case RECEIVE_MESSAGES = "receiveMessages"
    
    case SEND_NEW_MESSAGE = "sendNewMessage"
    case RECEIVE_NEW_MESSAGE = "receiveNewMessage"
}

let NOTI_BACK_TO_FOREGROUND = Notification.Name("backToForeground")
