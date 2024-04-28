//
//  EditMyProfileRequestBody.swift
//  WaveEcho
//
//  Created by 박지은 on 4/28/24.
//

import Foundation

struct EditMyProfileRequestBody: Encodable {
    let nick: String
    let phoneNum: String?
    let birthDay: String?
    let profile: Data?
}
