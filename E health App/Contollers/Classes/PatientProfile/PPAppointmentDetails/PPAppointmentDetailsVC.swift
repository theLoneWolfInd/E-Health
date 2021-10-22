//
//  PPAppointmentDetailsVC.swift
//  E health App
//
//  Created by Ranjan on 08/09/21.
//

import UIKit
import Alamofire
import SDWebImage

class PPAppointmentDetailsVC: UIViewController {
    
    var strSaveAppointmentId:String!
    
    var getPatientAppointmentDetails:NSDictionary!
    
    var dictGetAppointmentDetails: NSDictionary!
    
    
    
    @IBOutlet weak var viewNavigationBar:UIView!
    @IBOutlet weak var btnNavigationback:UIButton!
    @IBOutlet weak var lblNavigationBar:UILabel!{
        didSet {
            
            lblNavigationBar.text = "APPOINTMENT DETAILS"
        }
    }

    @IBOutlet weak var tablView:UITableView! {
        didSet {
            tablView.backgroundColor =  .white
            // tablView.delegate = self
            // tablView.dataSource = self
            tablView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.btnNavigationback.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        // self.btnCheckMedicalHist
        
        self.appointmentDetailsWB()
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }

    
    
    
    // MARK:- VIEW TEST -
    @objc func viewTestClick() {
        
        /*let x : Int = (self.dictGetAppointmentDetails["userId"] as! Int)
        let myString = String(x)
        
        let x2 : Int = (self.getPatientAppointmentDetails["appointmentId"] as! Int)
        let myString2 = String(x2)
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ShowImageId") as? ShowImage
        
        push!.strImageStatus = "test"
        push!.strDoctorId = String(myString)
        push!.strAppointmentId = String(myString2)
        
        self.navigationController?.pushViewController(push!, animated: true)*/
        
        // print(self.dictGetAppointmentDetails as Any)
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddImagesId") as? AddImages
        
        push!.getAppointmentDetailsIn = self.dictGetAppointmentDetails
        push!.strShowImageDetailsFor = "test"
        
        // PATIENT
        let x : Int = (self.dictGetAppointmentDetails["userId"] as! Int)
        let myString = String(x)
        push!.strSavePatientId = String(myString)
        
        // DOCTOR
        let x2 : Int = (self.dictGetAppointmentDetails["doctorId"] as! Int)
        let myString2 = String(x2)
        push!.strSaveDoctorId = String(myString2)
        
        // APPOINTMENT
        let x5 : Int = (self.dictGetAppointmentDetails["appointmentId"] as! Int)
        let myString5 = String(x5)
        push!.strSaveAppointmentId = String(myString5)
        
        // HOSPITAL
        if self.dictGetAppointmentDetails["hospitalId"] is String {
                          
            push!.strSaveHospitalId = String("")
            
        } else if self.dictGetAppointmentDetails["hospitalId"] is Int {
            
            let x4 : Int = (self.dictGetAppointmentDetails["hospitalId"] as! Int)
            let myString4 = String(x4)
            push!.strSaveHospitalId = String(myString4)
            
        }
        
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    // MARK:- DOCTOR PRISCRIPTION -
    @objc func doctorPriscriptionClick() {
        // self.dictGetAppointmentDetails
        
        /*let x : Int = (self.dictGetAppointmentDetails["doctorId"] as! Int)
        let myString = String(x)
        
        let x2 : Int = (self.dictGetAppointmentDetails["hospitalId"] as! Int)
        let myString2 = String(x2)
        
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ShowImageId") as? ShowImage
        
        push!.strDoctorId = String(myString)
        push!.strHospitalId = String(myString2)
        push!.strImageStatus = "prescription"
        
        self.navigationController?.pushViewController(push!, animated: true)*/
        
        // print(self.dictGetAppointmentDetails as Any)
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddImagesId") as? AddImages
        
        push!.getAppointmentDetailsIn = self.dictGetAppointmentDetails
        push!.strShowImageDetailsFor = "prescription"
        
        // PATIENT
        let x : Int = (self.dictGetAppointmentDetails["userId"] as! Int)
        let myString = String(x)
        push!.strSavePatientId = String(myString)
        
        // DOCTOR
        let x2 : Int = (self.dictGetAppointmentDetails["doctorId"] as! Int)
        let myString2 = String(x2)
        push!.strSaveDoctorId = String(myString2)
        
        // APPOINTMENT
        let x5 : Int = (self.dictGetAppointmentDetails["appointmentId"] as! Int)
        let myString5 = String(x5)
        push!.strSaveAppointmentId = String(myString5)
        
        // HOSPITAL
        if self.dictGetAppointmentDetails["hospitalId"] is String {
                          
            push!.strSaveHospitalId = String("")
            
        } else if self.dictGetAppointmentDetails["hospitalId"] is Int {
            
            let x4 : Int = (self.dictGetAppointmentDetails["hospitalId"] as! Int)
            let myString4 = String(x4)
            push!.strSaveHospitalId = String(myString4)
            
        }
        
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    // MARK:- VIEW NOTES -
    @objc func viewNotesClick() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DoctorNewNotesId") as? DoctorNewNotes
        
        push!.getAppointmentDetailsIn = self.dictGetAppointmentDetails
        push!.strShowImageDetailsFor = "note"
        
        // PATIENT
        let x : Int = (self.dictGetAppointmentDetails["userId"] as! Int)
        let myString = String(x)
        push!.strSavePatientId = String(myString)
        
        // DOCTOR
        let x2 : Int = (self.dictGetAppointmentDetails["doctorId"] as! Int)
        let myString2 = String(x2)
        push!.strSaveDoctorId = String(myString2)
        
        // APPOINTMENT
        let x5 : Int = (self.dictGetAppointmentDetails["appointmentId"] as! Int)
        let myString5 = String(x5)
        push!.strSaveAppointmentId = String(myString5)
        
        // HOSPITAL
        if self.dictGetAppointmentDetails["hospitalId"] is String {
                          
            push!.strSaveHospitalId = String("")
            
        } else if self.dictGetAppointmentDetails["hospitalId"] is Int {
            
            let x4 : Int = (self.dictGetAppointmentDetails["hospitalId"] as! Int)
            let myString4 = String(x4)
            push!.strSaveHospitalId = String(myString4)
            
        }
        
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func viewNotesWB() {
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        self.view.endEditing(true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            let x2 : Int = (self.getPatientAppointmentDetails["appointmentId"] as! Int)
            let myString2 = String(x2)
            
            let params = AppointmentDetailsImage(action: "noteslist",
                                                 userId: String(myString),
                                                 appointmentId: String(myString2))
            
            print(params as Any)
            
            AF.request(APPLICATION_BASE_URL,
                       method: .post,
                       parameters: params,
                       encoder: JSONParameterEncoder.default).responseJSON { response in
                        // debugPrint(response.result)
                        
                        switch response.result {
                        case let .success(value):
                            
                            let JSON = value as! NSDictionary
                            // print(JSON as Any)
                            
                            var strSuccess : String!
                            strSuccess = JSON["status"]as Any as? String
                            
                            // var strSuccess2 : String!
                            // strSuccess2 = JSON["msg"]as Any as? String
                            
                            if strSuccess == String("success") {
                                print("yes")
                                
                                ERProgressHud.sharedInstance.hide()
                                
                                var dict: Dictionary<AnyHashable, Any>
                                dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                
                                let strMessage:String! = (dict["content"] as! String)
                                
                                let alert = UIAlertController(title: "View Notes", message: strMessage, preferredStyle: .actionSheet)
                                
                                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
                                    print("User click Dismiss button")
                                }))
                                
                                self.present(alert, animated: true, completion: {
                                    print("completion block")
                                })
                                
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
    
    // MARK:- APPOINTMENT DETAILS -
    @objc func appointmentDetailsWB() {
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        self.view.endEditing(true)
        
        let x : Int = (self.getPatientAppointmentDetails["appointmentId"] as! Int)
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
                            
                            self.dictGetAppointmentDetails = (JSON["data"] as! NSDictionary)
                            
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
    
    
    
    @objc func addImageClickMethod() { // prescription
        
        // print(self.dictGetBookingDetailsForDoctors as Any)
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddImagesId") as? AddImages
        
        /*push!.getAppointmentDetailsIn = self.dictGetBookingDetailsForDoctors
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
            
        }*/
        
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    
}

extension PPAppointmentDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:PPAppointmentDetailsTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell") as! PPAppointmentDetailsTableViewCell
        
        cell.backgroundColor = .white
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        print(self.getPatientAppointmentDetails as Any)
        print(self.dictGetAppointmentDetails as Any)
        
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
        
        cell.btnAddress.setTitle((self.getPatientAppointmentDetails["PatientAddress"] as! String), for: .normal)
        cell.btnAddress.titleLabel?.lineBreakMode =  .byWordWrapping
        cell.btnAddress.setTitleColor(.black, for: .normal)
        cell.btnAddress.titleLabel?.lineBreakMode = .byWordWrapping
        
        cell.lblHospitalName.text = (self.getPatientAppointmentDetails["HospitalfullName"] as! String)
        cell.lblHospitalName.textColor = .black
        
        cell.lblPhone.text = (self.dictGetAppointmentDetails["DoctorNumber"] as! String)
        cell.lblEmail.text = (self.dictGetAppointmentDetails["DoctorEmail"] as! String)
        cell.lblEmail.numberOfLines = 0
        
        cell.imgBanner.image = UIImage(named: "background")
        cell.imgProfile.image = UIImage(named: "daze")
        
        cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.imgProfile.sd_setImage(with: URL(string: (self.getPatientAppointmentDetails["PatientImage"] as! String)), placeholderImage: UIImage(named: "1024"))
        
        let x : Int = (self.getPatientAppointmentDetails["appointmentId"] as! Int)
        let myString = String(x)
        
        cell.lblAppointmentId.text = String(myString)
        cell.lblDoctorNameSpeciality.text = (self.getPatientAppointmentDetails["DoctorfullName"] as! String)
        cell.lblAppointmentDate.text = (self.getPatientAppointmentDetails["Adate"] as! String)
        
        cell.btnViewTest.addTarget(self, action: #selector(viewTestClick), for: .touchUpInside)
        cell.btnDoctorPrescription.addTarget(self, action: #selector(doctorPriscriptionClick), for: .touchUpInside)
        cell.btnViewNotes.addTarget(self, action: #selector(viewNotesClick), for: .touchUpInside)
        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 780
    }
    
}
