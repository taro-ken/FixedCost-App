//
//  AddfixedCostViewController.swift
//  FixedCost-App
//
//  Created by 木元健太郎 on 2022/05/22.
//

import UIKit
import RealmSwift

final class AddfixedCostViewController: UIViewController {
    
    @IBOutlet weak var costTitle: UITextField!
    @IBOutlet weak var costCategory: UITextField!
    @IBOutlet weak var costValue: UITextField!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var navigationVar: UINavigationBar!
    
    private var period: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationVar.barTintColor = .white
        memoTextView.layer.cornerRadius = 10
        
        costValue.keyboardType = .numberPad
    }
    
    @IBAction func tapCancelButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func tapAddButton(_ sender: Any) {
        if costTitle.text == "" {
            let dialog = UIAlertController(title: "保存できません", message: "入力してください", preferredStyle: .alert)
            dialog.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(dialog, animated: true, completion: nil)
            return
        }
        
        if costValue.text == "" {
            let dialog = UIAlertController(title: "保存できません", message: "入力してください", preferredStyle: .alert)
            dialog.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(dialog, animated: true, completion: nil)
            return
        }
        
        
        guard  let value = costValue.text else { return }
        let realm = try! Realm()
        let cost = CostModel()
        if self.period == false {
            cost.value = Int(value)! / 12
        } else {
            cost.value = Int(value)!
        }
        cost.name = costTitle.text
        cost.category = costCategory.text
        cost.period = self.period
        cost.memo = memoTextView.text
        try? realm.write {
            realm.add(cost)
        }
        self.dismiss(animated: true)
    }
    
    @IBAction func periodSwich(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            period = true
            print("月")
        case 1:
            period = false
            print("年")
        default:
            break
        }
    }
}
