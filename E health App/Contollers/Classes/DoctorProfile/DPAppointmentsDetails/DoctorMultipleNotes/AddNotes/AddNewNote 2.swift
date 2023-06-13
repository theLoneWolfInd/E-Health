//
//  AddNewNote.swift
//  E health App
//
//  Created by apple on 27/09/21.
//

import UIKit
import Alamofire
import SDWebImage

class AddNewNote: UIViewController {

    var getAllDataOfThatpatient:NSDictionary!
    
    var strAddOrEdit:String!
    
    @IBOutlet weak var viewNavigationbar:UIView!
    @IBOutlet weak var btnDashboardMenu: UIButton!
    @IBOutlet weak var lblNavationbar:UILabel!{
        didSet {
            lblNavationbar.text = "Add Note"
        }
    }
    
    @IBOutlet weak var notesView:UIView! {
        didSet {
            notesView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            notesView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            notesView.layer.shadowOpacity = 1.0
            notesView.layer.shadowRadius = 15.0
            notesView.layer.masksToBounds = false
            notesView.layer.cornerRadius = 15
            notesView.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var txtView:UITextView! {
        didSet {
            txtView.backgroundColor = .clear
            txtView.text = ""
            txtView.textColor = .black
            txtView.layer.borderWidth = 1
            txtView.layer.borderColor = UIColor.lightGray.cgColor
            txtView.layer.cornerRadius = 6
            txtView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btnSupplierAddress:UIButton! {
        didSet {
            btnSupplierAddress.layer.cornerRadius = 6
            btnSupplierAddress.clipsToBounds = true
            btnSupplierAddress.layer.borderColor = UIColor.clear.cgColor
            btnSupplierAddress.layer.borderWidth = 1
            btnSupplierAddress.setTitle("Submit", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        // print(self.getAllDataOfThatpatient as Any)
        
        self.btnSupplierAddress.addTarget(self, action: #selector(validationBeforeAddNotes), for: .touchUpInside)
        
        self.btnDashboardMenu.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        
        if self.strAddOrEdit == "edit" {
            
            // print(self.getAllDataOfThatpatient as Any)
            /*
             DoctorAddress = "Anand vihar";
             DoctorLastName = "";
             DoctorfullName = Mdoc2;
             HospitalAddress = "9/1, Block C, Yojna Vihar, Anand Vihar, Ghaziabad, Uttar Pradesh 110092, India";
             HospitalLastName = "";
             HospitalfullName = Max;
             PatientAddress = "9/1, Block C, Yojna Vihar, Anand Vihar, Ghaziabad, Uttar Pradesh 110092, India";
             PatientImage = "https://demo4.evirtualservices.net/ehealth/img/uploads/users/1632298923images(68).jpeg";
             PatientLastName = one;
             PatientfullName = Maxp1;
             appointmentId = 118;
             content = "QWERTY ";
             created = "2021-09-27 13:25:00";
             doctorId = 193;
             hospitalId = 182;
             notesId = 42;
             notesImage = "";
             userId = 190;
             */
            
            self.txtView.text = (self.getAllDataOfThatpatient["content"] as! String)
            
        }
        
        
        
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            if (person["role"] as! String) == "Patient" {
                
                self.btnSupplierAddress.isHidden = true
                self.txtView.isEditable = false
                
            } else {
                
                self.btnSupplierAddress.isHidden = false
                self.txtView.isEditable = true
                
            }
            
        }
        
        
        
        
        
    }

    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func validationBeforeAddNotes() {
        
        if self.txtView.text! == "" {
            
            let alert = UIAlertController(title: String("Alert"), message: String("Notes should not be empty."), preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            if self.strAddOrEdit == "edit" {
                self.editNoteWB()
            } else {
                self.addNoteWB()
            }
            
        }
    }
    
    // MARK:- APPOINTMENT DETAILS EDIT -
    @objc func editNoteWB() {
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "updating...")
        
        self.view.endEditing(true)
        
        let x : Int = (self.getAllDataOfThatpatient["notesId"] as! Int)
        let myString = String(x)
        
        let params = Doctor_Edit_Note(action: "editnotes",
                                      noteId: String(myString),
                                      content:String(self.txtView.text!))
        
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
                            
                            let userDefaults = UserDefaults.standard
                            userDefaults.set("successSetNotes", forKey: "keySuccessSetNotes")
                            
                            // self.navigationController?.popViewController(animated: true)
                            
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
    
    // MARK:- APPOINTMENT DETAILS -
    @objc func addNoteWB() {
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Adding...")
        
        self.view.endEditing(true)
        
        let x : Int = (self.getAllDataOfThatpatient["appointmentId"] as! Int)
        let myString = String(x)
        
        let x2 : Int = (self.getAllDataOfThatpatient["doctorId"] as! Int)
        let myString2 = String(x2)
        
        var strHospitalId:String! = "0"
        // HOSPITAL
        if self.getAllDataOfThatpatient["hospitalId"] is String {
                          
            strHospitalId = (self.getAllDataOfThatpatient["hospitalId"] as! String)
            
        } else if self.getAllDataOfThatpatient["hospitalId"] is Int {
            
            let x3 : Int = (self.getAllDataOfThatpatient["hospitalId"] as! Int)
            let myString3 = String(x3)
             
            strHospitalId = String(myString3)
        }
        
        let x4 : Int = (self.getAllDataOfThatpatient["userId"] as! Int)
        let myString4 = String(x4)
        
        let params = Doctor_Add_Notes(action: "addnote",
                                      userId: String(myString4),
                                      doctorId: String(myString2),
                                      hospitalId: String(strHospitalId),
                                      content: String(self.txtView.text!),
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
                          // print(JSON as Any)
                        
                        var strSuccess : String!
                        strSuccess = JSON["status"]as Any as? String
                        
                        // var strSuccess2 : String!
                        // strSuccess2 = JSON["msg"]as Any as? String
                        
                        if strSuccess == String("success") {
                            print("yes")
                            
                            ERProgressHud.sharedInstance.hide()
                            
                            let userDefaults = UserDefaults.standard
                            userDefaults.set("successSetNotes", forKey: "keySuccessSetNotes")
                            
                            self.navigationController?.popViewController(animated: true)
                            
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
