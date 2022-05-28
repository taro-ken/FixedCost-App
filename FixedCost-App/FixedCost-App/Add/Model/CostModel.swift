//
//  CostModel.swift
//  FixedCost-App
//
//  Created by 木元健太郎 on 2022/05/22.
//

import Foundation
import RealmSwift

final class CostModel: Object {
    @objc dynamic var name: String?
    @objc dynamic var debitDate: String?
    @objc dynamic var period: Bool = true
    @objc dynamic var value: Int = 0
    @objc dynamic var memo: String?
}




