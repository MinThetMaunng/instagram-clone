//
//  AuthService.swift
//  Instagram
//
//  Created by Min Thet Maung on 13/03/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import Foundation

class AuthService {
    static let instance = AuthService()
    
    var defaults = UserDefaults.standard
    
    var isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: UserDefaultsKey.IS_LOGGED_IN.rawValue)
        }
        set {
            defaults.set(newValue, forKey: UserDefaultsKey.IS_LOGGED_IN.rawValue)
        }
    }
    
    var jwtToken: String {
        get {
            return defaults.string(forKey: UserDefaultsKey.JWT_TOKEN.rawValue) ?? ""
        }
        set {
            defaults.set(newValue, forKey: UserDefaultsKey.JWT_TOKEN.rawValue)
        }
    }
    
    var userId: String {
        get {
            return defaults.string(forKey: UserDefaultsKey.USER_ID.rawValue) ?? ""
        }
        set {
            defaults.set(newValue, forKey: UserDefaultsKey.USER_ID.rawValue)
        }
    }
}
