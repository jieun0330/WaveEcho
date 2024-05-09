//
//  UserDefaultsManager.swift
//  WaveEcho
//
//  Created by 박지은 on 5/4/24.
//

import Foundation

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private init() { }
    
    enum UserDefaultsKey: String {
        case accessToken
        case refreshToken
        case userID
        case email
        case nickname
        case sendPost
    }
    
    let userDefaults = UserDefaults.standard
    
    var accessToken: String {
        get {
            userDefaults.string(forKey: UserDefaultsKey.accessToken.rawValue) ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultsKey.accessToken.rawValue)
        }
    }
    
    var refreshToken: String {
        get {
            userDefaults.string(forKey: UserDefaultsKey.refreshToken.rawValue) ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultsKey.refreshToken.rawValue)
        }
    }
    
    var userID: String {
        get {
            userDefaults.string(forKey: UserDefaultsKey.userID.rawValue) ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultsKey.userID.rawValue)
        }
    }
    
    var email: String {
        get {
            userDefaults.string(forKey: UserDefaultsKey.email.rawValue) ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultsKey.email.rawValue)
        }
    }
    
    var nickname: String {
        get {
            userDefaults.string(forKey: UserDefaultsKey.nickname.rawValue) ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultsKey.nickname.rawValue)
        }
    }
    
    var sendPost: Int {
        get {
            userDefaults.integer(forKey: UserDefaultsKey.sendPost.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultsKey.sendPost.rawValue)
        }
    }
}
