//
//  AllNotifications.swift
//  E health App
//
//  Created by apple on 03/02/22.
//

import UIKit
import Alamofire
import SDWebImage

class AllNotifications: UIViewController {

    var arr_list_of_all_notifications:NSMutableArray = []
    
    @IBOutlet weak var viewNavigationbar:UIView!
    @IBOutlet weak var btnDashboardMenu: UIButton!
    @IBOutlet weak var lblNavationbar:UILabel!{
        didSet {
            lblNavationbar.text = "All Notifications"
        }
    }
    
    @IBOutlet weak var lbl_no_Data_found:UILabel!{
        didSet {
            lbl_no_Data_found.textColor = .black
            lbl_no_Data_found.isHidden = true
        }
    }
    
    @IBOutlet weak var tablView:UITableView! {
        didSet {
            tablView.backgroundColor =  .white
            tablView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tablView.separatorStyle = UITableViewCell.SeparatorStyle.none
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        if let myLoadedString = UserDefaults.standard.string(forKey: "keySetToBackOrMenu") {
            print(myLoadedString)
            
            if myLoadedString == "backOrMenu" {
                // menu
                self.btnDashboardMenu.setImage(UIImage(systemName: "list.dash"), for: .normal)
                self.sideBarMenuClick()
            } else {
                // back
                self.btnDashboardMenu.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
            }
        } else {
            // back
            self.btnDashboardMenu.setImage(UIImage(systemName: "arrow.left"), for: .normal)
            self.btnDashboardMenu.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
        
        self.all_notification_wb(str_loading: "yes")
        
    }

    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func sideBarMenuClick() {
        
        UserDefaults.standard.set("", forKey: "keySetToBackOrMenu")
        UserDefaults.standard.set(nil, forKey: "keySetToBackOrMenu")
        
        self.view.endEditing(true)
        
        if revealViewController() != nil {
            
            btnDashboardMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    @objc func all_notification_wb(str_loading:String) {
         self.arr_list_of_all_notifications.removeAllObjects()
        
        if str_loading == "yes" {
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        }
        
        
        
        self.view.endEditing(true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            let params = all_notifications(action: "notificationlist",
                                           userId: String(myString),
                                           role: (person["role"] as! String))
            
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
                    strSuccess = JSON["status"]as Any as? String
                    
                    // var strSuccess2 : String!
                    // strSuccess2 = JSON["msg"]as Any as? String
                    
                    if strSuccess == String("success") {
                        print("yes")
                        
                        ERProgressHud.sharedInstance.hide()
                        
                        
                        var ar : NSArray!
                        ar = (JSON["data"] as! Array<Any>) as NSArray
                        self.arr_list_of_all_notifications.addObjects(from: ar as! [Any])
                        
                        if self.arr_list_of_all_notifications.count == 0 {
                            
                            self.lbl_no_Data_found.isHidden = false
                            self.tablView.isHidden = true
                            
                        } else {
                            
                            self.lbl_no_Data_found.isHidden = true
                            self.tablView.isHidden = false
                            self.tablView.delegate = self
                            self.tablView.dataSource = self
                            self.tablView.reloadData()
                            
                        }
                        
                        /*var dict: Dictionary<AnyHashable, Any>
                         dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                         print(dict as Any)
                         self.arrListOfAllPrescription.add(dict)*/
                        
                        self.tablView.delegate = self
                        self.tablView.dataSource = self
                        self.tablView.reloadData()
                        
                    } else {
                        print("no")
                        ERProgressHud.sharedInstance.hide()
                        
                        var strSuccess2 : String!
                        strSuccess2 = JSON["msg"]as Any as? String
                        
                        let alert = UIAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
                            action in
                            self.navigationController?.popViewController(animated: true)
                        }))
                        
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
    
    // WEBSERVICES
    @objc func change_Status_prescription_request_wb(dictGetPatientDetails:NSDictionary,strStatus:String) {
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let x3 : Int = (dictGetPatientDetails["login_id"] as! Int)
        let myString2 = String(x3)
        
        let x4 : Int = (dictGetPatientDetails["userId"] as! Int)
        let myString4 = String(x4)
        
        let x5 : Int = (dictGetPatientDetails["prescriptionId"] as! Int)
        let myString5 = String(x5)
        
        let params = status_change_request_prescription_from_pharmacy(action: "prescriptionreply",
                                                                      userId: String(myString4),
                                                                      hospitalId: String(myString2),
                                                                      prescriptionId: String(myString5),
                                                                      request_reply: String(strStatus))
        
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
                strSuccess = JSON["status"]as Any as? String
                
                // var strSuccess2 : String!
                // strSuccess2 = JSON["msg"]as Any as? String
                
                if strSuccess == String("success") {
                    print("yes")
                    
                    // ERProgressHud.sharedInstance.hide()
                    
                    self.all_notification_wb(str_loading: "no")
                    
                } else {
                    
                    print("no")
                    ERProgressHud.sharedInstance.hide()
                    
                }
                
            case let .failure(error):
                print(error)
                ERProgressHud.sharedInstance.hide()
                
                // Utils.showAlert(alerttitle: SERVER_ISSUE_TITLE, alertmessage: SERVER_ISSUE_MESSAGE, ButtonTitle: "Ok", viewController: self)
            }
        }
        
        // }
    }
    
    // WEBSERVICES
    @objc func change_Status_test_request_wb(dictGetPatientDetails:NSDictionary,
                                             strStatus:String) {
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let x3 : Int = (dictGetPatientDetails["login_id"] as! Int)
        let myString2 = String(x3)
        
        let x4 : Int = (dictGetPatientDetails["userId"] as! Int)
        let myString4 = String(x4)
        
        let x5 : Int = (dictGetPatientDetails["testId"] as! Int)
        let myString5 = String(x5)
        
        let params = status_change_test_from_notification(action: "testreply",
                                                          userId: String(myString4),
                                                          hospitalId: String(myString2),
                                                          testId: String(myString5),
                                                          request_reply: String(strStatus))
        
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
                strSuccess = JSON["status"]as Any as? String
                
                // var strSuccess2 : String!
                // strSuccess2 = JSON["msg"]as Any as? String
                
                if strSuccess == String("success") {
                    print("yes")
                    
                    // ERProgressHud.sharedInstance.hide()
                    
                    self.all_notification_wb(str_loading: "no")
                    
                } else {
                    
                    print("no")
                    ERProgressHud.sharedInstance.hide()
                    
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

extension AllNotifications:UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arr_list_of_all_notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:AllNotificatinsTableCell = tablView.dequeueReusableCell(withIdentifier: "allNotificatinsTableCell") as! AllNotificatinsTableCell
        
        /*cell.backgroundColor = .white
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero*/
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        // cell.lblPatientName.text = arr[indexPath.row]
        
        /*
         appointmentId = 52;
         contactNumber = 23235654125;
         created = "2022-02-03 16:33:00";
         email = "p1m@gmail.com";
         fullName = p1m;
         hospitalId = 349;
         "login_id" = 339;
         permission = Decline;
         prescriptionId = 24;
         role = Pharmacy;
         type = Prescription;
         userId = 392;
     },
             {
         appointmentId = 53;
         contactNumber = 23235654125;
         created = "2022-02-03 16:33:00";
         email = "p1m@gmail.com";
         fullName = p1m;
         hospitalId = 365;
         "login_id" = 339;
         permission = Decline;
         prescriptionId = 25;
         role = Pharmacy;
         type = Prescription;
         userId = 392;
     },
             {
         appointmentId = 53;
         contactNumber = 8956234215;
         created = "2022-02-03 16:31:00";
         email = "lab10@mailinator.com";
         fullName = Lab10;
         hospitalId = 325;
         "login_id" = 350;
         permission = Decline;
         role = Lab;
         testId = 28;
         type = Test;
         userId = 392;
         
         [action] => prescriptionreply
         [userId] => 392
         [hospitalId] => 339
         [prescriptionId] => 25
         [request_reply] => Accept
         
         */
        
        let item = self.arr_list_of_all_notifications[indexPath.row] as? [String:Any]
        // print(item as Any)
        
        cell.lbl_title.text = (item!["fullName"] as! String)
        
        cell.lbl_email.text = (item!["email"] as! String)
        cell.lbl_phone.text = (item!["contactNumber"] as! String)
        
        
        cell.lbl_access_for.text = (item!["type"] as! String)
        
        
        
        return cell
    }
    
    @objc func cellTappedMethod1(_ sender:AnyObject) {
        
        print("you tap image number: \(sender.view.tag)")
        
        /*let item = self.arrListOfAppoitmentList[sender.view.tag] as? [String:Any]
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPAppointmentDetailsVC") as? PPAppointmentDetailsVC
        push!.getPatientAppointmentDetails = item as NSDictionary?
        self.navigationController?.pushViewController(push!, animated: true)*/
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item  = self.arr_list_of_all_notifications[indexPath.row] as? [String:Any]
        
        if (item!["type"] as! String) == "Prescription" { // prescription
            
            let alert = NewYorkAlertController(title: "Permission", message:"Allow request for Prescription" , style: .alert)
            
            alert.addImage(UIImage(named: "medical_permission"))
            
            let cancel1 = NewYorkButton(title: "Yes, Approve", style: .default) {
                _ in
                print("i clicked accept")
                self.change_Status_prescription_request_wb(dictGetPatientDetails: item! as NSDictionary, strStatus: "Accept")
            }
            
            let cancel = NewYorkButton(title: "Decline", style: .cancel) {
                _ in
                print("i clicked decline")
                
                self.change_Status_prescription_request_wb(dictGetPatientDetails: item! as NSDictionary, strStatus: "Decline")
            }
            
            cancel1.setDynamicColor(.purple)
            cancel.setDynamicColor(.red)
            
            alert.addButtons([cancel1,cancel])
            
            self.present(alert, animated: true)
            
        } else if (item!["type"] as! String) == "Test" { // test
            
            let alert = NewYorkAlertController(title: "Permission", message:"Allow request for Test" , style: .alert)
            
            alert.addImage(UIImage(named: "medical_permission"))
            
            let cancel1 = NewYorkButton(title: "Yes, Approve", style: .default) {
                _ in
                print("i clicked accept")
                self.change_Status_test_request_wb(dictGetPatientDetails: item! as NSDictionary, strStatus: "Accept")
            }
            
            let cancel = NewYorkButton(title: "Decline", style: .cancel) {
                _ in
                print("i clicked decline")
                
                self.change_Status_test_request_wb(dictGetPatientDetails: item! as NSDictionary, strStatus: "Decline")
            }
            
            cancel1.setDynamicColor(.purple)
            cancel.setDynamicColor(.red)
            
            alert.addButtons([cancel1,cancel])
            
            self.present(alert, animated: true)
            
        } else {
            // something else
            
        }
        
        
        /*if (item!["item"] as! String) == "Prescription" {
            
            self.change_Status_prescription_request_wb(dictGetPatientDetails: <#T##NSDictionary#>, strStatus: <#T##String#>)
            
        } else {
            
        }*/
        
        /*let medical_request_notification_title    = (dictOfNotification["title"] as! String)
        let medical_request_notification_message  = (dictOfNotification["message"] as! String)
        
        let full_name  = (dictOfNotification["LoginUserName"] as! String)
        
        let alert = NewYorkAlertController(title: medical_request_notification_title, message:"'"+String(full_name)+"' "+medical_request_notification_message , style: .alert)
        
        alert.addImage(UIImage(named: "medical_permission"))
        
        let cancel1 = NewYorkButton(title: "Yes, Approve", style: .default) {
            _ in
            print("i clicked accept")
            self.change_Status_prescription_request_wb(dictGetPatientDetails: dictOfNotification, strStatus: "Accept")
        }
        
        let cancel = NewYorkButton(title: "decline", style: .cancel) {
            _ in
            print("i clicked decline")
            
            self.change_Status_prescription_request_wb(dictGetPatientDetails: dictOfNotification, strStatus: "Decline")
        }
        
        cancel1.setDynamicColor(.purple)
        cancel.setDynamicColor(.red)
        
        alert.addButtons([cancel1,cancel])
        */
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    @objc func pushToAllDoctorsList() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPBookAppointmentSelectDoctorVC") as? PPBookAppointmentSelectDoctorVC
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
}
