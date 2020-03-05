//
//  Constants.swift
//  Instagram
//
//  Created by Min Thet Maung on 25/02/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit

let primaryColor = #colorLiteral(red: 0.7647058824, green: 0.2156862745, blue: 0.3921568627, alpha: 1)
let secondaryColor = #colorLiteral(red: 0.1137254902, green: 0.1490196078, blue: 0.4431372549, alpha: 1)

let CHANGE_TO_DARK = Notification.Name("CHANGE_TO_DARK")
let CHANGE_TO_LIGHT = Notification.Name("CHANGE_TO_LIGHT")

let BASE_URL = "http://192.168.0.102:3000"
let SIGNUP_URL = "\(BASE_URL)/users/signup"
let LOGIN_URL = "\(BASE_URL)/users/login"
