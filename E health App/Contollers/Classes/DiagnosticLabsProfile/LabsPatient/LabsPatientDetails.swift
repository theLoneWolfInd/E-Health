//
//  LabsPatientDetails.swift
//  E health App
//
//  Created by apple on 18/10/21.
//

import UIKit
import Alamofire
import SDWebImage

class LabsPatientDetails: UIViewController , UITableViewDataSource , UITableViewDelegate  {
    
    var saveAllPrescriptionData : NSMutableArray! = []
    
    var dictSupplierLoginData:NSDictionary!
    
    @IBOutlet weak var viewNavigationBar:UIView!
    @IBOutlet weak var btnDashboardMenu:UIButton! {
        didSet {
            btnDashboardMenu.setImage(UIImage(systemName: "arrow.left"), for: .normal)
            btnDashboardMenu.addTarget(self, action: #selector(backClickMethods), for: .touchUpInside)
        }
    }
    @IBOutlet weak var lblNavigationBar:UILabel!{
        didSet {
            lblNavigationBar.text = "PATIENT DETAILS"
        }
    }

    @IBOutlet weak var tablView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        tablView.dataSource = self
        tablView.delegate = self
        tablView.backgroundColor = .white
        self.tablView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        
        // self.sideBarMenuClick()
        
        // print(self.dictSupplierLoginData as Any)
        
         
        
        
         
        
    }

    @objc func backClickMethods() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func yesLogout() {
        
        UserDefaults.standard.set("", forKey: "keyLoginFullData")
        UserDefaults.standard.set(nil, forKey: "keyLoginFullData")
        
        UserDefaults.standard.set("", forKey: "keySetToBackOrMenu")
        UserDefaults.standard.set(nil, forKey: "keySetToBackOrMenu")
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "registerVC") as? registerVC
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        if indexPath.row == 0 {
            
            let cell:LabsPatientDetailsTableCell = tablView.dequeueReusableCell(withIdentifier: "cell1") as! LabsPatientDetailsTableCell
            
            cell.backgroundColor = .white
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            print(self.dictSupplierLoginData as Any)
            
            for n in 1...5 {
                print(n, terminator: "")
            }
            
            cell.btnAddress.setTitle(" "+(self.dictSupplierLoginData["address"] as! String), for: .normal)
            cell.btnAddress.titleLabel?.lineBreakMode = .byWordWrapping
            
            cell.lblLabName.text = (self.dictSupplierLoginData["fullName"] as! String)
            
            cell.lblPhone.text = (self.dictSupplierLoginData["contactNumber"] as! String)
            cell.lblEmail.text = (self.dictSupplierLoginData["email"] as! String)
            
            cell.imgBanner.image = UIImage(named: "background")
            cell.imgProfile.image = UIImage(named: "daze")

            cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.imgProfile.sd_setImage(with: URL(string: (self.dictSupplierLoginData["image"] as! String)), placeholderImage: UIImage(named: "1024"))
            
            return cell
        }
        
        else if indexPath.row == 1 {
            
            let cell:LabsPatientDetailsTableCell = tablView.dequeueReusableCell(withIdentifier: "cell2") as! LabsPatientDetailsTableCell
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.backgroundColor = .white
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.lblSpecialist.text = (self.dictSupplierLoginData["description"] as! String)
            
            return cell
        }
        else if indexPath.row == 2 {
            
            let cell:LabsPatientDetailsTableCell = tablView.dequeueReusableCell(withIdentifier: "cell3") as! LabsPatientDetailsTableCell
            cell.backgroundColor = .white
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
             
                if (person["role"] as! String) == "Lab" {
                    cell.lbl_heading.text = "Name"
                } else {
                    cell.lbl_heading.text = "Hospital / Clinic"
                }
            }
            
            cell.lblHospitalName.text = (self.dictSupplierLoginData["fullName"] as! String)
            
