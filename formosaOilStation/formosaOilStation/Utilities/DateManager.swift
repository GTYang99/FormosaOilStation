//
//  DateManager.swift
//  formosaOilStation
//
//  Created by 10362 on 2025/7/30.
//

import Foundation


class DateManager {
    static let shared = DateManager()
    
    let dateFormatter = DateFormatter()

    private init() {
        dateFormatter.locale = Locale(identifier: "zh_Hant_TW")
    }

    func stringToDate(string: String) -> Date {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: string) ?? Date()
    }
    
    func timeToString(time: Date) -> String {
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: time)
    }
    
    
    func stringToTime(from timeString: String) -> Date? {
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "zh_TW")
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.date(from: timeString)
    }
    
    func engStringToDate(from timeString: String) -> Date? {
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MMM dd,yyyy"
        return dateFormatter.date(from: timeString)
    }
    
    func dateToString(from date: Date) -> String {
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MM-dd"
        return dateFormatter.string(from: date)
    }
}
