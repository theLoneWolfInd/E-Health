//
//  PPAppointmentsVC.swift
//  E health App
//
//  Created by Ranjan on 03/09/21.
//

import UIKit
import Alamofire
import SDWebImage

class PPAppointmentsVC: UIViewController {
    
    var arr = ["Allen","Denical JohnSon", "Shawn Davis"]
    
    // save add to cart food
    var arrListOfAppoitmentList:NSMutableArray = []
    
    var strAppointmentDateCheck:String!
    
    @IBOutlet weak var viewNavigationbar:UIView!
    @IBOutlet weak var btnDashboardMenu: UIButton!
    @IBOutlet weak var lblNavationbar:UILabel!{
        didSet {
            
            lblNavationbar.text = "APPOINTMENTS"
        }
    }
    
    @IBOutlet weak var btnAddPatient:UIButton!
    
    @IBOutlet weak var tablView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // tablView.delegate = self
        // tablView.dataSource =  self
        self.view.backgroundColor = .white
        tablView.backgroundColor =  .white
        self.navigationController?.isNavigationBarHidden = true
        self.tablView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        self.tablView.separatorStyle = UITableViewCell.SeparatorStyle.none

        self.btnAddPatient.addTarget(self, action: #selector(pushToAllDoctorsList), for: .touchUpInside)
        
        
        if let myLoadedString = UserDefaults.standard.string(forKey: "keySetToBackOrMenu") {
            print(myLoadedString)
            
            if myLoadedString == "backOrMenu" {
                // menu
                self.btnDashboardMenu.setImage(UIImage(systemName: "list.dash"), for: .normal)
                self.sideBarMenuClick()
            } else {
                // back
                self.btnDashboardMenu.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
            }
        } else {
            // back
            self.btnDashboardMenu.setImage(UIImage(systemName: "arrow.left"), for: .normal)
            self.btnDashboardMenu.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            if (person["role"] as! String) == "Doctor" || (person["role"] as! String) == "Hospital" {
                self.btnAddPatient.isHidden = true
            } else if (person["role"] as! String) == "Patient"  {
                self.btnAddPatient.isHidden = false
            }
            
        }
        
        
        if self.strAppointmentDateCheck == nil {
            self.appoitmentList(strDateIs: "")
        } else {
            self.appoitmentList(strDateIs: String(self.strAppointmentDateCheck))
        }
         
    }

    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
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
    
    // Appoitment_List
    @objc func appoitmentList(strDateIs:String) {
        self.arrListOfAppoitmentList.removeAllObjects()
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            if (person["role"] as! String) == "Doctor" {
                ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Checking...")
            } else {
                ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            }
            
        }
        
        
        self.view.endEditing(true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            let params = Patient_Appoitment_List(action: "appointmentlist",
                                                 userId: String(myString),
                                                 type: (person["role"] as! String),
                                                 Adate: String(strDateIs))
            
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
                            
                            // var strSuccess2 : String!
                            // strSuccess2 = JSON["msg"]as Any as? String
                            
                            if strSuccess == String("success") {
                                print("yes")
                                
                                ERProgressHud.sharedInstance.hide()
                                
                                
                                var ar : NSArray!
                                ar = (JSON["data"] as! Array<Any>) as NSArray
                                self.arrListOfAppoitmentList.addObjects(from: ar as! [Any])
                                
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
            
        }
    }
}

