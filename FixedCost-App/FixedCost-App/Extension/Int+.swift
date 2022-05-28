//
//  Int+.swift
//  FixedCost-App
//
//  Created by 木元健太郎 on 2022/05/28.
//

import Foundation

extension Int {
    private static let numberFormatter: NumberFormatter = {
        return NumberFormatter()
    }()
    var withCommaString: String {
        Int.numberFormatter.numberStyle = .decimal
        Int.numberFormatter.groupingSeparator = ","
        Int.numberFormatter.groupingSize = 3

        return Int.numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}


