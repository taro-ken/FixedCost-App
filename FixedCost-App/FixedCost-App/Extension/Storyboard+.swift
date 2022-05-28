//
//  Storyboard+.swift
//  FixedCost-App
//
//  Created by 木元健太郎 on 2022/05/24.
//

import UIKit
import SwiftUI

extension UIStoryboard {
    
    static var fixedCostViewController: FixedCostViewController {
        UIStoryboard.init(name: "FixedCost", bundle: nil).instantiateInitialViewController() as! FixedCostViewController
    }
    
    static var editCostViewController: EditCostViewController {
        UIStoryboard.init(name: "EditCost", bundle: nil).instantiateInitialViewController() as! EditCostViewController
    }
    
    
}
