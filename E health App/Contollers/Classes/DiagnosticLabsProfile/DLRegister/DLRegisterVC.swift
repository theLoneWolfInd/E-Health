//
//  DLRegisterVC.swift
//  E health App
//
//  Created by Ranjan on 08/09/21.
//

import UIKit

import Alamofire

// MARK:- LOCATION -
import CoreLocation

import SDWebImage

class DLRegisterVC: UIViewController , CLLocationManagerDelegate, UINavigationControllerDelegate , UIImagePickerControllerDelegate {
    
    let regularFont = UIFont.systemFont(ofSize: 16)
    let boldFont = UIFont.boldSystemFont(ofSize: 16)
    
    let locationManager = CLLocationManager()
    
    // MARK:- SAVE LOCATION STRING -
    var strSaveLatitude:String! = "0"
    var strSaveLongitude:String! = "0"
    var strSaveCountryName:String!
    var strSaveLocalAddress:String!
    var strSaveLocality:String!
    var strSaveLocalAddressMini:String!
    var strSaveStateName:String!
    var strSaveZipcodeName:String!
    
    var myStr = ""
    var myStr2 = ""
    var countryId = ""
    var hospitalClinicUserId = ""
    var countryListArray:NSMutableArray = []
    var hospitalClinicListArray:NSMutableArray = []
    
    var strSaveSelectedCountryId:String! = "0"
    
    var strProfileForEdit:String!
    var getAllDetails:NSDictionary!
    var imageStr:String! = "0"
    var imgData:Data!
    
    @IBOutlet weak var viewNavigationbar:UIView!
    @IBOutlet weak var btnNavigationBack:UIButton!
    @IBOutlet weak var lblNavationbar:UILabel!{
        didSet {
            
            lblNavationbar.text = "ADD NEW LAB"
        }
    }
    
    
    
    @IBOutlet weak var tablView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tablView.delegate = self
        // tablView.dataSource = self
        self.navigationController?.isNavigationBarHidden = true
        
        self.view.backgroundColor = .white
        tablView.backgroundColor =  .white
        
        btnNavigationBack.addTarget(self, action: #selector(btnNavigationBackPress), for: .touchUpInside)
        
        self.hideKeyboardWhenTappedAround()
        
        
        tablView.delegate = self
        tablView.dataSource = self
        
        
        
        self.iAmHereForLocationPermission()
        
        self.countryListWebSer()
    
    }
    
    // MARK: - LIST OF ALL HOSPITAL -
    @objc func hospitalClinicListWB() {
        
        
        let params =
        hospitalClininicListWeb(action: "userlist",
                                role:"Hospital",
                                addedBy: "")
        
        
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
                    
                    var ar : NSArray!
                    ar = (JSON["data"] as! Array<Any>) as NSArray
                    self.hospitalClinicListArray.addObjects(from: ar as! [Any])
                    
                    ERProgressHud.sharedInstance.hide()
                    
                }
                else{
                    print("no")
                    
                }
            case let .failure(error):
                
