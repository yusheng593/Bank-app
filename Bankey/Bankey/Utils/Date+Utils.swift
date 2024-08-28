//
//  Date+Utils.swift
//  Bankey
//
//  Created by yusheng Lu on 2024/8/28.
//

import Foundation

extension Date {
    static var bankeyDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current // 使用用戶設備的當前時區
        return formatter
    }

    var monthDayYearString: String {
        let dateFormatter = Date.bankeyDateFormatter
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: self)
    }
}