            return cell
        }
        else if indexPath.row == 3 {
            
            let cell:LabsPatientDetailsTableCell = tablView.dequeueReusableCell(withIdentifier: "cell4") as! LabsPatientDetailsTableCell
            
            cell.backgroundColor = .white
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.lblLocation.text = (self.dictSupplierLoginData["address"] as! String)
            
            return cell
        }
        
        else {
            
            let cell:LabsPatientDetailsTableCell = tablView.dequeueReusableCell(withIdentifier: "cell5") as! LabsPatientDetailsTableCell
            cell.backgroundColor = .white
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView

            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
                
                if (person["role"] as! String) == "Pharmacy" {
                    
                    cell.btnRqstSupplier.setTitle("View Prescription", for: .normal)
                    cell.btnAllPatient.addTarget(self, action: #selector(get_medical_history_data_for_permission), for: .touchUpInside)
                    cell.btnRqstSupplier.addTarget(self, action: #selector(prescription_list_wb), for: .touchUpInside)
                    
                } else {
                    
                    cell.btnRqstSupplier.setTitle("View Test", for: .normal)
                    cell.btnAllPatient.addTarget(self, action: #selector(getMedicalHistoryPermission), for: .touchUpInside)
                    cell.btnRqstSupplier.addTarget(self, action: #selector(test_list_wb), for: .touchUpInside)
                    
                }
                
            }
            
            //
            
            return cell
        }
    }
    // self.strImageStatus == "" {
        
    @objc func viewAllTestClickMethod() {
        
        let x : Int = (self.dictSupplierLoginData!["userId"] as! Int)
        let myString = String(x)
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ShowImageId") as? ShowImage
        
        push!.imgGetMedicalHistory = (self.dictSupplierLoginData["image"] as! String)
        push!.strImageStatus = "test_list_from_labs"
        push!.strPatientId = String(myString)
        
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func test_list_wb() {
        
        
         print(self.dictSupplierLoginData as Any)
        
        let x : Int = (self.dictSupplierLoginData!["userId"] as! Int)
        let myString = String(x)
        
        /*if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x_4 : Int = (person["userId"] as! Int)
            let myString_4 = String(x_4)
            
            let x : Int = (self.dictSupplierLoginData!["userId"] as! Int)
            let myString = String(x)
            
            let x_2 : Int = (self.dictSupplierLoginData!["doctorId"] as! Int)
            let myString_2 = String(x_2)
            
            let x_3 : Int = (self.dictSupplierLoginData!["appointmentId"] as! Int)
            let myString_3 = String(x_3)
            */
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPAppointmentsVC") as? PPAppointmentsVC
            
            push!.check_apoointment_status_patient_details = "yes_appointment_from_patient_Details"
            push!.patient_id_from_apoointment_detail = String(myString)
            // push!.str_lab_permission_doctor_id = String(myString_2)
            // push!.str_lab_permission_appointment_id = String(myString_3)
            // push!.str_lab_permission_login_id = String(myString_4)
            
            self.navigationController?.pushViewController(push!, animated: true)
        // }
        
        /*let x : Int = (self.dictSupplierLoginData!["userId"] as! Int)
         let myString = String(x)
         
         ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
         
         self.view.endEditing(true)
         
         let params = show_only_test_list(action: "testlist",
         userId: String(myString))
         
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
         
         // self.imgView.isHidden = false
         
         var ar : NSArray!
         ar = (JSON["data"] as! Array<Any>) as NSArray
         // self.arrListOfAllHistory.addObjects(from: ar as! [Any])
         
         let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddImagesId") as? AddImages
         
         // push!.imgGetMedicalHistory = (self.dictSupplierLoginData["image"] as! String)
         push!.strShowImageDetailsFor = "test_list_from_labs"
         push!.arr_list_of_all_test_from_labs = ar!
         
         self.navigationController?.pushViewController(push!, animated: true)
         
         } else {
         print("no")
         ERProgressHud.sharedInstance.hide()
         
         var strSuccess2 : String!
         strSuccess2 = JSON["msg"]as Any as? String
         
         let alert = NewYorkAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), style: .alert)
         
         alert.addImage(UIImage.gif(name: "gif_alert"))
         
         let cancel = NewYorkButton(title: "Ok", style: .cancel) { _ in
         
         // SPConfetti.stopAnimating()
         
         // self.navigationController?.popViewController(animated: true)
         }
         alert.addButtons([cancel])
         
         self.present(alert, animated: true)
         
         /*let alert = UIAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), preferredStyle: .alert)
          
          alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
          action in
          // self.navigationController?.popViewController(animated: true)
          }))
          
          self.present(alert, animated: true)*/
         
         }
         
         case let .failure(error):
         print(error)
         ERProgressHud.sharedInstance.hide()
         
         // Utils.showAlert(alerttitle: SERVER_ISSUE_TITLE, alertmessage: SERVER_ISSUE_MESSAGE, ButtonTitle: "Ok", viewController: self)
         }
         }*/
        
        
    }
    
    @objc func prescription_list_wb() {
        
        let x : Int = (self.dictSupplierLoginData!["userId"] as! Int)
        let myString = String(x)
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        self.view.endEditing(true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x2 : Int = (person["userId"] as! Int)
            let myString2 = String(x2)
            
            let params = show_only_prescription_list(action: "prescriptionlist",
                                                     userId: String(myString),
                                                     login_id:String(myString2))
            
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
                        
                        // self.imgView.isHidden = false
                        
                        self.saveAllPrescriptionData.removeAllObjects()
                        
                         var ar : NSArray!
                         ar = (JSON["data"] as! Array<Any>) as NSArray
                         self.saveAllPrescriptionData.addObjects(from: ar as! [Any])
                        
                        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PharmacyPatientsPrescriptionsListId") as? PharmacyPatientsPrescriptionsList
                        
                        push!.arrListOfPrescription = self.saveAllPrescriptionData
                        
                        self.navigationController?.pushViewController(push!, animated: true)
                        
                        
                    } else {
                        print("no")
                        ERProgressHud.sharedInstance.hide()
                        
                        var strSuccess2 : String!
                        strSuccess2 = JSON["msg"]as Any as? String
                        
                        let alert = UIAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
                            action in
                            // self.navigationController?.popViewController(animated: true)
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
    
    @objc func allPatientsClickMethod() {
        
        // self.lab_permission_request_wb()
        
        // let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HPDoctorsVC") as? HPDoctorsVC
        // push!.strMyProfileIs = "FromLabToAllPatients"
        // self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            
            return 310
            
        } else if indexPath.row == 1 {
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
             
                if (person["role"] as! String) == "Lab" {
                    return 0 // UITableView.automaticDimension
                } else {
                    return UITableView.automaticDimension
                }
            } else {
                return 0
            }
            
            
        } else if indexPath.row == 2 {
            
            if (self.dictSupplierLoginData["fullName"] as! String) == "" {
                return 0
            } else {
                return UITableView.automaticDimension
            }
            
        }
        else if indexPath.row == 3 {
            
            return UITableView.automaticDimension
            
        }
        else {
            
            return 140
            
        }
    }
    
    @objc func get_medical_history_data_for_permission() {
        // self.arrListOfAppoitmentList.removeAllObjects()
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MedicalHistoryVC") as? MedicalHistoryVC
        
        push!.str_edit_patient = "no_edit"
        push!.getPatientRegistrationDetails = self.dictSupplierLoginData
        
        self.navigationController?.pushViewController(push!, animated: true)
        
        /*ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        print(self.dictSupplierLoginData as Any)
        
        self.view.endEditing(true)
        
        // if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
        let x : Int = (self.dictSupplierLoginData!["userId"] as! Int)
        let myString = String(x)
        
        // let x2 : Int = (self.getPatientRegistrationDetails["userId"] as! Int)
        // let myString2 = String(x2)
        
        var hospitalIdInString:String!
        // var medicalHistoryIdInString:String!
        
        // hospital id
        if (self.dictSupplierLoginData["hospitalId"] is String) {
            
            print("Yes, it's a String")
            
            hospitalIdInString = (self.dictSupplierLoginData!["hospitalId"] as! String)
            
        } else if self.dictSupplierLoginData!["hospitalId"] is Int {
            
            print("It is Integer")
            
            let x2 : Int = (self.dictSupplierLoginData!["hospitalId"] as! Int)
            let myString2 = String(x2)
            hospitalIdInString = String(myString2)
            
        }
        
        let params = medical_history_for_pharmacy(action: "medicalhistory",
                                                  userId: String(myString),
                                                  doctorId: "",
                                                  hospitalId: String(hospitalIdInString),
                                                  type:"Pharmacy")
        
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
                    
                    var dict: Dictionary<AnyHashable, Any>
                    dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                    // print(dict as Any)
                    
                    var strSuccess3 : String!
                    strSuccess3 = dict["permission"]as Any as? String
                    
                    if strSuccess3 == "Decline" {
                        
                        let alert = NewYorkAlertController(title: "Permission", message: String("You don't have permission to access Patient's Medical History."), style: .alert)
                        
                        alert.addImage(UIImage(named: "medical_permission"))
                        
                        let send_permission = NewYorkButton(title: "Ask Permission", style: .default) {
                            _ in
                            
                            let x2 : Int = (dict["medicalhistoryId"] as! Int)
                            let myString2 = String(x2)
                            
                            self.lab_permission_request_wb(strAction: "requestmedicalhistory",
                                                           strUserId: String(myString),
                                                           strHospitalId: String(hospitalIdInString),
                                                           strMedicalHistoryId: String(myString2),
                                                           dictGetMedicalHistoryDetails:dict as NSDictionary)
                            
                        }
                        
                        let cancel = NewYorkButton(title: "Dismiss", style: .cancel)
                        alert.addButtons([send_permission,cancel])
                        
                        self.present(alert, animated: true)
                        
                    } else {
                        
                        // push to medical history page
                        
                        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PatientMedicalHistoryDetailsVC") as? PatientMedicalHistoryDetailsVC
                        push!.getPatientMedicalHistoryDetails = dict as NSDictionary
                        self.navigationController?.pushViewController(push!, animated: true)
                        
                    }
                    
                } else {
                    
                    print("no")
                    ERProgressHud.sharedInstance.hide()
                    
                    var strSuccess1 : String!
                    strSuccess1 = JSON["status"]as Any as? String
                    
                    var strSuccess : String!
                    strSuccess = JSON["msg"]as Any as? String
                    
                    let alert = NewYorkAlertController(title: strSuccess1, message: String(strSuccess), style: .alert)
                    
                    alert.addImage(UIImage(named: "medical_history"))
                    
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
        
        // }*/
    }
    
    @objc func getMedicalHistoryPermission() {
        
        // PPAppointmentsVC
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MedicalHistoryVC") as? MedicalHistoryVC
        
        push!.str_edit_patient = "no_edit"
        push!.getPatientRegistrationDetails = self.dictSupplierLoginData
        
        self.navigationController?.pushViewController(push!, animated: true)
        
        
        
        /*// self.arrListOfAppoitmentList.removeAllObjects()
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        print(self.dictSupplierLoginData as Any)
        
        self.view.endEditing(true)
        
        // if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
        let x : Int = (self.dictSupplierLoginData!["userId"] as! Int)
        let myString = String(x)
        
        // let x2 : Int = (self.getPatientRegistrationDetails["userId"] as! Int)
        // let myString2 = String(x2)
        
        var hospitalIdInString:String!
        // var medicalHistoryIdInString:String!
        
        // hospital id
        if (self.dictSupplierLoginData["hospitalId"] is String) {
            
            print("Yes, it's a String")
            
            hospitalIdInString = (self.dictSupplierLoginData!["hospitalId"] as! String)
            
        } else if self.dictSupplierLoginData!["hospitalId"] is Int {
            
            print("It is Integer")
            
            let x2 : Int = (self.dictSupplierLoginData!["hospitalId"] as! Int)
            let myString2 = String(x2)
            hospitalIdInString = String(myString2)
            
        }
        
        let params = MedicalHistory(action: "medicalhistory",
                                    userId: String(myString),
                                    doctorId: "",
                                    hospitalId: String(hospitalIdInString))
        
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
                    
                    var dict: Dictionary<AnyHashable, Any>
                    dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                    // print(dict as Any)
                    
                     var strSuccess3 : String!
                     strSuccess3 = dict["permission"]as Any as? String
                    
                    if strSuccess3 == "Decline" {
                        
                        let alert = NewYorkAlertController(title: "Permission", message: String("You don't have permission to access Patient's Medical History."), style: .alert)
                        
                        alert.addImage(UIImage(named: "medical_permission"))
                        
                        let send_permission = NewYorkButton(title: "Ask Permission", style: .default) {
                            _ in
                            
                            let x2 : Int = (dict["medicalhistoryId"] as! Int)
                            let myString2 = String(x2)
                            
                            self.lab_permission_request_wb(strAction: "requestmedicalhistory",
                                                           strUserId: String(myString),
                                                           strHospitalId: String(hospitalIdInString),
                                                           strMedicalHistoryId: String(myString2),
                                                           dictGetMedicalHistoryDetails:dict as NSDictionary)
                            
                        }
                        
                        let cancel = NewYorkButton(title: "Dismiss", style: .cancel)
                        alert.addButtons([send_permission,cancel])
                        
                        self.present(alert, animated: true)
                        
                    } else {
                        
                        // push to medical history page
                        
                        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PatientMedicalHistoryDetailsVC") as? PatientMedicalHistoryDetailsVC
                        push!.getPatientMedicalHistoryDetails = dict as NSDictionary
                        self.navigationController?.pushViewController(push!, animated: true)
                        
                     }
                    
                } else {
                    
                    print("no")
                    ERProgressHud.sharedInstance.hide()
                    
                    var strSuccess1 : String!
                    strSuccess1 = JSON["status"]as Any as? String
                    
                    var strSuccess : String!
                    strSuccess = JSON["msg"]as Any as? String
                    
                    let alert = NewYorkAlertController(title: strSuccess1, message: String(strSuccess), style: .alert)
                    
                    alert.addImage(UIImage(named: "medical_history"))
                    
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
        
        // }*/
    }
    
    @objc func lab_permission_request_wb(strAction:String,
                                         strUserId:String,
                                         strHospitalId:String,
                                         strMedicalHistoryId:String,
                                         dictGetMedicalHistoryDetails:NSDictionary) {
        
        self.view.endEditing(true)
         ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // let str:String = person["role"] as! String
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
        //  print(self.dictSupplierLoginData as Any)
        let params =  lab_request_medical_history_permission(action: String(strAction),
                                                             login_id:String(myString),
                                                             userId: String(strUserId),
                                                             hospitalId: String(strHospitalId),
                                                             medicalHistoryId: String(strMedicalHistoryId))
        
        
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
                
                var strSuccess2 : String!
                strSuccess2 = JSON["msg"]as Any as? String
                
                if strSuccess == String("success") {
                    print("yes")
                    
                    ERProgressHud.sharedInstance.hide()
                    
                    var dict: Dictionary<AnyHashable, Any>
                    dict = JSON["data"] as! Dictionary<AnyHashable, Any>

                    print(dictGetMedicalHistoryDetails as Any) // medical history
                    
                    print(dict as Any) // patient personal details
                    
                    
                    
                    
                    let alert = NewYorkAlertController(title: "Success", message: String(strSuccess2), style: .alert)
                    
                    alert.addImage(UIImage.gif(name: "success3"))
                    
                    let cancel = NewYorkButton(title: "Ok", style: .cancel)
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
