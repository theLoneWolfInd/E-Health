//
//  AddNewPatientVC.swift
//  E health App
//
//  Created by Ranjan on 25/08/21.
//

import UIKit
import Alamofire
import SDWebImage

class AddNewPatientVC: UIViewController , UINavigationControllerDelegate , UIImagePickerControllerDelegate {
    
    
    let regularFont = UIFont.systemFont(ofSize: 16)
    let boldFont = UIFont.boldSystemFont(ofSize: 16)
    var strRandomMedicalId:String!
    
    var myStr = ""
    var countryId = ""
    var countryListArray:NSMutableArray = []
    
    var saveCountryId:String!
    
    var imageStr:String! = "0"
    var imgData:Data!
    
    var strUserPaidOrNot:String! = "0"
    
    var strProfileForEdit:String!
    var getAllDetails:NSDictionary!
    
    @IBOutlet weak var viewNavigationBar:UIView!
    @IBOutlet weak var btnNaviagtionBack:UIButton!
    @IBOutlet weak var lblNavigationBar:UILabel!{
        didSet {
            
            lblNavigationBar.text = "ADD NEW PATIENT"
        }
    }
    
    @IBOutlet weak var viewBtnBG:UIView!{
        didSet{
            viewBtnBG.backgroundColor = .clear
        }
    }
    
    
    
    @IBOutlet weak var tablView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tablView.delegate = self
        tablView.dataSource = self
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .white
        self.tablView.backgroundColor = .white
        
        btnNaviagtionBack.addTarget(self, action: #selector(btnNavigationBackPress), for: .touchUpInside)
        
        fetchServerValuesAndParse()
        countryListWebService()
        
        
        print(self.strProfileForEdit as Any)
        
        if self.strProfileForEdit == "yes" {
            
            lblNavigationBar.text = "EDIT PATIENT"
            
        } else {
            self.createRandomPatientMedicalId()
        }
        
    }
    
