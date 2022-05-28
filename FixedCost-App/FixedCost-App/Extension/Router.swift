//
//  Router.swift
//  FixedCost-App
//
//  Created by 木元健太郎 on 2022/05/28.
//

import Foundation
import UIKit

final class Router {
    
    static let shard = Router()
    private init() {}
    
    func showCostEdit(from: UIViewController, model: CostModel) {
        let vc = EditCostViewController.makeFromStoryboard(model: model)
        from.present(vc, animated: true, completion: nil)
    }
}

private extension Router {
    func show(from: UIViewController, next: UIViewController, animated: Bool = true) {
        if let nav = from.navigationController {
            nav.pushViewController(next, animated: animated)
        } else {
            from.present(next, animated: animated, completion: nil)
        }

    }
    
}