                print(error)
            }
            
        }
        
    }
    
    @objc func iAmHereForLocationPermission() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                self.strSaveLatitude = "0"
                self.strSaveLongitude = "0"
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
                
            @unknown default:
                break
            }
        }
    }
    // MARK:- GET CUSTOMER LOCATION -
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        // let indexPath = IndexPath.init(row: 0, section: 0)
        // let cell = self.tablView.cellForRow(at: indexPath) as! DLRegisterTableViewCell
        
        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        location.fetchCityAndCountry { city, country, zipcode,localAddress,localAddressMini,locality, error in
            guard let city = city, let country = country,let zipcode = zipcode,let localAddress = localAddress,let localAddressMini = localAddressMini,let locality = locality, error == nil else { return }
            
            self.strSaveCountryName     = country
            self.strSaveStateName       = city
            self.strSaveZipcodeName     = zipcode
            
            self.strSaveLocalAddress     = localAddress
            self.strSaveLocality         = locality
            self.strSaveLocalAddressMini = localAddressMini
            
            //print(self.strSaveLocality+" "+self.strSaveLocalAddress+" "+self.strSaveLocalAddressMini)
            
            let doubleLat = locValue.latitude
            let doubleStringLat = String(doubleLat)
            
            let doubleLong = locValue.longitude
            let doubleStringLong = String(doubleLong)
            
            self.strSaveLatitude = String(doubleStringLat)
            self.strSaveLongitude = String(doubleStringLong)
            
            print("local address ==> "+localAddress as Any) // south west delhi
            print("local address mini ==> "+localAddressMini as Any) // new delhi
            print("locality ==> "+locality as Any) // sector 10 dwarka
            
            print(self.strSaveCountryName as Any) // india
            print(self.strSaveStateName as Any) // new delhi
            print(self.strSaveZipcodeName as Any) // 110075
            
            //MARK:- STOP LOCATION -
            self.locationManager.stopUpdatingLocation()
            
            // cell.txtAddress.text = locality+", "+localAddress+", "+self.strSaveZipcodeName
            
            // self.findMyStateTaxWB()
        }
    }
    
    @objc func btnSignUpPress() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "adminApprovalVC") as? adminApprovalVC
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    @objc func btnNavigationBackPress() {
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func parseEditData() {
        /*
         address = "qwerty address";
         city = "";
         contactNumber = 9897989697;
         country = India;
         countryId = 101;
         department = "";
         description = "qwerty description";
         device = iOS;
         deviceToken = "";
         dob = "";
         email = "qwertylab@gmail.com";
         eyeColor = "";
         "fee_Paid_for_M_card" = 0;
         firebaseId = "";
         fullName = "qwerty lab";
         gender = "";
         height = "";
         image = "https://demo4.evirtualservices.net/ehealth/img/uploads/users/1633943199DoctorProfilePicture.png";
         lastName = "";
         latitude = "";
         longitude = "";
         medicalCardID = "";
         middleName = "";
         practiceDate = "";
         registeredDt = "";
         role = Lab;
         socialId = "";
         socialType = "";
         specialty = "";
         state = "";
         status = 1;
         userId = 253;
         zipCode = "";
         */
        
         // let indexPath = IndexPath.init(row: 0, section: 0)
         // let cell = self.tablView.cellForRow(at: indexPath) as! DLRegisterTableViewCell
        
        
    }
    
    @objc func callBeforeRegister() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! DLRegisterTableViewCell
        
        if self.strProfileForEdit == "yes" {
            
            if String(cell.txtName.text!) == "" {
                self.fieldShoulNotBeEmptyPopup(strTitle: "Name")
            } else if String(cell.txtEmail.text!) == "" {
                self.fieldShoulNotBeEmptyPopup(strTitle: "Email")
            } else if String(cell.txtPhone.text!) == "" {
                self.fieldShoulNotBeEmptyPopup(strTitle: "Phone")
            } else if String(cell.txtCountry.text!) == "" {
                self.fieldShoulNotBeEmptyPopup(strTitle: "Country")
            } else if String(cell.txtAddress.text!) == "" {
                self.fieldShoulNotBeEmptyPopup(strTitle: "Address")
            } else if String(cell.txtDescription.text!) == "" {
                self.fieldShoulNotBeEmptyPopup(strTitle: "Description")
            } else {
                
                if self.imageStr == "1" {
                    self.editLabWithImage()
                } else {
                    self.editLabsDetails()
                }
                
                
            }
            
        } else {
            
            if String(cell.txtName.text!) == "" {
                self.fieldShoulNotBeEmptyPopup(strTitle: "Name")
            } else if String(cell.txtEmail.text!) == "" {
                self.fieldShoulNotBeEmptyPopup(strTitle: "Email")
            } else if String(cell.txtPassword.text!) == "" {
                self.fieldShoulNotBeEmptyPopup(strTitle: "Password")
            } else if String(cell.txtPhone.text!) == "" {
                self.fieldShoulNotBeEmptyPopup(strTitle: "Phone")
            } else if String(cell.txtCountry.text!) == "" {
                self.fieldShoulNotBeEmptyPopup(strTitle: "Country")
            } else if String(cell.txtAddress.text!) == "" {
                self.fieldShoulNotBeEmptyPopup(strTitle: "Address")
            } else if String(cell.txtDescription.text!) == "" {
                self.fieldShoulNotBeEmptyPopup(strTitle: "Description")
            } else {
                
                if self.imageStr == "1" {
                    self.addLabWithImage()
                } else {
                    self.registerHospitalLabWB()
                }
                
                
            }
            
        }
        
        
        
        
    }
    
    @objc func fieldShoulNotBeEmptyPopup(strTitle:String) {
        
        /*let alert = UIAlertController(title: "Alert", message: String(strTitle)+" Field should not be empty", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
         self.present(alert, animated: true)*/
        
        let alert = NewYorkAlertController(title: "Alert", message: String(strTitle)+" Field should not be empty", style: .alert)
        
        alert.addImage(UIImage(named: "sorry"))
        
        let cancel = NewYorkButton(title: "Ok", style: .cancel)
        alert.addButtons([cancel])
        
        present(alert, animated: true)
        
    }
    
    @objc func registerHospitalLabWB() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! DLRegisterTableViewCell
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let params = HospitalLabRegistrationParam(action: "registration",
                                                  addedBy: String(self.hospitalClinicUserId),
                                                  username: String(cell.txtName.text!),
                                                  fullName: String(cell.txtName.text!),
                                                  email: String(cell.txtEmail.text!),
                                                  password: String(cell.txtPassword.text!),
                                                  contactNumber: String(cell.txtPhone.text!),
                                                  address: String(cell.txtAddress.text!),
                                                  countryId: String(self.strSaveSelectedCountryId),
                                                  device: MY_DEVICE,
                                                  role: "Lab",
                                                  specialty: String("N.A."),
                                                  department: String("N.A."),
                                                  latitude: String(self.strSaveLatitude),
                                                  longitude: String(self.strSaveLongitude),
                                                  description: String(cell.txtDescription.text!),
                                                  open_time: String(cell.txtOpenTiming.text!),
                                                  close_time: String(cell.txtCloseTiming.text!))
        
        
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
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        self.btnNavigationBackPress()
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
    
    // MARK: - EDIT LABS DETAILS -
    @objc func editLabsDetails() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! DLRegisterTableViewCell
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        
        // if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
        
        let x : Int = self.getAllDetails["userId"] as! Int
         let myString = String(x)
        
        let params = Edit_Labs_Details(action: "editProfile",
                                       userId:String(myString),
                                       username: String(cell.txtName.text!),
                                       fullName: String(cell.txtName.text!),
                                       email: String(cell.txtEmail.text!),
                                       password: String(cell.txtPassword.text!),
                                       contactNumber: String(cell.txtPhone.text!),
                                       address: String(cell.txtAddress.text!),
                                       countryId: String(self.strSaveSelectedCountryId),
                                       device: MY_DEVICE,
                                       role: "Lab",
                                       specialty: String("N.A."),
                                       department: String("N.A."),
                                       latitude: String(self.strSaveLatitude),
                                       longitude: String(self.strSaveLongitude),
                                       description: String(cell.txtDescription.text!),
                                       open_time: String(cell.txtOpenTiming.text!),
                                       close_time: String(cell.txtCloseTiming.text!))
        
        
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
                    
                    let alert = NewYorkAlertController(title: "Success", message: String(strSuccess2), style: .alert)

                    alert.addImage(UIImage.gif(name: "success3"))
                    
                    let cancel = NewYorkButton(title: "Ok", style: .cancel) { _ in
                         self.navigationController?.popViewController(animated: true)
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
        // }
    }
    
    
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
                    // ERProgressHud.sharedInstance.hide()
                    var ar : NSArray!
                    ar = (JSON["data"] as! Array<Any>) as NSArray
                    self.countryListArray.addObjects(from: ar as! [Any])
                    
                    self.hospitalClinicListWB()
                }
                else{
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
        let cell = self.tablView.cellForRow(at: indexPath) as! DLRegisterTableViewCell
        
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
    
    @objc func cellTappedMethod2(_ sender:AnyObject) {
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
        let cell = self.tablView.cellForRow(at: indexPath) as! DLRegisterTableViewCell
        
        cell.imgBackground.isHidden = false
        let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        cell.imgBackground.image = image_data // show image on profile
        let imageData:Data = image_data!.pngData()!
        self.imageStr = imageData.base64EncodedString()
        self.dismiss(animated: true, completion: nil)
        self.imgData = image_data!.jpegData(compressionQuality: 0.2)!
        //print(type(of: imgData)) // data
        
        self.imageStr = "1"
        
        
        // self.uploadDataWithImage()
    }
    
    @objc func addLabWithImage() {
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        //Set Your URL
        let api_url = APPLICATION_BASE_URL
        guard let url = URL(string: api_url) else {
            return
        }
        
        
        // let str:String = person["role"] as! String
        
        // let x : Int = person["userId"] as! Int
        // let myString = String(x)
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! DLRegisterTableViewCell
        
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        /*
         action: "registration",
         username: String(cell.txtName.text!),
         fullName: String(cell.txtName.text!),
         email: String(cell.txtEmail.text!),
         password: String(cell.txtPassword.text!),
         contactNumber: String(cell.txtPhone.text!),
         address: String(cell.txtAddress.text!),
         countryId: String(self.strSaveSelectedCountryId),
         device: MY_DEVICE,
         role: "Lab",
         specialty: String("N.A."),
         department: String("N.A."),
         latitude: String(self.strSaveLatitude),
         longitude: String(self.strSaveLongitude),
         description: String(cell.txtDescription.text!))
         */
        
        //Set Your Parameter
        let parameterDict = NSMutableDictionary()
        parameterDict.setValue("registration", forKey: "action")
        
        parameterDict.setValue(String(self.hospitalClinicUserId), forKey: "addedBy")
        
        parameterDict.setValue(String(cell.txtName.text!), forKey: "fullName")
        parameterDict.setValue(String(cell.txtName.text!), forKey: "fullName")
        parameterDict.setValue(String(cell.txtEmail.text!), forKey: "email")
        parameterDict.setValue(String(cell.txtPhone.text!), forKey: "contactNumber")
        parameterDict.setValue(String(cell.txtPassword.text!), forKey: "password")
        parameterDict.setValue(String(cell.txtAddress.text!), forKey: "address")
        // parameterDict.setValue(String(""), forKey: "practiceDate")
        // parameterDict.setValue(String(""), forKey: "department")
        // parameterDict.setValue(String(""), forKey: "specialty")
        parameterDict.setValue(String(MY_DEVICE), forKey: "device")
        parameterDict.setValue(String("Lab"), forKey: "role")
        parameterDict.setValue(String(self.strSaveLatitude), forKey: "latitude")
        parameterDict.setValue(String(self.strSaveLongitude), forKey: "longitude")
        parameterDict.setValue(String(cell.txtDescription.text!), forKey: "description")
        parameterDict.setValue(String(self.strSaveSelectedCountryId), forKey: "countryId")
        
        parameterDict.setValue(String(cell.txtOpenTiming.text!), forKey: "open_time")
        parameterDict.setValue(String(cell.txtCloseTiming.text!), forKey: "close_time")
        
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
            multiPart.append(self.imgData, withName: "image", fileName: "LabProfilePicture.png", mimeType: "image/png")
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
                        
                        let alert = NewYorkAlertController(title: "Success", message: String(strSuccess2), style: .alert)
                        
                        alert.addImage(UIImage.gif(name: "success3"))
                        
                        let cancel = NewYorkButton(title: "dismiss", style: .cancel) { _ in
                            self.navigationController?.popViewController(animated: true)
                        }
                        alert.addButtons([cancel])
                        
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
        
        
        
        
        
        
        
        
    }
    
    // MARK: - EDIT LABS  ( WITH IMAGE ) -
    @objc func editLabWithImage() {
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "updating...")
        
        //Set Your URL
        let api_url = APPLICATION_BASE_URL
        
        guard let url = URL(string: api_url) else {
            return
        }
        
        // if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
        // let str:String = person["role"] as! String
        
        let x : Int = self.getAllDetails["userId"] as! Int
        let myString = String(x)
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! DLRegisterTableViewCell
        
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //Set Your Parameter
        let parameterDict = NSMutableDictionary()
        
        parameterDict.setValue("editProfile", forKey: "action")
        parameterDict.setValue(String(myString), forKey: "userId")
        parameterDict.setValue(String(cell.txtName.text!), forKey: "fullName")
        parameterDict.setValue(String(cell.txtName.text!), forKey: "fullName")
        parameterDict.setValue(String(cell.txtEmail.text!), forKey: "email")
        parameterDict.setValue(String(cell.txtPhone.text!), forKey: "contactNumber")
        // parameterDict.setValue(String(cell.txtPassword.text!), forKey: "password")
        parameterDict.setValue(String(cell.txtAddress.text!), forKey: "address")
        // parameterDict.setValue(String(""), forKey: "practiceDate")
        // parameterDict.setValue(String(""), forKey: "department")
        // parameterDict.setValue(String(""), forKey: "specialty")
        parameterDict.setValue(String(MY_DEVICE), forKey: "device")
        parameterDict.setValue(String("Lab"), forKey: "role")
        parameterDict.setValue(String(self.strSaveLatitude), forKey: "latitude")
        parameterDict.setValue(String(self.strSaveLongitude), forKey: "longitude")
        parameterDict.setValue(String(cell.txtDescription.text!), forKey: "description")
        parameterDict.setValue(String(self.strSaveSelectedCountryId), forKey: "countryId")
        
        parameterDict.setValue(String(cell.txtOpenTiming.text!), forKey: "open_time")
        parameterDict.setValue(String(cell.txtCloseTiming.text!), forKey: "close_time")
        
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
            multiPart.append(self.imgData, withName: "image", fileName: "LabProfilePicture.png", mimeType: "image/png")
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
                        
                        let alert = NewYorkAlertController(title: "Success", message: String(strSuccess2), style: .alert)
                        
                        alert.addImage(UIImage.gif(name: "success3"))
                        
                        let cancel = NewYorkButton(title: "dismiss", style: .cancel) { _ in
                            self.navigationController?.popViewController(animated: true)
                        }
                        alert.addButtons([cancel])
                        
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
        
        // }
        
    }
    
    
    
    @objc func hospitalclick() {
        
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! DLRegisterTableViewCell
        
        let redAppearance = YBTextPickerAppearanceManager.init(
            pickerTitle         : "Select Hospital/Clinic",
            titleFont           : boldFont,
            titleTextColor      : .white,
            titleBackground     : .systemTeal,
            searchBarFont       : regularFont,
            searchBarPlaceholder: "Search Hospital/Clinic",
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
        
        let item = hospitalClinicListArray.mutableArrayValue(forKey: "fullName")
        let item2 = hospitalClinicListArray.mutableArrayValue(forKey: "userId")
        
        print(item2 as Any)
        
        let picker = YBTextPicker.init(with: item as! [String], appearance: redAppearance,onCompletion: { [self] (selectedIndexes, selectedValues) in
            
            if let selectedValue = selectedValues.first {
                
                // if selectedValue == item.lastObject! as! String {
                
                cell.btnOtherHospitalNClicnic.setTitle("Hopital Name : \(selectedValue)", for: .normal)
                
                myStr2 = selectedValue
                
                
                print(myStr2)
                
                for index in 0..<hospitalClinicListArray.count {
                    
                    let itm = hospitalClinicListArray[index] as? [String:Any]
                    
                    let name = (itm!["fullName"] as! String)
                    
                    //print(name)
                    
                    if myStr2 == (itm!["fullName"] as! String){
                        
                        print("selected index = \(hospitalClinicListArray[index])")
                        
                        self.hospitalClinicUserId = String((itm!["userId"] as! Int))
                        
                        print(hospitalClinicUserId)
                        
                    }
                }
                
                
                // }
                /*else {
                 
                 cell.btnOtherHospitalNClicnic.setTitle("Hopital Name : \(selectedValue)", for: .normal)
                 
                 myStr2 = selectedValue
                 
                 
                 print(myStr2)
                 
                 for index in 0..<hospitalClinicListArray.count {
                 
                 let itm = hospitalClinicListArray[index] as? [String:Any]
                 
                 let name = (itm!["fullName"] as! String)
                 
                 //print(name)
                 
                 if myStr2 == (itm!["fullName"] as! String){
                 
                 print("selected index = \(hospitalClinicListArray[index])")
                 
                 self.hospitalClinicUserId = String((itm!["userId"] as! Int))
                 
                 print(hospitalClinicUserId)
                 
                 }
                 }
                 
                 }*/
                
            }
            else {
                
                cell.btnOtherHospitalNClicnic.setTitle("Select Hospital/Clinic", for: .normal)
                
            }
        },
                                       onCancel: {
            
            print("Cancelled")
        }
                                       
        )
        
        
        picker.show(withAnimation: .FromBottom)
        
    }
    
}

