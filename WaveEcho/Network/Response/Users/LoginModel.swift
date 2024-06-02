//
//  LoginResponse.swift
//  WaveEcho
//
//  Created by 박지은 on 4/15/24.
//

import Foundation

struct LoginModel: Decodable {
    let user_id: String
    let email: String
    let nick: String
    let profileImage: String?
    let accessToken: String
    let refreshToken: String
}
