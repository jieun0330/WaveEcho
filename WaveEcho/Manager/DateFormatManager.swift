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
    
    private let standardDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    private let displayDateFormat = "M월 d일 HH시 mm분"
    
    func stringToDate(date: String) -> Date? {
        dateFormatter.dateFormat = standardDateFormat
        return dateFormatter.date(from: date)
    }
    
    func stringToString(date: String) -> String {
        dateFormatter.dateFormat = standardDateFormat
        guard let converTodate = dateFormatter.date(from: date) else { return "" }
        dateFormatter.dateFormat = displayDateFormat
        return dateFormatter.string(from: converTodate)
    }
    
    func relativeDate(date: Date) -> String {
        relativeDateFormatter.unitsStyle = .abbreviated
        relativeDateFormatter.locale = Locale(identifier: "ko_KR")
        return relativeDateFormatter.localizedString(for: date, relativeTo: Date())
    }
}