extension PPAppointmentsVC:UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrListOfAppoitmentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:PPAppointmentsTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell") as! PPAppointmentsTableViewCell
        
        cell.backgroundColor = .white
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        // cell.lblPatientName.text = arr[indexPath.row]
        
        /*
         ATime = "Select Date";
         Adate = "2021-09-20";
         DoctorAddress = test;
         DoctorLastName = "";
         DoctorfullName = test02;
         HospitalAddress = India;
         HospitalLastName = "";
         HospitalfullName = test01;
         PatientAddress = "39, Sector 6, Sector 10 Dwarka, Dwarka, New Delhi, Delhi 110075, India";
         PatientImage = "https://demo4.evirtualservices.net/ehealth/img/uploads/users/1631791993images(44).jpeg";
         PatientLastName = one;
         PatientfullName = cap;
         appointmentId = 50;
         created = "2021-09-17 13:48:00";
         doctorId = 68;
         hospitalId = 67;
         userId = 161;
         */
        
        let item = self.arrListOfAppoitmentList[indexPath.row] as? [String:Any]
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            if (person["role"] as! String) == "Doctor" {
                cell.imgEye.isHidden = true
                
                cell.lblPatientName.text = (item!["PatientfullName"] as! String)
                
                cell.btnAppointmentDateTime.setTitle("Date: "+(item!["Adate"] as! String), for:.normal)
                
                cell.btnPatientAddress.setTitle(" "+(item!["PatientAddress"] as! String), for:.normal)
                cell.btnPatientAddress.titleLabel?.lineBreakMode = .byWordWrapping
                
                cell.imgPatientProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell.imgPatientProfile.sd_setImage(with: URL(string: (item!["PatientImage"] as! String)), placeholderImage: UIImage(named: "1024"))
                
                cell.imgEye.tag = indexPath.row
                let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(PPAppointmentsVC.cellTappedMethod1(_:)))

                cell.imgEye.isUserInteractionEnabled = true
                cell.imgEye.addGestureRecognizer(tapGestureRecognizer1)
                
            } else if (person["role"] as! String) == "Hospital" {
                cell.imgEye.isHidden = true
                
                cell.lblPatientName.text = (item!["DoctorfullName"] as! String)
                
                cell.btnAppointmentDateTime.setTitle("Date: "+(item!["Adate"] as! String), for:.normal)
                
                cell.btnPatientAddress.setTitle(" "+(item!["DoctorAddress"] as! String), for:.normal)
                cell.btnPatientAddress.titleLabel?.lineBreakMode = .byWordWrapping
                
                cell.imgPatientProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell.imgPatientProfile.sd_setImage(with: URL(string: (item!["DoctorImage"] as! String)), placeholderImage: UIImage(named: "1024"))
                
                cell.imgEye.tag = indexPath.row
                let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(PPAppointmentsVC.cellTappedMethod1(_:)))

                cell.imgEye.isUserInteractionEnabled = true
                cell.imgEye.addGestureRecognizer(tapGestureRecognizer1)
                
            }  else {
                cell.imgEye.isHidden = false
                
                cell.lblPatientName.text = (item!["DoctorfullName"] as! String)
                
                cell.btnAppointmentDateTime.setTitle("Date: "+(item!["Adate"] as! String), for:.normal)
                
                cell.btnPatientAddress.setTitle(" "+(item!["DoctorAddress"] as! String), for:.normal)
                cell.btnPatientAddress.titleLabel?.lineBreakMode = .byWordWrapping
                
                cell.imgPatientProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell.imgPatientProfile.sd_setImage(with: URL(string: (item!["DoctorImage"] as! String)), placeholderImage: UIImage(named: "1024"))
                
                cell.imgEye.tag = indexPath.row
                let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(PPAppointmentsVC.cellTappedMethod1(_:)))

                cell.imgEye.isUserInteractionEnabled = true
                cell.imgEye.addGestureRecognizer(tapGestureRecognizer1)
                
            }
            
        }
        
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            if (person["role"] as! String) == "Doctor" {
                
                let item = self.arrListOfAppoitmentList[indexPath.row] as? [String:Any]
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DPAppointmentsDetailsVC") as? DPAppointmentsDetailsVC
                push!.dictGetBookingDetailsForDoctors = item as NSDictionary?
                self.navigationController?.pushViewController(push!, animated: true)
                
            } else if (person["role"] as! String) == "Hospital" {
                
                let item = self.arrListOfAppoitmentList[indexPath.row] as? [String:Any]
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DPAppointmentsDetailsVC") as? DPAppointmentsDetailsVC
                push!.dictGetBookingDetailsForDoctors = item as NSDictionary?
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            
        }
    }
    
    @objc func cellTappedMethod1(_ sender:AnyObject) {
        
        print("you tap image number: \(sender.view.tag)")
        
        let item = self.arrListOfAppoitmentList[sender.view.tag] as? [String:Any]
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPAppointmentDetailsVC") as? PPAppointmentDetailsVC
        push!.getPatientAppointmentDetails = item as NSDictionary?
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func pushToAllDoctorsList() {
        //
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPBookAppointmentSelectDoctorVC") as? PPBookAppointmentSelectDoctorVC
        self.navigationController?.pushViewController(push!, animated: true)
        
        
    }
    
}
