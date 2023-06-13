//
//  DPAppointmentsDetailsVC.swift
//  E health App
//
//  Created by Ranjan on 31/08/21.
//

import UIKit
import Alamofire
import SDWebImage

class DPAppointmentsDetailsVC: UIViewController {

    var dictGetBookingDetailsForDoctors:NSDictionary!
    
    var arr = ["Allen","Denical JohnSon", "Shawn Davis"]
    
    @IBOutlet weak var viewNavigationbar:UIView!
    @IBOutlet weak var btnDashboardMenu: UIButton!
    @IBOutlet weak var lblNavationbar:UILabel!{
        didSet {
            
            lblNavationbar.text = "APPOINTMENT DETAILS"
        }
    }
    
    @IBOutlet weak var tablView:UITableView!
    @IBOutlet weak var lblAppointmentId:UILabel!
    @IBOutlet weak var lblDoctorName:UILabel!
    @IBOutlet weak var lblDateTime:UILabel!
    
    @IBOutlet weak var btnCheckMedicalHist:UIButton!{
        
        didSet {
            btnCheckMedicalHist.layer.cornerRadius = 27.5
            btnCheckMedicalHist.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnUploadPrescription:UIButton!{
        
        didSet{
            btnUploadPrescription.layer.cornerRadius = 27.5
            btnUploadPrescription.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnUploadTest:UIButton!{
        
        didSet{
            btnUploadTest.layer.cornerRadius = 27.5
            btnUploadTest.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnNotes:UIButton!{
        
        didSet{
            btnNotes.layer.cornerRadius = 27.5
            btnNotes.clipsToBounds = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tablView.delegate = self
        // tablView.dataSource =  self
        self.view.backgroundColor = .white
        tablView.backgroundColor =  .white
        self.tablView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        
        self.navigationController?.isNavigationBarHidden = true
        
        
        print(self.dictGetBookingDetailsForDoctors as Any)
        
        self.lblDateTime.text = (self.dictGetBookingDetailsForDoctors["Adate"] as! String)
        
        let x : Int = (self.dictGetBookingDetailsForDoctors["appointmentId"] as! Int)
        let myString = String(x)
        self.lblAppointmentId.text = "# "+String(myString)
        
        self.lblDoctorName.text = (self.dictGetBookingDetailsForDoctors["DoctorfullName"] as! String)
        
        self.tablView.separatorColor = .clear
        
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
            
            if (person["role"] as! String) == "Hospital" {
                
                self.btnUploadPrescription.setTitle("Check Prescription", for: .normal)
                self.btnCheckMedicalHist.setTitle("Check Medical History", for: .normal)
                self.btnNotes.isHidden = true
                self.btnUploadTest.isHidden = true
                self.btnCheckMedicalHist.addTarget(self, action: #selector(checkMedicalHistoryClickMethod), for: .touchUpInside)
                
            } else if (person["role"] as! String) == "Doctor" {
                
                self.btnUploadPrescription.setTitle("Upload Prescription", for: .normal)
                self.btnCheckMedicalHist.setTitle("Check Medical History", for: .normal)
                self.btnCheckMedicalHist.addTarget(self, action: #selector(doctor_check_medical_history), for: .touchUpInside)
                
            } else {
                
                self.btnUploadPrescription.setTitle("Check Prescription", for: .normal)
                self.btnCheckMedicalHist.setTitle("Check Medical History", for: .normal)
                
            }
            
        }
        
        self.btnUploadPrescription.addTarget(self, action: #selector(addImageClickMethod), for: .touchUpInside)
        self.btnUploadTest.addTarget(self, action: #selector(addTestClickMethod), for: .touchUpInside)
        self.btnNotes.addTarget(self, action: #selector(addNotesClickMethod), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // ALL APPOINTMENT LISTS
        self.appointmentDetailsWB()
        
    }
    
    @objc func doctor_check_medical_history() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MedicalHistoryVC") as? MedicalHistoryVC
        
        push!.strIamFromBookedAppointment = "yes"
        push!.getPatientRegistrationDetails = self.dictGetBookingDetailsForDoctors
        
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func checkMedicalHistoryClickMethod() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MedicalHistoryVC") as? MedicalHistoryVC
        
        push!.strIamFromBookedAppointment = "yes"
        push!.getPatientRegistrationDetails = self.dictGetBookingDetailsForDoctors
        
        self.navigationController?.pushViewController(push!, animated: true)
        
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
    
    @objc func addImageClickMethod() { // prescription
        
        // print(self.dictGetBookingDetailsForDoctors as Any)
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddImagesId") as? AddImages
        
        push!.getAppointmentDetailsIn = self.dictGetBookingDetailsForDoctors
        push!.strShowImageDetailsFor = "prescription"
        
        // PATIENT
        let x : Int = (self.dictGetBookingDetailsForDoctors["userId"] as! Int)
        let myString = String(x)
        push!.strSavePatientId = String(myString)
        
        // DOCTOR
        let x2 : Int = (self.dictGetBookingDetailsForDoctors["doctorId"] as! Int)
        let myString2 = String(x2)
        push!.strSaveDoctorId = String(myString2)
        
        // APPOINTMENT
        let x5 : Int = (self.dictGetBookingDetailsForDoctors["appointmentId"] as! Int)
        let myString5 = String(x5)
        push!.strSaveAppointmentId = String(myString5)
        
        // HOSPITAL
        if self.dictGetBookingDetailsForDoctors["hospitalId"] is String {
                          
            push!.strSaveHospitalId = String("")
            
        } else if self.dictGetBookingDetailsForDoctors["hospitalId"] is Int {
            
            let x4 : Int = (self.dictGetBookingDetailsForDoctors["hospitalId"] as! Int)
            let myString4 = String(x4)
            push!.strSaveHospitalId = String(myString4)
            
        }
        
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    
    
    @objc func addTestClickMethod() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddImagesId") as? AddImages
        
        
        push!.getAppointmentDetailsIn = self.dictGetBookingDetailsForDoctors
        push!.strShowImageDetailsFor = "test"
        
        // PATIENT
        let x : Int = (self.dictGetBookingDetailsForDoctors["userId"] as! Int)
        let myString = String(x)
        push!.strSavePatientId = String(myString)
        
        // DOCTOR
        let x2 : Int = (self.dictGetBookingDetailsForDoctors["doctorId"] as! Int)
        let myString2 = String(x2)
        push!.strSaveDoctorId = String(myString2)
        
        // APPOINTMENT
        let x5 : Int = (self.dictGetBookingDetailsForDoctors["appointmentId"] as! Int)
        let myString5 = String(x5)
        push!.strSaveAppointmentId = String(myString5)
        
        // HOSPITAL
        if self.dictGetBookingDetailsForDoctors["hospitalId"] is String {
                          
            push!.strSaveHospitalId = String("")
            
        } else if self.dictGetBookingDetailsForDoctors["hospitalId"] is Int {
            
            let x4 : Int = (self.dictGetBookingDetailsForDoctors["hospitalId"] as! Int)
            let myString4 = String(x4)
            push!.strSaveHospitalId = String(myString4)
            
        }
        
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    
    @objc func addNotesClickMethod() { //
        
        // print(self.dictGetBookingDetailsForDoctors as Any)
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DoctorNewNotesId") as? DoctorNewNotes
        
        push!.getAppointmentDetailsIn = self.dictGetBookingDetailsForDoctors
        push!.strShowImageDetailsFor = "note"
        
        // PATIENT
        let x : Int = (self.dictGetBookingDetailsForDoctors["userId"] as! Int)
        let myString = String(x)
        push!.strSavePatientId = String(myString)
        
        // DOCTOR
        let x2 : Int = (self.dictGetBookingDetailsForDoctors["doctorId"] as! Int)
        let myString2 = String(x2)
        push!.strSaveDoctorId = String(myString2)
        
        // APPOINTMENT
        let x5 : Int = (self.dictGetBookingDetailsForDoctors["appointmentId"] as! Int)
        let myString5 = String(x5)
        push!.strSaveAppointmentId = String(myString5)
        
        // HOSPITAL
        if self.dictGetBookingDetailsForDoctors["hospitalId"] is String {
                          
            push!.strSaveHospitalId = String("")
            
        } else if self.dictGetBookingDetailsForDoctors["hospitalId"] is Int {
            
            let x4 : Int = (self.dictGetBookingDetailsForDoctors["hospitalId"] as! Int)
            let myString4 = String(x4)
            push!.strSaveHospitalId = String(myString4)
            
        }
        
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    
    // MARK:- APPOINTMENT DETAILS -
    @objc func appointmentDetailsWB() {
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        self.view.endEditing(true)
        
        let x : Int = (self.dictGetBookingDetailsForDoctors["appointmentId"] as! Int)
        let myString = String(x)
        
        let params = AppointmentDetails(action: "appointmentdetails",
                                        appointmentId: String(myString))
        
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
                            
                            self.dictGetBookingDetailsForDoctors = (JSON["data"] as! NSDictionary)
                            
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

extension DPAppointmentsDetailsVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:DPAppointmentsDetailsTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell") as! DPAppointmentsDetailsTableViewCell
        
        cell.backgroundColor = .white
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        // print(self.dictGetBookingDetailsForDoctors as Any)
        
        if indexPath.row == 0 {
            
            cell.lblTitle.text = "Patient"
            cell.lblPatientOrHospitalName.text = (self.dictGetBookingDetailsForDoctors["PatientfullName"] as! String)+" "+(self.dictGetBookingDetailsForDoctors["PatientLastName"] as! String)
            
            cell.lblPatientOrHospitalPhone.text = (self.dictGetBookingDetailsForDoctors["PatientNumber"] as! String)
            cell.lblPatientOrHospitalAddress.text = (self.dictGetBookingDetailsForDoctors["PatientAddress"] as! String)
            
            cell.imgPatientProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.imgPatientProfile.sd_setImage(with: URL(string: (self.dictGetBookingDetailsForDoctors["PatientImage"] as! String)), placeholderImage: UIImage(named: "1024"))
            
        } else {
            
            cell.lblTitle.text = "Hospital"
            cell.lblPatientOrHospitalName.text = (self.dictGetBookingDetailsForDoctors["HospitalfullName"] as! String)
            
            cell.lblPatientOrHospitalPhone.text = (self.dictGetBookingDetailsForDoctors["HospitalNumber"] as! String)
            cell.lblPatientOrHospitalAddress.text = (self.dictGetBookingDetailsForDoctors["HospitalAddress"] as! String)
            
            cell.imgPatientProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.imgPatientProfile.sd_setImage(with: URL(string: (self.dictGetBookingDetailsForDoctors["HospitalImage"] as! String)), placeholderImage: UIImage(named: "1024"))
            
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.dictGetBookingDetailsForDoctors["hospitalId"] is String {
                          
            print("Yes, it's a String")
          
            if (self.dictGetBookingDetailsForDoctors["hospitalId"] as! String) == "" {
                
                if indexPath.row == 0 {
                    return UITableView.automaticDimension
                } else {
                    return 0
                }
                
            } else {
                
                return UITableView.automaticDimension
            }
            
        } else if self.dictGetBookingDetailsForDoctors["hospitalId"] is Int {
          
            print("It is Integer")
          
            let x : Int = (self.dictGetBookingDetailsForDoctors["hospitalId"] as! Int)
            let myString = String(x)
            
            if myString == "" {
                
                if indexPath.row == 0 {
                    return UITableView.automaticDimension
                } else {
                    return 0
                }
                
            } else {
                
                return UITableView.automaticDimension
            }
        }
        
        return 0
        
        /*let x : Int = (self.dictGetBookingDetailsForDoctors["hospitalId"] as! Int)
        let myString = String(x)
        
        if myString == "" {
            
            if indexPath.row == 0 {
                return UITableView.automaticDimension
            } else {
                return 0
            }
            
        } else {
            
            return UITableView.automaticDimension
        }*/
        
    }
}
