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
    private var costModel: Results<CostModel>!
    private var totalCostContainer:Int = 0
    private var differenceContainer:Int = 0
    @IBOutlet weak var totalFixedCost: UILabel!
    @IBOutlet weak var differenceLabel: UILabel!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var totalFixedCostBackView: UIView!
    @IBOutlet weak var differenceBackView: UIView!
    
    @IBOutlet weak var addFixedCostButton: UIButton!
    @IBOutlet weak var shadowView: UIView!
    
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
        
        addFixedCostButton.addTarget(self, action: #selector(addFixedCost), for: .touchUpInside)
        
        guard let realm = try? Realm() else {return}
        costModel = realm.objects(CostModel.self)
        fixedCostTableView.reloadData()
        
        totalCostContainer = realm.objects(CostModel.self).map {$0.value}.reduce(0, +)
        totalFixedCost.text = "\(totalCostContainer.withCommaString)円"
        let salary = UserDefaults.standard.integer(forKey: "salary")
        differenceContainer = salary - totalCostContainer
        differenceLabel.text = "\(differenceContainer.withCommaString)円"
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
            differenceLabel.text = "\(differenceContainer.withCommaString)円"
        case 1:
            differenceLabel.text = "\((totalCostContainer * 12).withCommaString)円"
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
    
    
}

extension FixedCostViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if costModel.isEmpty {
            emptyLabel.isHidden = false
        } else {
            emptyLabel.isHidden = true
        }
        return costModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = fixedCostTableView.dequeueReusableCell(withIdentifier: fixedCostCell, for: indexPath) as? FixedCostCell else {
            return UITableViewCell()
        }
        cell.configure(model: costModel[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let realm = try? Realm() else {return}
        try?realm.write {
            realm.delete(costModel[indexPath.row])
        }
        fixedCostTableView.deleteRows(at: [indexPath], with: .automatic)
        viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cost = costModel[indexPath.row]
        Router.shard.showCostEdit(from: self, model: cost)
    }
}


