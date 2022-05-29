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
    @IBOutlet weak var editDebitDate: UITextField!
    @IBOutlet weak var editCostValue: UITextField!
    @IBOutlet weak var editMemoTextView: UITextView!
    @IBOutlet weak var navigationVar: UINavigationBar!
    @IBOutlet weak var swichSegment: UISegmentedControl!
    
    private var period: Bool = true
    private var costModel:CostModel = CostModel()
    private  let months = (0...12).map { $0 }
    private  let days = (0...31).map { $0 }
    private  let pickerView = UIPickerView()
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationVar.barTintColor = .white
        editMemoTextView.layer.cornerRadius = 10
        editCostValue.keyboardType = .numberPad
        
        pickerView.backgroundColor = .white
        pickerView.delegate = self
        editDebitDate.inputView = pickerView
        setKeyboardAccessory()
        
        editCostTitle.text = costModel.name
        editDebitDate.text = costModel.debitDate
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
        case 1:
            period = false
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
            costModel.debitDate = editDebitDate.text
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

extension EditCostViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return months.count
        } else if component == 1 {
            return days.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            if row == 0 {
                return "未設定"
            } else {
                return "\(months[row])月" }
        } else if component == 1 {
            if row == 0 {
                return "未設定"
            } else {
                return "\(days[row])日"}
        } else {
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let month = months[pickerView.selectedRow(inComponent: 0)]
        let day = days[pickerView.selectedRow(inComponent: 1)]
        
        if months[pickerView.selectedRow(inComponent: 0)] == 0 {
            editDebitDate.text = "\(day)日"
        } else if days[pickerView.selectedRow(inComponent: 1)] == 0 {
            editDebitDate.text = "\(month)月"
        } else {
            editDebitDate.text = "\(month)月 \(day)日"
        }
    }
    
    func setKeyboardAccessory() {
        let keyboardAccessory = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 36))
        keyboardAccessory.backgroundColor = UIColor.white
        editDebitDate.inputAccessoryView = keyboardAccessory
        
        let topBorder = UIView(frame: CGRect(x: 0, y: 0, width: keyboardAccessory.bounds.size.width, height: 0.5))
        topBorder.backgroundColor = .lightGray
        keyboardAccessory.addSubview(topBorder)
        
        let completeButton = UIButton(frame: CGRect(x: keyboardAccessory.bounds.size.width - 48, y: 0, width: 48, height: keyboardAccessory.bounds.size.height - 0.5 * 2))
        completeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        completeButton.setTitle("完了", for: .normal)
        completeButton.setTitleColor(.systemCyan, for: .normal)
        completeButton.setTitleColor(UIColor.red, for: .highlighted)
        completeButton.addTarget(self, action: #selector(hidePickerView), for: .touchUpInside)
        keyboardAccessory.addSubview(completeButton)
        
        let bottomBorder = UIView(frame: CGRect(x: 0, y: keyboardAccessory.bounds.size.height - 0.5, width: keyboardAccessory.bounds.size.width, height: 0.5))
        bottomBorder.backgroundColor = .lightGray
        keyboardAccessory.addSubview(bottomBorder)
    }
    
    @objc func hidePickerView() {
        editDebitDate.resignFirstResponder()
    }
}

