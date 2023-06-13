//
//  MedicalHistoryVC.swift
//  E health App
//
//  Created by Ranjan on 26/08/21.
//

import UIKit
import Alamofire
import SDWebImage

class MedicalHistoryVC: UIViewController , UIScrollViewDelegate {
    
    var str_i_am_from_panic_page:String!
    
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    var getPatientRegistrationDetails:NSDictionary!
    
    var saveMedicalImage:String!
    var saveMedicalPatientDetails:NSDictionary!
    
    var arrSaveImageForScroll:NSMutableArray = []
    
    // medical history id
    var strStoreMedicalHistoryId:String!
    
    var dictSavePatientDetails:NSDictionary!
    
    var strMedicalHistoryFound:String! = "no"
    
    var strIamFromBookedAppointment:String!
    @IBOutlet weak var viewNavigationBar:UIView!
    @IBOutlet weak var btnNaviagtionBack:UIButton! {
        didSet {
            
        }
    }
    @IBOutlet weak var lblNavigationBar:UILabel!{
        didSet {
            
            lblNavigationBar.text = "ADD MEDICAL HISTORY"
        }
    }
    
    @IBOutlet weak var tablViw:UITableView!

    
    var strCheckBoxMedication:String! = "n.a."
    var strCheckBoxAllergies:String! = "n.a."
    var strCheckBoxDrugs:String! = "n.a."
    
    var isMedicalHistoryCreated:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        tablViw.backgroundColor = .white
        
        tablViw.delegate = self
        tablViw.dataSource = self
        