    @objc func btnNavigationBackPress(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func fetchServerValuesAndParse() {
      
    }
    
    
    //MARK:- PATIENT RANDOM MEDICAL ID -
    @objc func createRandomPatientMedicalId() {
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "please wait...")
        
        let params =  CreatePatientMedicalId(action: "uniquecode")
        
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
                            
                            var dict: Dictionary<AnyHashable, Any>
                            dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                            
                            self.strRandomMedicalId = (dict["medicalCardID"] as! String)
                            
                            let indexPath = IndexPath.init(row: 0, section: 0)
                            let cell = self.tablView.cellForRow(at: indexPath) as! AddNewPatientTableViewCell
                            
                            
                            
                            cell.txtUID.text = self.strRandomMedicalId
                            cell.txtUID.isUserInteractionEnabled = false
                            
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
    
    @objc func validationBeforeAddPatient() {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! AddNewPatientTableViewCell
        
        if cell.txtDateOfReg.text == "" {
            
            self.fieldShoulNotBeEmptyPopup(strTitle: "Date of Registration")
            
        } else if cell.txtUID.text == "" {
            
            self.fieldShoulNotBeEmptyPopup(strTitle: "Unique Identification Card")
            
        } else if cell.txtFirstName.text == "" {
            
            self.fieldShoulNotBeEmptyPopup(strTitle: "First Name")
            
        } else if cell.txtMiddleName.text == "" {
            
            self.fieldShoulNotBeEmptyPopup(strTitle: "Middle Name")
            
        } else if cell.txtLastName.text == "" {
            
            self.fieldShoulNotBeEmptyPopup(strTitle: "Last Name")
            
        } else if cell.txtNickName.text == "" {
            
            self.fieldShoulNotBeEmptyPopup(strTitle: "Nick Name")
            
        } else if cell.txtDob.text == "" {
            
            self.fieldShoulNotBeEmptyPopup(strTitle: "Date of Birth")
            
        } else if cell.txtCity.text == "" {
            
            self.fieldShoulNotBeEmptyPopup(strTitle: "City")
            
        } else if cell.txtCountryName.text == "" {
            
            self.fieldShoulNotBeEmptyPopup(strTitle: "Country")
            
        } else if cell.txtGender.text == "" {
            
            self.fieldShoulNotBeEmptyPopup(strTitle: "Gender")
            
        } else if cell.txtHeight.text == "" {
            
            self.fieldShoulNotBeEmptyPopup(strTitle: "Height")
            
        } else if cell.txtEyeColor.text == "" {
            
            self.fieldShoulNotBeEmptyPopup(strTitle: "Eye Color")
            
        } else if cell.txtPinNumber.text == "" {
            
            self.fieldShoulNotBeEmptyPopup(strTitle: "Pin number for Security")
            
        } else if cell.txtUserName.text == "" {
            
            self.fieldShoulNotBeEmptyPopup(strTitle: "Username")
            
        } else if cell.txtPhoneNumber.text == "" {
            
            self.fieldShoulNotBeEmptyPopup(strTitle: "Phone Number")
            
        } else if cell.txtEmail.text == "" {
            
            self.fieldShoulNotBeEmptyPopup(strTitle: "Email")
            
        } else if cell.txtPassword.text == "" {
            
            self.fieldShoulNotBeEmptyPopup(strTitle: "Password")
            
        } else if cell.txtConfirmPassword.text == "" {
            
            self.fieldShoulNotBeEmptyPopup(strTitle: "Confirm Password")
            
        } else if cell.txtPassword.text != cell.txtConfirmPassword.text {
            
            let alert = UIAlertController(title: "Alert", message: "Password not match", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
            
        } else {
            
            if self.imageStr == "1" {
                self.addPatientWithImage()
            } else {
                
                
                // editPatientWB
                
                if self.strProfileForEdit == "yes" {
                    self.editPatientWB()
                } else {
                    self.addPatientWB()
                }
                
            }
            
            
        }
        
    }
    
    @objc func fieldShoulNotBeEmptyPopup(strTitle:String) {
        
        let alert = UIAlertController(title: "Alert", message: String(strTitle)+" Field should not be empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true)
        
    }
    
    
    
    @objc func addPatientWB() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! AddNewPatientTableViewCell
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "adding...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params =  AddPatient(action: "registration",
                                     addedBy: String(myString),
                                     registeredDt: String(cell.txtDateOfReg.text!),
                                     medicalCardID: String(cell.txtUID.text!),
                                     fullName: String(cell.txtFirstName.text!),
                                     middleName: String(cell.txtMiddleName.text!),
                                     lastName: String(cell.txtLastName.text!),
                                     dob: String(cell.txtDob.text!),
                                     username: String(cell.txtUserName.text!),
                                     email: String(cell.txtEmail.text!),
                                     contactNumber: String(cell.txtPhoneNumber.text!),
                                     password: String(cell.txtPassword.text!),
                                     city: String(cell.txtCity.text!),
                                     height: String(cell.txtHeight.text!),
                                     eyeColor: String(cell.txtEyeColor.text!),
                                     securityNumber: String(cell.txtPinNumber.text!),
                                     zipCode: String("N.A."),
                                     countryId: String(self.saveCountryId),
                                     device: MY_DEVICE,
                                     role: "Patient",
                                     latitude: "N.A.",
                                     longitude: "N.A.",
                                     gender: String(cell.txtGender.text!),
                                     fee_Paid_for_M_card:String(self.strUserPaidOrNot),
                                     address:String(cell.txtAddress.text!))
            
            
            print(params as Any)
            
            /*
             AddPatient(action: "registration", addedBy: "108", medicalCardID: "X6W5-85F0-N74F-J4X1", fullName: "iFirstName", middleName: "iMiddleName", lastName: "iLastName", dob: "Sep-16-2021", username: "iUserName", email: "iEmail@gmail.com", contactNumber: "iPhoneNumber", password: "123456", city: "iCity", height: "iHeight", eyeColor: "iEyecolor", zipCode: "N.A.", countryId: "India", device: "iOS", role: "Patient", latitude: "N.A.", longitude: "N.A.", gender: "Prefer not to say", fee_Paid_for_M_card: "1")
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
                            strSuccess = (JSON["status"]as Any as? String)?.lowercased()
                            print(strSuccess as Any)
                            if strSuccess == String("success") {
                                print("yes")
                                
                                ERProgressHud.sharedInstance.hide()
                                
                                // var dict: Dictionary<AnyHashable, Any>
                                // dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                
                                if self.strProfileForEdit == "yes" {
                                    
                                } else {
                                    
                                    var strSuccess : String!
                                    strSuccess = (JSON["msg"]as Any as? String)
                                    
                                    let alert = NewYorkAlertController(title: "Success", message: String(strSuccess), style: .alert)

                                    alert.addImage(UIImage.gif(name: "success3"))
                                    
                                    let cancel = NewYorkButton(title: "Ok", style: .cancel) { _ in
                                         self.navigationController?.popViewController(animated: true)
                                    }
                                    alert.addButtons([cancel])

                                    self.present(alert, animated: true)
                                    
                                    
                                }
                                
                                /*
                                 let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MedicalHistoryVC") as? MedicalHistoryVC
                                 push!.getPatientRegistrationDetails = dict as NSDictionary?
                                 self.navigationController?.pushViewController(push!, animated: true)
                                 */
                                
                                
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
    
    @objc func editPatientWB() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! AddNewPatientTableViewCell
        /*
         if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
             // let str:String = person["role"] as! String
             
             let x : Int = person["userId"] as! Int
             let myString = String(x)
             
             let indexPath = IndexPath.init(row: 0, section: 0)
             let cell = self.tablView.cellForRow(at: indexPath) as! AddNewPatientTableViewCell
             
             var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
             urlRequest.httpMethod = "POST"
             urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
             
             
             
             //Set Your Parameter
             let parameterDict = NSMutableDictionary()
             
             if self.strProfileForEdit == "yes" {
                 
                 ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Updating...")
                 parameterDict.setValue("editProfile", forKey: "action")
                 
             } else {
                 
                 ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
                 parameterDict.setValue("registration", forKey: "action")
                 parameterDict.setValue(String(cell.txtPassword.text!), forKey: "password")
                 
             }
             
             if (person["role"] as! String) == "Hospital" {
                 
                 let x2 : Int = self.getAllDetails["userId"] as! Int
                 let myString2 = String(x2)
                 
                 parameterDict.setValue(String(myString), forKey: "addedBy")
                 parameterDict.setValue(String(myString2), forKey: "userId")
                 
             } else {
                 
                 parameterDict.setValue(String(myString), forKey: "addedBy")
             }
         */
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Updating...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let x2 : Int = self.getAllDetails["userId"] as! Int
            let myString2 = String(x2)
            
            let params =  EditPatient(action: "editProfile",
                                     addedBy: String(myString),
                                      userId: String(myString2),
                                     registeredDt: String(cell.txtDateOfReg.text!),
                                     medicalCardID: String(cell.txtUID.text!),
                                     fullName: String(cell.txtFirstName.text!),
                                     middleName: String(cell.txtMiddleName.text!),
                                     lastName: String(cell.txtLastName.text!),
                                     dob: String(cell.txtDob.text!),
                                     username: String(cell.txtUserName.text!),
                                     email: String(cell.txtEmail.text!),
                                     contactNumber: String(cell.txtPhoneNumber.text!),
                                     password: String(cell.txtPassword.text!),
                                     city: String(cell.txtCity.text!),
                                     height: String(cell.txtHeight.text!),
                                     eyeColor: String(cell.txtEyeColor.text!),
                                     securityNumber: String(cell.txtPinNumber.text!),
                                     zipCode: String("N.A."),
                                     countryId: String(self.saveCountryId),
                                     device: MY_DEVICE,
                                     role: "Patient",
                                     latitude: "N.A.",
                                     longitude: "N.A.",
                                     gender: String(cell.txtGender.text!),
                                     fee_Paid_for_M_card:String(self.strUserPaidOrNot),
                                      address:String(cell.txtAddress.text!))
            
            
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
                                
                               if self.strProfileForEdit == "yes" {
                                   
                                   let alert = UIAlertController(title: String("Success").uppercased(), message: String(strSuccess2), preferredStyle: .alert)
                                   
                                   alert.addAction(UIAlertAction(title: "Edit Medical History", style: .default, handler: { action  in
                                       
                                       let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MedicalHistoryVC") as? MedicalHistoryVC
                                       
                                       push!.getPatientRegistrationDetails = dict as NSDictionary?
                                       
                                       self.navigationController?.pushViewController(push!, animated: true)
                                   }))
                                   
                                   alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { action  in
                                       
                                   }))
                                   
                                   self.present(alert, animated: true)
                                   
                               } else {
                                   
                                   let alert = UIAlertController(title: String("Success").uppercased(), message: String(strSuccess2), preferredStyle: .alert)
                                   
                                   /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MedicalHistoryVC") as? MedicalHistoryVC
                                   push!.getPatientRegistrationDetails = dict as NSDictionary?
                                   self.navigationController?.pushViewController(push!, animated: true)*/
                                   
                                   alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action  in
                                       
                                   }))
                                   
                                   self.present(alert, animated: true)
                                   
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
    
    
    
    
    
    @objc func cellTappedMethod1(_ sender:AnyObject) {
        print("you tap image number: \(sender.view.tag)")
        
        let alert = UIAlertController(title: "Upload Profile Image", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            print("User click Approve button")
            self.openCamera1()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default , handler:{ (UIAlertAction)in
            print("User click Edit button")
            self.openGallery1()
        }))
        
        alert.addAction(UIAlertAction(title: "In-Appropriate terms", style: .default , handler:{ (UIAlertAction)in
            print("User click Delete button")
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }
    
    @objc func openCamera1() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera;
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    @objc func openGallery1() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary;
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
         let indexPath = IndexPath.init(row: 0, section: 0)
         let cell = self.tablView.cellForRow(at: indexPath) as! AddNewPatientTableViewCell
        
        let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        cell.imgUploadBg.image = image_data // show image on profile
        let imageData:Data = image_data!.pngData()!
        self.imageStr = imageData.base64EncodedString()
        self.dismiss(animated: true, completion: nil)
        self.imgData = image_data!.jpegData(compressionQuality: 0.2)!
         
        
        self.imageStr = "1"
        
    }
    
    @objc func addPatientWithImage() {
        
        //Set Your URL
        let api_url = APPLICATION_BASE_URL
        guard let url = URL(string: api_url) else {
            return
        }
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // let str:String = person["role"] as! String
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let indexPath = IndexPath.init(row: 0, section: 0)
            let cell = self.tablView.cellForRow(at: indexPath) as! AddNewPatientTableViewCell
            
            var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            
            
            // print(self.getAllDetails as Any)
            
            //Set Your Parameter
            let parameterDict = NSMutableDictionary()
            
            if self.strProfileForEdit == "yes" {
                
                ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Updating...")
                parameterDict.setValue("editProfile", forKey: "action")
                
                let x2 : Int = self.getAllDetails["userId"] as! Int
                let myString2 = String(x2)
                parameterDict.setValue(String(myString2), forKey: "userId")
                
            } else {
                
                ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
                parameterDict.setValue("registration", forKey: "action")
                parameterDict.setValue(String(cell.txtPassword.text!), forKey: "password")
                
            }
            
            if (person["role"] as! String) == "Hospital" {
                
                if self.strProfileForEdit == "yes" {
                    
                    let x2 : Int = self.getAllDetails["userId"] as! Int
                    let myString2 = String(x2)
                    parameterDict.setValue(String(myString2), forKey: "userId")
                    
                }
                
                parameterDict.setValue(String(myString), forKey: "addedBy")
                
            } else {
                
                parameterDict.setValue(String(myString), forKey: "addedBy")
            }
            
            parameterDict.setValue(String(cell.txtDateOfReg.text!), forKey: "registeredDt")
            parameterDict.setValue(String(cell.txtHeight.text!), forKey: "height")
            parameterDict.setValue(String(cell.txtUID.text!), forKey: "medicalCardID")
            parameterDict.setValue(String(cell.txtFirstName.text!), forKey: "fullName")
            parameterDict.setValue(String(cell.txtMiddleName.text!), forKey: "middleName")
            parameterDict.setValue(String(cell.txtLastName.text!), forKey: "lastName")
            parameterDict.setValue(String(cell.txtUserName.text!), forKey: "username")
            parameterDict.setValue(String(cell.txtDob.text!), forKey: "dob")
            parameterDict.setValue(String(cell.txtEmail.text!), forKey: "email")
            parameterDict.setValue(String(cell.txtPhoneNumber.text!), forKey: "contactNumber")
            parameterDict.setValue(String(cell.txtCity.text!), forKey: "city")
            parameterDict.setValue(String(cell.txtEyeColor.text!), forKey: "eyeColor")
            parameterDict.setValue(String("N.A."), forKey: "zipCode")
            parameterDict.setValue(String(self.saveCountryId), forKey: "countryId")
            parameterDict.setValue(MY_DEVICE, forKey: "device")
            parameterDict.setValue(String("Patient"), forKey: "role")
            parameterDict.setValue("N.A.", forKey: "latitude")
            parameterDict.setValue("N.A.", forKey: "longitude")
            parameterDict.setValue(String(cell.txtGender.text!), forKey: "gender")
            parameterDict.setValue(String(self.strUserPaidOrNot), forKey: "fee_Paid_for_M_card")
            parameterDict.setValue(String(cell.txtPinNumber.text!), forKey: "securityNumber")
            parameterDict.setValue(String(cell.txtAddress.text!), forKey: "address")
            
            print(parameterDict as Any)
            
            //Set Image Data
            // let imgData = self.img_photo.image!.jpegData(compressionQuality: 0.5)!
            
            /*
             let params =  AddPatient(action: "registration",
             addedBy: String(myString),
             medicalCardID: String(cell.txtUID.text!),
             fullName: String(cell.txtFirstName.text!),
             middleName: String(cell.txtMiddleName.text!),
             lastName: String(cell.txtLastName.text!),
             dob: String(cell.txtDob.text!),
             username: String(cell.txtUserName.text!),
             email: String(cell.txtEmail.text!),
             contactNumber: String(cell.txtPhoneNumber.text!),
             password: String(cell.txtPassword.text!),
             city: String(cell.txtCity.text!),
             height: String(cell.txtHeight.text!),
             eyeColor: String(cell.txtEyeColor.text!),
             zipCode: String("N.A."),
             countryId: String(cell.txtCountryName.text!),
             device: MY_DEVICE,
             role: "Patient",
             latitude: "N.A.",
             longitude: "N.A.",
             gender: "")
             */
            // Now Execute
            
            AF.upload(multipartFormData: { multiPart in
                for (key, value) in parameterDict {
                    if let temp = value as? String {
                        multiPart.append(temp.data(using: .utf8)!, withName: key as! String)
                    }
                    if let temp = value as? Int {
                        multiPart.append("\(temp)".data(using: .utf8)!, withName: key as! String)
                    }
                    if let temp = value as? NSArray {
                        temp.forEach({ element in
                            let keyObj = key as! String + "[]"
                            if let string = element as? String {
                                multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                            } else
                            if let num = element as? Int {
                                let value = "\(num)"
                                multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                            }
                        })
                    }
                }
                multiPart.append(self.imgData, withName: "image", fileName: "DoctorProfilePicture.png", mimeType: "image/png")
            }, with: urlRequest)
            .uploadProgress(queue: .main, closure: { progress in
                //Current upload progress of file
                print("Upload Progress: \(progress.fractionCompleted)")
            })
            .responseJSON(completionHandler: { data in
                
                switch data.result {
                
                case .success(_):
                    do {
                        
                        let dictionary = try JSONSerialization.jsonObject(with: data.data!, options: .fragmentsAllowed) as! NSDictionary
                        
                        print("Success!")
                        print(dictionary)
                        
                        
                        ERProgressHud.sharedInstance.hide()
                        self.imageStr = "0"
                        
                         var strSuccess2 : String!
                         strSuccess2 = dictionary["msg"]as Any as? String
                        
                        var strSuccess : String!
                        strSuccess = dictionary["status"]as Any as? String
                        
                        if strSuccess == "Fails" {
                            
                            let alert = UIAlertController(title: String("Error"), message: String("Something went wrong. Please try again after some time."), preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action  in
                                self.btnNavigationBackPress()
                            }))
                            
                            self.present(alert, animated: true)
                            
                        } else {
                            
                            var dict: Dictionary<AnyHashable, Any>
                            dict = dictionary["data"] as! Dictionary<AnyHashable, Any>
                            
                            if self.strProfileForEdit == "yes" {
                                
                                let alert = UIAlertController(title: String("Success").uppercased(), message: String(strSuccess2), preferredStyle: .alert)
                                
                                alert.addAction(UIAlertAction(title: "Edit Medical History", style: .default, handler: { action  in
                                    
                                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MedicalHistoryVC") as? MedicalHistoryVC
                                    
                                    push!.getPatientRegistrationDetails = dict as NSDictionary?
                                    
                                    self.navigationController?.pushViewController(push!, animated: true)
                                }))
                                
                                alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { action  in
                                    
                                }))
                                
                                self.present(alert, animated: true)
                                
                            } else {
                                
                                let alert = UIAlertController(title: String("Success").uppercased(), message: String(strSuccess2), preferredStyle: .alert)
                                
                                /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MedicalHistoryVC") as? MedicalHistoryVC
                                push!.getPatientRegistrationDetails = dict as NSDictionary?
                                self.navigationController?.pushViewController(push!, animated: true)*/
                                
                                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action  in
                                    self.btnNavigationBackPress()
                                }))
                                
                                self.present(alert, animated: true)
                                
                            }
                            
                        }
                        
                        
                        
                    }
                    catch {
                        // catch error.
                        print("catch error")
                        ERProgressHud.sharedInstance.hide()
                    }
                    break
                    
                case .failure(_):
                    print("failure")
                    ERProgressHud.sharedInstance.hide()
                    break
                    
                }
                
                
            })
            
        }}
    
}

