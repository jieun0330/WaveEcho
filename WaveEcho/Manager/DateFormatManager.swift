//
//  DateFormatManager.swift
//  WaveEcho
//
//  Created by 박지은 on 4/23/24.
//

import Foundation

final class DateFormatManager {
    static let shared = DateFormatManager()
    
    private init() { }
    
    private let dateFormatter = DateFormatter()
    private let relativeDateFormatter = RelativeDateTimeFormatter()
    
    func stringToDate(date: String) -> Date? {
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: date) {
            return date
        } else {
            return nil
        }
    }
    
    func stringToString(date: String) -> String {
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let convertToDate = dateFormatter.date(from: date)
        let myDateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "M월 d일 HH시 mm분"
        return myDateFormatter.string(from: convertToDate!)
    }
    
    func relativeDate(date: Date) -> String {
        relativeDateFormatter.unitsStyle = .abbreviated
        relativeDateFormatter.locale = Locale(identifier: "ko_KR")
        return relativeDateFormatter.localizedString(for: date, relativeTo: Date())
    }
}


