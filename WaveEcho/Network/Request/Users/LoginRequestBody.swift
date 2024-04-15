//
//  LoginRequestBody.swift
//  WaveEcho
//
//  Created by 박지은 on 4/10/24.
//

import Foundation

struct LoginRequestBody: Encodable {
    let email: String
    let password: String
}