extension DLRegisterVC:UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:DLRegisterTableViewCell = tablView.dequeueReusableCell(withIdentifier: "dLRegisterTableViewCell")as! DLRegisterTableViewCell
        
        cell.backgroundColor = .white
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        cell.btnSignUp.addTarget(self, action: #selector(callBeforeRegister), for: .touchUpInside)
        cell.btnCountry.addTarget(self, action: #selector(btnCountryPress), for: .touchUpInside)
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(HospitalNewLabRegistration.cellTappedMethod2(_:)))
        
        cell.imgBackground.isUserInteractionEnabled = true
        cell.imgBackground.addGestureRecognizer(tapGestureRecognizer1)
        
        cell.btnOpenTime.addTarget(self, action: #selector(openTimeClickMethod), for: .touchUpInside)
        cell.btnCloseTime.addTarget(self, action: #selector(closeTimeClickMethod), for: .touchUpInside)
        
        cell.btnOtherHospitalNClicnic.addTarget(self, action: #selector(hospitalclick), for: .touchUpInside)
        
        if self.strProfileForEdit == "yes" {
            self.lblNavationbar.text = "EDIT"
            
            cell.txtName.text = (self.getAllDetails["fullName"] as! String)
            cell.txtEmail.text = (self.getAllDetails["email"] as! String)
            
            cell.txtEmail.isUserInteractionEnabled = false
            cell.txtPassword.isUserInteractionEnabled = false
            
            cell.txtPhone.text = (self.getAllDetails["contactNumber"] as! String)
            cell.txtCountry.text = (self.getAllDetails["country"] as! String)
            cell.txtAddress.text = (self.getAllDetails["address"] as! String)
            cell.txtDescription.text = (self.getAllDetails["description"] as! String)
            
            // let x : Int = self.getAllDetails["countryId"] as! Int
            // let myString = String(x)
            
            cell.txtOpenTiming.text = (self.getAllDetails["open_time"] as! String)
            cell.txtCloseTiming.text = (self.getAllDetails["close_time"] as! String)
            
            if self.getAllDetails["countryId"] is String {
                
                print("Yes, it's a String")
                
                self.strSaveSelectedCountryId = (self.getAllDetails["countryId"] as! String)
                
            } else if self.getAllDetails["countryId"] is Int {
                
                let x : Int = self.getAllDetails["countryId"] as! Int
                let myString = String(x)
                self.strSaveSelectedCountryId = String(myString)
            }
            
            // self.strSaveSelectedCountryId = String(myString)
            cell.btnSignUp.setTitle("Edit Details", for: .normal)
            
            cell.imgBackground.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.imgBackground.sd_setImage(with: URL(string: (self.getAllDetails["image"] as! String)), placeholderImage: UIImage(named: "1024"))
            
        } else {
            cell.btnSignUp.setTitle("Add Details", for: .normal)
        }
        
        
        return cell
        
    }
    
    @objc func openTimeClickMethod() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! DLRegisterTableViewCell
        
        RPicker.selectDate(title: "Open Lab Time", cancelText: "Cancel", datePickerMode: .time, didSelectDate: { [](selectedDate) in
            // TODO: Your implementation for date
            
            cell.txtOpenTiming.text = selectedDate.dateString("hh:mm a")
        })
        
    }
    
    @objc func closeTimeClickMethod() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! DLRegisterTableViewCell
        
        RPicker.selectDate(title: "Close Lab Time", cancelText: "Cancel", datePickerMode: .time, didSelectDate: { [](selectedDate) in
            // TODO: Your implementation for date
            
            cell.txtCloseTiming.text = selectedDate.dateString("hh:mm a")
            
        })
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 2000
    }
    
    
    
    
}
