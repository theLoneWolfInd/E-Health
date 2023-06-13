//
//  PPRegisterVC.swift
//  E health App
//
//  Created by Ranjan on 27/08/21.
//

import UIKit
// MARK:- LOCATION -
import CoreLocation
import Alamofire

class PPRegisterVC: UIViewController , CLLocationManagerDelegate {
    
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
    
    @IBOutlet weak var viewNavigationbar:UIView!
    @IBOutlet weak var btnNavigationBack:UIButton!
    @IBOutlet weak var lblNavationbar:UILabel!{
        didSet {
            
            lblNavationbar.text = "CREATE AN ACCOUNT"
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
        let cell = self.tablView.cellForRow(at: indexPath) as! PPRegisterTableViewCell
        
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
        let cell = self.tablView.cellForRow(at: indexPath) as! PPRegisterTableViewCell
        
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
        
        
        let item2 = countryListArray.mutableArrayValue(forKey: "id")
        
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
        let cell = self.tablView.cellForRow(at: indexPath) as! PPRegisterTableViewCell
        
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
    
    
    
    
    
    
    
    
    @objc func registerPharmacyWB() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! PPRegisterTableViewCell
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "please wait...")
        
        let params =  AddDoctors(action: "registration",
                                 addedBy: String(self.hospitalClinicUserId),
                                 username: String(cell.txtPharmacyName.text!),
                                 fullName: String(cell.txtPharmacyName.text!),
                                 email: String(cell.txtEmail.text!),
                                 contactNumber: String(cell.txtPhone.text!),
                                 password: String(cell.txtPassword.text!),
                                 address: String(cell.txtAddress.text!),
                                 practiceDate: String(""),
                                 department: String(cell.txtTiming.text!),
                                 specialty: String(cell.txtAbout.text!),
                                 device: MY_DEVICE,
                                 role: String("Pharmcy"),
                                 latitude: String(self.strSaveLatitude),
                                 longitude: self.strSaveLongitude,
                                 countryId: String(self.countryId))
        
        
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

extension PPRegisterVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:PPRegisterTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell") as! PPRegisterTableViewCell
        
        cell.backgroundColor = .white
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.btnSelectHospitalNClicnic.addTarget(self, action: #selector(selectHospitalNameFromList), for: .touchUpInside)
        
        cell.btnCountry.addTarget(self, action: #selector(btnCountryPress), for: .touchUpInside)
        
        cell.btnSignUp.addTarget(self, action: #selector(registerPharmacyWB), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 1400
    }
    
    /*@objc func btnSelectHospitalNClicnicPress() {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! PPRegisterTableViewCell
        
        let dummyList = ["Clinic", "Hospital"]
        RPicker.selectOption(title: "Select Hospital or Clicnic", cancelText: "Cancel", dataArray: dummyList, selectedIndex: 0) {[] (selctedText, atIndex) in
            // TODO: Your implementation for selection
            // cell.txtSelectHospitalNClicnic.text = selctedText
        }
    }*/
    
     
    
}
