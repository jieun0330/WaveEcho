//
//  MyProfileResponse.swift
//  WaveEcho
//
//  Created by 박지은 on 4/24/24.
//

import Foundation

struct ProfileModel: Decodable {
    let user_id: String
    let email: String
    let nick: String
    let profileImage: String?
    let posts: [String]
}
