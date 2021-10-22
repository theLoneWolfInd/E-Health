//
//  logInVC.swift
//  E health App
//
//  Created by Ranjan on 16/08/21.
//

import UIKit
import Alamofire

// MARK:- LOCATION -
import CoreLocation

class logInVC: UIViewController,UITextFieldDelegate , CLLocationManagerDelegate {
    
    var strUserLoginProfile:String!
    
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
    
    @IBOutlet weak var viewNavigationbar:UIView!
    @IBOutlet weak var btnNavigationBack:UIButton!
    @IBOutlet weak var lblNavationbar:UILabel!{
        didSet {
            
            lblNavationbar.text = "SIGN IN"
        }
    }
    
    @IBOutlet weak var imgBackground:UIImageView!{
        didSet {
            
            imgBackground.layer.cornerRadius = 45.0
            imgBackground.clipsToBounds = true
            imgBackground.image = UIImage(named: "1024")
            
        }
    }
    
    @IBOutlet weak var txtEmail:UITextField!{
        didSet {
            
            Utils.txtUitextField(textField: txtEmail, placeholderName: "Email", setLeftPadding: 20)
            
            if let myImage = UIImage(named: "user"){
                txtEmail.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
            
            txtEmail.delegate = self
            
        }
    }
    @IBOutlet weak var txtPassword:UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtPassword, placeholderName: "Password", setLeftPadding: 20 )
            
            if let myImage = UIImage(systemName: "lock.fill"){
                
                txtPassword.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
            
            txtPassword.delegate = self
        }
    }
    
    @IBOutlet weak var btnSignIn:UIButton!{
        
        didSet{
            btnSignIn.layer.cornerRadius = 27.5
            btnSignIn.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnForgotPassword:UIButton!
    @IBOutlet weak var btnSignUp:UIButton!{
        didSet{
            let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "Avenir Heavy", size: 20.0)!]
            
            let myString = NSMutableAttributedString(string: "Don't have an account - Sign Up", attributes: myAttribute )
            
            let myRange1 = NSRange(location: 0, length: 24)
            
            myString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range:myRange1 )
            
            btnSignUp.setAttributedTitle(myString, for: .normal)
            
        }
    }
    
    // support@kwikapi.com
    // liza@kwikapi.com
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self.strUserLoginProfile as Any)
        
        self.navigationController?.isNavigationBarHidden = true
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        btnNavigationBack.addTarget(self, action: #selector(btnNavigationBackPress), for: .touchUpInside)
        
        btnSignIn.addTarget(self, action: #selector(callBeforeLogin), for: .touchUpInside)
        btnForgotPassword.addTarget(self, action: #selector(btnForgotPasswordPress), for: .touchUpInside)
        self.view.backgroundColor = .white
        
        if self.strUserLoginProfile == "Patient" {
            self.btnSignUp.isHidden = true
        } else {
            self.btnSignUp.isHidden = false
        }
        btnSignUp.addTarget(self, action: #selector(btnSignUpPress), for: .touchUpInside)
        
        self.iAmHereForLocationPermission()
        
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
        // let cell = self.tablView.cellForRow(at: indexPath) as! HospitalNewLabeRegistrationTableCell
        
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
    
    @objc func btnNavigationBackPress() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func btnForgotPasswordPress() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPOrderDetailsVC") as? PPOrderDetailsVC
        
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    @objc func btnSignInPress() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "dashboardVC") as? dashboardVC
        
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func btnSignUpPress() {
        
        if self.strUserLoginProfile == "Diagnostic" {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DLRegisterVC") as? DLRegisterVC
            self.navigationController?.pushViewController(push!, animated: true)
            
        } else {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "registerVC") as? registerVC
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
    }
    
    // MARK:- VALIDATION BEFORE LOGIN -
    @objc func callBeforeLogin() {
         
        if String(txtEmail.text!) == "" {
            self.fieldShoulNotBeEmptyPopup(strTitle: "Name")
        } else if String(txtPassword.text!) == "" {
            self.fieldShoulNotBeEmptyPopup(strTitle: "Email")
        } else {
            self.loginWB()
        }
        
    }
    
    @objc func fieldShoulNotBeEmptyPopup(strTitle:String) {
        
        let alert = UIAlertController(title: "Alert", message: String(strTitle)+" Field should not be empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true)
        
    }
    
    @objc func loginWB() {
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let defaults = UserDefaults.standard
        if let myString = defaults.string(forKey: "key_my_device_token") {
            print("defaults savedString: \(myString)")
            
            /*
             self.strSaveLatitude = String(doubleStringLat)
             self.strSaveLongitude = String(doubleStringLong)
             */
            
            let params = LoginParam(action: "login",
                                    login_id: String(self.txtEmail.text!),
                                    password: String(self.txtPassword.text!),
                                    device: MY_DEVICE,
                                    deviceToken: "\(myString)",
                                    latitude: String(self.strSaveLatitude),
                                    longitude: String(self.strSaveLongitude))
            
            
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
                        
                        let defaults = UserDefaults.standard
                        defaults.setValue(dict, forKey: "keyLoginFullData")
                        
                        
                        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
                            
                            print(person as Any)
                            
                            if (person["role"] as! String) == "Hospital" {
                                
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HPDashboardVC")
                                self.navigationController?.pushViewController(push, animated: true)
                                
                            } else if (person["role"] as! String) == "Patient" {
                                
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPDashboardVC")
                                self.navigationController?.pushViewController(push, animated: true)
                                
                            } else if (person["role"] as! String) == "Doctor" {
                                
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DPDashboardVC")
                                self.navigationController?.pushViewController(push, animated: true)
                                
                            } else if (person["role"] as! String) == "Supplier" {
                                
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "dashboardVC")
                                self.navigationController?.pushViewController(push, animated: true)
                                
                            } else if (person["role"] as! String) == "Lab" {
                                
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardDLPVC")
                                self.navigationController?.pushViewController(push, animated: true)
                                
                            } else if (person["role"] as! String) == "Pharmacy" {
                                
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardDLPVC")
                                self.navigationController?.pushViewController(push, animated: true)
                                
                            }
                            
                        }
                        
                    } else {
                        print("no")
                        ERProgressHud.sharedInstance.hide()
                        
                        var strSuccess2 : String!
                        strSuccess2 = JSON["msg"]as Any as? String
                        
                        if strSuccess2 == "Your Account is Inactive. Please contact admin.!!" ||
                            strSuccess2 == "Your Account is Inactive. Please contact admin.!" ||
                            strSuccess2 == "Your Account is Inactive. Please contact admin." {
                            
                            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "adminApprovalVC")
                            self.navigationController?.pushViewController(push, animated: true)
                            
                        } else {
                            
                            let alert = UIAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                            
                            self.present(alert, animated: true)
                            
                        }
                        
                        
                        
                        
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
