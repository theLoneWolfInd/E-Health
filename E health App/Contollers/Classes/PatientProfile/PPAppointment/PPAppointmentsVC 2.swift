//
//  PPAppointmentsVC.swift
//  E health App
//
//  Created by Ranjan on 03/09/21.
//

import UIKit
import Alamofire
import SDWebImage

class PPAppointmentsVC: UIViewController {
    
    var arr = ["Allen","Denical JohnSon", "Shawn Davis"]
    
    // save add to cart food
    var arrListOfAppoitmentList:NSMutableArray = []
    
    var strAppointmentDateCheck:String!
    
    var str_search_report_data:String!
    var str_get_start_Date:String!
    var str_get_end_Date:String!
    
    var str_patient_id_prescription_from_pharmacy:String!
    var str_patient_prescription_from_pharmacy:String!
    
    @IBOutlet weak var viewNavigationbar:UIView!
    @IBOutlet weak var btnDashboardMenu: UIButton!
    
    @IBOutlet weak var lblNavationbar:UILabel! {
        didSet {
            
            lblNavationbar.text = "APPOINTMENTS"
        }
    }
    
    @IBOutlet weak var btnAddPatient:UIButton!
    
    @IBOutlet weak var tablView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // tablView.delegate = self
        // tablView.dataSource =  self
        self.view.backgroundColor = .white
        tablView.backgroundColor =  .white
        self.navigationController?.isNavigationBarHidden = true
        self.tablView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        self.tablView.separatorStyle = UITableViewCell.SeparatorStyle.none

        self.btnAddPatient.addTarget(self, action: #selector(pushToAllDoctorsList), for: .touchUpInside)
        
        
        if let myLoadedString = UserDefaults.standard.string(forKey: "keySetToBackOrMenu") {
            print(myLoadedString)
            
            if myLoadedString == "backOrMenu" {
                // menu
                
                if self.str_search_report_data == nil {
                    
                    self.btnDashboardMenu.setImage(UIImage(systemName: "list.dash"), for: .normal)
                    self.sideBarMenuClick()
                    
                } else {
                
                    self.btnDashboardMenu.setImage(UIImage(systemName: "arrow.left"), for: .normal)
                    self.btnDashboardMenu.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
                    
                }
                
                
            } else {
                // back
                self.btnDashboardMenu.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
            }
        } else {
            // back
            self.btnDashboardMenu.setImage(UIImage(systemName: "arrow.left"), for: .normal)
            self.btnDashboardMenu.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
        
        
        
        
        
        
        if self.str_patient_prescription_from_pharmacy == "yes" {
            
             self.btnAddPatient.isHidden = true
            
            self.appointment_list_of_patient_in_pharmacy()
            
        } else if self.str_patient_prescription_from_pharmacy == "yes_labs" {
            
            self.btnAddPatient.isHidden = true
           
           self.appointment_list_of_patient_in_pharmacy()
            
        } else {
            
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                
                if (person["role"] as! String) == "Doctor" || (person["role"] as! String) == "Hospital" {
                    self.btnAddPatient.isHidden = true
                } else if (person["role"] as! String) == "Patient"  {
                    self.btnAddPatient.isHidden = false
                }
                
            }
            
            
            
            if self.str_search_report_data == nil {
                
                self.str_search_report_data = ""
                
                if self.strAppointmentDateCheck == nil {
                    
                    self.appoitmentList(strDateIs: "", str_start_Date: "", str_end_date: "")
                    
                } else {
                    
                    self.appoitmentList(strDateIs: String(self.strAppointmentDateCheck), str_start_Date: "", str_end_date: "")
                    
                }
                
            } else {
                
                if self.str_search_report_data == "custom" {
                    self.appoitmentList(strDateIs: "", str_start_Date: String(self.str_get_start_Date), str_end_date: String(self.str_get_end_Date))
                } else {
                    self.appoitmentList(strDateIs: "", str_start_Date: "", str_end_date: "")
                }
                
                
            }
            
        }
        
        
        
        
        
        
        
        
        
         
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
    
    @objc func appointment_list_of_patient_in_pharmacy() {
        self.arrListOfAppoitmentList.removeAllObjects()
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            if (person["role"] as! String) == "Doctor" {
                ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Checking...")
            } else {
                ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            }
            
        }
        
        
        self.view.endEditing(true)
        
        /*if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            */
            
            let params = Patient_Appoitment_List(action: "appointmentlist",
                                                 userId: String(self.str_patient_id_prescription_from_pharmacy),
                                                 type: "Patient",
                                                 Adate: String(""),
                                                 timespan:String(""),
                                                 start_date:String(""),
                                                 end_date:String(""))
            
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
                                self.arrListOfAppoitmentList.addObjects(from: ar as! [Any])
                                
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
    }
    
