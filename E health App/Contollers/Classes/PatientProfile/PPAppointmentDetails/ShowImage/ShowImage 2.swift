//
//  ShowImage.swift
//  E health App
//
//  Created by apple on 20/09/21.
//

import UIKit
import SDWebImage
import Alamofire

class ShowImage: UIViewController {

    var strAppointmentId:String!
    var strImageStatus:String!
    var imgGetMedicalHistory:String!
    
    
    // for prescription
    var strHospitalId:String!
    var strDoctorId:String!
    
    var strPatientId:String!
    
    @IBOutlet weak var imgView:UIImageView! 
    
    @IBOutlet weak var btnDismiss:UIButton! {
        didSet {
            btnDismiss.layer.cornerRadius = 8
            btnDismiss.clipsToBounds = true
            btnDismiss.backgroundColor = .systemRed
            
            btnDismiss.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btnDismiss.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btnDismiss.layer.shadowOpacity = 1.0
            btnDismiss.layer.shadowRadius = 15.0
            btnDismiss.layer.masksToBounds = false
            btnDismiss.layer.cornerRadius = 15.0
            btnDismiss.clipsToBounds = true
            btnDismiss.setTitle("Dismiss", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .black
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
         print(self.strDoctorId as Any)
     
        self.imgView.isHidden = true
        
        self.btnDismiss.addTarget(self, action: #selector(dismissClickMethod), for: .touchUpInside)
        
        if self.strImageStatus == "test" {
            
            self.dynamicWebservice(strAction: "testlist")
            
        } else if self.strImageStatus == "prescription" {
            
            self.prescriptionImageList()
            
        } else if self.strImageStatus == "MedicalHistoryPageFromPatient" {
            
            self.imgView.isHidden = false
            self.imgView.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            self.imgView.sd_setImage(with: URL(string: "\(self.imgGetMedicalHistory!)"), placeholderImage: UIImage(named: "1024"))
            
        } else if self.strImageStatus == "Prescription_Details_Patient_Profile" {
            
            self.imgView.isHidden = false
            self.imgView.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            self.imgView.sd_setImage(with: URL(string: "\(self.imgGetMedicalHistory!)"), placeholderImage: UIImage(named: "1024"))
            
        } else if self.strImageStatus == "Patient_Prescreption_List" {
            
            self.imgView.isHidden = false
            self.imgView.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            self.imgView.sd_setImage(with: URL(string: "\(self.imgGetMedicalHistory!)"), placeholderImage: UIImage(named: "1024"))
            
        } else if self.strImageStatus == "test_list_from_labs" {
            // print(self.strPatientId as Any)
            
            self.imgView.isHidden = false
            self.imgView.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            self.imgView.sd_setImage(with: URL(string: "\(self.imgGetMedicalHistory!)"), placeholderImage: UIImage(named: "1024"))
            
            // self.test_list_wb()
            
        } else {
            
            self.dynamicWebservice(strAction: "noteslist")
            
        }
        
    }
    
    @objc func dismissClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }

    
    
    @objc func dynamicWebservice(strAction:String) {
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        self.view.endEditing(true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            // let x2 : Int = self.strDoctorId as // (person["userId"] as! Int)
            // let myString2 = String(x2)
            
            let params = AppointmentDetailsImage(action: strAction,
                                                 userId: String(myString),// String(self.strDoctorId),
                                                 appointmentId:String(self.strAppointmentId))
            
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
                                
                                self.imgView.isHidden = false
                                
                                    var dict: Dictionary<AnyHashable, Any>
                                    dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                    
                                    self.imgView.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                                    
                                    
                                
                                    /*if self.strImageStatus == "test" {
                                        
                                        self.imgView.sd_setImage(with: URL(string: dict["testImage"] as! String), placeholderImage: UIImage(named: "1024"))
                                        
                                    } else if self.strImageStatus == "prescription" {
                                        
                                        self.imgView.sd_setImage(with: URL(string: dict["medical_history_image"] as! String), placeholderImage: UIImage(named: "1024"))
                                        
                                    } else {
                                        
                                        self.imgView.sd_setImage(with: URL(string: dict["testImage"] as! String), placeholderImage: UIImage(named: "1024"))
                                        
                                    }
                                    */
                                
                                
                                
                                
                                
                                
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
    
    
    
    
    @objc func prescriptionImageList() {
        // self.arrListOfAllPrescription.removeAllObjects()
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        /*
         added in 3 API's -
             addprescription( ) - appointmentId is mandatory
             prescriptionlist( ) - appointmentId is optional
             prescriptiondetails( ) - appointmentId is optional

         */
        
        self.view.endEditing(true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            let params = Patient_List_of_all_Prescription(action: "prescriptiondetails",
                                                          userId: String(myString),
                                                          doctorId: String(self.strDoctorId),
                                                          hospitalId: String(self.strHospitalId),
                                                          appointmentId:String(self.strAppointmentId))
            
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
                                self.imgView.isHidden = false
                                ERProgressHud.sharedInstance.hide()
                                
                                var dict: Dictionary<AnyHashable, Any>
                                dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                
                                self.imgView.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                                self.imgView.sd_setImage(with: URL(string: dict["prescription_image"] as! String), placeholderImage: UIImage(named: "1024"))
                                
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
}
