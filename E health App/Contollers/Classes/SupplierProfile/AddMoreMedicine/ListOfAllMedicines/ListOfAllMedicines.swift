//
//  ListOfAllMedicines.swift
//  E health App
//
//  Created by apple on 07/10/21.
//

import UIKit
import Alamofire
import SDWebImage

class ListOfAllMedicines: UIViewController {

    var arrListOfAllMedicines : NSMutableArray! = []
    
    @IBOutlet weak var viewNavigationBar:UIView!
    
    @IBOutlet weak var btnDashboardMenu:UIButton! {
        didSet {
            btnDashboardMenu.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        }
    }
    
    @IBOutlet weak var btnDashboardSearch:UIButton! {
        didSet {
            btnDashboardSearch.tintColor = .white
        }
    }
    
    @IBOutlet weak var lblNavigationBar:UILabel!{
        didSet {
            
            lblNavigationBar.text = "MEDICINES"
        }
    }
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            tbleView.delegate = self
            tbleView.dataSource = self
            tbleView.backgroundColor =  .white
            tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        self.tbleView.separatorColor = .lightGray
        
        self.btnDashboardMenu.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        self.btnDashboardSearch.addTarget(self, action: #selector(openPopupForSearch), for: .touchUpInside)
        
        self.listOfAllMedicines()
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func openPopupForSearch() {
        
        let alert = NewYorkAlertController.init(title: "Search", message: "You can search any medicine here via Medicine name.", style: .alert)
        
        alert.addImage(UIImage.gif(name: "search"))
        
        alert.addTextField { tf in
            
            tf.placeholder = "medicine name..."
            
            tf.keyboardType = .default
            tf.tag = 1
        }
        
        let ok = NewYorkButton(title: "Search", style: .default) { [unowned alert] _ in
            alert.textFields.forEach { tf in
                let text = tf.text ?? ""
                switch tf.tag {
                case 1:
                    print("quantity: \(text)")
                    
                    self.searchMedicinesWB(strSearchText: "\(text)")
                    
                default:
                    break
                }
            }
        }
        
        let cancel = NewYorkButton(title: "Cancel", style: .cancel)
        alert.addButtons([ok, cancel])
        
        alert.isTapDismissalEnabled = false
        
        present(alert, animated: true)
    }
    
    // MARK: - SEARCH MEDICINE -
    @objc func searchMedicinesWB(strSearchText:String) {
        
        self.arrListOfAllMedicines.removeAllObjects()
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "searching...")
        
        
        let params =  List_Of_All_Medicines(action: "medicineslist",
                                            keyword: String(strSearchText),
                                            pageNo: "1")
        
        
        print(params as Any)
        
        AF.request(APPLICATION_BASE_URL,
                   method: .post,
                   parameters: params,
                   encoder: JSONParameterEncoder.default).responseJSON { response in
            // debugPrint(response.result)
            
            switch response.result {
            case let .success(value):
                
                let JSON = value as! NSDictionary
                print(JSON as Any)
                
                var strSuccess : String!
                strSuccess = (JSON["status"]as Any as? String)?.lowercased()
                print(strSuccess as Any)
                
                if strSuccess == String("success") {
                    print("yes")
                    
                    ERProgressHud.sharedInstance.hide()
                    
                    // arrListOfAllMedicines
                    
                    var ar : NSArray!
                    ar = (JSON["data"] as! Array<Any>) as NSArray
                    self.arrListOfAllMedicines.addObjects(from: ar as! [Any])
                    
                    if self.arrListOfAllMedicines.count == 0 {
                        
                        let alert = UIAlertController(title: "Alert", message: "No Data found.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: {
                        action in
                            self.listOfAllMedicines()
                        }))
                        self.present(alert, animated: true)
                        
                    } else {
                        self.tbleView.delegate = self
                        self.tbleView.dataSource = self
                        self.tbleView.reloadData()
                    }
                    
                } else {
                    print("no")
                    ERProgressHud.sharedInstance.hide()
                    
                    var strSuccess2 : String!
                    strSuccess2 = JSON["msg"]as Any as? String
                    
                    let alert = UIAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
                    
                    
                    
                    
                }
                
            case let .failure(error):
                print(error)
                ERProgressHud.sharedInstance.hide()
                
                // Utils.showAlert(alerttitle: SERVER_ISSUE_TITLE, alertmessage: SERVER_ISSUE_MESSAGE, ButtonTitle: "Ok", viewController: self)
                
            }
        }
    }
    
    @objc func listOfAllMedicines() {
        
        self.arrListOfAllMedicines.removeAllObjects()
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "please wait...")
        
        
        let params =  List_Of_All_Medicines(action: "medicineslist",
                                            keyword: "",
                                            pageNo: "1")
        
        
        print(params as Any)
        
        AF.request(APPLICATION_BASE_URL,
                   method: .post,
                   parameters: params,
                   encoder: JSONParameterEncoder.default).responseJSON { response in
            // debugPrint(response.result)
            
            switch response.result {
            case let .success(value):
                
                let JSON = value as! NSDictionary
                print(JSON as Any)
                
                var strSuccess : String!
                strSuccess = (JSON["status"]as Any as? String)?.lowercased()
                print(strSuccess as Any)
                
                if strSuccess == String("success") {
                    print("yes")
                    
                    ERProgressHud.sharedInstance.hide()
                    
                    // arrListOfAllMedicines
                    
                    var ar : NSArray!
                    ar = (JSON["data"] as! Array<Any>) as NSArray
                    self.arrListOfAllMedicines.addObjects(from: ar as! [Any])
                    
                    if self.arrListOfAllMedicines.count == 0 {
                        
                        let alert = UIAlertController(title: "Alert", message: "No Data found.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                        self.present(alert, animated: true)
                        
                    } else {
                        self.tbleView.delegate = self
                        self.tbleView.dataSource = self
                        self.tbleView.reloadData()
                    }
                    
                    
                    /*var strSuccess2 : String!
                     strSuccess2 = JSON["msg"]as Any as? String
                     
                     let alert = UIAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), preferredStyle: .alert)
                     
                     alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action  in
                     
                     }))
                     
                     self.present(alert, animated: true)*/
                    
                    
                    
                } else {
                    print("no")
                    ERProgressHud.sharedInstance.hide()
                    
                    var strSuccess2 : String!
                    strSuccess2 = JSON["msg"]as Any as? String
                    
                    let alert = UIAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
                    
                    
                    
                    
                }
                
            case let .failure(error):
                print(error)
                ERProgressHud.sharedInstance.hide()
                
                // Utils.showAlert(alerttitle: SERVER_ISSUE_TITLE, alertmessage: SERVER_ISSUE_MESSAGE, ButtonTitle: "Ok", viewController: self)
                
            }
        }
    }
}


