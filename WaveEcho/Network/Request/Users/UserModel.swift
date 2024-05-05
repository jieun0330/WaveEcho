//
//  SignupRequestBody.swift
//  WaveEcho
//
//  Created by 박지은 on 4/12/24.
//

import Foundation

struct UserModel: Encodable {
    let email: String
    let password: String
    let nick: String
    let profile: Data?
}
