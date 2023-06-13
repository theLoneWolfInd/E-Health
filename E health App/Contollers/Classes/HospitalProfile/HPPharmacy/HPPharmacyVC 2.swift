//
//  HPPharmacyVC.swift
//  E health App
//
//  Created by Ranjan on 02/09/21.
//

import UIKit
import Alamofire
import SDWebImage

class HPPharmacyVC: UIViewController {
    
    var strMyProfileIs:String!
    
    var arrListOfAllDoctors : NSMutableArray! = []
    
    var nameArray = ["Jp hospita","Noida Hospital","Aims","M G Hospital"]
    
    var phoneArray = ["888-124-1434","745-343-4233","638-343-3243","888-124-1434","745-343-4233","638-343-3243","888-124-1434","745-343-4233","638-343-3243","638-343-3243"]

    @IBOutlet weak var btnSearch:UIButton! {
        didSet {
            btnSearch.tintColor = .white
        }
    }
    
    @IBOutlet weak var btnAddNewPharmacy: UIButton!
    @IBOutlet weak var viewNavigationBar:UIView!
    @IBOutlet weak var btnNaviagtionMenu:UIButton!
    @IBOutlet weak var lblNavigationBar:UILabel!{
        didSet {
            
            lblNavigationBar.text = "PHARMACY"
        }
    }
    @IBOutlet weak var tablView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var filtered:[String] = []
    
    var searchActive : Bool =  false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        // searchBar.backgroundColor = .white
        // searchBar.barTintColor = .white
        
        tablView.backgroundColor = .white
        tablView.delegate = self
        tablView.dataSource = self
        
        // searchBar.delegate = self
        
        self.tablView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        self.navigationController?.isNavigationBarHidden = true
        
        self.btnAddNewPharmacy.addTarget(self, action: #selector(btnAddNewPharmacyPress), for: .touchUpInside)
        
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
        self.allDataListings(strSearchText: "")
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
    
    @objc func btnAddNewPharmacyPress() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HospitalNewPharmacyRegistrationId") as? HospitalNewPharmacyRegistration
        // push!.strFromWhichProfile = "FromHospitalForPharmacy"
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func searchData() {
        self.arrListOfAllDoctors.removeAllObjects()
        
        let alert = NewYorkAlertController.init(title: "Search", message: "Search Pharmacy via Name", style: .alert)
        
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
                    
                    self.allDataListings(strSearchText: "\(text)")
                    
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
    
    // MARK:- ALL DOCTORS LISTING -
    @objc func allDataListings(strSearchText:String) {
        self.arrListOfAllDoctors.removeAllObjects()
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = DoctorsList(action: "userlist",
                                     role: String("Pharmacy"),
                                     addedBy: String(myString),
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
        }
    }
    
    
    
    @objc func editDoctorFromListClickMethod(_ sender:UIButton) {
        
        let item = arrListOfAllDoctors[sender.tag] as? [String:Any]
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HospitalNewPharmacyRegistrationId") as? HospitalNewPharmacyRegistration
        push!.getAllDetails = item as NSDictionary?
        push!.strProfileForEdit = "yes"
        // push!.strFromWhichProfile = "FromHospitalForPharmacy"
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    @objc func deleteDoctorFromListClickMethod(_ sender:UIButton) {
        
        let item = arrListOfAllDoctors[sender.tag] as? [String:Any]
        
        let alert = UIAlertController(title: String("Delete Lab"), message: "Are you sure you want to delete \n\n Pharmacy :  '\(item!["fullName"] as! String)'", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes, Delete", style: .default, handler: { action in
             
            let x : Int = item!["userId"] as! Int
            let myString = String(x)
            
             self.deletePharmacyFromDatabase(strDoctorId: String(myString))
        }))
        
        alert.addAction(UIAlertAction(title: "Dismisss", style: .destructive, handler: nil))
        
        self.present(alert, animated: true)
        
    }
    
    @objc func deletePharmacyFromDatabase(strDoctorId:String) {
        // let indexPath = IndexPath.init(row: 0, section: 0)
        // let cell = self.tablView.cellForRow(at: indexPath) as! HPAddNewDoctorTableViewCell
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "adding...")
        
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
                                
                                self.allDataListings(strSearchText: "")
                                
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
    
}

extension HPPharmacyVC: UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchActive {
            
            return filtered.count
        } else {
            
            return arrListOfAllDoctors.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:HPPharmacyTableViewCell  =  tablView.dequeueReusableCell(withIdentifier: "cell") as! HPPharmacyTableViewCell
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.backgroundColor = .white
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.imgPharmacyProfile.image = UIImage(named: "phramacy")
        cell.btnPharmacyAddress.setTitle("e-1 sector 23, Noida UP", for: .normal)
        cell.lblPharmacyPhone.text = phoneArray[indexPath.row]
        
        if searchActive {
            
            
            cell.lblPharmacyName.text =  filtered[indexPath.row]
        }
        
        else {
            
            let item = arrListOfAllDoctors[indexPath.row] as? [String:Any]
            cell.lblPharmacyName.text = (item!["fullName"] as! String)
            
            cell.imgPharmacyProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.imgPharmacyProfile.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "1024"))
            
            cell.btnPharmacyAddress.setTitle((item!["contactNumber"] as! String), for: .normal)
            cell.lblPharmacyPhone.text = (item!["email"] as! String)
            
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.addTarget(self, action: #selector(deleteDoctorFromListClickMethod), for: .touchUpInside)
            
            cell.btnEdit.tag = indexPath.row
            cell.btnEdit.addTarget(self, action: #selector(editDoctorFromListClickMethod), for: .touchUpInside)
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 98
    }
    
    //Search bar Delegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = nameArray.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        
        if(filtered.count == 0) {
            searchActive = false
        } else {
            searchActive = true
        }
        
        self.tablView.reloadData()
    }
    
}
