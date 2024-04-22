//
//  SignupResponse.swift
//  WaveEcho
//
//  Created by 박지은 on 4/13/24.
//

import Foundation

struct SignupResponse: Decodable {
    let user_id: String
    let email: String
    let nick: String
}
