//
//  PayResponse.swift
//  WaveEcho
//
//  Created by 박지은 on 5/10/24.
//

import Foundation

struct PayResponse: Decodable {
    let success: Bool?
    let imp_uid: String?
    let merchant_uid: String?
    let description: String?
    let error_code: String?
}