    // Appoitment_List
    @objc func appoitmentList(strDateIs:String,str_start_Date:String,str_end_date:String) {
        self.arrListOfAppoitmentList.removeAllObjects()
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            if (person["role"] as! String) == "Doctor" {
                ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Checking...")
            } else {
                ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            }
            
        }
        
        
        self.view.endEditing(true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            let params = Patient_Appoitment_List(action: "appointmentlist",
                                                 userId: String(myString),
                                                 type: (person["role"] as! String),
                                                 Adate: String(strDateIs),
                                                 timespan:String(self.str_search_report_data),
                                                 start_date:String(str_start_Date),
                                                 end_date:String(str_end_date))
            
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
                                self.arrListOfAppoitmentList.addObjects(from: ar as! [Any])
                                
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

extension PPAppointmentsVC:UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrListOfAppoitmentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:PPAppointmentsTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell") as! PPAppointmentsTableViewCell
        
        cell.backgroundColor = .white
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        // cell.lblPatientName.text = arr[indexPath.row]
        
        /*
         ATime = "Select Date";
         Adate = "2021-09-20";
         DoctorAddress = test;
         DoctorLastName = "";
         DoctorfullName = test02;
         HospitalAddress = India;
         HospitalLastName = "";
         HospitalfullName = test01;
         PatientAddress = "39, Sector 6, Sector 10 Dwarka, Dwarka, New Delhi, Delhi 110075, India";
         PatientImage = "https://demo4.evirtualservices.net/ehealth/img/uploads/users/1631791993images(44).jpeg";
         PatientLastName = one;
         PatientfullName = cap;
         appointmentId = 50;
         created = "2021-09-17 13:48:00";
         doctorId = 68;
         hospitalId = 67;
         userId = 161;
         */
        
        let item = self.arrListOfAppoitmentList[indexPath.row] as? [String:Any]
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            if (person["role"] as! String) == "Doctor" {
                cell.imgEye.isHidden = true
                cell.btn_notes.isHidden = false
                
                cell.btn_notes.tag = indexPath.row
                cell.btn_notes.addTarget(self, action: #selector(notes_click_method), for: .touchUpInside)
                
                cell.lblPatientName.text = (item!["PatientfullName"] as! String)
                
                cell.btnAppointmentDateTime.setTitle("Date: "+(item!["Adate"] as! String), for:.normal)
                
                cell.btnPatientAddress.setTitle(" "+(item!["PatientAddress"] as! String), for:.normal)
                cell.btnPatientAddress.titleLabel?.lineBreakMode = .byWordWrapping
                
                cell.imgPatientProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell.imgPatientProfile.sd_setImage(with: URL(string: (item!["PatientImage"] as! String)), placeholderImage: UIImage(named: "1024"))
                
                cell.imgEye.tag = indexPath.row
                let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(PPAppointmentsVC.cellTappedMethod1(_:)))

                cell.imgEye.isUserInteractionEnabled = true
                cell.imgEye.addGestureRecognizer(tapGestureRecognizer1)
                
            } else if (person["role"] as! String) == "Hospital" {
                cell.imgEye.isHidden = true
                
                cell.btn_notes.isHidden = false
                
                cell.btn_notes.tag = indexPath.row
                cell.btn_notes.addTarget(self, action: #selector(notes_click_method), for: .touchUpInside)
                
                cell.lblPatientName.text = (item!["PatientfullName"] as! String)+" "+(item!["PatientLastName"] as! String)
                
                cell.btnAppointmentDateTime.setTitle("Date: "+(item!["Adate"] as! String), for:.normal)
                
                cell.btnPatientAddress.setTitle(" "+(item!["PatientAddress"] as! String), for:.normal)
                cell.btnPatientAddress.titleLabel?.lineBreakMode = .byWordWrapping
                
                cell.imgPatientProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell.imgPatientProfile.sd_setImage(with: URL(string: (item!["PatientImage"] as! String)), placeholderImage: UIImage(named: "1024"))
                
                cell.imgEye.tag = indexPath.row
                let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(PPAppointmentsVC.cellTappedMethod1(_:)))

                cell.imgEye.isUserInteractionEnabled = true
                cell.imgEye.addGestureRecognizer(tapGestureRecognizer1)
                
            }  else if (person["role"] as! String) == "Pharmacy" {
                
                cell.imgEye.isHidden = false
                
                cell.btn_notes.isHidden = true
                
                cell.btn_notes.tag = indexPath.row
                cell.btn_notes.addTarget(self, action: #selector(notes_click_method), for: .touchUpInside)
                
                cell.lblPatientName.text = (item!["DoctorfullName"] as! String)
                
                cell.btnAppointmentDateTime.setTitle("Date: "+(item!["Adate"] as! String), for:.normal)
                
                cell.btnPatientAddress.setTitle(" "+(item!["DoctorAddress"] as! String), for:.normal)
                cell.btnPatientAddress.titleLabel?.lineBreakMode = .byWordWrapping
                
                cell.imgPatientProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell.imgPatientProfile.sd_setImage(with: URL(string: (item!["DoctorImage"] as! String)), placeholderImage: UIImage(named: "1024"))
                
                cell.imgEye.tag = indexPath.row
                let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(PPAppointmentsVC.cellTappedMethod1(_:)))

                cell.imgEye.isUserInteractionEnabled = true
                cell.imgEye.addGestureRecognizer(tapGestureRecognizer1)
                
            } else if (person["role"] as! String) == "Lab" {
                
                cell.imgEye.isHidden = false
                
                cell.btn_notes.isHidden = true
                
                cell.btn_notes.tag = indexPath.row
                cell.btn_notes.addTarget(self, action: #selector(notes_click_method), for: .touchUpInside)
                
                cell.lblPatientName.text = (item!["DoctorfullName"] as! String)
                
                cell.btnAppointmentDateTime.setTitle("Date: "+(item!["Adate"] as! String), for:.normal)
                
                cell.btnPatientAddress.setTitle(" "+(item!["DoctorAddress"] as! String), for:.normal)
                cell.btnPatientAddress.titleLabel?.lineBreakMode = .byWordWrapping
                
                cell.imgPatientProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell.imgPatientProfile.sd_setImage(with: URL(string: (item!["DoctorImage"] as! String)), placeholderImage: UIImage(named: "1024"))
                
                cell.imgEye.tag = indexPath.row
                let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(PPAppointmentsVC.cellTappedMethod1(_:)))

                cell.imgEye.isUserInteractionEnabled = true
                cell.imgEye.addGestureRecognizer(tapGestureRecognizer1)
                
            }  else {
                
                cell.imgEye.isHidden = false
                cell.btn_notes.isHidden = true
                
                cell.lblPatientName.text = (item!["DoctorfullName"] as! String)
                
                cell.btnAppointmentDateTime.setTitle("Date: "+(item!["Adate"] as! String), for:.normal)
                
                cell.btnPatientAddress.setTitle(" "+(item!["DoctorAddress"] as! String), for:.normal)
                cell.btnPatientAddress.titleLabel?.lineBreakMode = .byWordWrapping
                
                cell.imgPatientProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell.imgPatientProfile.sd_setImage(with: URL(string: (item!["DoctorImage"] as! String)), placeholderImage: UIImage(named: "1024"))
                
                cell.imgEye.tag = indexPath.row
                let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(PPAppointmentsVC.cellTappedMethod1(_:)))

                cell.imgEye.isUserInteractionEnabled = true
                cell.imgEye.addGestureRecognizer(tapGestureRecognizer1)
                
            }
            
        }
        
        return cell
    }
    
    @objc func notes_click_method(_ sender:UIButton) {
        
        let btn:UIButton = sender
        print(btn.tag as Any)
        
        let item = self.arrListOfAppoitmentList[btn.tag] as? [String:Any]
        
        let alert = UIAlertController(title: "Notes", message: (item!["note"] as! String), preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = self.arrListOfAppoitmentList[indexPath.row] as? [String:Any]
        print(item as Any)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            if (person["role"] as! String) == "Doctor" {
                
                let item = self.arrListOfAppoitmentList[indexPath.row] as? [String:Any]
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DPAppointmentsDetailsVC") as? DPAppointmentsDetailsVC
                push!.dictGetBookingDetailsForDoctors = item as NSDictionary?
                self.navigationController?.pushViewController(push!, animated: true)
                
            } else if (person["role"] as! String) == "Hospital" {
                
                let item = self.arrListOfAppoitmentList[indexPath.row] as? [String:Any]
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DPAppointmentsDetailsVC") as? DPAppointmentsDetailsVC
                push!.dictGetBookingDetailsForDoctors = item as NSDictionary?
                self.navigationController?.pushViewController(push!, animated: true)
                
            } else if (person["role"] as! String) == "Patient" || (person["role"] as! String) == "Pharmacy" {
                
                let alert = UIAlertController(title: String("Note"), message: (item!["note"] as! String), preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                
            }
            
        }
    }
    
    @objc func cellTappedMethod1(_ sender:AnyObject) {
        print("you tap image number: \(sender.view.tag)")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let item = self.arrListOfAppoitmentList[sender.view.tag] as? [String:Any]
            print(item as Any)
            
            if (person["role"] as! String) == "Pharmacy" {
                
                self.getPrescriptionDetails(dict_get_patient_details: item! as NSDictionary)
                
            } else if (person["role"] as! String) == "Lab" {
                
                self.get_test_lists(dict_get_patient_details: item! as NSDictionary)
                
            } else {
                
                
                
                let item = self.arrListOfAppoitmentList[sender.view.tag] as? [String:Any]
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPAppointmentDetailsVC") as? PPAppointmentDetailsVC
                push!.getPatientAppointmentDetails = item as NSDictionary?
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            
        }
        
        
        
    }
    @objc func get_test_lists(dict_get_patient_details:NSDictionary) {
        
        
        
        
        /*
         [action] => requesttest
             [userId] => 333
             [hospitalId] => 341
             [testId] => 23
             [login_id] => 350
             [appointmentId] => 40
         */
        
        
        
        print(dict_get_patient_details as Any)
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        
        self.view.endEditing(true)
        // print(self.getAppointmentId as Any)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            print(myString as Any)
            
            var hospitalIdInString:String!
            // var medicalHistoryIdInString:String!
            
            // hospital id
            if (dict_get_patient_details["hospitalId"] is String) {
                
                print("Yes, it's a String")
                
                hospitalIdInString = (dict_get_patient_details["hospitalId"] as! String)
                
            } else if dict_get_patient_details["hospitalId"] is Int {
                
                print("It is Integer")
                
                let x2 : Int = (dict_get_patient_details["hospitalId"] as! Int)
                let myString2 = String(x2)
                hospitalIdInString = String(myString2)
                
            }
            
            let x3 : Int = (dict_get_patient_details["doctorId"] as! Int)
            let myString3 = String(x3)
            
            let x4 : Int = (dict_get_patient_details["userId"] as! Int)
            let myString4 = String(x4)
            
            let x5 : Int = (dict_get_patient_details["appointmentId"] as! Int)
            let myString5 = String(x5)
            
            /*
             /*
              [action] => testlist
                  [userId] => 333
                  [doctorId] => 345
                  [appointmentId] => 40
                  [login_id] => 350
              */
             */
            /*let params = MedicalHistory(action: "prescriptiondetails",
                                                          userId: String(myString4),
                                                          doctorId: String(myString3),
                                                          hospitalId: String(myString))*/
            
            let params = lab_test_list_permission_check(action: "testlist",
                                                        userId: String(myString4),
                                                        doctorId: String(myString3),
                                                        appointmentId: String(myString5),
                                                        login_id: String(myString))
            
            
            
            print(params as Any)
            
            /*
             [action] => prescriptiondetails
                 [userId] => 333
                 [doctorId] => 323
                 [hospitalId] => 351
             
             */
            
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
                            
                            if strSuccess == String("success") {
                                print("yes")
                                
                                ERProgressHud.sharedInstance.hide()
                                
                                var ar : NSArray!
                                ar = (JSON["data"] as! Array<Any>) as NSArray
                                
                                print(ar as Any)
                                
                                
                                
                                let item = ar[0] as? [String:Any]
                                print(item as Any)
                                
                                // var dict: Dictionary<AnyHashable, Any>
                                // dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                
                                var strSuccess3 : String!
                                strSuccess3 = (item!["permission"] as! String)
                                
                                if strSuccess3 == "Decline" {
                                    
                                    let alert = NewYorkAlertController(title: "Permission", message: String("You don't have permission to access Patient's Test."), style: .alert)
                                    
                                    alert.addImage(UIImage(named: "medical_permission"))
                                    
                                    let send_permission = NewYorkButton(title: "Ask Permission", style: .default) {
                                        _ in
                                        
                                        // let x2 : Int = (dict["medicalhistoryId"] as! Int)
                                        // let myString2 = String(x2)
                                        
                                         if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                                             
                                             if (person["role"] as! String) == "Lab" {
                                                 
self.get_test_details_wb(get_prescription_details_data: item! as NSDictionary)
                                                 
                                                 /*self.pharmacy_permission_request_wb(strAction: "requestmedicalhistory",
                                                                                strUserId: String(myString),
                                                                                strHospitalId: String(hospitalIdInString),
                                                                                strMedicalHistoryId: String(myString2))*/
                                                 
                                             }
                                         
                                         
                                         }
                                        
                                    }
                                    
                                    let cancel = NewYorkButton(title: "Dismiss", style: .cancel)
                                    alert.addButtons([send_permission,cancel])
                                    
                                    self.present(alert, animated: true)
                                    
                                } else {
                                    
                                    
    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddImagesId") as? AddImages
                                     
                                    push!.arr_list_of_all_test_from_labs = ar
        push!.strShowImageDetailsFor = "test_list_from_labs"
                                     
                                     // PATIENT
    let x : Int = (item!["userId"] as! Int)
    let myString = String(x)
    push!.strSavePatientId = String(myString)
                                     
                                     // DOCTOR
    let x2 : Int = (item!["doctorId"] as! Int)
    let myString2 = String(x2)
    push!.strSaveDoctorId = String(myString2)
                                     
                                     // APPOINTMENT
    let x5 : Int = (item!["appointmentId"] as! Int)
    let myString5 = String(x5)
    push!.strSaveAppointmentId = String(myString5)
                                     
                                     // HOSPITAL
                                     if item!["hospitalId"] is String {
                                                       
                                         push!.strSaveHospitalId = String("")
                                         
                                     } else if item!["hospitalId"] is Int {
                                         
                                         let x4 : Int = (item!["hospitalId"] as! Int)
                                         let myString4 = String(x4)
                                         push!.strSaveHospitalId = String(myString4)
                                         
                                     }
                                     
                                     self.navigationController?.pushViewController(push!, animated: true)
                                     
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                   
                                    // self.strShowImageDetailsFor == "prescription_list_from_pharmacy"
                                }
                                
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
    
    @objc func getPrescriptionDetails(dict_get_patient_details:NSDictionary) {
        
        print(dict_get_patient_details as Any)
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        
        self.view.endEditing(true)
        // print(self.getAppointmentId as Any)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            print(myString as Any)
            
            var hospitalIdInString:String!
            // var medicalHistoryIdInString:String!
            
            // hospital id
            if (dict_get_patient_details["hospitalId"] is String) {
                
                print("Yes, it's a String")
                
                hospitalIdInString = (dict_get_patient_details["hospitalId"] as! String)
                
            } else if dict_get_patient_details["hospitalId"] is Int {
                
                print("It is Integer")
                
                let x2 : Int = (dict_get_patient_details["hospitalId"] as! Int)
                let myString2 = String(x2)
                hospitalIdInString = String(myString2)
                
            }
            
            let x3 : Int = (dict_get_patient_details["doctorId"] as! Int)
            let myString3 = String(x3)
            
            let x4 : Int = (dict_get_patient_details["userId"] as! Int)
            let myString4 = String(x4)
            
            let x5 : Int = (dict_get_patient_details["appointmentId"] as! Int)
            let myString5 = String(x5)
            
            let params = MedicalHistory(action: "prescriptiondetails",
                                                          userId: String(myString4),
                                                          doctorId: String(myString3),
                                                          hospitalId: String(myString))
            
            print(params as Any)
            
            /*
             [action] => prescriptiondetails
                 [userId] => 333
                 [doctorId] => 323
                 [hospitalId] => 351
             
             */
            
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
                            
                            if strSuccess == String("success") {
                                print("yes")
                                
                                ERProgressHud.sharedInstance.hide()
                                
                                var dict: Dictionary<AnyHashable, Any>
                                dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                
                                
                                
                                
                                
                                var strSuccess3 : String!
                                strSuccess3 = dict["permission"]as Any as? String
                                
                                if strSuccess3 == "Decline" {
                                    
                                    let alert = NewYorkAlertController(title: "Permission", message: String("You don't have permission to access Patient's Medical History."), style: .alert)
                                    
                                    alert.addImage(UIImage(named: "medical_permission"))
                                    
                                    let send_permission = NewYorkButton(title: "Ask Permission", style: .default) {
                                        _ in
                                        
                                        // let x2 : Int = (dict["medicalhistoryId"] as! Int)
                                        // let myString2 = String(x2)
                                        
                                         if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                                             
                                             if (person["role"] as! String) == "Pharmacy" {
                                                 
                                                 self.get_prescription_details_wb(get_prescription_details_data: dict as NSDictionary)
                                                 
                                                 /*self.pharmacy_permission_request_wb(strAction: "requestmedicalhistory",
                                                                                strUserId: String(myString),
                                                                                strHospitalId: String(hospitalIdInString),
                                                                                strMedicalHistoryId: String(myString2))*/
                                                 
                                             }
                                         
                                         
                                         }
                                        
                                    }
                                    
                                    let cancel = NewYorkButton(title: "Dismiss", style: .cancel)
                                    alert.addButtons([send_permission,cancel])
                                    
                                    self.present(alert, animated: true)
                                    
                                } else {
                                    
                                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddImagesId") as? AddImages
                                    
                                    push!.strShowImageDetailsFor = "prescription_list_from_pharmacy"
                                    push!.dict_get_pharmacy_prescription = dict as NSDictionary
                                    
                                    self.navigationController?.pushViewController(push!, animated: true)
                                   
                                    // self.strShowImageDetailsFor == "prescription_list_from_pharmacy"
                                }
                                
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
    
    @objc func get_test_details_wb(get_prescription_details_data:NSDictionary) {
        
        print(get_prescription_details_data as Any)
        
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        self.view.endEditing(true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            // let x2 : Int = (self.getPatientRegistrationDetails["userId"] as! Int)
            // let myString2 = String(x2)
            
            var hospitalIdInString:String!
            // var medicalHistoryIdInString:String!
            
            // hospital id
            if (get_prescription_details_data["hospitalId"] is String) {
                
                print("Yes, it's a String")
                
                hospitalIdInString = (get_prescription_details_data["hospitalId"] as! String)
                
            } else if get_prescription_details_data["hospitalId"] is Int {
                
                print("It is Integer")
                
                let x2 : Int = (get_prescription_details_data["hospitalId"] as! Int)
                let myString2 = String(x2)
                hospitalIdInString = String(myString2)
                
            }
            
            let x21 : Int = (get_prescription_details_data["testId"] as! Int)
            let myString21 = String(x21)
            
            let x22 : Int = (get_prescription_details_data["userId"] as! Int)
            let myString22 = String(x22)
            
            let x33 : Int = (get_prescription_details_data["appointmentId"] as! Int)
            let myString33 = String(x33)
            
            let params = lab_test_request(action: "requesttest", userId: String(myString22), hospitalId: String(hospitalIdInString), testId: String(myString21), login_id: String(myString), appointmentId: String(myString33))
            
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
                    
                     var strSuccess2 : String!
                     strSuccess2 = JSON["msg"]as Any as? String
                    
                    if strSuccess == String("success") {
                        print("yes")
                        
                        ERProgressHud.sharedInstance.hide()
                        
                        
                        let alert = NewYorkAlertController(title: "Success", message: String(strSuccess2), style: .alert)
                        
                        alert.addImage(UIImage.gif(name: "success3"))
                        
                        let cancel = NewYorkButton(title: "Ok", style: .cancel)
                        alert.addButtons([cancel])
                        
                        self.present(alert, animated: true)
                        
                        
                    } else {
                        
                        print("no")
                        ERProgressHud.sharedInstance.hide()
                        
                        var strSuccess1 : String!
                        strSuccess1 = JSON["status"]as Any as? String
                        
                        var strSuccess : String!
                        strSuccess = JSON["msg"]as Any as? String
                        
                        let alert = NewYorkAlertController(title: strSuccess1, message: String(strSuccess), style: .alert)
                        
                        alert.addImage(UIImage(named: "user_not_found"))
                        
                        let cancel = NewYorkButton(title: "Ok", style: .cancel)
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
    
    @objc func get_prescription_details_wb(get_prescription_details_data:NSDictionary) {
        
        print(get_prescription_details_data as Any)
        
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        self.view.endEditing(true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            // let x2 : Int = (self.getPatientRegistrationDetails["userId"] as! Int)
            // let myString2 = String(x2)
            
            var hospitalIdInString:String!
            // var medicalHistoryIdInString:String!
            
            // hospital id
            if (get_prescription_details_data["hospitalId"] is String) {
                
                print("Yes, it's a String")
                
                hospitalIdInString = (get_prescription_details_data["hospitalId"] as! String)
                
            } else if get_prescription_details_data["hospitalId"] is Int {
                
                print("It is Integer")
                
                let x2 : Int = (get_prescription_details_data["hospitalId"] as! Int)
                let myString2 = String(x2)
                hospitalIdInString = String(myString2)
                
            }
            
            let x21 : Int = (get_prescription_details_data["prescriptionId"] as! Int)
            let myString21 = String(x21)
            
            let x22 : Int = (get_prescription_details_data["userId"] as! Int)
            let myString22 = String(x22)
            
            let x33 : Int = (get_prescription_details_data["appointmentId"] as! Int)
            let myString33 = String(x33)
            
            let params = pharmacy_prescription_permission_to_patient(action: "requestprescription",
                                                                 userId: String(myString22),
                                                                     
                                                                     hospitalId: String(hospitalIdInString),
                                                                     
                                                                     prescriptionId: String(myString21),
                                                                     
                                                                     
                                                                     login_id: String(myString),
                                                                     
                                                                     appointmentId: String(myString33)
                                                                 )
            
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
                    
                     var strSuccess2 : String!
                     strSuccess2 = JSON["msg"]as Any as? String
                    
                    if strSuccess == String("success") {
                        print("yes")
                        
                        ERProgressHud.sharedInstance.hide()
                        
                        
                        let alert = NewYorkAlertController(title: "Success", message: String(strSuccess2), style: .alert)
                        
                        alert.addImage(UIImage.gif(name: "success3"))
                        
                        let cancel = NewYorkButton(title: "Ok", style: .cancel)
                        alert.addButtons([cancel])
                        
                        self.present(alert, animated: true)
                        
                        
                    } else {
                        
                        print("no")
                        ERProgressHud.sharedInstance.hide()
                        
                        var strSuccess1 : String!
                        strSuccess1 = JSON["status"]as Any as? String
                        
                        var strSuccess : String!
                        strSuccess = JSON["msg"]as Any as? String
                        
                        let alert = NewYorkAlertController(title: strSuccess1, message: String(strSuccess), style: .alert)
                        
                        alert.addImage(UIImage(named: "user_not_found"))
                        
                        let cancel = NewYorkButton(title: "Ok", style: .cancel)
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func pushToAllDoctorsList() {
        //
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPBookAppointmentSelectDoctorVC") as? PPBookAppointmentSelectDoctorVC
        self.navigationController?.pushViewController(push!, animated: true)
        
        
    }
    
}
