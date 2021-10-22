//
//  PPBookAppointmentSelectDoctorVC.swift
//  E health App
//
//  Created by Ranjan on 07/09/21.
//

import UIKit
import Alamofire
import SDWebImage

var strDoc = ""

class PPBookAppointmentSelectDoctorVC: UIViewController {
    
    var arrListOfAllDoctors:NSMutableArray = []
    
    var saveHospitalListing:NSMutableArray = []
    
    @IBOutlet weak var viewNavigationBar: UIView!
    
    @IBOutlet weak var btnNavigationBack: UIButton!
    
    @IBOutlet weak var tablView: UITableView! {
        didSet {
            tablView.backgroundColor =  .white
            // tablView.delegate = self
            // tablView.dataSource = self
            self.tablView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        }
    }
    
    @IBOutlet weak var lblNavigationBar: UILabel!{
        didSet {
            lblNavigationBar.text =  "SELECT DOCTOR"
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.btnNavigationBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.listOfAllDoctors()
        
    }
    @objc func listOfAllDoctors() {
        self.arrListOfAllDoctors.removeAllObjects()
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        // if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            // let x : Int = person["userId"] as! Int
            // let myString = String(x)
            
            let params = DoctorsList(action: "userlist",
                                     role: String("Doctor"),
                                     addedBy: String(""),
                                     keyword: String(""))
            
            
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
                                
                                var ar : NSArray!
                                ar = (JSON["data"] as! Array<Any>) as NSArray
                                self.arrListOfAllDoctors.addObjects(from: ar as! [Any])
                                
                                self.tablView.delegate = self
                                self.tablView.dataSource = self
                                self.tablView.reloadData()
                                
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
}

extension PPBookAppointmentSelectDoctorVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrListOfAllDoctors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:PPBookAppointmentSelectDoctorTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell") as! PPBookAppointmentSelectDoctorTableViewCell
        
        cell.backgroundColor = .white
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        // cell.lblDoctorName.text = arr[indexPath.row]
        //cell.lblDoctorSpeciality.text = arr2[indexPath.row]
        cell.imgDoctorProfile.image = UIImage(named: "david")
        
        /*
         address = "Ramprastha 10";
         city = "";
         contactNumber = 9865320012;
         countryId = "";
         department = "";
         description = "";
         device = Android;
         deviceToken = "cLJ03vn3RYedLl9VOfQQsY:APA91bFcefuxPG0KvSeSjwioLjbXcc9_ujJ0n1dHdzqFvyjlFJR4orj9Gvf8FJXGLZGyFghYU7LPyE_IwOErdmciBZcPpT6ulJXdy5gKODtEr9CGx5GHK9DXMvnfvFlboQUknUihGNLo";
         dob = "";
         email = "Doc1@gmail.com";
         eyeColor = "";
         firebaseId = "";
         fullName = Doc1;
         gender = "";
         height = "";
         image = "https://demo4.evirtualservices.net/ehealth/img/uploads/users/1630423989images(33).jpeg";
         lastName = "";
         latitude = "28.6634121";
         longitude = "77.3239865";
         medicalCardID = "";
         middleName = "";
         practiceDate = "19 Aug, 2021";
         registeredDt = "0000-00-00 00:00:00";
         role = Doctor;
         socialId = "";
         socialType = "";
         specialty = "";
         state = "";
         status = 1;
         userId = 65;
         zipCode = "";
         */
        
        let item = arrListOfAllDoctors[indexPath.row] as? [String:Any]
        
        cell.lblDoctorName.text = (item!["fullName"] as! String)+" "+(item!["middleName"] as! String)+" "+(item!["lastName"] as! String)
        cell.lblDoctorSpeciality.text = (item!["specialty"] as! String)
        
        // cell.btnBook.tag = indexPath.row
        // cell.btnBook.addTarget(self, action: #selector(btnBookPress), for: .touchUpInside)
        
        cell.imgDoctorProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.imgDoctorProfile.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "1024"))
        
         cell.btnBook.tag = indexPath.row
         cell.btnBook.addTarget(self, action: #selector(checkThisDoctorStatus), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 98
    }
    
    @objc func btnBookPress(_ sender:UIButton) {
    
        // strDoc = arr[sender.tag]
        print(strDoc)
        
        // let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPBookAppointmentSelectDateVC") as? PPBookAppointmentSelectDateVC
        
        // self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    
    @objc func checkThisDoctorStatus(_ sender:UIButton) {
        let item = arrListOfAllDoctors[sender.tag] as? [String:Any]
        print(item as Any)
        
        /*
         Optional(["height": , "longitude": , "status": 1, "gender": , "email": doc10@gmail.com, "image": , "latitude": , "state": , "department": ENT, "city": , "contactNumber": 123456, "firebaseId": , "eyeColor": , "description": , "device": iOS, "registeredDt": , "socialId": , "dob": , "fullName": doc 10, "middleName": , "role": Doctor, "address": Ramprastha , "lastName": , "country": , "zipCode": , "specialty": ent, "practiceDate": Aug-16-2021, "socialType": , "userId": 170, "deviceToken": , "medicalCardID": ])
         */
        
        self.arrListOfAllDoctors.removeAllObjects()
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        // if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
        
         let x : Int = item!["userId"] as! Int
         let myString = String(x)
        
        let params = DoctorsList(action: "userlist",
                                 role: String("Hospital"),
                                 addedBy: String(myString),
                                 keyword: String(""))
        
        
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
                            
                            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPAppointmentHospitalListVC") as? PPAppointmentHospitalListVC
                            
                            /*var dict: Dictionary<AnyHashable, Any>
                            dict = JSON["data"] as! Dictionary<AnyHashable, Any>*/
                            
                            /*var ar : NSArray!
                            ar = (JSON["data"] as! Array<Any>) as NSArray
                            self.saveHospitalListing.add(ar as! [Any])*/
                            
                            // print(self.saveHospitalListing as Any)
                            push!.getSelectedDoctorDetails = item as NSDictionary?
                            push!.getHospitalListingOfThatDoctorInDictionary = JSON
                            self.navigationController?.pushViewController(push!, animated: true)
                            
                        } else {
                            print("no")
                            ERProgressHud.sharedInstance.hide()
                            
                            let doctorName = (item!["fullName"] as! String)+" "+(item!["middleName"] as! String)+" "+(item!["lastName"] as! String)
                            let alert = UIAlertController(title: String("Alert").uppercased(), message: "'"+doctorName+"' does not belong to any hospital. \n\nPlease proceed further to book an appointment."//String("Doctor does not belong to any hospital. \n\nPlease proceed further to book an appoitment.")
                                                          , preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "Book an appointment", style: .default, handler: {
                                action in
                                
                                // print(item as Any)
                                
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPBookAppointmentSelectDateVC") as? PPBookAppointmentSelectDateVC
                                push!.strHitDirect = "yes"
                                push!.fetchHospitalDataForBooking = item as NSDictionary?
                                
                                self.navigationController?.pushViewController(push!, animated: true)
                                
                            }))
                            
                            alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
                            
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
    
    
    
}
