//
//  EditMyProfileRequestBody.swift
//  WaveEcho
//
//  Created by 박지은 on 4/28/24.
//

import Foundation

struct EditMyProfileRequestBody: Codable {
    let nick: String
    let profile: Data?
}
