//
//  HPDoctorsVC.swift
//  E health App
//
//  Created by Ranjan on 02/09/21.
//

import UIKit
import Alamofire
import SDWebImage

class HPDoctorsVC: UIViewController {
    
    var strMyProfileIs:String!
    
    var strSearchText:String! = "0"
    var strSearchMessage:String! = "0"
    
    var arrListOfAllDoctors : NSMutableArray! = []
    
    var str_from_reports:String!
    var str_report_role:String!
    var str_start_Date:String!
    var str_end_Date:String!
    var str_paid:String!
    var str_keyword:String!
    
    
    var nameArray = ["Dishant Rajput","Deepak Kumar","Pankaj Sharma","Steve Richomnd","Natile Shawn Johnson","Dishant Rajput","Deepak Kumar","Pankaj Sharma","Steve Richomnd","Natile Shawn Johnson"]
    
    var amountArray = ["$245.73","$1297.034", "$09.2",
                       "$123456.987","$245.73","$1297.034", "$09.2",
                       "$123456.987","$245.73","$1297.034"]
    var phoneArray = ["888-124-1434","745-343-4233","638-343-3243","888-124-1434","745-343-4233","638-343-3243","888-124-1434","745-343-4233","638-343-3243","638-343-3243"]
    
    @IBOutlet weak var btnAddNewDoctor: UIButton!
    @IBOutlet weak var viewNavigationBar:UIView!
    @IBOutlet weak var btnNaviagtionMenu:UIButton!
    @IBOutlet weak var lblNavigationBar:UILabel!{
        didSet {
            
            lblNavigationBar.text = "DOCTORS"
        }
    }
    @IBOutlet weak var tablView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var filtered:[String] = []
    
    
    
    var searchActive : Bool =  false
    
