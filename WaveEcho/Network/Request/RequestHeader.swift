//
//  RequestHeader.swift
//  WaveEcho
//
//  Created by 박지은 on 4/12/24.
//

import Foundation

struct RequestHeader: Decodable {
    let accessToken: String
    let refreshToken: String
}

