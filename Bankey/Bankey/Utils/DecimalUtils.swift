//
//  DecimalUtils.swift
//  Bankey
//
//  Created by yusheng Lu on 2024/8/23.
//

import Foundation

extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber(decimal:self).doubleValue
    }
}