    @IBOutlet weak var btnSearch:UIButton! {
        didSet {
            btnSearch.tintColor = .white
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // searchBar.backgroundColor = .white
        // searchBar.barTintColor = .white
        tablView.backgroundColor = .white
        // tablView.delegate = self
        // tablView.dataSource = self
        // searchBar.delegate = self
        self.tablView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        self.navigationController?.isNavigationBarHidden = true
        btnAddNewDoctor.addTarget(self, action: #selector(btnAddNewDoctorPress), for: .touchUpInside)
        
        
        // self.btnNaviagtionMenu.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        self.btnSearch.addTarget(self, action: #selector(searchData), for: .touchUpInside)
        
        
        if let myLoadedString = UserDefaults.standard.string(forKey: "keySetToBackOrMenu") {
            print(myLoadedString)
            
            if myLoadedString == "backOrMenu" {
                // menu
                self.btnNaviagtionMenu.setImage(UIImage(systemName: "list.dash"), for: .normal)
                self.sideBarMenuClick()
            } else {
                // back
                self.btnNaviagtionMenu.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
            }
        } else {
            // back
            self.btnNaviagtionMenu.setImage(UIImage(systemName: "arrow.left"), for: .normal)
            self.btnNaviagtionMenu.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if strMyProfileIs == "FromHospitalProfileToDoctors" {
            
            self.lblNavigationBar.text = "DOCTORS"
            self.allDataListings(strRole: "Doctor", strSearchValue: "")
            // self.searchBar.placeholder = "Search Doctor here...."
            self.strSearchText = "Doctor"
            self.strSearchMessage = "You can search Doctor via Name"
            
        } else if strMyProfileIs == "FromHospitalProfileToLabs" {
            
            self.lblNavigationBar.text = "LABS"
            self.allDataListings(strRole: "Lab", strSearchValue: "")
            // self.searchBar.placeholder = "Search Lab here...."
            self.strSearchText = "Lab"
            self.strSearchMessage = "You can search Lab via Name"
            
        } else if strMyProfileIs == "FromHospitalProfileToPatient" {
            
            self.lblNavigationBar.text = "PATIENT"
            
            if self.str_from_reports == "yes" {
                
                self.show_reports_Result()
                
            } else {
                
                self.allDataListings(strRole: "Patient", strSearchValue: "")
                
            }
            
            
            // self.searchBar.placeholder = "Search Patient here...."
            self.strSearchText = "Patient"
            self.strSearchMessage = "You can search Patient via Name"
            
        } else if strMyProfileIs == "FromHospitalProfileToSuppliers" {
            
            self.lblNavigationBar.text = "SUPPLIERS"
            self.allDataListings(strRole: "Supplier", strSearchValue: "")
            // self.searchBar.placeholder = "Search Supplier here...."
            self.strSearchText = "Supplier"
            self.strSearchMessage = "You can search Supplier via Name"
            
        } else if self.strMyProfileIs == "FromLabToAllPatients" {
            
            self.lblNavigationBar.text = "PATIENTS LIST"
            self.allDataListings(strRole: "Patient", strSearchValue: "")
            // self.searchBar.placeholder = "Search Supplier here...."
            self.strSearchText = "Patient"
            self.strSearchMessage = "You can search Patient via Name"
            
        }
        
        
        
    }
    
    @objc func sideBarMenuClick() {
        
        UserDefaults.standard.set("", forKey: "keySetToBackOrMenu")
        UserDefaults.standard.set(nil, forKey: "keySetToBackOrMenu")
        
        self.view.endEditing(true)
        
        if revealViewController() != nil {
            
            btnNaviagtionMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    @objc func searchData() {
        self.arrListOfAllDoctors.removeAllObjects()
        
        let alert = NewYorkAlertController.init(title: "Search "+String(self.strSearchText), message: String(self.strSearchMessage), style: .alert)
        
        alert.addImage(UIImage.gif(name: "search"))
        
        alert.addTextField { tf in
            
            tf.placeholder = "name..."
            
            tf.keyboardType = .default
            tf.tag = 1
        }
        
        let ok = NewYorkButton(title: "Search", style: .default) { [unowned alert] _ in
            alert.textFields.forEach { tf in
                let text = tf.text ?? ""
                switch tf.tag {
                case 1:
                    print("quantity: \(text)")
                    
                    if self.strMyProfileIs == "FromHospitalProfileToDoctors" {
                        
                        self.allDataListings(strRole: "Doctor", strSearchValue: "\(text)")
                        
                    } else if self.strMyProfileIs == "FromHospitalProfileToLabs" {
                        
                        self.allDataListings(strRole: "Lab", strSearchValue: "\(text)")
                        
                    } else if self.strMyProfileIs == "FromHospitalProfileToPatient" {
                        
                        self.allDataListings(strRole: "Patient", strSearchValue: "\(text)")
                        
                    } else if self.strMyProfileIs == "FromHospitalProfileToSuppliers" {
                       
                        self.allDataListings(strRole: "Supplier", strSearchValue: "\(text)")
                        
                    } else if self.strMyProfileIs == "FromLabToAllPatients" {
                        
                        self.allDataListings(strRole: "Patient", strSearchValue: "\(text)")
                        
                    }
                    
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
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnAddNewDoctorPress() {
        
        if self.strMyProfileIs == "FromHospitalProfileToDoctors" {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HPAddNewDoctorVC") as? HPAddNewDoctorVC
            push!.strFromWhichProfile = "FromHospitalForDoctors"
            self.navigationController?.pushViewController(push!, animated: true)
            
        } else if self.strMyProfileIs == "FromHospitalProfileToLabs" {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HospitalNewLabRegistrationId") as? HospitalNewLabRegistration
            // push!.strFromWhichProfile = "FromHospitalForLabs"
            self.navigationController?.pushViewController(push!, animated: true)
            
        } else if self.strMyProfileIs == "FromHospitalProfileToPatient" {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddNewPatientVC") as? AddNewPatientVC
            // push!.strFromWhichProfile = "FromHospitalForPatient"
            self.navigationController?.pushViewController(push!, animated: true)
            
        } else if self.strMyProfileIs == "FromLabToAllPatients" {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddNewPatientVC") as? AddNewPatientVC
            // push!.strFromWhichProfile = "FromHospitalForPatient"
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        
    }
    
    // MARK:- ALL DOCTORS LISTING -
    @objc func allDataListings(strRole:String,strSearchValue:String) {
        self.arrListOfAllDoctors.removeAllObjects()
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if self.strMyProfileIs == "FromLabToAllPatients" {
            // if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            // let x : Int = person["userId"] as! Int
            // let myString = String(x)
            
            let params = DoctorsList(action: "userlist",
                                     role: String(strRole),
                                     addedBy: String(""),
                                     keyword: String(""))
            
            
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
                        
                        var ar : NSArray!
                        ar = (JSON["data"] as! Array<Any>) as NSArray
                        self.arrListOfAllDoctors.addObjects(from: ar as! [Any])
                        
                        self.tablView.delegate = self
                        self.tablView.dataSource = self
                        self.tablView.reloadData()
                        
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
            // }
        } else {
            
            if strRole == "Supplier" {
                
                let params = DoctorsList(action: "userlist",
                                         role: String(strRole),
                                         addedBy: String(""),
                                         keyword: String(strSearchValue))
                
                
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
                            
                            var ar : NSArray!
                            ar = (JSON["data"] as! Array<Any>) as NSArray
                            self.arrListOfAllDoctors.addObjects(from: ar as! [Any])
                            
                            self.tablView.delegate = self
                            self.tablView.dataSource = self
                            self.tablView.reloadData()
                            
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
                
            } else {
                
                if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                    
                    let x : Int = person["userId"] as! Int
                    let myString = String(x)
                    
                    let params = DoctorsList(action: "userlist",
                                             role: String(strRole),
                                             addedBy: String(myString),
                                             keyword: String(strSearchValue))
                    
                    
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
                                
                                var ar : NSArray!
                                ar = (JSON["data"] as! Array<Any>) as NSArray
                                self.arrListOfAllDoctors.addObjects(from: ar as! [Any])
                                
                                self.tablView.delegate = self
                                self.tablView.dataSource = self
                                self.tablView.reloadData()
                                
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
        
        
    }
    
    @objc func deleteDoctorFromListClickMethod(_ sender:UIButton) {
        
        if strMyProfileIs == "FromHospitalProfileToDoctors" {
            
            let item = arrListOfAllDoctors[sender.tag] as? [String:Any]
            
            let alert = UIAlertController(title: String("Delete Doctor"), message: "Are you sure you want to delete \n\n Doctor :  '\(item!["fullName"] as! String)'", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes, Delete", style: .default, handler: { action in
                
                let x : Int = item!["userId"] as! Int
                let myString = String(x)
                
                self.deleteDoctorFromDatabase(strDoctorId: String(myString))
            }))
            
            alert.addAction(UIAlertAction(title: "Dismisss", style: .destructive, handler: nil))
            
            self.present(alert, animated: true)
            
        } else if strMyProfileIs == "FromHospitalProfileToLabs" {
            
            let item = arrListOfAllDoctors[sender.tag] as? [String:Any]
            
            let alert = UIAlertController(title: String("Delete Lab"), message: "Are you sure you want to delete \n\n Lab :  '\(item!["fullName"] as! String)'", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes, Delete", style: .default, handler: { action in
                
                let x : Int = item!["userId"] as! Int
                let myString = String(x)
                
                self.deleteDoctorFromDatabase(strDoctorId: String(myString))
            }))
            
            alert.addAction(UIAlertAction(title: "Dismisss", style: .destructive, handler: nil))
            
            self.present(alert, animated: true)
            
        } else if self.strMyProfileIs == "FromHospitalProfileToPatient" {
            
            let item = arrListOfAllDoctors[sender.tag] as? [String:Any]
            
            let alert = UIAlertController(title: String("Delete Lab"), message: "Are you sure you want to delete \n\n Patient :  '\(item!["fullName"] as! String)'", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes, Delete", style: .default, handler: { action in
                
                let x : Int = item!["userId"] as! Int
                let myString = String(x)
                
                self.deleteDoctorFromDatabase(strDoctorId: String(myString))
            }))
            
            alert.addAction(UIAlertAction(title: "Dismisss", style: .destructive, handler: nil))
            
            self.present(alert, animated: true)
            
        } else if self.strMyProfileIs == "FromLabToAllPatients" {
            
            let item = arrListOfAllDoctors[sender.tag] as? [String:Any]
            
            let alert = UIAlertController(title: String("Delete Lab"), message: "Are you sure you want to delete \n\n Patient :  '\(item!["fullName"] as! String)'", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes, Delete", style: .default, handler: { action in
                
                let x : Int = item!["userId"] as! Int
                let myString = String(x)
                
                self.deleteDoctorFromDatabase(strDoctorId: String(myString))
            }))
            
            alert.addAction(UIAlertAction(title: "Dismisss", style: .destructive, handler: nil))
            
            self.present(alert, animated: true)
            
        }
       
    }
    
    @objc func deleteDoctorFromDatabase(strDoctorId:String) {
        // let indexPath = IndexPath.init(row: 0, section: 0)
        // let cell = self.tablView.cellForRow(at: indexPath) as! HPAddNewDoctorTableViewCell
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "deleting...")
        
        // if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
        
        let params =  DeleteDoctors(action: "deleteuser",
                                    userId: String(strDoctorId))
        
        
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
                    
                    var strSuccess2 : String!
                    strSuccess2 = JSON["msg"]as Any as? String
                    
                    let alert = UIAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action  in
                        
                        if self.strMyProfileIs == "FromHospitalProfileToDoctors" {
                            
                            self.lblNavigationBar.text = "DOCTORS"
                            self.allDataListings(strRole: "Doctor", strSearchValue: "")
                            
                        } else if self.strMyProfileIs == "FromHospitalProfileToLabs" {
                            
                            self.lblNavigationBar.text = "LABS"
                            self.allDataListings(strRole: "Lab", strSearchValue: "")
                            
                        } else if self.strMyProfileIs == "FromHospitalProfileToPatient" {
                            
                            self.lblNavigationBar.text = "PATIENT"
                            self.allDataListings(strRole: "Patient", strSearchValue: "")
                        }
                        
                    }))
                    
                    self.present(alert, animated: true)
                    
                    
                    
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
        // }
    }
    