extension ListOfAllMedicines : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrListOfAllMedicines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell:ListOfAllMedicinesTableCell = tableView.dequeueReusableCell(withIdentifier: "listOfAllMedicinesTableCell") as! ListOfAllMedicinesTableCell
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        let item = self.arrListOfAllMedicines[indexPath.row] as? [String:Any]
        cell.lblMedicineName.text = (item!["name"] as! String)
        
        cell.imgMedicineProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.imgMedicineProfile.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "1024"))
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let item = self.arrListOfAllMedicines[indexPath.row] as? [String:Any]
        
        let alert = NewYorkAlertController(title: "Medicine Details", message: (item!["name"] as! String), style: .alert)

        let url = URL(string: (item!["image"] as! String))
        let data = try? Data(contentsOf: url!)

        if let imageData = data {
            let image = UIImage(data: imageData)
            
            ERProgressHud.sharedInstance.hide()
            
            alert.addImage(image)
            
        }
        
        let ok = NewYorkButton(title: "Yes, Select", style: .default) { _ in
            print("Tapped OK")
            
            ERProgressHud.sharedInstance.hide()
            
            let x : Int = (item!["medicineId"] as! Int)
            let myString = String(x)
            
            let defaults = UserDefaults.standard
            defaults.set(myString, forKey: "key_medicine_id")
            defaults.set((item!["name"] as! String), forKey: "key_medicine_name")
            defaults.set((item!["image"] as! String), forKey: "key_medicine_image")
            
            self.navigationController?.popViewController(animated: true)
            
        }
        
        ok.setDynamicColor(.purple)
        let cancel = NewYorkButton(title: "Cancel", style: .cancel) {
            _ in
            ERProgressHud.sharedInstance.hide()
        }
        alert.addButtons([ok, cancel])

        present(alert, animated: true)
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let item = self.arrListOfAllMedicines[indexPath.row] as? [String:Any]
        if (item!["name"] as! String).count > 80 {
            return UITableView.automaticDimension
        } else {
            return 100
            
        }
        
            
       
    }
    
}