        btnNaviagtionBack.addTarget(self, action: #selector(btnNavigationBackPress), for: .touchUpInside)
        
        print(self.getPatientRegistrationDetails as Any)
        
        
        
        if let myLoadedString = UserDefaults.standard.string(forKey: "keySetToBackOrMenu") {
            print(myLoadedString)
            
            if myLoadedString == "backOrMenu" {
                // menu
                self.btnNaviagtionBack.setImage(UIImage(systemName: "list.dash"), for: .normal)
                self.sideBarMenuClick()
            } else {
                // back
                self.btnNaviagtionBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
            }
        } else {
            // back
            self.btnNaviagtionBack.setImage(UIImage(systemName: "arrow.left"), for: .normal)
            self.btnNaviagtionBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
        
        
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            if (person["role"] as! String) == "Patient" {
                
                btnNaviagtionBack.isHidden = false
                lblNavigationBar.text = "MEDICAL HISTORY"
                self.medicalHistoryWB()
                
            } else if (person["role"] as! String) == "Hospital" || (person["role"] as! String) == "Lab" {
                
                if self.str_i_am_from_panic_page == nil {
                
                    btnNaviagtionBack.isHidden = false
                    self.checkPatientMedicalHistoryFromHispitalSide()
                    
                } else {
                    
                    self.medical_history_via_panic_wb()
                    
                }
                
                
            }
            else if (person["role"] as! String) == "Pharmacy" {
                self.medical_history_for_pharmacy_wb()
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
            
            btnNaviagtionBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    @objc func btnNavigationBackPress() {
        // self.navigationController?.popViewController(animated: true)
    }
    
    @objc func validateBeforeAddMedicalHistory() {
        
        /*let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablViw.cellForRow(at: indexPath) as! MedicalHistoryTableViewCell
        
        if cell.txtDiseasename.text == "" {
            
            self.fieldShoulNotBeEmptyPopup(strTitle: "Disease name if any")
            
        } else if cell.txtGender.text == "" {
            
            self.fieldShoulNotBeEmptyPopup(strTitle: "What is your gender")
            
        } else if cell.txtAboutMedication.text == "" {
            
            self.fieldShoulNotBeEmptyPopup(strTitle: "About Medication")
            
        } else if cell.txtAboutMedicationAllergies.text == "" {
            
            self.fieldShoulNotBeEmptyPopup(strTitle: "About Medication Allergies")
            
        } else if cell.txtAboutHistoryDrug.text == "" {
            
            self.fieldShoulNotBeEmptyPopup(strTitle: "Any Drugs")
            
        } else {
            
            self.addPatientMedicalHistory()
            
        }*/
        
        if self.isMedicalHistoryCreated == "1" {
            self.editMedicalHistoryWB()
        } else {
            self.addPatientMedicalHistory()
        }
        
        
    }
    
    @objc func fieldShoulNotBeEmptyPopup(strTitle:String) {
        
        let alert = UIAlertController(title: "Alert", message: String(strTitle)+" Field should not be empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true)
        
    }
    
    @objc func addPatientMedicalHistory() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablViw.cellForRow(at: indexPath) as! MedicalHistoryTableViewCell
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "adding...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            // patient id
            
            let x2 : Int = getPatientRegistrationDetails["userId"] as! Int
            let myString2 = String(x2)
            
            
            /*
              var strCheckBoxMedication:String!
              var strCheckBoxAllergies:String!
              var strCheckBoxDrugs:String!
             */
            
            let params =  AddDPatientMedicalHistoryWithoutImage(action: "addmedicalhistory",
                                                                userId: String(myString2),
                                                                hospitalId: String(myString),
                                                                disease: String(cell.txtDiseasename.text!),
                                                                gender: String(cell.txtGender.text!),
                                                                medicine: String(cell.txtAboutMedication.text!),
                                                                allergies: String(cell.txtAboutMedicationAllergies.text!),
                                                                using_alcohol: String(cell.txtAboutHistoryDrug.text!),
                                                                use_medicine: String(self.strCheckBoxMedication),
                                                                have_allergies: String(self.strCheckBoxAllergies),
                                                                alcohol: String(self.strCheckBoxDrugs))
            
            
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
                                    
                                    /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HPDoctorsVC") as? HPDoctorsVC
                                    push!.strMyProfileIs = "FromHospitalProfileToPatient"
                                    self.navigationController?.pushViewController(push!, animated: true)*/
                                    
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
        }
    }
    
    @objc func editMedicalHistoryWB() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablViw.cellForRow(at: indexPath) as! MedicalHistoryTableViewCell
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "updating...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            // patient id
            
            let x2 : Int = getPatientRegistrationDetails["userId"] as! Int
            let myString2 = String(x2)
            
            let params =  editPatientMedicalHistoryWithoutImage(action: "editmedicalhistory",
                                                                userId: String(myString2), // patient id
                                                                medicalHistoryId: String(self.strStoreMedicalHistoryId),
                                                                hospitalId: String(myString), // hospital id
                                                                disease: String(cell.txtDiseasename.text!),
                                                                gender: String(cell.txtGender.text!),
                                                                medicine: String(cell.txtAboutMedication.text!),
                                                                allergies: String(cell.txtAboutMedicationAllergies.text!),
                                                                using_alcohol: String(cell.txtAboutHistoryDrug.text!),
                                                                use_medicine: String(self.strCheckBoxMedication),
                                                                have_allergies: String(self.strCheckBoxAllergies),
                                                                alcohol: String(self.strCheckBoxDrugs))
            
            
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
                            
                            if self.strIamFromBookedAppointment == "yes" {
                                
                            } else {
                                
                                // let myString = "backOrMenu"
                                // UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                                
                                for controller in self.navigationController!.viewControllers as Array {
                                if controller.isKind(of: HPDoctorsVC.self) {
                                    self.navigationController!.popToViewController(controller, animated: true)
                                        break
                                    }
                                }
                                
                                /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HPDoctorsVC") as? HPDoctorsVC
                                push!.strMyProfileIs = "FromHospitalProfileToPatient"
                                self.navigationController?.pushViewController(push!, animated: true)*/
                                
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
        }
    }
    
    @objc func medical_history_for_pharmacy_wb() {
        // self.arrListOfAppoitmentList.removeAllObjects()
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        
        self.view.endEditing(true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            let x2 : Int = (self.getPatientRegistrationDetails["userId"] as! Int)
            let myString2 = String(x2)
            
            /*
             New_Hospital_Medical_History
             
             action: "medicalhistory",
             userId: String(myString2),
             doctorId: "",
             hospitalId: String(myString),
             login_id: String(myString),
             type: (person["role"] as! String)
             
             */
            
            let params = New_Hospital_Medical_History(action: "medicalhistory",
                                                      userId: String(myString2),
                                                      doctorId: "",
                                                      hospitalId: String(myString),
                                                      login_id:String(myString),
                                                      type: String("Pharmacy"))
            
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
                        print(dict as Any)
                        
                        //  dict = self.dictSavePatientDetails
                        self.dictSavePatientDetails = dict as NSDictionary
                        self.isMedicalHistoryCreated = "1"
                        self.fetchMedicalHistory(getDictValue: dict as NSDictionary)
                        
                        
                    } else {
                        
                        print("no")
                        ERProgressHud.sharedInstance.hide()
                        self.isMedicalHistoryCreated = "2"
                        
                        /*var strSuccess2 : String!
                         strSuccess2 = JSON["msg"]as Any as? String
                         
                         let alert = UIAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), preferredStyle: .alert)
                         
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
    
    @objc func checkPatientMedicalHistoryFromHispitalSide() {
        // self.arrListOfAppoitmentList.removeAllObjects()
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        
        self.view.endEditing(true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            let x2 : Int = (self.getPatientRegistrationDetails["userId"] as! Int)
            let myString2 = String(x2)
            
            /*
             [action] => medicalhistory
             [userId] => 362
             [doctorId] =>
             [hospitalId] => 324
             [login_id] => 324
             [type] => Hospital
             */
            
            /*
             New_Hospital_Medical_History
             */
            
            /*let params = MedicalHistory(action: "medicalhistory",
             userId: String(myString2),
             doctorId: "",
             hospitalId: String(myString))*/
            
            let params = New_Hospital_Medical_History(action: "medicalhistory",
                                                      userId: String(myString2),
                                                      doctorId: "",
                                                      hospitalId: String(myString),
                                                      login_id: String(myString),
                                                      type: (person["role"] as! String))
            
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
                        print(dict as Any)
                        
                        //  dict = self.dictSavePatientDetails
                        self.dictSavePatientDetails = dict as NSDictionary
                        self.isMedicalHistoryCreated = "1"
                        self.fetchMedicalHistory(getDictValue: dict as NSDictionary)
                        
                        
                    } else {
                        
                        print("no")
                        ERProgressHud.sharedInstance.hide()
                        self.isMedicalHistoryCreated = "2"
                        
                        /*var strSuccess2 : String!
                         strSuccess2 = JSON["msg"]as Any as? String
                         
                         let alert = UIAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), preferredStyle: .alert)
                         
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
    
    @objc func medical_history_via_panic_wb() {
        
        /*
         [action] => medicalhistory
             [userId] => 342
             [doctorId] =>
             [hospitalId] => 341
             [login_id] => 341
             [type] => Hospital
         */
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        self.view.endEditing(true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            print(person as Any)
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            // print(self.getPatientRegistrationDetails as Any)
            
            /*let x2 : Int = (self.getPatientRegistrationDetails["userId"] as! Int)
            let myString2 = String(x2)
            
            let x3 : Int = (self.getPatientRegistrationDetails["hospitalId"] as! Int)
            let myString3 = String(x3)*/
            
            let params = New_Hospital_Medical_History(action: "medicalhistory",
                                                      userId: (self.getPatientRegistrationDetails["userId"] as! String),
                                                      doctorId: "",
                                                      hospitalId: (self.getPatientRegistrationDetails["hospitalId"] as! String),
                                                      login_id: String(myString),
                                                      type: (person["role"] as! String))
            
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
                        print(dict as Any)
                        
                        //  dict = self.dictSavePatientDetails
                        self.dictSavePatientDetails = dict as NSDictionary
                        self.isMedicalHistoryCreated = "1"
                        self.fetchMedicalHistory(getDictValue: dict as NSDictionary)
                        
                        
                    } else {
                        
                        print("no")
                        ERProgressHud.sharedInstance.hide()
                        self.isMedicalHistoryCreated = "2"
                        
                        /*var strSuccess2 : String!
                         strSuccess2 = JSON["msg"]as Any as? String
                         
                         let alert = UIAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), preferredStyle: .alert)
                         
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
    
    @objc func medicalHistoryWB() {
        // self.arrListOfAppoitmentList.removeAllObjects()
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        
        self.view.endEditing(true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            /*
             New_Hospital_Medical_History(action: "medicalhistory",
                                                       userId: String(myString2),
                                                       doctorId: "",
                                                       hospitalId: String(myString),
                                                       login_id: String(myString),
                                                       type: (person["role"] as! String))
             */
            
            let params = New_Hospital_Medical_History(action: "medicalhistory",
                                                      userId: String(myString),
                                                      doctorId: "",
                                                      hospitalId: "",
                                                      login_id: String(myString),
                                                      type: (person["role"] as! String))
            
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
                                
                                
                                self.fetchMedicalHistory(getDictValue: dict as NSDictionary)
                                 
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
    
    
    @objc func fetchMedicalHistory(getDictValue:NSDictionary) {
        
        // print(getDictValue as Any)
        
        /*
         DoctorAddress = "";
         DoctorEmail = "";
         DoctorLastName = "";
         DoctorNumber = "";
         DoctorfullName = "";
         HospitalAddress = "9/1, Block C, Yojna Vihar, Anand Vihar, Ghaziabad, Uttar Pradesh 110092, India";
         HospitalLastName = "";
         HospitalfullName = "New West one";
         PatientAddress = "110062, India";
         PatientEmail = "lee@mailinator.com";
         PatientImage = "";
         PatientLastName = msff;
         PatientNumber = 9835353456;
         PatientfullName = "lee n";
         alcohol = "";
         allergies = "testf dgj";
         created = "2021-09-15 19:31:00";
         disease = bgdfh;
         doctorId = "";
         gender = Female;
         "have_allergies" = "";
         hospitalId = 140;
         "medical_history_image" = "";
         medicalhistoryId = 19;
         medicine = yffgfth;
         permission = Accept;
         "use_medicine" = "";
         userId = 148;
         "using_alcohol" = Yes;
         */
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            if person["role"] as! String == "Hospital" || (person["role"] as! String) == "Lab" || (person["role"] as! String) == "Pharmacy" {
                
                if self.str_i_am_from_panic_page == nil {
                    
                    let x1234 : Int = getDictValue["medicalhistoryId"] as! Int
                    let myString1234 = String(x1234)
                    
                    self.strStoreMedicalHistoryId = String(myString1234)
                    
                    let indexPath = IndexPath.init(row: 0, section: 0)
                    let cell = self.tablViw.cellForRow(at: indexPath) as! MedicalHistoryTableViewCell
                    
                    cell.txtDiseasename.text    = (getDictValue["disease"] as! String)
                    cell.txtGender.text         = (getDictValue["gender"] as! String)
                    
                    cell.txtAboutMedication.text    = (getDictValue["medicine"] as! String)
                    
                    cell.txtAboutMedicationAllergies.text   = (getDictValue["allergies"] as! String)
                    
                    cell.txtAboutHistoryDrug.text   = (getDictValue["using_alcohol"] as! String)
                    
                    
                    
                    cell.txtDiseasename.isUserInteractionEnabled = true
                    cell.txtGender.isUserInteractionEnabled = true
                    
                    cell.txtAboutMedicationAllergies.isUserInteractionEnabled = true
                    cell.txtAboutHistoryDrug.isUserInteractionEnabled = true
                    
                    cell.btnSaveDetails.isHidden = false
                    
                    cell.btnGender.isUserInteractionEnabled = true
                    
                    cell.imgProfileImage.isHidden = true
                    cell.imgProfileImage.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                    cell.imgProfileImage.sd_setImage(with: URL(string: (getDictValue["medical_history_image"] as! String)), placeholderImage: UIImage(named: "logo"))
                    
                    self.saveMedicalPatientDetails = getDictValue
                    self.saveMedicalImage = (getDictValue["medical_history_image"] as! String)
                    
                    /*
                     cell.btnYesForMedication.addTarget(self, action: #selector(btnYesPress), for: .touchUpInside)
                     cell.btnYesForHistoryDrug.addTarget(self, action: #selector(btnYesPress), for: .touchUpInside)
                     cell.btnYesForMedicationAllergies.addTarget(self, action: #selector(btnYesPress), for: .touchUpInside)
                     
                     cell.btnNOForMedication.addTarget(self, action: #selector(btnNOPress), for: .touchUpInside)
                     cell.btnNOForHistoryDrug.addTarget(self, action: #selector(btnNOPress), for: .touchUpInside)
                     cell.btnNOForMedicationAllergies.addTarget(self, action: #selector(btnNOPress), for: .touchUpInside)
                     */
                    
                    // use_medicine
                    // have_allergies
                    // alcohol
                    
                    cell.btnYesForMedication.isUserInteractionEnabled = true
                    cell.btnYesForHistoryDrug.isUserInteractionEnabled = true
                    cell.btnYesForMedicationAllergies.isUserInteractionEnabled = true
                    
                    cell.btnNOForMedication.isUserInteractionEnabled = true
                    cell.btnNOForHistoryDrug.isUserInteractionEnabled = true
                    cell.btnNOForMedicationAllergies.isUserInteractionEnabled = true
                    
                    // use medicine
                    if (getDictValue["use_medicine"] as! String) == "" {
                        
                        cell.txtAboutMedication.isUserInteractionEnabled = false
                        cell.btnNOForMedication.setImage(UIImage(named: "check5"), for: .normal)
                        cell.txtAboutMedication.text = ""
                        self.strCheckBoxMedication = "No"
                        
                    } else {
                        
                        if (getDictValue["use_medicine"] as! String) == "Yes" {
                            
                            self.strCheckBoxMedication = "Yes"
                            cell.txtAboutMedication.isUserInteractionEnabled = true
                            cell.btnYesForMedication.setImage(UIImage(named: "check5"), for: .normal)
                            
                        } else {
                            
                            self.strCheckBoxMedication = "No"
                            cell.txtAboutMedication.isUserInteractionEnabled = false
                            cell.btnNOForMedication.setImage(UIImage(named: "check5"), for: .normal)
                            cell.txtAboutMedication.text = ""
                        }
                        
                    }
                    
                    // have allergies
                    if (getDictValue["have_allergies"] as! String) == "" {
                        cell.btnNOForMedicationAllergies.setImage(UIImage(named: "check5"), for: .normal)
                        cell.txtAboutMedicationAllergies.text = ""
                        cell.txtAboutMedicationAllergies.isUserInteractionEnabled = false
                        self.strCheckBoxAllergies = "No"
                        
                    } else {
                        
                        if (getDictValue["have_allergies"] as! String) == "Yes" {
                            
                            self.strCheckBoxAllergies = "Yes"
                            cell.txtAboutMedicationAllergies.isUserInteractionEnabled = true
                            cell.btnYesForMedicationAllergies.setImage(UIImage(named: "check5"), for: .normal)
                        } else {
                            
                            self.strCheckBoxAllergies = "No"
                            cell.txtAboutMedicationAllergies.isUserInteractionEnabled = false
                            cell.btnNOForMedicationAllergies.setImage(UIImage(named: "check5"), for: .normal)
                            cell.txtAboutMedicationAllergies.text = ""
                        }
                        
                    }
                    
                    // alcohol
                    if (getDictValue["alcohol"] as! String) == "" {
                        cell.btnNOForHistoryDrug.setImage(UIImage(named: "check5"), for: .normal)
                        cell.txtAboutHistoryDrug.text = ""
                        cell.txtAboutHistoryDrug.isUserInteractionEnabled = false
                        self.strCheckBoxDrugs = "No"
                        
                    } else {
                        
                        if (getDictValue["alcohol"] as! String) == "Yes" {
                            
                            self.strCheckBoxDrugs = "Yes"
                            cell.txtAboutHistoryDrug.isUserInteractionEnabled = true
                            cell.btnYesForHistoryDrug.setImage(UIImage(named: "check5"), for: .normal)
                            
                        } else {
                            
                            self.strCheckBoxDrugs = "No"
                            cell.txtAboutHistoryDrug.isUserInteractionEnabled = false
                            cell.btnNOForHistoryDrug.setImage(UIImage(named: "check5"), for: .normal)
                            cell.txtAboutHistoryDrug.text = ""
                        }
                        
                    }
                    
                    cell.btnUploadReport.isUserInteractionEnabled = true
                    
                    /*
                     var strCheckBoxMedication:String!
                     var strCheckBoxAllergies:String!
                     var strCheckBoxDrugs:String!
                     */
                    
                    
                    /*self.tablViw.delegate   = self
                     self.tablViw.dataSource = self
                     self.tablViw.reloadData()*/
                    
                    
                    
                    
                    
                    
                    // print(self.isMedicalHistoryCreated as Any)
                    // print(self.dictSavePatientDetails as Any)
                    
                    if self.isMedicalHistoryCreated == "1" {
                        self.arrSaveImageForScroll.removeAllObjects()
                        
                        for indexx in 0...4 {
                            /*
                             "medical_history_image" = "https://demo4.evirtualservices.net/ehealth/img/uploads/medicalhistory/1634040481uploadMedicalHistory.png";
                             "medical_history_image_2" = "https://demo4.evirtualservices.net/ehealth/img/uploads/medicalhistory/1634040496uploadMedicalHistory.png";
                             "medical_history_image_3" = "";
                             "medical_history_image_4" = "";
                             "medical_history_image_5" = "";
                             */
                            
                            if indexx == 0 {
                                
                                if (self.dictSavePatientDetails["medical_history_image"] as! String) == "" {
                                    
                                } else {
                                    
                                    let addDict = ["image":(self.dictSavePatientDetails["medical_history_image"] as! String)]
                                    self.arrSaveImageForScroll.add(addDict)
                                }
                                
                            } else if indexx == 1 {
                                
                                if (self.dictSavePatientDetails["medical_history_image_2"] as! String) == "" {
                                    
                                } else {
                                    let addDict = ["image":(self.dictSavePatientDetails["medical_history_image_2"] as! String)]
                                    self.arrSaveImageForScroll.add(addDict)
                                }
                                
                            } else if indexx == 2 {
                                
                                if (self.dictSavePatientDetails["medical_history_image_3"] as! String) == "" {
                                    
                                } else {
                                    let addDict = ["image":(self.dictSavePatientDetails["medical_history_image_3"] as! String)]
                                    self.arrSaveImageForScroll.add(addDict)
                                }
                                
                            } else if indexx == 3 {
                                
                                if (self.dictSavePatientDetails["medical_history_image_4"] as! String) == "" {
                                    
                                } else {
                                    let addDict = ["image":(self.dictSavePatientDetails["medical_history_image_4"] as! String)]
                                    self.arrSaveImageForScroll.add(addDict)
                                }
                                
                            } else {
                                
                                if (self.dictSavePatientDetails["medical_history_image_5"] as! String) == "" {
                                    
                                } else {
                                    let addDict = ["image":(self.dictSavePatientDetails["medical_history_image_5"] as! String)]
                                    self.arrSaveImageForScroll.add(addDict)
                                }
                                
                            }
                            
                            //
                        }
                        
                        // print(self.arrSaveImageForScroll as Any)
                        
                        if self.arrSaveImageForScroll.count == 0 {
                            
                            cell.btnRightScroll.isHidden = true
                            cell.btnLeftScroll.isHidden = true
                            cell.scrollView.isHidden = true
                            
                        } else if self.arrSaveImageForScroll.count == 1 {
                            
                            cell.btnRightScroll.isHidden = true
                            cell.btnLeftScroll.isHidden = true
                            cell.scrollView.isHidden = false
                            
                            cell.scrollView.isPagingEnabled = true
                            for index in 0..<self.arrSaveImageForScroll.count {
                                
                                frame.origin.x = cell.scrollView.frame.size.width * CGFloat(index)
                                frame.size = cell.scrollView.frame.size
                                
                                // print(arrSaveImageForScroll.count)
                                let item = arrSaveImageForScroll[index] as? [String:Any]
                                // print(item as Any)
                                
                                let imageView = UIImageView()
                                
                                imageView.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "1024"))
                                
                                imageView.frame = frame
                                imageView.tag = index
                                cell.scrollView.contentSize.width = cell.scrollView.frame.width * CGFloat(index + 1)
                                cell.scrollView.addSubview(imageView)
                                
                                /*let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(PatientPrescriptionDetails.cellTappedMethod2(_:)))
                                imageView.isUserInteractionEnabled = true
                                imageView.addGestureRecognizer(tapGestureRecognizer1)*/
                                
                            }
                            
                            cell.btnLeftScroll.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
                            cell.btnRightScroll.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
                            
                            cell.scrollView.contentSize = CGSize(width: cell.scrollView.frame.size.width * CGFloat(self.arrSaveImageForScroll.count), height: cell.scrollView.frame.size.height)
                            cell.scrollView.delegate = self
                            
                        } else {
                            
                            cell.btnRightScroll.isHidden = false
                            cell.btnLeftScroll.isHidden = false
                            cell.scrollView.isHidden = false
                            
                            cell.scrollView.isPagingEnabled = true
                            for index in 0..<self.arrSaveImageForScroll.count {
                                
                                frame.origin.x = cell.scrollView.frame.size.width * CGFloat(index)
                                frame.size = cell.scrollView.frame.size
                                
                                // print(arrSaveImageForScroll.count)
                                let item = arrSaveImageForScroll[index] as? [String:Any]
                                // print(item as Any)
                                
                                let imageView = UIImageView()
                                
                                imageView.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "1024"))
                                
                                imageView.frame = frame
                                imageView.tag = index
                                cell.scrollView.contentSize.width = cell.scrollView.frame.width * CGFloat(index + 1)
                                cell.scrollView.addSubview(imageView)
                                
                                /*let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(PatientPrescriptionDetails.cellTappedMethod2(_:)))
                                imageView.isUserInteractionEnabled = true
                                imageView.addGestureRecognizer(tapGestureRecognizer1)*/
                                
                            }
                            
                            cell.btnLeftScroll.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
                            cell.btnRightScroll.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
                            
                            cell.scrollView.contentSize = CGSize(width: cell.scrollView.frame.size.width * CGFloat(self.arrSaveImageForScroll.count), height: cell.scrollView.frame.size.height)
                            cell.scrollView.delegate = self
                            
                        }
                        
                    } else {
                        
                    }
                    
                    
                } else {
                    
                    
                    let indexPath = IndexPath.init(row: 0, section: 0)
                    let cell = self.tablViw.cellForRow(at: indexPath) as! MedicalHistoryTableViewCell
                    
                    cell.txtDiseasename.text    = (getDictValue["disease"] as! String)
                    cell.txtGender.text         = (getDictValue["gender"] as! String)
                    
                    cell.txtAboutMedication.text    = (getDictValue["medicine"] as! String)
                    
                    cell.txtAboutMedicationAllergies.text   = (getDictValue["allergies"] as! String)
                    
                    cell.txtAboutHistoryDrug.text   = (getDictValue["using_alcohol"] as! String)
                    
                    
                    
                    cell.txtDiseasename.isUserInteractionEnabled = false
                    cell.txtGender.isUserInteractionEnabled = false
                    cell.txtAboutMedication.isUserInteractionEnabled = false
                    cell.txtAboutMedicationAllergies.isUserInteractionEnabled = false
                    cell.txtAboutHistoryDrug.isUserInteractionEnabled = false
                    
                    cell.btnSaveDetails.isHidden = true
                    
                    cell.btnGender.isUserInteractionEnabled = false
                    
                    cell.imgProfileImage.isHidden = true
                    cell.imgProfileImage.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                    cell.imgProfileImage.sd_setImage(with: URL(string: (getDictValue["medical_history_image"] as! String)), placeholderImage: UIImage(named: "logo"))
                     
                    self.saveMedicalPatientDetails = getDictValue
                    self.saveMedicalImage = (getDictValue["medical_history_image"] as! String)
                    
                    /*
                     cell.btnYesForMedication.addTarget(self, action: #selector(btnYesPress), for: .touchUpInside)
                     cell.btnYesForHistoryDrug.addTarget(self, action: #selector(btnYesPress), for: .touchUpInside)
                     cell.btnYesForMedicationAllergies.addTarget(self, action: #selector(btnYesPress), for: .touchUpInside)
                     
                     cell.btnNOForMedication.addTarget(self, action: #selector(btnNOPress), for: .touchUpInside)
                     cell.btnNOForHistoryDrug.addTarget(self, action: #selector(btnNOPress), for: .touchUpInside)
                     cell.btnNOForMedicationAllergies.addTarget(self, action: #selector(btnNOPress), for: .touchUpInside)
                     */
                    
                    // use_medicine
                    // have_allergies
                    // alcohol
                    
                    cell.btnYesForMedication.isUserInteractionEnabled = false
                    cell.btnYesForHistoryDrug.isUserInteractionEnabled = false
                    cell.btnYesForMedicationAllergies.isUserInteractionEnabled = false
                    
                    cell.btnNOForMedication.isUserInteractionEnabled = false
                    cell.btnNOForHistoryDrug.isUserInteractionEnabled = false
                    cell.btnNOForMedicationAllergies.isUserInteractionEnabled = false
                    
                    // use medicine
                    if (getDictValue["use_medicine"] as! String) == "" {
                        cell.btnNOForMedication.setImage(UIImage(named: "check5"), for: .normal)
                    } else {
                        
                        if (getDictValue["use_medicine"] as! String) == "Yes" {
                            
                            cell.btnYesForMedication.setImage(UIImage(named: "check5"), for: .normal)
                        } else {
                            
                            cell.btnNOForMedication.setImage(UIImage(named: "check5"), for: .normal)
                        }
                        
                    }
                    
                    // have allergies
                    if (getDictValue["have_allergies"] as! String) == "" {
                        cell.btnNOForMedicationAllergies.setImage(UIImage(named: "check5"), for: .normal)
                    } else {
                                    
                        if (getDictValue["have_allergies"] as! String) == "Yes" {
                            
                            cell.btnYesForMedicationAllergies.setImage(UIImage(named: "check5"), for: .normal)
                        } else {
                            
                            cell.btnNOForMedicationAllergies.setImage(UIImage(named: "check5"), for: .normal)
                        }
                        
                    }
                    
                    // alcohol
                    if (getDictValue["using_alcohol"] as! String) == "" {
                        cell.btnNOForHistoryDrug.setImage(UIImage(named: "check5"), for: .normal)
                    } else {
                                    
                        if (getDictValue["using_alcohol"] as! String) == "Yes" {
                            
                            cell.btnYesForHistoryDrug.setImage(UIImage(named: "check5"), for: .normal)
                        } else {
                            
                            cell.btnNOForHistoryDrug.setImage(UIImage(named: "check5"), for: .normal)
                        }
                        
                    }
                    
                    cell.btnUploadReport.isUserInteractionEnabled = false
                    
                    
                    
                    
                    self.arrSaveImageForScroll.removeAllObjects()
                    
                    for indexx in 0...4 {
                        
                        if indexx == 0 {
                            
                            if (getDictValue["medical_history_image"] as! String) == "" {
                                
                            } else {
                                
                                let addDict = ["image":(getDictValue["medical_history_image"] as! String)]
                                self.arrSaveImageForScroll.add(addDict)
                            }
                            
                        } else if indexx == 1 {
                            
                            if (getDictValue["medical_history_image_2"] as! String) == "" {
                                
                            } else {
                                let addDict = ["image":(getDictValue["medical_history_image_2"] as! String)]
                                self.arrSaveImageForScroll.add(addDict)
                            }
                            
                        } else if indexx == 2 {
                            
                            if (getDictValue["medical_history_image_3"] as! String) == "" {
                                
                            } else {
                                let addDict = ["image":(getDictValue["medical_history_image_3"] as! String)]
                                self.arrSaveImageForScroll.add(addDict)
                            }
                            
                        } else if indexx == 3 {
                            
                            if (getDictValue["medical_history_image_4"] as! String) == "" {
                                
                            } else {
                                let addDict = ["image":(getDictValue["medical_history_image_4"] as! String)]
                                self.arrSaveImageForScroll.add(addDict)
                            }
                            
                        } else {
                            
                            if (getDictValue["medical_history_image_5"] as! String) == "" {
                                
                            } else {
                                let addDict = ["image":(getDictValue["medical_history_image_5"] as! String)]
                                self.arrSaveImageForScroll.add(addDict)
                            }
                            
                        }
                        
                        //
                    }
                    
                    if self.arrSaveImageForScroll.count == 0 {
                        
                        cell.btnRightScroll.isHidden = true
                        cell.btnLeftScroll.isHidden = true
                        cell.scrollView.isHidden = true
                        
                    } else {
                        
                        cell.btnRightScroll.isHidden = false
                        cell.btnLeftScroll.isHidden = false
                        cell.scrollView.isHidden = false
                        
                        cell.scrollView.isPagingEnabled = true
                        for index in 0..<self.arrSaveImageForScroll.count {
                            
                            frame.origin.x = cell.scrollView.frame.size.width * CGFloat(index)
                            frame.size = cell.scrollView.frame.size
                            
                            // print(arrSaveImageForScroll.count)
                            let item = arrSaveImageForScroll[index] as? [String:Any]
                            // print(item as Any)
                            
                            let imageView = UIImageView()
                            
                            imageView.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "1024"))
                            
                            imageView.frame = frame
                            imageView.tag = index
                            cell.scrollView.contentSize.width = cell.scrollView.frame.width * CGFloat(index + 1)
                            cell.scrollView.addSubview(imageView)
                            
                            /*let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(PatientPrescriptionDetails.cellTappedMethod2(_:)))
                            imageView.isUserInteractionEnabled = true
                            imageView.addGestureRecognizer(tapGestureRecognizer1)*/
                            
                        }
                        
                        cell.btnLeftScroll.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
                        cell.btnRightScroll.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
                        
                        cell.scrollView.contentSize = CGSize(width: cell.scrollView.frame.size.width * CGFloat(self.arrSaveImageForScroll.count), height: cell.scrollView.frame.size.height)
                        cell.scrollView.delegate = self
                        
                        
                    }
                    
                    
                    
                    
                    
                    
                }
                
                
                
                
                
                
                
                
                
                
            } else {
                
                
                let indexPath = IndexPath.init(row: 0, section: 0)
                let cell = self.tablViw.cellForRow(at: indexPath) as! MedicalHistoryTableViewCell
                
                cell.txtDiseasename.text    = (getDictValue["disease"] as! String)
                cell.txtGender.text         = (getDictValue["gender"] as! String)
                
                cell.txtAboutMedication.text    = (getDictValue["medicine"] as! String)
                
                cell.txtAboutMedicationAllergies.text   = (getDictValue["allergies"] as! String)
                
                cell.txtAboutHistoryDrug.text   = (getDictValue["using_alcohol"] as! String)
                
                
                
                cell.txtDiseasename.isUserInteractionEnabled = false
                cell.txtGender.isUserInteractionEnabled = false
                cell.txtAboutMedication.isUserInteractionEnabled = false
                cell.txtAboutMedicationAllergies.isUserInteractionEnabled = false
                cell.txtAboutHistoryDrug.isUserInteractionEnabled = false
                
                cell.btnSaveDetails.isHidden = true
                
                cell.btnGender.isUserInteractionEnabled = false
                
                cell.imgProfileImage.isHidden = true
                cell.imgProfileImage.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell.imgProfileImage.sd_setImage(with: URL(string: (getDictValue["medical_history_image"] as! String)), placeholderImage: UIImage(named: "logo"))
                 
                self.saveMedicalPatientDetails = getDictValue
                self.saveMedicalImage = (getDictValue["medical_history_image"] as! String)
                
                /*
                 cell.btnYesForMedication.addTarget(self, action: #selector(btnYesPress), for: .touchUpInside)
                 cell.btnYesForHistoryDrug.addTarget(self, action: #selector(btnYesPress), for: .touchUpInside)
                 cell.btnYesForMedicationAllergies.addTarget(self, action: #selector(btnYesPress), for: .touchUpInside)
                 
                 cell.btnNOForMedication.addTarget(self, action: #selector(btnNOPress), for: .touchUpInside)
                 cell.btnNOForHistoryDrug.addTarget(self, action: #selector(btnNOPress), for: .touchUpInside)
                 cell.btnNOForMedicationAllergies.addTarget(self, action: #selector(btnNOPress), for: .touchUpInside)
                 */
                
                // use_medicine
                // have_allergies
                // alcohol
                
                cell.btnYesForMedication.isUserInteractionEnabled = false
                cell.btnYesForHistoryDrug.isUserInteractionEnabled = false
                cell.btnYesForMedicationAllergies.isUserInteractionEnabled = false
                
                cell.btnNOForMedication.isUserInteractionEnabled = false
                cell.btnNOForHistoryDrug.isUserInteractionEnabled = false
                cell.btnNOForMedicationAllergies.isUserInteractionEnabled = false
                
                // use medicine
                if (getDictValue["use_medicine"] as! String) == "" {
                    cell.btnNOForMedication.setImage(UIImage(named: "check5"), for: .normal)
                } else {
                    
                    if (getDictValue["use_medicine"] as! String) == "Yes" {
                        
                        cell.btnYesForMedication.setImage(UIImage(named: "check5"), for: .normal)
                    } else {
                        
                        cell.btnNOForMedication.setImage(UIImage(named: "check5"), for: .normal)
                    }
                    
                }
                
                // have allergies
                if (getDictValue["have_allergies"] as! String) == "" {
                    cell.btnNOForMedicationAllergies.setImage(UIImage(named: "check5"), for: .normal)
                } else {
                                
                    if (getDictValue["have_allergies"] as! String) == "Yes" {
                        
                        cell.btnYesForMedicationAllergies.setImage(UIImage(named: "check5"), for: .normal)
                    } else {
                        
                        cell.btnNOForMedicationAllergies.setImage(UIImage(named: "check5"), for: .normal)
                    }
                    
                }
                
                // alcohol
                if (getDictValue["using_alcohol"] as! String) == "" {
                    cell.btnNOForHistoryDrug.setImage(UIImage(named: "check5"), for: .normal)
                } else {
                                
                    if (getDictValue["using_alcohol"] as! String) == "Yes" {
                        
                        cell.btnYesForHistoryDrug.setImage(UIImage(named: "check5"), for: .normal)
                    } else {
                        
                        cell.btnNOForHistoryDrug.setImage(UIImage(named: "check5"), for: .normal)
                    }
                    
                }
                
                cell.btnUploadReport.isUserInteractionEnabled = false
                
                
                
                
                self.arrSaveImageForScroll.removeAllObjects()
                
                for indexx in 0...4 {
                    
                    if indexx == 0 {
                        
                        if (getDictValue["medical_history_image"] as! String) == "" {
                            
                        } else {
                            
                            let addDict = ["image":(getDictValue["medical_history_image"] as! String)]
                            self.arrSaveImageForScroll.add(addDict)
                        }
                        
                    } else if indexx == 1 {
                        
                        if (getDictValue["medical_history_image_2"] as! String) == "" {
                            
                        } else {
                            let addDict = ["image":(getDictValue["medical_history_image_2"] as! String)]
                            self.arrSaveImageForScroll.add(addDict)
                        }
                        
                    } else if indexx == 2 {
                        
                        if (getDictValue["medical_history_image_3"] as! String) == "" {
                            
                        } else {
                            let addDict = ["image":(getDictValue["medical_history_image_3"] as! String)]
                            self.arrSaveImageForScroll.add(addDict)
                        }
                        
                    } else if indexx == 3 {
                        
                        if (getDictValue["medical_history_image_4"] as! String) == "" {
                            
                        } else {
                            let addDict = ["image":(getDictValue["medical_history_image_4"] as! String)]
                            self.arrSaveImageForScroll.add(addDict)
                        }
                        
                    } else {
                        
                        if (getDictValue["medical_history_image_5"] as! String) == "" {
                            
                        } else {
                            let addDict = ["image":(getDictValue["medical_history_image_5"] as! String)]
                            self.arrSaveImageForScroll.add(addDict)
                        }
                        
                    }
                    
                    //
                }
                
                if self.arrSaveImageForScroll.count == 0 {
                    
                    cell.btnRightScroll.isHidden = true
                    cell.btnLeftScroll.isHidden = true
                    cell.scrollView.isHidden = true
                    
                } else {
                    
                    cell.btnRightScroll.isHidden = false
                    cell.btnLeftScroll.isHidden = false
                    cell.scrollView.isHidden = false
                    
                    cell.scrollView.isPagingEnabled = true
                    for index in 0..<self.arrSaveImageForScroll.count {
                        
                        frame.origin.x = cell.scrollView.frame.size.width * CGFloat(index)
                        frame.size = cell.scrollView.frame.size
                        
                        // print(arrSaveImageForScroll.count)
                        let item = arrSaveImageForScroll[index] as? [String:Any]
                        // print(item as Any)
                        
                        let imageView = UIImageView()
                        
                        imageView.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "1024"))
                        
                        imageView.frame = frame
                        imageView.tag = index
                        cell.scrollView.contentSize.width = cell.scrollView.frame.width * CGFloat(index + 1)
                        cell.scrollView.addSubview(imageView)
                        
                        /*let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(PatientPrescriptionDetails.cellTappedMethod2(_:)))
                        imageView.isUserInteractionEnabled = true
                        imageView.addGestureRecognizer(tapGestureRecognizer1)*/
                        
                    }
                    
                    cell.btnLeftScroll.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
                    cell.btnRightScroll.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
                    
                    cell.scrollView.contentSize = CGSize(width: cell.scrollView.frame.size.width * CGFloat(self.arrSaveImageForScroll.count), height: cell.scrollView.frame.size.height)
                    cell.scrollView.delegate = self
                    
                    
                }
                
                
                
                
                
                
            }
            
        }
        
      
        
        
    }
    
    
    @objc func leftButtonTapped() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablViw.cellForRow(at: indexPath) as! MedicalHistoryTableViewCell
        
         if cell.scrollView.contentOffset.x > 0 {
             cell.scrollView.contentOffset.x -=  cell.scrollView.bounds.width
         }
    }
    
    @objc func rightButtonTapped() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablViw.cellForRow(at: indexPath) as! MedicalHistoryTableViewCell
        
        if cell.scrollView.contentOffset.x < cell.scrollView.bounds.width * CGFloat(self.arrSaveImageForScroll.count-1) {
            cell.scrollView.contentOffset.x +=  cell.scrollView.bounds.width
        }
        
    }
        
        
}