    @objc func editDoctorFromListClickMethod(_ sender:UIButton) {
        
        /*let item = arrListOfAllDoctors[sender.tag] as? [String:Any]
         // print(item as Any) //
         
         let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HPAddNewDoctorVC") as? HPAddNewDoctorVC
         push!.getAllDetails = item as NSDictionary?
         push!.strProfileForEdit = "yes"
         push!.strFromWhichProfile = "FromHospital"
         self.navigationController?.pushViewController(push!, animated: true)*/
        
        let item = arrListOfAllDoctors[sender.tag] as? [String:Any]
        
        if self.strMyProfileIs == "FromHospitalProfileToDoctors" {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HPAddNewDoctorVC") as? HPAddNewDoctorVC
            push!.getAllDetails = item as NSDictionary?
            push!.strProfileForEdit = "yes"
            push!.strFromWhichProfile = "FromHospitalForDoctors"
            self.navigationController?.pushViewController(push!, animated: true)
            
        } else if self.strMyProfileIs == "FromHospitalProfileToLabs" {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HospitalNewLabRegistrationId") as? HospitalNewLabRegistration
            push!.getAllDetails = item as NSDictionary?
            push!.strProfileForEdit = "yes"
            // push!.strFromWhichProfile = "FromHospitalForLabs"
            self.navigationController?.pushViewController(push!, animated: true)
            
        } else if self.strMyProfileIs == "FromHospitalProfileToPatient" {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddNewPatientVC") as? AddNewPatientVC
            push!.getAllDetails = item as NSDictionary?
            push!.strProfileForEdit = "yes"
            self.navigationController?.pushViewController(push!, animated: true)
            
        } else if self.strMyProfileIs == "FromLabToAllPatients" {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddNewPatientVC") as? AddNewPatientVC
            push!.getAllDetails = item as NSDictionary?
            push!.strProfileForEdit = "yes"
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        
        
        
    }
    
    
    
    
    @objc func show_reports_Result() {
        self.arrListOfAllDoctors.removeAllObjects()
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = get_all_patient_list(action: "userlist",
                                              role: String(self.str_report_role),
                                              addedBy: String(myString),
                                              start_date: String(self.str_start_Date),
                                              end_date: String(self.str_end_Date),
                                              paid: String(self.str_paid),
                                              keyword: String(self.str_keyword))
            
            
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
                        
                        var ar : NSArray!
                        ar = (JSON["data"] as! Array<Any>) as NSArray
                        self.arrListOfAllDoctors.addObjects(from: ar as! [Any])
                        
                        self.tablView.delegate = self
                        self.tablView.dataSource = self
                        self.tablView.reloadData()
                        
                    } else {
                        print("no")
                        ERProgressHud.sharedInstance.hide()
                        
                        var strSuccess2 : String!
                        strSuccess2 = JSON["msg"]as Any as? String
                        
                        let alert = NewYorkAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), style: .alert)
                        
