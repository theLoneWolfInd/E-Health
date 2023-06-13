//
//  PPDashboardVC.swift
//  E health App
//
//  Created by Ranjan on 03/09/21.
//

import UIKit
import SDWebImage
import Alamofire
import Firebase
import CoreLocation

class PPDashboardVC: UIViewController , CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    var arr = ["Medical",
               "Appointment",
               "eHealth Card",
               "Prescription",
               "Edit Profile",
               "Panic"]
    
    var imgArr = ["medical_yellow",
                  "appointment_yellow",
                  "e_health_card_yellow",
                  "prescription_yellow",
                  "edit_profile_yellow",
                  "iAmPanicButton"]
    
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
    @IBOutlet weak var btnDashboardMenu: UIButton! {
        didSet {
            btnDashboardMenu.tintColor = .white
        }
    }
    @IBOutlet weak var lblNavationbar:UILabel!{
        didSet {
            
            lblNavationbar.text = "DASHBOARD"
        }
    }
    
    @IBOutlet weak var imgCustomerProfile:UIImageView!{
        didSet {
            imgCustomerProfile.layer.borderWidth = 5.0
            imgCustomerProfile.layer.borderColor = UIColor.white.cgColor
            imgCustomerProfile.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var viewImageBG:UIView!{
        didSet {
            viewImageBG.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var lblPatientName:UILabel!
    @IBOutlet weak var btnPatientAddress:UIButton!
    
    @IBOutlet weak var collectionViw:UICollectionView!
    
    @IBOutlet weak var btnPanic:UIButton!{
        didSet {
            btnPanic.layer.cornerRadius = 28
            btnPanic.clipsToBounds = true
            btnPanic.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        collectionViw.delegate = self
        collectionViw.dataSource = self
        collectionViw.backgroundColor = .white
        
        self.lblPatientName.text = "Lille Johnson"
        btnPatientAddress.setTitle("e-1 sector 23, Noida UP", for: .normal)
        btnPanic.addTarget(self, action: #selector(btnPanicPress), for: .touchUpInside)
        
        self.sideBarMenuClick()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.fetchDynamicData()
        
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
    
    @objc func sideBarMenuClick() {
        
        UserDefaults.standard.set("", forKey: "keySetToBackOrMenu")
        UserDefaults.standard.set(nil, forKey: "keySetToBackOrMenu")
        
        self.view.endEditing(true)
        
        if revealViewController() != nil {
            
            btnDashboardMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    @objc func fetchDynamicData() {
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
            
            print(person as Any)
            
            if (person["role"] as! String) == "Patient" {
                
                self.lblPatientName.text = (person["fullName"] as! String)
                self.lblPatientName.textColor = .black
                
                self.btnPatientAddress.setTitle((person["address"] as! String), for: .normal)
                self.btnPatientAddress.setTitleColor(.black, for: .normal)
                self.btnPatientAddress.titleLabel?.lineBreakMode = .byWordWrapping
                
                self.imgCustomerProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                self.imgCustomerProfile.sd_setImage(with: URL(string: (person["image"] as! String)), placeholderImage: UIImage(named: "1024"))
                
                
            }
            
        }
        
    }
    
    @objc func btnPanicPress() {
        
        // let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPBookAppointmentVC") as? PPBookAppointmentVC
        // self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    
    
    @objc func send_panic_notificaion_wb() {
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = send_panic_notification(action: "sendpanic",
                                                 userId: String(myString),
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
                        
                        var strSuccess2 : String!
                        strSuccess2 = JSON["msg"]as Any as? String
                        
                        let alert = NewYorkAlertController(title: "Success", message: String(strSuccess2), style: .alert)
                        
                        alert.addImage(UIImage.gif(name: "success3"))
                        
                        let cancel = NewYorkButton(title: "Ok", style: .cancel) { _ in
                            // self.navigationController?.popViewController(animated: true)
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
    
}

extension PPDashboardVC: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:PPDashboardCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PPDashboardCollectionViewCell
        
        cell.backgroundColor = .white
        
        cell.lblDashboard.text = arr[indexPath.row]
        cell.imgDashboard.image = UIImage(named: imgArr[indexPath.row])
        
        /*if indexPath.row == 5 {
            
            cell.imgDashboard.isHidden = true
            cell.imgPanicFullImage.isHidden = false
            cell.imgPanicFullImage.image = UIImage(named: "iAmPanicButton")
            cell.lblDashboard.isHidden = true
            cell.viewCellBG.isHidden = true
            
        } else {
            */
            cell.imgDashboard.isHidden = false
            cell.imgPanicFullImage.isHidden = true
            cell.lblDashboard.isHidden = false
            cell.viewCellBG.isHidden = false
            
        // }
        
        // cell.imgDashboard.layer.cornerRadius = cell.imgDashboard.frame.height/2
        // cell.imgDashboard.image = UIImage(named: imgArr[indexPath.row])
        // cell.layer.cornerRadius = 4.0
        // cell.imgDashboard.clipsToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 1 {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPAppointmentsVC") as? PPAppointmentsVC
            self.navigationController?.pushViewController(push!, animated: true)
            
            /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPatientPanicProfileId") as? PPatientPanicProfile
            self.navigationController?.pushViewController(push!, animated: true)*/
            
        } else if indexPath.row == 4 {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CEditProfileId") as? CEditProfile
            self.navigationController?.pushViewController(push!, animated: true)
            
        } else if indexPath.row == 5 {
            
            // let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "helpVC") as? helpVC
            // self.navigationController?.pushViewController(push!, animated: true)
            
            self.send_panic_notificaion_wb()
            
        } else if indexPath.row == 0 {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MedicalHistoryVC") as? MedicalHistoryVC
            self.navigationController?.pushViewController(push!, animated: true)
            
        } else if indexPath.row == 2 {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PatientEhealthCardId") as? PatientEhealthCard
            self.navigationController?.pushViewController(push!, animated: true)
            
        } else if indexPath.row == 3 {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PatientPrescriptionListId") as? PatientPrescriptionList
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var sizes: CGSize
        let result = UIScreen.main.bounds.size
        NSLog("%f",result.height)
        
        if result.height == 844 {
            
            print("i am iPhone 12")
            sizes = CGSize(width: 116, height: 130)
        } else if result.height == 812 {
            
            print("i am iPhone 12 mini")
            sizes = CGSize(width: 110, height: 130)
        } else {
            
            sizes = CGSize(width: 120, height: 130)
        }
        
        return sizes
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
        
        /*let result = UIScreen.main.bounds.size
        if result.height == 667.000000 { // 8
            return 2
        } else if result.height == 812.000000 { // 11 pro
            return 4
        } else {
            return 10
        }*/
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
}

extension UIView {
    
    func designForPP() {
        
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.systemGreen.cgColor
        self.layer.masksToBounds = true
    }
    
}
