//
//  HPAddNewDoctorVC.swift
//  E health App
//
//  Created by Ranjan on 02/09/21.
//

import UIKit
import Alamofire
import SDWebImage

class HPAddNewDoctorVC: UIViewController , UINavigationControllerDelegate , UIImagePickerControllerDelegate {
    
    let regularFont = UIFont.systemFont(ofSize: 16)
    let boldFont = UIFont.boldSystemFont(ofSize: 16)
    
    var strFromWhichProfile:String!
    
    var strProfileForEdit:String!
    var getAllDetails:NSDictionary!
    var imageStr:String! = "0"
    var imgData:Data!
    
    var myStr = ""
    var myStr2 = ""
    var countryId = ""
    var hospitalClinicUserId = ""
    var countryListArray:NSMutableArray = []
    var hospitalClinicListArray:NSMutableArray = []
    
    var strSaveSelectedCountryId:String! = "0"
    
    @IBOutlet weak var viewNavigationBar:UIView!
    @IBOutlet weak var btnNaviagtionBack:UIButton!
    @IBOutlet weak var lblNavigationBar:UILabel!{
        didSet {
            
            lblNavigationBar.text = "ADD NEW DOCTOR"
        }
    }
    
    @IBOutlet weak var viewBtnBG:UIView!{
        didSet{
            viewBtnBG.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var imgUploadBg:UIImageView!{
        didSet{
            // imgUploadBg.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            // imgUploadBg.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            // imgUploadBg.layer.shadowOpacity = 1.0
            // imgUploadBg.layer.shadowRadius = 15.0
            // imgUploadBg.layer.masksToBounds = false
            imgUploadBg.layer.cornerRadius = 12
            imgUploadBg.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btnImageUpload:UIButton!
    
    @IBOutlet weak var tablView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tablView.delegate = self
        tablView.dataSource = self
        tablView.reloadData()
        
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .white
        self.tablView.backgroundColor = .white
        
        self.btnNaviagtionBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
         // print(self.getDoctorDetails as Any)
        
        // image one
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(HPAddNewDoctorVC.cellTappedMethod1(_:)))
        
        self.imgUploadBg.isUserInteractionEnabled = true
        self.imgUploadBg.addGestureRecognizer(tapGestureRecognizer1)
        
        
        
        if self.strFromWhichProfile == "FromHospitalForDoctors" { // doctors
            lblNavigationBar.text = "ADD NEW DOCTOR"
        } else if self.strFromWhichProfile == "FromHospitalForLabs" { // labs
            lblNavigationBar.text = "ADD NEW LAB"
        } else if self.strFromWhichProfile == "FromHospitalForPharmacy" { // pharmcy
            lblNavigationBar.text = "ADD NEW PHARMCY"
        } else if self.strFromWhichProfile == "FromHospitalForPatient" { // pharmcy
            lblNavigationBar.text = "ADD NEW PATIENT"
        }
        
        self.countryListWebSer()
        
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func validationBeforeAddOrEditDoctor() {
        
        
        
        
        
        if self.strFromWhichProfile == "FromHospitalForDoctors" { // doctors
            lblNavigationBar.text = "ADD NEW DOCTOR"
            
            if self.strProfileForEdit == "yes" { // for edit
                
                if self.imageStr == "1" {
                    self.addDataWithImage(strRole: "Doctor")
                } else {
                    self.editNewData(strRole: "Doctor")
                }
                
                
            } else if self.imageStr == "0" { // for add
                
                self.addNewData(strRole: "Doctor")
                
            } else {
                
                self.addDataWithImage(strRole: "Doctor")
                
            }
            
            
            
            
            
        } else if self.strFromWhichProfile == "FromHospitalForLabs" { // labs
            lblNavigationBar.text = "ADD NEW LAB"
            if self.strProfileForEdit == "yes" { // for edit
                
                self.editNewData(strRole: "Lab")
                
            } else if self.imageStr == "0" { // for add
                
                self.addNewData(strRole: "Lab")
                
            } else {
                
                self.addDataWithImage(strRole: "Lab")
                
            }
            
            
        } else if self.strFromWhichProfile == "FromHospitalForPharmacy" { // PHARMACY
            lblNavigationBar.text = "ADD NEW PHARMACY"
            if self.strProfileForEdit == "yes" { // for edit
                
                self.editNewData(strRole: "Pharmacy")
                
            } else if self.imageStr == "0" { // for add
                
                self.addNewData(strRole: "Pharmacy")
                
            } else {
                
                self.addDataWithImage(strRole: "Pharmacy")
                
            }
            
            
        }
        
        
        
    }
    
    @objc func addNewData(strRole:String) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! HPAddNewDoctorTableViewCell
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "adding...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            
            let params =  AddDoctors(action: "registration",
                                     addedBy: String(myString),
                                     username: String(cell.txtDoctorName.text!),
                                     fullName: String(cell.txtDoctorName.text!),
                                     email: String(cell.txtDoctorEmail.text!),
                                     contactNumber: String(cell.txtDoctorPhone.text!),
                                     password: String(cell.txtDoctorPassword.text!),
                                     address: String(cell.txtDoctorAddress.text!),
                                     practiceDate: String(cell.txtDoctorPracticeStartDate.text!),
                                     department: String(cell.txtDoctorDepartment.text!),
                                     specialty: String(cell.txtDoctorSpeciality.text!),
                                     device: MY_DEVICE,
                                     role: String(strRole),
                                     latitude: "",
                                     longitude: "",
                                     countryId: String(self.strSaveSelectedCountryId))
            
            
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
                            self.backClickMethod()
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
    
    @objc func editNewData(strRole:String) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! HPAddNewDoctorTableViewCell
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "updating...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            // doctor id
            let x2 : Int = self.getAllDetails["userId"] as! Int
            let myString2 = String(x2)
            
            
            let params =  EditDoctors(action: "editProfile",
                                      addedBy: String(myString),
                                      userId: String(myString2),
                                      username: String(cell.txtDoctorName.text!),
                                      fullName: String(cell.txtDoctorName.text!),
                                      email: String(cell.txtDoctorEmail.text!),
                                      contactNumber: String(cell.txtDoctorPhone.text!),
                                      password: String(cell.txtDoctorPassword.text!),
                                      address: String(cell.txtDoctorAddress.text!),
                                      practiceDate: String(cell.txtDoctorPracticeStartDate.text!),
                                      department: String(cell.txtDoctorDepartment.text!),
                                      specialty: String(cell.txtDoctorSpeciality.text!),
                                      device: MY_DEVICE,
                                      role: String(strRole),
                                      latitude: "",
                                      longitude: "",
                                      countryId:String(self.strSaveSelectedCountryId)
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
                    strSuccess = (JSON["status"]as Any as? String)?.lowercased()
                    print(strSuccess as Any)
                    if strSuccess == String("success") {
                        print("yes")
                        
                        ERProgressHud.sharedInstance.hide()
                        
                        var strSuccess2 : String!
                        strSuccess2 = JSON["msg"]as Any as? String
                        
                        let alert = UIAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action  in
                            self.backClickMethod()
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
        
        // let indexPath = IndexPath.init(row: 0, section: 0)
        // let cell = self.tablView.cellForRow(at: indexPath) as! HPAddNewDoctorTableViewCell
        
        self.imgUploadBg.isHidden = false
        let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.imgUploadBg.image = image_data // show image on profile
        let imageData:Data = image_data!.pngData()!
        self.imageStr = imageData.base64EncodedString()
        self.dismiss(animated: true, completion: nil)
        self.imgData = image_data!.jpegData(compressionQuality: 0.2)!
        //print(type(of: imgData)) // data
        
        self.imageStr = "1"
        
        
        // self.uploadDataWithImage()
    }
    
    @objc func addDataWithImage(strRole:String) {
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
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
            let cell = self.tablView.cellForRow(at: indexPath) as! HPAddNewDoctorTableViewCell
            
            var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            
            //Set Your Parameter
            let parameterDict = NSMutableDictionary()
            parameterDict.setValue("registration", forKey: "action")
            parameterDict.setValue(String(myString), forKey: "addedBy")
            parameterDict.setValue(String(cell.txtDoctorName.text!), forKey: "fullName")
            parameterDict.setValue(String(cell.txtDoctorName.text!), forKey: "fullName")
            parameterDict.setValue(String(cell.txtDoctorEmail.text!), forKey: "email")
            parameterDict.setValue(String(cell.txtDoctorPhone.text!), forKey: "contactNumber")
            parameterDict.setValue(String(cell.txtDoctorPassword.text!), forKey: "password")
            parameterDict.setValue(String(cell.txtDoctorAddress.text!), forKey: "address")
            parameterDict.setValue(String(cell.txtDoctorPracticeStartDate.text!), forKey: "practiceDate")
            parameterDict.setValue(String(cell.txtDoctorDepartment.text!), forKey: "department")
            parameterDict.setValue(String(cell.txtDoctorSpeciality.text!), forKey: "specialty")
            parameterDict.setValue(String(MY_DEVICE), forKey: "device")
            parameterDict.setValue(String(strRole), forKey: "role")
            parameterDict.setValue(String(""), forKey: "latitude")
            parameterDict.setValue(String(""), forKey: "longitude")
            parameterDict.setValue(String(self.strSaveSelectedCountryId), forKey: "countryId")
        
            
            //Set Image Data
            // let imgData = self.img_photo.image!.jpegData(compressionQuality: 0.5)!
            
            /*
             let params = EditUserWithoutImage(action: "editprofile",
             userId: String(myString),
             fullName: String(cell.txtUsername.text!),
             contactNumber: String(cell.txtPhoneNumber.text!),
             address: String(cell.txtAddress.text!))
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
                            
                            // var strSuccess2 : String!
                            // strSuccess2 = dictionary["msg"]as Any as? String
                            
                            let alert = UIAlertController(title: String("Success").uppercased(), message: String("Data saved Successfully"), preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action  in
                                self.backClickMethod()
                            }))
                            
                            self.present(alert, animated: true)
                            
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
    
    @objc func countryListWebSer() {
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please Wait...")
        
        let params = countryListWeb(action: "countrylist")
        
        
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
                
                if strSuccess == String("success") {
                    
                    print("yes")
                    ERProgressHud.sharedInstance.hide()
                    var ar : NSArray!
                    ar = (JSON["data"] as! Array<Any>) as NSArray
                    self.countryListArray.addObjects(from: ar as! [Any])
                    
                    
                }
                else {
                    print("no")
                    ERProgressHud.sharedInstance.hide()
                    
                }
            case let .failure(error):
                
                print(error)
                ERProgressHud.sharedInstance.hide()
            }
            
        }
        
    }
    
    
    @objc func btnCountryPress() {
        
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! HPAddNewDoctorTableViewCell
        
        let redAppearance = YBTextPickerAppearanceManager.init(
            pickerTitle         : "Select Country",
            titleFont           : boldFont,
            titleTextColor      : .white,
            titleBackground     : .systemTeal,
            searchBarFont       : regularFont,
            searchBarPlaceholder: "Search Country",
            closeButtonTitle    : "Cancel",
            closeButtonColor    : .darkGray,
            closeButtonFont     : regularFont,
            doneButtonTitle     : "Okay",
            doneButtonColor     : .systemTeal,
            doneButtonFont      : boldFont,
            checkMarkPosition   : .Right,
            itemCheckedImage    : UIImage(named:"red_ic_checked"),
            itemUncheckedImage  : UIImage(named:"red_ic_unchecked"),
            itemColor           : .blue,
            itemFont            : regularFont
        )
        
        //let arrGender = ["Male", "Female", "Prefer not to Say"]
        
        let item = countryListArray.mutableArrayValue(forKey: "name")
        
        
        // let item2 = countryListArray.mutableArrayValue(forKey: "id")
        
        //print(item as Any)
        
        let picker = YBTextPicker.init(with: item as! [String], appearance: redAppearance,onCompletion: { [self] (selectedIndexes, selectedValues) in
            
            if let selectedValue = selectedValues.first{
                
                cell.btnCountry.setTitle("\(selectedValue)", for: .normal)
                cell.btnCountry.setTitleColor(.clear, for: .normal)
                
                cell.txtCountry.text = "\(selectedValue)"
                
                myStr = selectedValue
                
                
                // print(myStr)
                
                for index in 0..<countryListArray.count {
                    
                    let itm = countryListArray[index] as? [String:Any]
                    
                    // let name = (itm!["name"] as! String)
                    
                    //print(name)
                    
                    if myStr == (itm!["name"] as! String) {
                        
                        print("selected index = \(countryListArray[index])")
                        
                        countryId = String((itm!["id"] as! Int))
                        
                        print(countryId)
                        
                        // cell.txtCountry.text = countryId
                        cell.txtCountry.textColor = .black
                        
                        self.strSaveSelectedCountryId = String(countryId)
                        
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
    
    
    
}


extension HPAddNewDoctorVC:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:HPAddNewDoctorTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell") as! HPAddNewDoctorTableViewCell
        
        cell.backgroundColor = .white
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        
        cell.selectedBackgroundView = backgroundView
        
        cell.btnDoctorDoctorDepartment.isHidden = true
        cell.btnDoctorDoctorSpeciality.isHidden = true
        
        // cell.btnDoctorDoctorSpeciality.addTarget(self, action: #selector(btnDoctorDoctorSpecialityPress), for: .touchUpInside)
        // cell.btnDoctorDoctorDepartment.addTarget(self, action: #selector(btnDoctorDoctorDepartmentPress), for: .touchUpInside)
        cell.btnDoctorPracticeStartDate.addTarget(self, action: #selector(btnDoctorPracticeStartDatePress), for: .touchUpInside)
        
        cell.btnSubmit.addTarget(self, action: #selector(validationBeforeAddOrEditDoctor), for: .touchUpInside)
        
        
        // for both Doctor and Labs
        if self.strFromWhichProfile == "FromHospitalForDoctors" { // doctors
            
            cell.txtDoctorName.placeholder = "Doctor name"
            cell.txtDoctorDepartment.placeholder = "Department"
            cell.txtDoctorPracticeStartDate.placeholder = "Practice Start Date"
            cell.btnDoctorPracticeStartDate.isHidden = false
            cell.btnCountry.addTarget(self, action: #selector(btnCountryPress), for: .touchUpInside)
            
        } else if self.strFromWhichProfile == "FromHospitalForLabs" { // labs
            
            cell.txtDoctorName.placeholder = "Lab name"
            cell.txtDoctorDepartment.placeholder = "Availaible Time"
            cell.txtDoctorPracticeStartDate.placeholder = "Zipcode"
            cell.btnDoctorPracticeStartDate.isHidden = true
            cell.btnCountry.addTarget(self, action: #selector(btnCountryPress), for: .touchUpInside)
            
        } else if self.strFromWhichProfile == "FromHospitalForPharmacy" { // pharmacy
            
            cell.txtDoctorName.placeholder = "Pharmacy name"
            cell.txtDoctorDepartment.placeholder = "Availaible Time"
            cell.txtDoctorPracticeStartDate.placeholder = "Zipcode"
            cell.btnDoctorPracticeStartDate.isHidden = true
            cell.lblDepartment.text = "Availaible Time"
            cell.lblPracticeStartDate.text = "Zipcode"
            
        }
        
        
        if self.strProfileForEdit == "yes" {
            // self.parseDoctorData()
            
            cell.txtDoctorName.text                 = (self.getAllDetails["fullName"] as! String)
            cell.txtDoctorEmail.text                = (self.getAllDetails["email"] as! String)
            cell.txtDoctorPassword.text                = "******"
            cell.txtDoctorEmail.isUserInteractionEnabled = false
            cell.txtDoctorPassword.isUserInteractionEnabled = false
            cell.txtDoctorPhone.text                = (self.getAllDetails["contactNumber"] as! String)
            cell.txtDoctorAddress.text              = (self.getAllDetails["address"] as! String)
            cell.txtDoctorSpeciality.text           = (self.getAllDetails["specialty"] as! String)
            cell.txtDoctorDepartment.text           = (self.getAllDetails["department"] as! String)
            cell.txtDoctorPracticeStartDate.text    = (self.getAllDetails["practiceDate"] as! String)
            cell.txtCountry.text                    = (self.getAllDetails["country"] as! String)
            
            
            if self.getAllDetails["countryId"] is String {
                              
                print("Yes, it's a String")
              
                self.strSaveSelectedCountryId = (self.getAllDetails["countryId"] as! String)

            } else if self.getAllDetails["countryId"] is Int {
                
                let x : Int = self.getAllDetails["countryId"] as! Int
                let myString = String(x)
                self.strSaveSelectedCountryId = String(myString)
                
            }
            
            
            self.imgUploadBg.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            self.imgUploadBg.sd_setImage(with: URL(string: (self.getAllDetails["image"] as! String)), placeholderImage: UIImage(named: "1024"))
            
        } else {
            cell.txtDoctorEmail.isUserInteractionEnabled = true
            cell.txtDoctorEmail.isUserInteractionEnabled = true
        }
        
        return cell
    }
    
    @objc func parseDoctorData() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! HPAddNewDoctorTableViewCell
        
        cell.txtDoctorName.text = (self.getAllDetails["fullName"] as! String)
        cell.txtDoctorEmail.text = (self.getAllDetails["email"] as! String)
        cell.txtDoctorEmail.text = "******"
        cell.txtDoctorEmail.isUserInteractionEnabled = false
        cell.txtDoctorEmail.isUserInteractionEnabled = false
        cell.txtDoctorPhone.text = (self.getAllDetails["contactNumber"] as! String)
        cell.txtDoctorAddress.text = (self.getAllDetails["address"] as! String)
        cell.txtDoctorSpeciality.text = (self.getAllDetails["fullName"] as! String)
        cell.txtDoctorDepartment.text = (self.getAllDetails["department"] as! String)
        cell.txtDoctorPracticeStartDate.text = (self.getAllDetails["practiceDate"] as! String)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 1200
    }
    
    @objc func btnDoctorDoctorSpecialityPress(){
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! HPAddNewDoctorTableViewCell
        
        let dummyList = ["Gynac", "Surgical", "Phyisican"]
        RPicker.selectOption(title: "Speciality", cancelText: "Cancel", dataArray: dummyList, selectedIndex: 0) {[] (selctedText, atIndex) in
            // TODO: Your implementation for selection
            cell.txtDoctorSpeciality.text = selctedText
        }
        
    }
    
    
    @objc func btnDoctorDoctorDepartmentPress(){
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! HPAddNewDoctorTableViewCell
        
        let dummyList = ["Gynac", "Surgical", "Phyisican"]
        RPicker.selectOption(title: "Speciality", cancelText: "Cancel", dataArray: dummyList, selectedIndex: 0) {[] (selctedText, atIndex) in
            // TODO: Your implementation for selection
            cell.txtDoctorDepartment.text = selctedText
        }
        
    }
    
    
    @objc func btnDoctorPracticeStartDatePress(){
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! HPAddNewDoctorTableViewCell
        
        RPicker.selectDate(title: "Practice Start Date.", didSelectDate: {[] (selectedDate) in
            // TODO: Your implementation for date
            cell.txtDoctorPracticeStartDate.text = selectedDate.dateString("MMM-dd-YYYY")
        })
    }
    

    
    
    
}