                        alert.addImage(UIImage.gif(name: "gif_alert"))
                        
                        let cancel = NewYorkButton(title: "Ok", style: .cancel) { _ in
                            
                            self.navigationController?.popViewController(animated: true)
                        }
                        alert.addButtons([cancel])
                        
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


extension HPDoctorsVC: UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchActive {
            
            return filtered.count
        }
        
        else {
            
            return  arrListOfAllDoctors.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:HPDoctorsTableViewCell  =  tablView.dequeueReusableCell(withIdentifier: "cell") as! HPDoctorsTableViewCell
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.backgroundColor = .white
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        // cell.imgDoctorsProfile.image = UIImage(named: "david")
        // cell.btnPhoneNumber.setTitle(phoneArray[indexPath.row], for: .normal)
        // cell.lblSpecialist.text = "Genral Physician"
        
        if searchActive {
            
            
            cell.lblDoctorsName.text =  filtered[indexPath.row]
        }
        
        else {
            
            let item = arrListOfAllDoctors[indexPath.row] as? [String:Any]
            
            
            cell.imgDoctorsProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.imgDoctorsProfile.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "1024"))
            
            
            
            if self.strMyProfileIs == "FromHospitalProfileToPatient" {
                
                cell.lblDoctorsName.text = (item!["fullName"] as! String)// +" "+(item!["middleName"] as! String)+" "+(item!["lastName"] as! String)
                cell.lblSpecialist.text = (item!["email"] as! String)
                cell.btnPhoneNumber.setTitle((item!["contactNumber"] as! String), for: .normal)
                
                cell.btnEdit.isHidden = false
                cell.btnDelete.isHidden = false
                
                cell.imgEdit.isHidden = false
                cell.imgDelete.isHidden = false
                
            } else if strMyProfileIs == "FromHospitalProfileToSuppliers" {
                
                cell.lblDoctorsName.text = (item!["fullName"] as! String)
                cell.lblSpecialist.text = (item!["address"] as! String)
                cell.btnPhoneNumber.setTitle((item!["contactNumber"] as! String), for: .normal)
                
                cell.btnEdit.isHidden = true
                cell.btnDelete.isHidden = true
                
                cell.imgEdit.isHidden = true
                cell.imgDelete.isHidden = true
                
                self.btnAddNewDoctor.isHidden = true
                
            } else if strMyProfileIs == "FromHospitalProfileToLabs" {
                
                cell.lblDoctorsName.text = (item!["fullName"] as! String)
                cell.lblSpecialist.text = (item!["address"] as! String)
                cell.btnPhoneNumber.setTitle((item!["contactNumber"] as! String), for: .normal)
                
                cell.btnEdit.isHidden = false
                cell.btnDelete.isHidden = false
                
                cell.imgEdit.isHidden = false
                cell.imgDelete.isHidden = false
                
                // self.btnAddNewDoctor.isHidden = true
                
            } else if self.strMyProfileIs == "FromLabToAllPatients" {
                
                cell.lblDoctorsName.text    = (item!["fullName"] as! String)
                cell.lblSpecialist.text     = (item!["address"] as! String)
                cell.btnPhoneNumber.setTitle((item!["contactNumber"] as! String), for: .normal)
                
                cell.btnEdit.isHidden = true
                cell.btnDelete.isHidden = true
                
                cell.imgEdit.isHidden = true
                cell.imgDelete.isHidden = true
                
                self.btnAddNewDoctor.isHidden = true
                
                cell.accessoryType = .disclosureIndicator
                
            } else {
                
                cell.lblDoctorsName.text = (item!["fullName"] as! String)
                cell.lblSpecialist.text = (item!["specialty"] as! String)
                cell.btnPhoneNumber.setTitle((item!["contactNumber"] as! String), for: .normal)
                
                cell.btnEdit.isHidden = false
                cell.btnDelete.isHidden = false
                
                cell.imgEdit.isHidden = false
                cell.imgDelete.isHidden = false
                
            }
            
            
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.addTarget(self, action: #selector(deleteDoctorFromListClickMethod), for: .touchUpInside)
            
            cell.btnEdit.tag = indexPath.row
            cell.btnEdit.addTarget(self, action: #selector(editDoctorFromListClickMethod), for: .touchUpInside)
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = arrListOfAllDoctors[indexPath.row] as? [String:Any]
        // print(item as Any)
        
         if self.strMyProfileIs == "FromHospitalProfileToSuppliers" {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPSupplierDetailsVC") as? PPSupplierDetailsVC
            push!.getSupplierDetails = item as NSDictionary?
            // push!.strProfileForEdit = "yes"
            self.navigationController?.pushViewController(push!, animated: true)
            
         } else if self.strMyProfileIs == "FromLabToAllPatients" {
             
             let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LabsPatientDetailsId") as? LabsPatientDetails
             push!.dictSupplierLoginData = item as NSDictionary?
             self.navigationController?.pushViewController(push!, animated: true)
             
         }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if strMyProfileIs == "FromHospitalProfileToSuppliers" {
            return UITableView.automaticDimension
        } else {
            return 90
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
        
        filtered = nameArray.filter({ (text) -> Bool in
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
}
