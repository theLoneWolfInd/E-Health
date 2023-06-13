//
//  manageInventoryVC.swift
//  E health App
//
//  Created by Ranjan on 19/08/21.
//

import UIKit
import Alamofire
import SDWebImage

var medNameStr:String = ""
var medPriceStr:String = ""
var medImageStr:String = ""

class manageInventoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var arrListOfAllMedicines : NSMutableArray! = []
    
    var strWhereAreYouFrom:String!
    var dictGetClickedDiseaseData:NSDictionary!
    
    var arr1 = ["Aciloc","Amlovas","Dexona","Aristo","Megapen","cetrizin","Liv-52","Diolna","Covaxin","COVishield","Tugain","Onecan","Vigara","Ear Drop","EyeDrop","Pain Killer"]
    
    var arr2 = ["$20", "$21","$22","$23",
                "$20", "$21","$22","$23",
                "$20", "$21","$22","$23",
                "$20", "$21","$22","$23"]
    
    @IBOutlet weak var viewNavigationBar:UIView!
    @IBOutlet weak var btnDashboardMenu:UIButton!
    
    @IBOutlet weak var btnAddMedicine:UIButton! {
        didSet {
            btnAddMedicine.tintColor = .white
            btnAddMedicine.setImage(UIImage(systemName: "plus"), for: .normal)
        }
    }
    
    @IBOutlet weak var lblNavigationBar:UILabel!{
        didSet {
            
            lblNavigationBar.text = "MANAGE INVENTORY"
        }
    }
    
    @IBOutlet weak var tablView: UITableView! {
        didSet {
            // tablView.delegate = self
            // tablView.dataSource = self
            
            tablView.backgroundColor =  .white
            self.tablView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            self.tablView.separatorStyle = UITableViewCell.SeparatorStyle.none
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var filtered:[String] = []
    
    var searchActive : Bool =  false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        self.view.backgroundColor = .white
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.btnAddMedicine.addTarget(self, action: #selector(btnAddMedicineClickMethod), for: .touchUpInside)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            if (person["role"] as! String) == "Supplier" {
                
                self.lblNavigationBar.text = "MANAGE INVENTORY"
                
            } else {
                
                self.lblNavigationBar.text = "REQUEST SUPPLIER"
                self.btnAddMedicine.isHidden = true
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if self.strWhereAreYouFrom == "supplierProfile" {
            
            self.btnDashboardMenu.setImage(UIImage(systemName: "arrow.left"), for: .normal)
            self.btnDashboardMenu.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
            self.listOfAllMedicinesOfThatDiseaseWB()
            
        } else {
            
            self.btnDashboardMenu.setImage(UIImage(systemName: "list.dash"), for: .normal)
            self.sideBarMenuClick()
            self.listOfAllMedicinesWB()
        }
        
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func sideBarMenuClick() {
        
        let defaults = UserDefaults.standard
        defaults.setValue("", forKey: "keyBackOrSlide")
        defaults.setValue(nil, forKey: "keyBackOrSlide")
        
        if revealViewController() != nil {
            btnDashboardMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    @objc func btnAddMedicineClickMethod() {
        
        let x : Int = self.dictGetClickedDiseaseData["DiseaseId"] as! Int
        let myString = String(x)
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddMoreMedicinesId") as? AddMoreMedicines
        push!.getDieseaaseId = String(myString)
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func btnDashboardMenuPress() {
        
        if revealViewController() != nil {
            btnDashboardMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        /*if searchActive {
         
         return filtered.count
         }
         
         else {*/
        
        return self.arrListOfAllMedicines.count
        
        // }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:manageInventoryTableViewCell  =  tablView.dequeueReusableCell(withIdentifier: "cell") as! manageInventoryTableViewCell
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.backgroundColor = .white
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.imgMedicine.image = UIImage(named: "medbox")
        // cell.lblMedicinePrice.text = arr2[indexPath.row]
        
        /*if searchActive{
         
         
         cell.lblMedicineName.text =  filtered[indexPath.row]
         }
         
         else {*/
        
        // cell.lblMedicineName.text =  arr1[indexPath.row]
        
        // self.arrListOfAllMedicines
        
        let item = self.arrListOfAllMedicines[indexPath.row] as? [String:Any]
        
        cell.lblMedicineName.text = (item!["name"] as! String)
        
        if self.strWhereAreYouFrom == "supplierProfile" {
            
            cell.btn_edit.isHidden = false
        } else {
            cell.btn_edit.isHidden = true
        }
        
        cell.btn_edit.tag = indexPath.row
        cell.btn_edit.addTarget(self, action: #selector(edit_click_method), for: .touchUpInside)
        
        cell.imgMedicine.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.imgMedicine.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "1024"))
        
        cell.lblMedicinePrice.text = "$"+(item!["price"] as! String)
        // }
        
        return cell
    }
    
    @objc func edit_click_method(_ sender:UIButton) {
        
        
        // print("you tap image number: \(sender.view.tag)")
        
        let alert = UIAlertController(title: "Settings", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Edit medicine", style: .default , handler:{ (UIAlertAction)in
            print("User click Approve button")
            
            let item = self.arrListOfAllMedicines[sender.tag] as? [String:Any]
            
            // print(item as Any)
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddMoreMedicinesId") as? AddMoreMedicines
            
            push!.getProfileInfo = "edit_medicine"
            push!.getDictOfThatMedicine = item as NSDictionary?
            
            self.navigationController?.pushViewController(push!, animated: true)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Delete medicine", style: .destructive , handler:{ (UIAlertAction)in
            print("User click Edit button")
            
            let item = self.arrListOfAllMedicines[sender.tag] as? [String:Any]
            print(item as Any)
            
            self.delete_medicine_wb(str_disease_id: "\(item!["diseaseId"]!)",
                                    str_supplier_id: "",
                                    str_medicine_id: "\(item!["medicineId"]!)")
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
        
        
        
        
        
        /*
         Optional(["image": https://demo4.evirtualservices.net/ehealth/img/uploads/medicines/1639742398medicineName.png, "quantity": 1003, "diseaseId": 2, "subdetails": , "sm_id": 1, "name": (AENC) DISINFECTANT WATER-FREE HAND FOAM (POLIHEXANIDE) SOLUTION YANTAI DONGKE LVZHIYUAN DISINFECTION PHARMACEUTICAL CO., LTD., "price": 5, "supplierId": 14, "medicineId": 141061, "weight": ])
         (lldb)
         */
        
        /*let x : Int = self.dictGetClickedDiseaseData["DiseaseId"] as! Int
         let myString = String(x)
         
         print(self.dictGetClickedDiseaseData as Any)
         
         let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddMoreMedicinesId") as? AddMoreMedicines
         
         push!.getProfileInfo = "edit_medicine"
         push!.getDictOfThatMedicine = self.dictGetClickedDiseaseData
         
         push!.getDieseaaseId = String(myString)
         
         self.navigationController?.pushViewController(push!, animated: true)*/
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
        
        /*let item = self.arrListOfAllMedicines[indexPath.row] as? [String:Any]
         
         if (item!["name"] as! String).count < 100 {
         return 100
         } else {
         return UITableView.automaticDimension
         }*/
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if searchActive {
            medNameStr = filtered[indexPath.row]
        }
        else {
            
            let item = self.arrListOfAllMedicines[indexPath.row] as? [String:Any]
            
            if self.strWhereAreYouFrom == "supplierProfile" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "inventoryDetailsVC") as? inventoryDetailsVC // AddMoreMedicines
                push!.getDictInventoryDetails = item as NSDictionary?
                push!.whichProfileYouAreFrom = self.strWhereAreYouFrom // edit_medicine
                self.navigationController?.pushViewController(push!, animated: true)
                
            } else {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "inventoryDetailsVC") as? inventoryDetailsVC
                push!.getDictInventoryDetails = item as NSDictionary?
                push!.whichProfileYouAreFrom = ""
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            
        }
        
    }
    
    //Searchbar Delegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = arr1.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tablView.reloadData()
    }
    
    
    
    @objc func listOfAllMedicinesWB() {
        self.arrListOfAllMedicines.removeAllObjects()
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x_2 : Int = self.dictGetClickedDiseaseData["DiseaseId"] as! Int
            let myString_2 = String(x_2)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            // let params =  ListMedicineList(action: "medicineproductlist")
            
            let params = list_of_all_medicines_product_list(action: "medicineproductlist",
                                                            userId: String(myString),
                                                            diseaseId: String(myString_2),
                                                            supplierId: "")
            
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
                        
                        self.tablView.delegate = self
                        self.tablView.dataSource = self
                        self.tablView.reloadData()
                        
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
    
    @objc func listOfAllMedicinesOfThatDiseaseWB() {
        self.arrListOfAllMedicines.removeAllObjects()
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = self.dictGetClickedDiseaseData["DiseaseId"] as! Int
            let myString = String(x)
            
            let x2 : Int = person["userId"] as! Int
            let myString2 = String(x2)
            
            let params = list_of_all_medicines_product_list(action: "medicineproductlist",
                                                            userId: String(myString),
                                                            diseaseId: String(myString),
                                                            supplierId: String(myString2))
            
            
            
            /*Medicine_Of_That_Disease(action: "medicineproductlist",
             supplierId:String(myString2),
             diseaseId: String(myString))*/
            
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
                        
                        self.tablView.delegate = self
                        self.tablView.dataSource = self
                        self.tablView.reloadData()
                        
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
    
    @objc func delete_medicine_wb(str_disease_id:String ,
                                  str_supplier_id:String,
                                  str_medicine_id:String) {
        // self.arrListOfAllDoctors.removeAllObjects()
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            
            let params = delete_medicine(action: "deletemedicine",
                                         diseaseId: String(str_disease_id),
                                         supplier_id: String(myString),
                                         medicine_id: String(str_medicine_id))
            
            
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
                                
                                if self.strWhereAreYouFrom == "supplierProfile" {

                                    self.listOfAllMedicinesOfThatDiseaseWB()
                                    
                                } else {

                                    self.listOfAllMedicinesWB()
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
    }
    
}
