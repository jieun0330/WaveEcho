//
//  ImageUploadResponse.swift
//  WaveEcho
//
//  Created by 박지은 on 4/24/24.
//

import Foundation

struct ImageUploadResponse: Decodable {
    let files: [String]
    
    enum CodingKeys: CodingKey {
        case files
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.files = try container.decode([String].self, forKey: .files)
    }
}
