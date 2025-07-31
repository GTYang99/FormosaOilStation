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
    
    func fomatterString(time: Date) -> String {
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: time)
    }
}
