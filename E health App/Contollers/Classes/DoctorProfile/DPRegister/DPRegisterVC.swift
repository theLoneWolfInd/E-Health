//
//  DPRegisterVC.swift
//  E health App
//
//  Created by Ranjan on 30/08/21.
//

import UIKit
import Alamofire
import SDWebImage

// MARK:- LOCATION -
import CoreLocation

class DPRegisterVC: UIViewController , CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    // MARK:- SAVE LOCATION STRING -
    var strSaveLatitude:String!
    var strSaveLongitude:String!
    var strSaveCountryName:String!
    var strSaveLocalAddress:String!
    var strSaveLocality:String!
    var strSaveLocalAddressMini:String!
    var strSaveStateName:String!
    var strSaveZipcodeName:String!
    
    @IBOutlet weak var viewNavigationbar:UIView!
    @IBOutlet weak var btnNavigationBack:UIButton!
    @IBOutlet weak var lblNavationbar:UILabel!{
        didSet {
            
            lblNavationbar.text = "CREATE AN ACCOUNT"
        }
    }

    @IBOutlet weak var tablView:UITableView!
    
    let regularFont = UIFont.systemFont(ofSize: 16)
    let boldFont = UIFont.boldSystemFont(ofSize: 16)
    
    var myStr = ""
    var myStr2 = ""
    var countryId = ""
    var hospitalClinicUserId = ""
    var countryListArray:NSMutableArray = []
    var hospitalClinicListArray:NSMutableArray = []
    
    var strSaveSelectedCountryId:String! = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tablView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
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
         let cell = self.tablView.cellForRow(at: indexPath) as! DPRegisterTableViewCell
        
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
    
    @objc func btnNavigationBackPress(){
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func callBeforeRegister() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! DPRegisterTableViewCell
        
        
        if String(cell.txtDoctorName.text!) == "" {
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
        } else if String(cell.txtPracticeStarteDate.text!) == "" {
            self.fieldShoulNotBeEmptyPopup(strTitle: "Practice Starte Date")
        }
        else if String(cell.txtDepartment.text!) == "" {
            
            self.fieldShoulNotBeEmptyPopup(strTitle: "Department")
        }
        else if String(cell.txtCountry.text!) == "" {
            
            self.fieldShoulNotBeEmptyPopup(strTitle: "Country")
        }
        else {
            self.doctorRegWB()
        }
        
        
    }
    
    @objc func fieldShoulNotBeEmptyPopup(strTitle:String) {
        
        let alert = UIAlertController(title: "Alert", message: String(strTitle)+" Field should not be empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true)
        
    }
    
    @objc func doctorRegWB() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! DPRegisterTableViewCell
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please Wait...")
        
            let params =  AddDoctors(action: "registration",
                                     addedBy: String(hospitalClinicUserId),
                                     username: String(cell.txtDoctorName.text!),
                                     fullName: String(cell.txtDoctorName.text!),
                                     email: String(cell.txtEmail.text!),
                                     contactNumber: String(cell.txtPhone.text!),
                                     password: String(cell.txtPassword.text!),
                                     address: String(cell.txtAddress.text!),
                                     practiceDate: String(cell.txtPracticeStarteDate.text!),
                                     department: String(cell.txtDepartment.text!),
                                     specialty: String(cell.txtSpecialty.text!),
                                     device: MY_DEVICE,
                                     role: "Doctor",
                                     latitude: String(self.strSaveLatitude),
                                     longitude: String(self.strSaveLongitude),
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
                                    //self.backClickMethod()
                                    
                                    self.navigationController?.popViewController(animated: true)
                                    
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

extension DPRegisterVC:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:DPRegisterTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell") as! DPRegisterTableViewCell
        
        cell.backgroundColor = .white
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        cell.btnSelectCountry.addTarget(self, action: #selector(btnSelectCountry), for: .touchUpInside)
        // cell.btnDepartment.addTarget(self, action: #selector(btnDepartmentPress), for: .touchUpInside)
        cell.btnPracticeStarteDate.addTarget(self, action: #selector(btnPracticeStarteDatePress), for: .touchUpInside)
        cell.btnOtherHospitalNClicnic.addTarget(self, action: #selector(btnOtherHospitalNClicnicPress), for: .touchUpInside)
        cell.txtSpecialty.isHidden = false
        cell.txtCountry.textColor = .clear
        cell.btnSignUp.addTarget(self, action: #selector(callBeforeRegister), for:.touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 1200
    }
    
    @objc func btnOtherHospitalNClicnicPress(_ sender:UIButton){
        
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! DPRegisterTableViewCell
        
        let redAppearance = YBTextPickerAppearanceManager.init(
            pickerTitle         : "Select Hospital/Clinic",
            titleFont           : boldFont,
            titleTextColor      : .white,
            titleBackground     : sender.backgroundColor,
            searchBarFont       : regularFont,
            searchBarPlaceholder: "Search Hospital/Clinic",
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
    
    @objc func btnSelectCountry(_ sender:UIButton) {
        
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! DPRegisterTableViewCell
        
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
                
                cell.btnSelectCountry.setTitle("\(selectedValue)", for: .normal)
                cell.btnSelectCountry.setTitleColor(.clear, for: .normal)
                
                cell.txtCountry.text = "\(selectedValue)"
                
                myStr = selectedValue
                
                
                // print(myStr)
                
                for index in 0..<countryListArray.count {
                    
                    let itm = countryListArray[index] as? [String:Any]
                    
                    let name = (itm!["name"] as! String)
                    
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
                cell.btnSelectCountry.setTitle("Select Country", for: .normal)
                
            }
        },
                                       onCancel: {
            
            print("Cancelled")
        }
                                       
        )
        
        
        picker.show(withAnimation: .FromBottom)
        
    }
    
    @objc func btnDepartmentPress(){
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! DPRegisterTableViewCell
        
        let dummyList = ["Surgical", "Physicain", "Gynac","Sexologist"]
        RPicker.selectOption(title: "Select Department", cancelText: "Cancel", dataArray: dummyList, selectedIndex: 0) {[] (selctedText, atIndex) in
            // TODO: Your implementation for selection
            cell.txtDepartment.text = selctedText
        }
    }
    
    @objc func btnPracticeStarteDatePress(){
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! DPRegisterTableViewCell
        
        RPicker.selectDate(title: "Practice Starte Date", didSelectDate: {[] (selectedDate) in
            // TODO: Your implementation for date
            cell.txtPracticeStarteDate.text = selectedDate.dateString("MMM-dd-YYYY")
        })
        
        
    }
    
}
