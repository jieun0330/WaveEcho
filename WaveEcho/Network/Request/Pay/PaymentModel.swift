//
//  PaymentValidationQuery.swift
//  WaveEcho
//
//  Created by 박지은 on 5/9/24.
//

import Foundation

struct PaymentModel: Codable {
    let imp_uid: String
    let post_id: String
    let productName: String
    let price: Int
}
