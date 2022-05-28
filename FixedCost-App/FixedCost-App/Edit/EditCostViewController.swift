//
//  EditCostViewController.swift
//  FixedCost-App
//
//  Created by 木元健太郎 on 2022/05/27.
//

import UIKit
import RealmSwift

final class EditCostViewController: UIViewController {
    
    static func makeFromStoryboard(model: CostModel) -> EditCostViewController{
        let vc = UIStoryboard.editCostViewController
        vc.costModel = model
        return vc
    }
    
    @IBOutlet weak var editCostTitle: UITextField!
    @IBOutlet weak var editCostCategory: UITextField!
    @IBOutlet weak var editCostValue: UITextField!
    @IBOutlet weak var editMemoTextView: UITextView!
    @IBOutlet weak var navigationVar: UINavigationBar!
    @IBOutlet weak var swichSegment: UISegmentedControl!
    
    private var period: Bool = true
    private var costModel:CostModel = CostModel()
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationVar.barTintColor = .white
        editMemoTextView.layer.cornerRadius = 10
        editCostValue.keyboardType = .numberPad
        
        editCostTitle.text = costModel.name
        editCostCategory.text = costModel.category
        editCostValue.text = costModel.value.description
        editMemoTextView.text = costModel.memo
        period = costModel.period
        if period == true {
            swichSegment.selectedSegmentIndex = 0
        } else {
            swichSegment.selectedSegmentIndex = 1
        }
    }
    
    
    @IBAction func editPeriodSwich(_ sender: UISegmentedControl) {
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
    
    @IBAction func tapSaveButton(_ sender: Any) {
        if editCostTitle.text == "" {
            let dialog = UIAlertController(title: "保存できません", message: "入力してください", preferredStyle: .alert)
            dialog.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(dialog, animated: true, completion: nil)
            return
        }
        
        if editCostValue.text == "" {
            let dialog = UIAlertController(title: "保存できません", message: "入力してください", preferredStyle: .alert)
            dialog.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(dialog, animated: true, completion: nil)
            return
        }
        guard  let value = editCostValue.text else { return }
        try? realm.write {
            if self.period == false {
                costModel.value = Int(value)! / 12
            } else {
                costModel.value = Int(value)!
            }
            costModel.name = editCostTitle.text
            costModel.category = editCostCategory.text
            costModel.period = self.period
            costModel.memo = editMemoTextView.text
        }
        self.dismiss(animated: true)
    }
    
    @IBAction func tapDelete(_ sender: Any) {
        
        let controller = UIAlertController(title: .none, message: "削除しますか？",
                                           preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "キャンセル",
                                         style: .cancel,
                                         handler: nil)
        let buyAction = UIAlertAction(title: "OK",
                                      style: .default) { [self] _ in
            try? realm.write {
                realm.delete(costModel)
            }
            self.dismiss(animated: true)
        }
        controller.addAction(cancelAction)
        controller.addAction(buyAction)
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func tapCancelButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
