//
//  HospitalNewPharmacyRegistration.swift
//  E health App
//
//  Created by apple on 11/10/21.
//

import UIKit

// MARK:- LOCATION -
import CoreLocation
import Alamofire
import SDWebImage

class HospitalNewPharmacyRegistration: UIViewController , CLLocationManagerDelegate, UINavigationControllerDelegate , UIImagePickerControllerDelegate {
    
    let locationManager = CLLocationManager()
    
    // MARK:- SAVE LOCATION STRING -
    var strSaveLatitude:String! = ""
    var strSaveLongitude:String! = ""
    var strSaveCountryName:String!
    var strSaveLocalAddress:String!
    var strSaveLocality:String!
    var strSaveLocalAddressMini:String!
    var strSaveStateName:String!
    var strSaveZipcodeName:String!
    
    let regularFont = UIFont.systemFont(ofSize: 16)
    let boldFont = UIFont.boldSystemFont(ofSize: 16)
    
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
            
            lblNavationbar.text = "ADD NEW PHARMACY"
        }
    }
    
    @IBOutlet weak var tablView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tablView.delegate = self
        tablView.dataSource = self
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .white
        tablView.backgroundColor =  .white
        btnNavigationBack.addTarget(self, action: #selector(btnNavigationBackPress), for: .touchUpInside)
        
        self.iAmHereForLocationPermission()
        
        self.countryListWebSer()
        self.hospitalClinicListWB()
    }
    
    @objc func btnNavigationBackPress(){
        
        navigationController?.popViewController(animated: true)
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
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! HospitalNewPharmacyRegistrationTableCell
        
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
            
            cell.txtAddress.text = locality+", "+localAddress+", "+self.strSaveZipcodeName
            
            // self.findMyStateTaxWB()
        }
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
                    ERProgressHud.sharedInstance.hide()
                    var ar : NSArray!
                    ar = (JSON["data"] as! Array<Any>) as NSArray
                    self.countryListArray.addObjects(from: ar as! [Any])
                    
                    
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
        let cell = self.tablView.cellForRow(at: indexPath) as! HospitalNewPharmacyRegistrationTableCell
        
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
            itemColor           : .black,
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
                    
                    
                }
                else{
                    print("no")
                    
                }
            case let .failure(error):
                
                print(error)
            }
            
        }
        
    }
    
    
    @objc func selectHospitalNameFromList() {
        
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! HospitalNewPharmacyRegistrationTableCell
        
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
            itemColor           : .black,
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
                    
                    // let name = (itm!["fullName"] as! String)
                    
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
    
    
    @objc func validationBeforeRegister() {
        
        if self.strProfileForEdit == "yes" {
            
            if self.imageStr == "1" {
                self.editPharmacyWithImage()
            } else {
                self.editPharmacyWB()
            }
            
        } else {
            
            if self.imageStr == "1" {
                self.registerPharmacyWithImage()
            } else {
                self.registerPharmacyWB()
            }
            
        }
        
    }
    
    // MARK: - ADD NEW PHARMACY -
    @objc func registerPharmacyWB() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! HospitalNewPharmacyRegistrationTableCell
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // let str:String = person["role"] as! String
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params =  Register_Pharmacy(action: "registration",
                                            addedBy: String(myString),
                                            username: String(cell.txtPharmacyName.text!),
                                            fullName: String(cell.txtPharmacyName.text!),
                                            email: String(cell.txtEmail.text!),
                                            contactNumber: String(cell.txtPhone.text!),
                                            password: String(cell.txtPassword.text!),
                                            address: String(cell.txtAddress.text!),
                                            device: MY_DEVICE,
                                            role: text_pharmacy,
                                            latitude: String(self.strSaveLatitude),
                                            longitude: self.strSaveLongitude,
                                            countryId: String(self.countryId),
                                            open_time: String(cell.txtOpenTiming.text!),
                                            close_time: String(cell.txtCloseTiming.text!),
                                            description: String(cell.txtDescription.text!))
            
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
                        
                        let cancel = NewYorkButton(title: "dismiss", style: .cancel) { _ in
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
        }
    }
    
    // MARK: - EDIT NEW PHARMACY -
    @objc func editPharmacyWB() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! HospitalNewPharmacyRegistrationTableCell
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "please wait...")
        
        // if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // let str:String = person["role"] as! String
            
            let x : Int = self.getAllDetails["userId"] as! Int
            let myString = String(x)
            
            let params =  Edit_Pharmacy(action: "editProfile",
                                            userId: String(myString),
                                            username: String(cell.txtPharmacyName.text!),
                                            fullName: String(cell.txtPharmacyName.text!),
                                            email: String(cell.txtEmail.text!),
                                            contactNumber: String(cell.txtPhone.text!),
                                            password: String(cell.txtPassword.text!),
                                            address: String(cell.txtAddress.text!),
                                            device: MY_DEVICE,
                                            role: text_pharmacy,
                                            latitude: String(self.strSaveLatitude),
                                            longitude: self.strSaveLongitude,
                                            countryId: String(self.countryId),
                                            open_time: String(cell.txtOpenTiming.text!),
                                            close_time: String(cell.txtCloseTiming.text!),
                                            description: String(cell.txtDescription.text!))
            
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
                        
                        let cancel = NewYorkButton(title: "dismiss", style: .cancel) { _ in
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
    
    
    
    @objc func cellTappedMethod3(_ sender:AnyObject) {
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
        let cell = self.tablView.cellForRow(at: indexPath) as! HospitalNewPharmacyRegistrationTableCell
        
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
    
    
    @objc func registerPharmacyWithImage() {
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "please wait...")
        
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
            let cell = self.tablView.cellForRow(at: indexPath) as! HospitalNewPharmacyRegistrationTableCell
            
            var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            
            //Set Your Parameter
            let parameterDict = NSMutableDictionary()
            parameterDict.setValue("registration", forKey: "action")
            parameterDict.setValue(String(myString), forKey: "addedBy")
            parameterDict.setValue(String(cell.txtPharmacyName.text!), forKey: "username")
            parameterDict.setValue(String(cell.txtPharmacyName.text!), forKey: "fullName")
            parameterDict.setValue(String(cell.txtEmail.text!), forKey: "email")
            parameterDict.setValue(String(cell.txtPhone.text!), forKey: "contactNumber")
            parameterDict.setValue(String(cell.txtPassword.text!), forKey: "password")
            parameterDict.setValue(String(cell.txtAddress.text!), forKey: "address")
            parameterDict.setValue(MY_DEVICE, forKey: "device")
            parameterDict.setValue(text_pharmacy, forKey: "role")
            parameterDict.setValue(String(self.strSaveLatitude), forKey: "latitude")
            parameterDict.setValue(String(self.strSaveLongitude), forKey: "longitude")
            parameterDict.setValue(String(self.countryId), forKey: "countryId")
            parameterDict.setValue(String(cell.txtOpenTiming.text!), forKey: "open_time")
            parameterDict.setValue(String(cell.txtCloseTiming.text!), forKey: "close_time")
            parameterDict.setValue(String(cell.txtDescription.text!), forKey: "description")
            
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
                multiPart.append(self.imgData, withName: "image", fileName: "PharmacyProfilePicture.png", mimeType: "image/png")
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
        
    }
    
    // MARK: - EDIT PHARMACY WITH IMAGE -
    @objc func editPharmacyWithImage() {
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
            let cell = self.tablView.cellForRow(at: indexPath) as! HospitalNewPharmacyRegistrationTableCell
            
            var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            
            //Set Your Parameter
            let parameterDict = NSMutableDictionary()
            parameterDict.setValue("editProfile", forKey: "action")
            parameterDict.setValue(String(myString), forKey: "userId")
            parameterDict.setValue(String(cell.txtPharmacyName.text!), forKey: "username")
            parameterDict.setValue(String(cell.txtPharmacyName.text!), forKey: "fullName")
            parameterDict.setValue(String(cell.txtEmail.text!), forKey: "email")
            parameterDict.setValue(String(cell.txtPhone.text!), forKey: "contactNumber")
            parameterDict.setValue(String(cell.txtPassword.text!), forKey: "password")
            parameterDict.setValue(String(cell.txtAddress.text!), forKey: "address")
            parameterDict.setValue(MY_DEVICE, forKey: "device")
            parameterDict.setValue(text_pharmacy, forKey: "role")
            parameterDict.setValue(String(self.strSaveLatitude), forKey: "latitude")
            parameterDict.setValue(String(self.strSaveLongitude), forKey: "longitude")
            parameterDict.setValue(String(self.countryId), forKey: "countryId")
            parameterDict.setValue(String(cell.txtOpenTiming.text!), forKey: "open_time")
            parameterDict.setValue(String(cell.txtCloseTiming.text!), forKey: "close_time")
            parameterDict.setValue(String(cell.txtDescription.text!), forKey: "description")
            
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
                multiPart.append(self.imgData, withName: "image", fileName: "PharmacyProfilePicture.png", mimeType: "image/png")
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
    
    
}


extension HospitalNewPharmacyRegistration:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:HospitalNewPharmacyRegistrationTableCell = tablView.dequeueReusableCell(withIdentifier: "hospitalNewPharmacyRegistrationTableCell") as! HospitalNewPharmacyRegistrationTableCell
        
        cell.backgroundColor = .white
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        // cell.btnSelectHospitalNClicnic.addTarget(self, action: #selector(selectHospitalNameFromList), for: .touchUpInside)
        
        cell.btnCountry.addTarget(self, action: #selector(btnCountryPress), for: .touchUpInside)
        
        cell.btnSignUp.addTarget(self, action: #selector(validationBeforeRegister), for: .touchUpInside)
        
        cell.btnOpenTime.addTarget(self, action: #selector(openTimeClickMethod), for: .touchUpInside)
        cell.btnCloseTime.addTarget(self, action: #selector(closeTimeClickMethod), for: .touchUpInside)
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(HospitalNewPharmacyRegistration.cellTappedMethod3(_:)))
        cell.imgBackground.isUserInteractionEnabled = true
        cell.imgBackground.addGestureRecognizer(tapGestureRecognizer1)
        
        if self.strProfileForEdit == "yes" {
            self.lblNavationbar.text = "EDIT PHARMACY"
            
            cell.txtPharmacyName.text = (self.getAllDetails["fullName"] as! String)
            cell.txtEmail.text = (self.getAllDetails["email"] as! String)
            
            cell.txtEmail.isUserInteractionEnabled = false
            cell.txtPassword.isUserInteractionEnabled = false
            
            cell.txtPhone.text = (self.getAllDetails["contactNumber"] as! String)
            cell.txtCountry.text = (self.getAllDetails["country"] as! String)
            cell.txtAddress.text = (self.getAllDetails["address"] as! String)
            cell.txtDescription.text = (self.getAllDetails["description"] as! String)
            
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
        let cell = self.tablView.cellForRow(at: indexPath) as! HospitalNewPharmacyRegistrationTableCell
        
        RPicker.selectDate(title: "Open Pharmacy Time", cancelText: "Cancel", datePickerMode: .time, didSelectDate: { [](selectedDate) in
            // TODO: Your implementation for date
            
            cell.txtOpenTiming.text = selectedDate.dateString("hh:mm a")
        })
        
    }
    
    @objc func closeTimeClickMethod() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! HospitalNewPharmacyRegistrationTableCell
        
        RPicker.selectDate(title: "Close Pharmacy Time", cancelText: "Cancel", datePickerMode: .time, didSelectDate: { [](selectedDate) in
            // TODO: Your implementation for date
            
            cell.txtCloseTiming.text = selectedDate.dateString("hh:mm a")
            
        })
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 1400
    }
    
    
}
