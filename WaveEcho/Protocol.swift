//
//  Protocol.swift
//  WaveEcho
//
//  Created by 박지은 on 5/13/24.
//

import Foundation

protocol ReusableProtocol {
    static var identifier: String { get }
}

extension ReusableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}
