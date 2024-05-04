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
}