extension MedicalHistoryVC:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MedicalHistoryTableViewCell = tablViw.dequeueReusableCell(withIdentifier: "cell") as! MedicalHistoryTableViewCell
        cell.backgroundColor = .white
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.btnGender.addTarget(self, action: #selector(btnGenderPress), for: .touchUpInside)
        
        cell.btnYesForMedication.addTarget(self, action: #selector(btnYesPress), for: .touchUpInside)
        cell.btnNOForMedication.addTarget(self, action: #selector(btnNOPress), for: .touchUpInside)
        
        cell.btnYesForHistoryDrug.addTarget(self, action: #selector(btnYesHistoryDrugsPress), for: .touchUpInside)
        cell.btnNOForHistoryDrug.addTarget(self, action: #selector(btnNOHistoryDrugsPress), for: .touchUpInside)
        
        cell.btnYesForMedicationAllergies.addTarget(self, action: #selector(btnYesAllergiesPress), for: .touchUpInside)
        cell.btnNOForMedicationAllergies.addTarget(self, action: #selector(btnNOAllergiesPress), for: .touchUpInside)
        
        
        cell.btnSaveDetails.addTarget(self, action: #selector(validateBeforeAddMedicalHistory), for: .touchUpInside)
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(showBigImage))
        cell.imgProfileImage.isUserInteractionEnabled = true
        cell.imgProfileImage.addGestureRecognizer(tapGestureRecognizer1)
        cell.imgProfileImage.isHidden = true
        
        cell.btnUploadReport.addTarget(self, action: #selector(uploadReportClickMethod), for: .touchUpInside)
        
        
        
        /*cell.scrollView.isPagingEnabled = true
         for index in 0..<self.arrPrescriptionTotalImages.count {
         
         frame.origin.x = cell.scrollView.frame.size.width * CGFloat(index)
         frame.size = cell.scrollView.frame.size
         
         let item = arrPrescriptionTotalImages[index] as? [String:Any]
         print(item as Any)
         
         let imageView = UIImageView()
         
         imageView.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "1024"))
         
         imageView.frame = frame
         imageView.tag = index
         cell.scrollView.contentSize.width = cell.scrollView.frame.width * CGFloat(index + 1)
         cell.scrollView.addSubview(imageView)
         
         let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(PatientPrescriptionDetails.cellTappedMethod2(_:)))
         imageView.isUserInteractionEnabled = true
         imageView.addGestureRecognizer(tapGestureRecognizer1)
         
         }
         
         cell.btnLeftScroll.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
         cell.btnRightScroll.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
         
         cell.scrollView.contentSize = CGSize(width: cell.scrollView.frame.size.width * CGFloat(self.arrPrescriptionTotalImages.count), height: cell.scrollView.frame.size.height)
         cell.scrollView.delegate = self*/
        
        
        return cell
    }
    
    // MARK: - UPLOAD PICTURE -
    @objc func uploadReportClickMethod() {
        
        // print(self.dictSavePatientDetails as Any)
        
        if self.isMedicalHistoryCreated == "2" {
            
            let alert = UIAlertController(title: "Alert", message: "Please save details before upload Medical History Image.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
            
        } else {
            
            // print(self.dictSavePatientDetails as Any)
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MedicalHistoryAddImageId") as? MedicalHistoryAddImage
            push!.dictGetPatientMedical = self.dictSavePatientDetails
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        
    }
    
    @objc func showBigImage() {
        
        // print(self.saveMedicalPatientDetails["medical_history_image"] as! String)
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ShowImageId") as? ShowImage
        push!.strImageStatus = "MedicalHistoryPageFromPatient"
        push!.imgGetMedicalHistory = (self.saveMedicalPatientDetails["medical_history_image"] as! String)
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 1000
    }
    
    @objc func btnGenderPress() {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablViw.cellForRow(at: indexPath) as! MedicalHistoryTableViewCell
        
        let dummyList = ["Male", "Female", "Prefer not to say"]
        RPicker.selectOption(title: "Gender", cancelText: "Cancel", dataArray: dummyList, selectedIndex: 0) {[] (selctedText, atIndex) in
            // TODO: Your implementation for selection
            cell.txtGender.text = selctedText
        }
    }
    
    /*
     var strCheckBoxMedication:String!
     var strCheckBoxAllergies:String!
     var strCheckBoxDrugs:String!
     */
    
    @objc func btnYesPress(_ sender:UIButton) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablViw.cellForRow(at: indexPath) as! MedicalHistoryTableViewCell
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            if person["role"] as! String == "Hospital"
                || person["role"] as! String == "Doctor"
                || (person["role"] as! String) == "Lab"
                || (person["role"] as! String) == "Pharmacy" {
                
                self.strCheckBoxMedication = "Yes"
                cell.btnYesForMedication.setImage(UIImage(named: "check5"), for: .normal)
                cell.btnNOForMedication.setImage(UIImage(named: "unchecked5"), for: .normal)
                
                cell.txtAboutMedication.isUserInteractionEnabled = true
                
            }
            
        }
    }
    
    @objc func btnNOPress(_ sender:UIButton) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablViw.cellForRow(at: indexPath) as! MedicalHistoryTableViewCell
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            if person["role"] as! String == "Hospital"
                || person["role"] as! String == "Doctor"
                || (person["role"] as! String) == "Lab"
                || (person["role"] as! String) == "Pharmacy" {
                
                self.strCheckBoxMedication = "No"
                
                cell.btnYesForMedication.setImage(UIImage(named: "unchecked5"), for: .normal)
                cell.btnNOForMedication.setImage(UIImage(named: "check5"), for: .normal)
                
                cell.txtAboutMedication.isUserInteractionEnabled = false
                
                cell.txtAboutMedication.text = ""
            }
            
            
            
        }
    }
    
    
    
    // history allergies
    @objc func btnYesAllergiesPress(_ sender:UIButton) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablViw.cellForRow(at: indexPath) as! MedicalHistoryTableViewCell
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            if person["role"] as! String == "Hospital"
                || person["role"] as! String == "Doctor"
                || (person["role"] as! String) == "Lab"
                || (person["role"] as! String) == "Pharmacy" {
                
                self.strCheckBoxAllergies = "Yes"
                cell.btnYesForMedicationAllergies.setImage(UIImage(named: "check5"), for: .normal)
                cell.btnNOForMedicationAllergies.setImage(UIImage(named: "unchecked5"), for: .normal)
                
                cell.txtAboutMedicationAllergies.isUserInteractionEnabled = true
            }
            
        }
    }
    
    @objc func btnNOAllergiesPress(_ sender:UIButton) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablViw.cellForRow(at: indexPath) as! MedicalHistoryTableViewCell
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            if person["role"] as! String == "Hospital"
                || person["role"] as! String == "Doctor"
                || (person["role"] as! String) == "Lab"
                || (person["role"] as! String) == "Pharmacy" {
                
                self.strCheckBoxAllergies = "No"
                cell.btnYesForMedicationAllergies.setImage(UIImage(named: "unchecked5"), for: .normal)
                cell.btnNOForMedicationAllergies.setImage(UIImage(named: "check5"), for: .normal)
                
                cell.txtAboutMedicationAllergies.isUserInteractionEnabled = false
                cell.txtAboutMedicationAllergies.text = ""
            }
            
            
            
        }
    }
    
    
    
    // history drugs
    @objc func btnYesHistoryDrugsPress(_ sender:UIButton) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablViw.cellForRow(at: indexPath) as! MedicalHistoryTableViewCell
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            if person["role"] as! String == "Hospital"
                || person["role"] as! String == "Doctor"
                || (person["role"] as! String) == "Lab"
                || (person["role"] as! String) == "Pharmacy" {
                
                self.strCheckBoxDrugs = "Yes"
                cell.btnYesForHistoryDrug.setImage(UIImage(named: "check5"), for: .normal)
                cell.btnNOForHistoryDrug.setImage(UIImage(named: "unchecked5"), for: .normal)
                
                cell.txtAboutHistoryDrug.isUserInteractionEnabled = true
            }
            
        }
    }
    
    @objc func btnNOHistoryDrugsPress(_ sender:UIButton) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablViw.cellForRow(at: indexPath) as! MedicalHistoryTableViewCell
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            if person["role"] as! String == "Hospital"
                || person["role"] as! String == "Doctor"
                || (person["role"] as! String) == "Lab"
                || (person["role"] as! String) == "Pharmacy" {
                
                self.strCheckBoxDrugs = "No"
                cell.btnYesForHistoryDrug.setImage(UIImage(named: "unchecked5"), for: .normal)
                cell.btnNOForHistoryDrug.setImage(UIImage(named: "check5"), for: .normal)
                
                cell.txtAboutHistoryDrug.isUserInteractionEnabled = false
                cell.txtAboutHistoryDrug.text = ""
                
            }
            
            
            
        }
    }
    
    
}
