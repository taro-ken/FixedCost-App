//
//  FixedCostCell.swift
//  FixedCost-App
//
//  Created by 木元健太郎 on 2022/05/22.
//

import UIKit

class FixedCostCell: UITableViewCell {

    @IBOutlet weak var listTitle: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var costValue: UILabel!
    @IBOutlet weak var period: UILabel!
    
    func configure(model: CostModel) {
        listTitle.text = model.name
        category.text = model.category
        if model.period == true {
            period.text = "/月"
            costValue.text = "\(model.value.withCommaString)円"
        } else {
            period.text = "/年"
            costValue.text = "\((model.value * 12).withCommaString)円"
        }
    }
    
    
}
