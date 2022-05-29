//
//  FixedCostViewController.swift
//  FixedCost-App
//
//  Created by 木元健太郎 on 2022/05/22.
//

import UIKit
import RealmSwift

final class FixedCostViewController: UIViewController {
    
    private var fixedCostCell = "FixedCostCell"
    private var listModel: List<CostModel>!
    private var costModel = CostModel()
    private var editflag = false
    private  let realm = try! Realm()
    private var totalCostContainer:Int = 0
    private var differenceContainer:Int = 0
    @IBOutlet weak var totalFixedCost: UILabel!
    @IBOutlet weak var differenceLabel: UILabel!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var totalFixedCostBackView: UIView!
    @IBOutlet weak var differenceBackView: UIView!
    @IBOutlet weak var addFixedCostButton: UIButton!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    
    @IBOutlet weak var fixedCostTableView: UITableView! {
        didSet {
            fixedCostTableView.register(UINib(nibName: fixedCostCell, bundle: nil), forCellReuseIdentifier: fixedCostCell)
            fixedCostTableView.dataSource = self
            fixedCostTableView.delegate = self
            fixedCostTableView.layer.cornerRadius = 20
            fixedCostTableView.separatorInset = UIEdgeInsets.zero
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addFixedCostButton.layer.cornerRadius = 25
        addFixedCostButton.layer.shadowOpacity = 0.5
        addFixedCostButton.layer.shadowRadius = 3
        addFixedCostButton.layer.shadowColor = UIColor.darkGray.cgColor
        addFixedCostButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        totalFixedCostBackView.layer.shadowOpacity = 0.5
        totalFixedCostBackView.layer.shadowRadius = 3
        totalFixedCostBackView.layer.shadowColor = UIColor.darkGray.cgColor
        totalFixedCostBackView.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        differenceBackView.layer.cornerRadius = 20
        differenceBackView.layer.shadowOpacity = 0.5
        differenceBackView.layer.shadowRadius = 3
        differenceBackView.layer.shadowColor = UIColor.darkGray.cgColor
        differenceBackView.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        shadowView.layer.cornerRadius = 20
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowRadius = 3
        shadowView.layer.shadowColor = UIColor.darkGray.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        navigationBar.barTintColor = .tertiarySystemGroupedBackground
        
        addFixedCostButton.addTarget(self, action: #selector(addFixedCost), for: .touchUpInside)
        
        listModel = realm.objects(ItemList.self).first?.list
        
        totalCostContainer = realm.objects(CostModel.self).compactMap {$0.value}.reduce(0, +)
        totalFixedCost.text = "\(totalCostContainer.withCommaString)円"
        let salary = UserDefaults.standard.integer(forKey: "salary")
        differenceContainer = salary - totalCostContainer
        
        if differenceContainer < 0 {
            differenceLabel.textColor = .red
            differenceLabel.text = "\(differenceContainer.withCommaString)円"
        } else if differenceContainer == 0 {
            differenceLabel.textColor = .black
            differenceLabel.text = "\(differenceContainer.withCommaString)円"
        } else {
            differenceLabel.textColor = .systemCyan
            differenceLabel.text = "+\(differenceContainer.withCommaString)円"
        }
        fixedCostTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewDidLoad()
    }
    
    @IBAction func periodSwitch(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            totalFixedCost.text = "\(totalCostContainer.withCommaString)円"
        case 1:
            totalFixedCost.text = "\((totalCostContainer * 12).withCommaString)円"
        default:
            break
        }
    }
    
    @IBAction func differenceSwich(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            if differenceContainer < 0 {
                differenceLabel.textColor = .red
                differenceLabel.text = "\(differenceContainer.withCommaString)円"
            } else if differenceContainer == 0 {
                differenceLabel.textColor = .black
                differenceLabel.text = "\(differenceContainer.withCommaString)円"
            } else {
                differenceLabel.textColor = .systemCyan
                differenceLabel.text = "+\(differenceContainer.withCommaString)円"
            }
        case 1:
            if differenceContainer < 0 {
                differenceLabel.textColor = .red
                differenceLabel.text = "\((differenceContainer * 12).withCommaString)円"
            } else if differenceContainer == 0 {
                differenceLabel.textColor = .black
                differenceLabel.text = "\(differenceContainer.withCommaString)円"
            } else {
                differenceLabel.textColor = .systemCyan
                differenceLabel.text = "+\((differenceContainer * 12).withCommaString)円"
            }
        default:
            break
        }
    }
    
    @objc func addFixedCost() {
        let vc = UIStoryboard.init(name: "AddfixedCost", bundle: nil).instantiateInitialViewController() as! AddfixedCostViewController
        self.present(vc, animated: true)
    }
    
    @IBAction func addMonthlySalary(_ sender: Any) {
        let salary = UserDefaults.standard.integer(forKey: "salary")
        let controller = UIAlertController(title: "月収を入力",
                                           message: "現在の設定は\(salary.withCommaString)円です",
                                           preferredStyle: .alert)
        controller.addTextField { textField in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .numberPad
        }
        let cancelAction = UIAlertAction(title: "キャンセル",
                                         style: .cancel,
                                         handler: nil)
        let buyAction = UIAlertAction(title: "OK",
                                      style: .default) { [self] _ in
            if controller.textFields?.first?.text == "" {
                let dialog = UIAlertController(title: "未入力", message: "金額を入力してください", preferredStyle: .alert)
                dialog.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(dialog, animated: true, completion: nil)
                return
            }
            guard let text = controller.textFields?.first?.text else {
                return
            }
            let salary = Int(text)
            UserDefaults.standard.set(salary, forKey: "salary")
            viewDidLoad()
        }
        controller.addAction(cancelAction)
        controller.addAction(buyAction)
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func doneEditTable(_ sender: Any) {
        if editflag == true {
            editflag = false
        } else {
            editflag = true
        }
        fixedCostTableView.setEditing(editflag, animated: true)
        fixedCostTableView.isEditing = editflag
    }
}

extension FixedCostViewController: UITableViewDelegate,UITableViewDataSource {
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        fixedCostTableView.setEditing(editing, animated: animated)
        fixedCostTableView.isEditing = editing
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if realm.objects(CostModel.self).isEmpty {
            emptyLabel.isHidden = false
        } else {
            emptyLabel.isHidden = true
        }
        return realm.objects(CostModel.self).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = fixedCostTableView.dequeueReusableCell(withIdentifier: fixedCostCell, for: indexPath) as? FixedCostCell else {
            return UITableViewCell()
        }
        cell.configure(model: listModel[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let realm = try? Realm() else {return}
        try?realm.write {
            realm.delete(listModel[indexPath.row])
        }
        fixedCostTableView.deleteRows(at: [indexPath], with: .fade)
        viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cost = listModel[indexPath.row]
        Router.shard.showCostEdit(from: self, model: cost)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        try! realm.write {
            let listItem = listModel[fromIndexPath.row]
            listModel.remove(at: fromIndexPath.row)
            listModel.insert(listItem, at: to.row)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}


