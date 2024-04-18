//
//  WithdrawResponse.swift
//  WaveEcho
//
//  Created by 박지은 on 4/18/24.
//

import Foundation

struct WithdrawResponse: Decodable {
    let user_id: String
    let email: String
    let nick: String
}
