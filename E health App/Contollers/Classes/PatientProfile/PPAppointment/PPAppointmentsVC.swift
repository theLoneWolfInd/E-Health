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
    
    var str_appointment_type:String!
    var str_appointment_start_Date:String!
    var str_appointment_end_date:String!
    var str_appointment_keyword:String!
    
    var patient_id_from_apoointment_detail:String!
    var check_apoointment_status_patient_details:String!
    
    var str_lab_permission_doctor_id:String!
    var str_lab_permission_appointment_id:String!
    var str_lab_permission_login_id:String!
    
    @IBOutlet weak var viewNavigationbar:UIView!
    @IBOutlet weak var btnDashboardMenu: UIButton!
    @IBOutlet weak var lblNavationbar:UILabel!{
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
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            if (person["role"] as! String) == "Doctor" || (person["role"] as! String) == "Hospital" {
                self.btnAddPatient.isHidden = true
            } else if (person["role"] as! String) == "Patient"  {
                self.btnAddPatient.isHidden = false
            }
            
        }
        
        if self.check_apoointment_status_patient_details == "yes_appointment_from_patient_Details" {
            
            self.appointment_list_from_lab_patient_details()
            
        } else {
            
            if self.strAppointmentDateCheck == nil {
                self.appoitmentList(strDateIs: "")
            } else {
                self.appoitmentList(strDateIs: String(self.strAppointmentDateCheck))
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
    
    // Appoitment_List
    @objc func appoitmentList(strDateIs:String) {
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
            
            
            if self.str_appointment_start_Date == nil {
                self.str_appointment_start_Date = ""
            }
            
            if self.str_appointment_end_date == nil {
                self.str_appointment_end_date = ""
            }
            
            if self.str_appointment_keyword == nil {
                self.str_appointment_keyword = ""
            }
            
            /*if self.str_appointment_type == nil {
                self.str_appointment_type = "Patient"
            } else {*/
                self.str_appointment_type = (person["role"] as! String)
            // }
            
            /*
             [action] => appointmentlist
                 [userId] => 6
                 [type] => Hospital
                 [start_date] => 2022-10-19
                 [end_date] => 2022-10-19
                 [keyword] => 
             */
            let params = Patient_Appoitment_List(action: "appointmentlist",
                                                 userId: String(myString),
                                                 type: String(self.str_appointment_type),
                                                 start_date:String(self.str_appointment_start_Date),
                                                 end_date: String(self.str_appointment_end_date),
                                                 keyword: String(self.str_appointment_keyword))
            
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
                                
                                
                                if ar.count == 0 {
                                    
                                    let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("No Data Found"), style: .alert)
                                    
                                    alert.addImage(UIImage.gif(name: "gif_alert"))
                                    
                                    let cancel = NewYorkButton(title: "Ok", style: .cancel) { _ in
                                        
                                        // SPConfetti.stopAnimating()
                                        
                                         self.navigationController?.popViewController(animated: true)
                                    }
                                    alert.addButtons([cancel])
                                    
                                    self.present(alert, animated: true)
                                    
                                } else {
                                    
                                    self.arrListOfAppoitmentList.addObjects(from: ar as! [Any])
                                    self.tablView.delegate = self
                                    self.tablView.dataSource = self
                                    self.tablView.reloadData()
                                    
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
    
    
    
    
    @objc func appointment_list_from_lab_patient_details() {
        // self.arrListOfAppoitmentList.removeAllObjects()
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        self.view.endEditing(true)
        
        let params = Patient_Appoitment_List(action: "appointmentlist",
                                             userId: String(self.patient_id_from_apoointment_detail),
                                             type: String("Patient"),
                                             start_date:String(""),
                                             end_date: String(""),
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
                strSuccess = JSON["status"]as Any as? String
                
                // var strSuccess2 : String!
                // strSuccess2 = JSON["msg"]as Any as? String
                
                if strSuccess == String("success") {
                    print("yes")
                    
                    ERProgressHud.sharedInstance.hide()
                    
                    
                    var ar : NSArray!
                    ar = (JSON["data"] as! Array<Any>) as NSArray
                    
                    
                    if ar.count == 0 {
                        
                        let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("No Data Found"), style: .alert)
                        
                        alert.addImage(UIImage.gif(name: "gif_alert"))
                        
                        let cancel = NewYorkButton(title: "Ok", style: .cancel) { _ in
                            
                            // SPConfetti.stopAnimating()
                            
                            self.navigationController?.popViewController(animated: true)
                        }
                        alert.addButtons([cancel])
                        
                        self.present(alert, animated: true)
                        
                    } else {
                        
                        self.arrListOfAppoitmentList.addObjects(from: ar as! [Any])
                        self.tablView.delegate = self
                        self.tablView.dataSource = self
                        self.tablView.reloadData()
                        
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
    
    @objc func permission_test_from_lab_profile(str_user_id:String,
                                                str_doctor_id:String,
                                                str_appintment_id:String) {
        // self.arrListOfAppoitmentList.removeAllObjects()
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        self.view.endEditing(true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            let params = test_list_permission_from_lab_profile(action: "testlist",
                                                               userId: String(str_user_id),
                                                               doctorId: String(str_doctor_id),
                                                               appointmentId: String(str_appintment_id),
                                                               login_id: String(myString))
            
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
                        
                        let item = ar[0] as? [String:Any]
                        print(item as Any)
                        
                        if (item!["permission"] as! String) == "Decline" {
                            
                            let alert = NewYorkAlertController(title: "Permission", message:"You don't have permission to access the Test." , style: .alert)
                            
                            alert.addImage(UIImage(named: "medical_permission"))
                            
                            let cancel1 = NewYorkButton(title: "Request to access", style: .default) {
                                _ in
                                print("i clicked accept")
                                
                                let x_1 : Int = (item!["userId"] as! Int)
                                let myString_1 = String(x_1)
                                
                                let x_2 : Int = (item!["hospitalId"] as! Int)
                                let myString_2 = String(x_2)
                                
                                let x_3 : Int = (item!["testId"] as! Int)
                                let myString_3 = String(x_3)
                                
                                let x_4 : Int = (item!["appointmentId"] as! Int)
                                let myString_4 = String(x_4)
                                
                                self.send_test_request_to_patient_wb(str_permission_patient_id: String(myString_1),
                                                                     str_permission_hospital_id: String(myString_2),
                                                                     str_permission_test_id: String(myString_3),
                                                                     str_permission_appointment_id: String(myString_4))
                            }
                            
                            let cancel = NewYorkButton(title: "Decline", style: .cancel) {
                                _ in
                                print("i clicked decline")
                                
                                // self.change_Status_prescription_request_wb(dictGetPatientDetails: item! as NSDictionary, strStatus: "Decline")
                            }
                            
                            cancel1.setDynamicColor(.purple)
                            cancel.setDynamicColor(.red)
                            
                            alert.addButtons([cancel1,cancel])
                            
                            self.present(alert, animated: true)
                            
                        } else {
                            // accept
                            
                            print("yes, i am approved")
                            
                        }
                        
                    } else {
                        print("no")
                        ERProgressHud.sharedInstance.hide()
                        
                        var strSuccess2 : String!
                        strSuccess2 = JSON["msg"]as Any as? String
                        
                        let alert = NewYorkAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), style: .alert)
                        
                        alert.addImage(UIImage.gif(name: "gif_alert"))
                        
                        let cancel = NewYorkButton(title: "Ok", style: .cancel) { _ in
                            
                        }
                        
                        alert.addButtons([cancel])
                        
                        self.present(alert, animated: true)
                        
                        /*let alert = UIAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        
                        self.present(alert, animated: true)*/
                        
                    }
                    
                case let .failure(error):
                    print(error)
                    ERProgressHud.sharedInstance.hide()
                    
                    // Utils.showAlert(alerttitle: SERVER_ISSUE_TITLE, alertmessage: SERVER_ISSUE_MESSAGE, ButtonTitle: "Ok", viewController: self)
                }
            }
        }
        
    }
    
    /*
     [action] => requesttest
         [userId] => 395
         [hospitalId] => 347
         [testId] => 36
         [login_id] => 350
         [appointmentId] => 68
     */
    
    @objc func send_test_request_to_patient_wb(str_permission_patient_id:String,
                                               str_permission_hospital_id:String,
                                               str_permission_test_id:String,
                                               str_permission_appointment_id:String) {
        self.arrListOfAppoitmentList.removeAllObjects()
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        self.view.endEditing(true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
        let params = send_test_request_to_patient(action: "requesttest",
                                                  userId: String(str_permission_patient_id),
                                                  hospitalId: String(str_permission_hospital_id),
                                                  testId: String(str_permission_test_id),
                                                  login_id: String(myString),
                                                  appointmentId: String(str_permission_appointment_id))
        
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
                    
                    
                    var strSuccess2 : String!
                    strSuccess2 = JSON["msg"]as Any as? String
                    
                    let alert = NewYorkAlertController(title: "Success", message: String(strSuccess2), style: .alert)
                    
                    alert.addImage(UIImage.gif(name: "success3"))
                    
                    let cancel = NewYorkButton(title: "Ok", style: .cancel) { _ in
                        // self.navigationController?.popViewController(animated: true)
                    }
                    alert.addButtons([cancel])
                    
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
                cell.lbl_notes.isHidden = false
                
                cell.lblPatientName.text = (item!["PatientfullName"] as! String)
                
                cell.btnAppointmentDateTime.setTitle("Date: "+(item!["Adate"] as! String), for:.normal)
                
                cell.btnPatientAddress.setTitle(" "+(item!["PatientAddress"] as! String), for:.normal)
                cell.btnPatientAddress.titleLabel?.lineBreakMode = .byWordWrapping
                
                cell.imgPatientProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell.imgPatientProfile.sd_setImage(with: URL(string: (item!["PatientImage"] as! String)), placeholderImage: UIImage(named: "1024"))
                
                cell.btnAppointmentDateTime.tag = indexPath.row
                cell.btnAppointmentDateTime.addTarget(self, action: #selector(appointment_date_time), for: .touchUpInside)
                
                cell.imgEye.tag = indexPath.row
                let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(PPAppointmentsVC.cellTappedMethod1(_:)))

                cell.imgEye.isUserInteractionEnabled = true
                cell.imgEye.addGestureRecognizer(tapGestureRecognizer1)
                
            } else if (person["role"] as! String) == "Hospital" {
                
                cell.imgEye.isHidden = true
                cell.lbl_notes.isHidden = true
                
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
                
            }  else {
                
                cell.imgEye.isHidden = false
                cell.lbl_notes.isHidden = true
                
                cell.lblPatientName.text = (item!["DoctorfullName"] as! String)
                
                cell.btnAppointmentDateTime.setTitle("Date: "+(item!["created"] as! String), for:.normal)
                
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
                
                let actionSheet = NewYorkAlertController(title: "Notes", message: (item!["note"] as! String), style: .actionSheet)

                let titles = ["Details"]
                
                actionSheet.addButtons(
                    titles.enumerated().map { index, title -> NewYorkButton in
                        let button = NewYorkButton(title: title, style: .default) { button in
                            print("Selected \(titles[button.tag])")
                            
                            let item = self.arrListOfAppoitmentList[indexPath.row] as? [String:Any]
                            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DPAppointmentsDetailsVC") as? DPAppointmentsDetailsVC
                            push!.dictGetBookingDetailsForDoctors = item as NSDictionary?
                            self.navigationController?.pushViewController(push!, animated: true)
                            
                        }
                        button.tag = index
                        button.setDynamicColor(.orange)
                        return button
                    }
                )

                let cancel = NewYorkButton(title: "Cancel", style: .cancel)
                actionSheet.addButton(cancel)

                present(actionSheet, animated: true)
                
                
                /*let item = self.arrListOfAppoitmentList[indexPath.row] as? [String:Any]
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DPAppointmentsDetailsVC") as? DPAppointmentsDetailsVC
                push!.dictGetBookingDetailsForDoctors = item as NSDictionary?
                self.navigationController?.pushViewController(push!, animated: true)*/
                
            } else if (person["role"] as! String) == "Patient" {
                
                /*let alert = UIAlertController(title: String("Note"), message: String("Are you sure your want to logout ?"), preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                
                self.present(alert, animated: true, completion: nil)*/
                
            }
            
        }
    }
    
    @objc func appointment_date_time(_ sender:UIButton) {
        
        let item = self.arrListOfAppoitmentList[sender.tag] as? [String:Any]
        
        let alert = UIAlertController(title: String("Note"), message: (item!["note"] as! String), preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func cellTappedMethod1(_ sender:AnyObject) {
        
        print("you tap image number: \(sender.view.tag)")
        
        print(self.arrListOfAppoitmentList as Any)
        
        let item = self.arrListOfAppoitmentList[sender.view.tag] as? [String:Any]
        print(item as Any)
        
        if self.check_apoointment_status_patient_details == "yes_appointment_from_patient_Details" {

            let x : Int = (item!["userId"] as! Int)
            let myString = String(x)
            
            let x_2 : Int = (item!["doctorId"] as! Int)
            let myString_2 = String(x_2)
            
            let x_3 : Int = (item!["appointmentId"] as! Int)
            let myString_3 = String(x_3)
            
            self.permission_test_from_lab_profile(str_user_id: String(myString),
                                                  str_doctor_id: String(myString_2),
                                                  str_appintment_id: String(myString_3))
            
        } else {
            
            let item = self.arrListOfAppoitmentList[sender.view.tag] as? [String:Any]
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPAppointmentDetailsVC") as? PPAppointmentDetailsVC
            push!.getPatientAppointmentDetails = item as NSDictionary?
            self.navigationController?.pushViewController(push!, animated: true)
            
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