extension AddNewPatientVC:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:AddNewPatientTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell") as! AddNewPatientTableViewCell
        cell.backgroundColor = .white
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.btnDor.addTarget(self, action: #selector(btnDorPress), for: .touchUpInside)
        cell.btnDOB.addTarget(self, action: #selector(btnDOBPress), for: .touchUpInside)
        cell.btnGender.addTarget(self, action: #selector(btnGenderPress), for: .touchUpInside)
        cell.btnCountry.addTarget(self, action: #selector(btnCountryPress), for: .touchUpInside)
        
        cell.btnAddMedicalHistory.addTarget(self, action: #selector(btnAddMedicalHistoryPress), for: .touchUpInside)
        
        cell.btnSubmit.addTarget(self, action: #selector(validationBeforeAddPatient), for: .touchUpInside)
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(AddNewPatientVC.cellTappedMethod1(_:)))
        cell.imgUploadBg.isUserInteractionEnabled = true
        cell.imgUploadBg.addGestureRecognizer(tapGestureRecognizer1)
        
        cell.btnCheckUnchek.tag = 0
        cell.btnCheckUnchek.addTarget(self, action: #selector(checkUncheckPaid), for: .touchUpInside)
        cell.txtCountryName.textColor = .clear
        /*
         address = "";
         city = Mann;
         contactNumber = 873456789;
         countryId = "";
         department = "";
         description = "";
         device = iOS;
         deviceToken = "";
         dob = "Sep-15-2021";
         email = "mann@gmail.com";
         eyeColor = "dads ";
         firebaseId = "";
         fullName = van;
         gender = Male;
         height = "";
         image = "https://demo4.evirtualservices.net/ehealth/img/uploads/users/1631687974DoctorProfilePicture.png";
         lastName = vbvb;
         latitude = "N.A.";
         longitude = "N.A.";
         medicalCardID = "0JY2-Q76K-03KY-50RC";
         middleName = Ben;
         practiceDate = "";
         registeredDt = "";
         role = Patient;
         socialId = "";
         socialType = "";
         specialty = "";
         state = "";
         status = 1;
         userId = 136;
         zipCode = "N.A.";
         */
        
        if self.strProfileForEdit == "yes" {
                
            // let indexPath = IndexPath.init(row: 0, section: 0)
            // let cell = self.tablView.cellForRow(at: indexPath) as! AddNewPatientTableViewCell
                
            cell.btnSubmit.setTitle("Update", for: .normal)
            cell.btnAddMedicalHistory.setTitle("Edit Medical History", for: .normal)
            
             print(self.getAllDetails as Any)
            /*
                 address = ramprastha;
                 city = Ghaziabad;
                 contactNumber = 9845464626222;
                 country = India;
                 department = "";
                 description = "";
                 device = Android;
                 deviceToken = "";
                 dob = "10 Sep, 2004";
                 email = "maxx@mailinator.com";
                 eyeColor = black;
                 firebaseId = "";
                 fullName = Maxx;
                 gender = Gender;
                 height = "5'1";
                 image = "https://demo4.evirtualservices.net/ehealth/img/uploads/users/1632223019images(12).jpeg";
                 lastName = one;
                 latitude = "28.6634131";
                 longitude = "77.3239693";
                 medicalCardID = "91PX-205M-2E60-P39Z";
                 middleName = new;
                 practiceDate = "";
                 registeredDt = "21 Sep, 2021";
                 role = Patient;
                 socialId = "";
                 socialType = "";
                 specialty = "";
                 state = "";
                 status = 1;
                 userId = 187;
                 zipCode = 201011;
             
             cell.btnCheckUnchek.setImage(UIImage(named: "check5"), for: .normal)
             
             btn.tag = 1
             
         } else if btn.tag == 1 {
             
             self.strUserPaidOrNot = "0"
             
             cell.btnCheckUnchek.setImage(UIImage(named: "unchecked5"), for: .normal)
             
             */
            
            if self.getAllDetails["fee_Paid_for_M_card"] is String {
                              
                print("Yes, it's a String")
              
                if (self.getAllDetails["fee_Paid_for_M_card"] as! String) == "1" {
                    
                    cell.btnCheckUnchek.setImage(UIImage(named: "check5"), for: .normal)
                    
                } else {
                    
                    cell.btnCheckUnchek.setImage(UIImage(named: "unchecked5"), for: .normal)
                    
                }
                
            } else if self.getAllDetails["fee_Paid_for_M_card"] is Int {
                
                let x : Int = (self.getAllDetails["fee_Paid_for_M_card"] as! Int)
                let myString = String(x)
                
                if myString == "1" {
                    
                    cell.btnCheckUnchek.setImage(UIImage(named: "check5"), for: .normal)
                    
                } else {
                    
                    cell.btnCheckUnchek.setImage(UIImage(named: "unchecked5"), for: .normal)
                    
                }
                
            }
            
            
            cell.txtDateOfReg.text = (self.getAllDetails["registeredDt"] as! String)
            
            cell.txtUID.text = (self.getAllDetails["medicalCardID"] as! String)
            cell.txtUID.isUserInteractionEnabled = false
            
            cell.txtFirstName.text = (self.getAllDetails["fullName"] as! String)
            cell.txtMiddleName.text = (self.getAllDetails["middleName"] as! String)
            cell.txtLastName.text = (self.getAllDetails["lastName"] as! String)
            cell.txtNickName.text = (self.getAllDetails["fullName"] as! String)
            
            cell.txtDob.text = (self.getAllDetails["dob"] as! String)
            
            cell.txtAddress.text = (self.getAllDetails["address"] as! String)
            cell.txtCity.text = (self.getAllDetails["city"] as! String)
            cell.txtCountryName.text = (self.getAllDetails["country"] as! String)
            cell.txtCountryName.textColor = .black
            
            if self.getAllDetails["countryId"] is String {
                              
                print("Yes, it's a String")
              
                self.saveCountryId = (self.getAllDetails["countryId"] as! String)
                
            } else if self.getAllDetails["countryId"] is Int {
                
                let x22 : Int = (self.getAllDetails["countryId"] as! Int)
                let myString22 = String(x22)
                
                self.saveCountryId = String(myString22) // save country id
            }
            
            
            
            
            
            cell.txtGender.text = (self.getAllDetails["gender"] as! String)
            
            cell.txtHeight.text = (self.getAllDetails["height"] as! String)
            cell.txtEyeColor.text = (self.getAllDetails["eyeColor"] as! String)
            
            cell.txtPinNumber.text = (self.getAllDetails["eyeColor"] as! String)
            
            cell.txtUserName.text = (self.getAllDetails["fullName"] as! String)
            cell.txtPhoneNumber.text = (self.getAllDetails["contactNumber"] as! String)
            
            cell.txtEmail.text = (self.getAllDetails["email"] as! String)
            cell.txtEmail.isUserInteractionEnabled = false
            
            cell.txtPassword.text = "******"
            cell.txtConfirmPassword.text = "******"
            cell.txtPassword.isUserInteractionEnabled = false
            cell.txtConfirmPassword.isUserInteractionEnabled = false
            
            
            cell.imgUploadBg.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.imgUploadBg.sd_setImage(with: URL(string: (self.getAllDetails["image"] as! String)), placeholderImage: UIImage(named: "1024"))
            
            
        }
        
        
        return cell
    }
    
    @objc func checkUncheckPaid(_ sender:UIButton) {
         let indexPath = IndexPath.init(row: 0, section: 0)
         let cell = self.tablView.cellForRow(at: indexPath) as! AddNewPatientTableViewCell
        
        let btn:UIButton = sender
        
        if btn.tag == 0 {
            
            self.strUserPaidOrNot = "1"
            
            cell.btnCheckUnchek.setImage(UIImage(named: "check5"), for: .normal)
            
            btn.tag = 1
            
        } else if btn.tag == 1 {
            
            self.strUserPaidOrNot = "0"
            
            cell.btnCheckUnchek.setImage(UIImage(named: "unchecked5"), for: .normal)
            
            btn.tag = 0
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 2400
    }
    
    @objc func btnGenderPress() {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! AddNewPatientTableViewCell
        
        let dummyList = ["Male", "Female", "Prefer not to say"]
        RPicker.selectOption(title: "Gender", cancelText: "Cancel", dataArray: dummyList, selectedIndex: 0) {[] (selctedText, atIndex) in
            // TODO: Your implementation for selection
            cell.txtGender.text = selctedText
        }
        
    }
    
    @objc func btnDOBPress(){
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! AddNewPatientTableViewCell
        
        RPicker.selectDate(title: "Select DOB", didSelectDate: {[] (selectedDate) in
            // TODO: Your implementation for date
            cell.txtDob.text = selectedDate.dateString("MMM-dd-YYYY")
        })
    }
    
    @objc func btnDorPress(){
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! AddNewPatientTableViewCell
        
        RPicker.selectDate(title: "Select Date of Reg.", didSelectDate: {[] (selectedDate) in
            // TODO: Your implementation for date
            cell.txtDateOfReg.text = selectedDate.dateString("MMM-dd-YYYY")
        })
    }
    
    
    
    @objc func btnCountryPress(_ sender: UIButton) {
        
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! AddNewPatientTableViewCell
        
        let redAppearance = YBTextPickerAppearanceManager.init(
            pickerTitle         : "Select Country",
            titleFont           : boldFont,
            titleTextColor      : .white,
            titleBackground     : sender.backgroundColor,
            searchBarFont       : regularFont,
            searchBarPlaceholder: "Search Country",
            closeButtonTitle    : "Cancel",
            closeButtonColor    : .darkGray,
            closeButtonFont     : regularFont,
            doneButtonTitle     : "Okay",
            doneButtonColor     : sender.backgroundColor,
            doneButtonFont      : boldFont,
            checkMarkPosition   : .Right,
            itemCheckedImage    : UIImage(named:"red_ic_checked"),
            itemUncheckedImage  : UIImage(named:"red_ic_unchecked"),
            itemColor           : .black,
            itemFont            : regularFont
        )
        
        //let arrGender = ["Male", "Female", "Prefer not to Say"]
        
        let item = countryListArray.mutableArrayValue(forKey: "name")
        
        
        let item2 = countryListArray.mutableArrayValue(forKey: "id")
        
        //print(item as Any)
        
        let picker = YBTextPicker.init(with: item as! [String], appearance: redAppearance,onCompletion: { [self] (selectedIndexes, selectedValues) in
            
            if let selectedValue = selectedValues.first{
                
                cell.txtCountryName.text = "\(selectedValue)"
                cell.txtCountryName.textColor = .black
                
                myStr = selectedValue
                
                
                // print(myStr)
                
                for index in 0..<countryListArray.count {
                    
                    let itm = countryListArray[index] as? [String:Any]
                    
                    let name = (itm!["name"] as! String)
                    
                    //print(name)
                    
                    if myStr == (itm!["name"] as! String){
                        
                        print("selected index = \(countryListArray[index])")
                        
                        countryId = String((itm!["id"] as! Int))
                        
                        self.saveCountryId = countryId
                    }
                }
                
            }
            else {
                cell.btnCountry.setTitle("Select Country", for: .normal)
                
            }
        },
                                       onCancel: {
            
            print("Cancelled")
        }
                                       
        )
        
        
        picker.show(withAnimation: .FromBottom)
        
    }
    
    @objc func countryListWebService(){
        
        
        let params =
            countryListWeb(action: "countrylist")
                        
            
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
                            
            if strSuccess == String("success") {
                    
                print("yes")
                                
                var ar : NSArray!
                 ar = (JSON["data"] as! Array<Any>) as NSArray
                  self.countryListArray.addObjects(from: ar as! [Any])
    
                
            }
    else{
            print("no")
                                
    }
    case let .failure(error):
        
            print(error)
                        }
                        
            }
            
        }
    
    @objc func btnAddMedicalHistoryPress() {
        
        if self.strProfileForEdit == "yes" {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MedicalHistoryVC") as? MedicalHistoryVC
            push!.getPatientRegistrationDetails = self.getAllDetails
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        
    }
}
