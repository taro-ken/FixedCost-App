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
    @IBOutlet weak var debitDate: UITextField!
    @IBOutlet weak var costValue: UITextField!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var navigationVar: UINavigationBar!
    
    private var period: Bool = true
    private  let months = (1...12).map { $0 }
    private  let days = (1...31).map { $0 }
    private  let pickerView = UIPickerView()
    private var listModel: List<CostModel>!
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationVar.barTintColor = .white
        memoTextView.layer.cornerRadius = 10
        costValue.keyboardType = .numberPad
        pickerView.backgroundColor = .white
        pickerView.delegate = self
        debitDate.inputView = pickerView
        setKeyboardAccessory()
        listModel = realm.objects(ItemList.self).first?.list
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
        cost.debitDate = debitDate.text
        cost.period = self.period
        cost.memo = memoTextView.text
        try? realm.write {
            
            if listModel == nil {
            
            let item = ItemList()
            item.list.append(cost)
            realm.add(item)
            } else {
                listModel.append(cost)
            }
        self.dismiss(animated: true)
    }
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

extension AddfixedCostViewController: UIPickerViewDelegate,UIPickerViewDataSource {
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
            return "\(months[row])月"
        } else if component == 1 {
            return "\(days[row])日"
        } else {
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let month = months[pickerView.selectedRow(inComponent: 0)]
        let day = days[pickerView.selectedRow(inComponent: 1)]
        debitDate.text = "\(month)月 \(day)日"
    }
    
    func setKeyboardAccessory() {
        let keyboardAccessory = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 36))
        keyboardAccessory.backgroundColor = UIColor.white
        debitDate.inputAccessoryView = keyboardAccessory
        
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
        debitDate.resignFirstResponder()
    }
}

