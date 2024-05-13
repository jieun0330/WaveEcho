//
//  PayHistoryModel.swift
//  WaveEcho
//
//  Created by 박지은 on 5/13/24.
//

import Foundation

struct PayHistoryModel: Decodable {
    let data: [PaymentData]
}

struct PaymentData: Decodable {
    let payment_id: String
    let buyer_id: String
    let post_id: String
    let merchant_uid: String
    let productName: String
    let price: Int
    let paidAt: String
}
