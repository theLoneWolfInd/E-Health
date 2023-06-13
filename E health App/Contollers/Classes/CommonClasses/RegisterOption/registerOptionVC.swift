//
//  registerOptionVC.swift
//  E health App
//
//  Created by Ranjan on 17/08/21.
//

import UIKit
import Alamofire

var employee : EmployeeData?

class registerOptionVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    
    var str_user_device_token:String!
    
    @IBOutlet weak var viewNavigationbar:UIView!
    @IBOutlet weak var btnNavigationBack: UIButton!
    @IBOutlet weak var lblNavationbar:UILabel!{
        didSet {
            
            lblNavationbar.text = "CONTINUE AS A"
        }
    }
    
    @IBOutlet weak var imgBackground:UIImageView!{
        didSet {
            
            imgBackground.layer.cornerRadius = 45.0
            imgBackground.clipsToBounds = true
            imgBackground.image = UIImage(named: "1024")
        }
    }
    
    @IBOutlet weak var viewImageBG:UIView!{
        didSet {
            
            viewImageBG.backgroundColor = .clear
        }
    }
    
    
    @IBOutlet weak var lblBrandName:UILabel!{
        didSet{
            
            let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "Chalkboard SE", size: 24.0)!]
            
            let myString = NSMutableAttributedString(string: "Welcome to Africa", attributes: myAttribute )
            
            let myRange1 = NSRange(location: 0, length: 10)
            
            myString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range:myRange1 )
            let myRange2 = NSRange(location: 11, length: 6)
            myString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range:myRange2 )
            
            let attrString = NSAttributedString(string: " eHealth", attributes: myAttribute)
            myString.append(attrString)
            
            let myRange3 = NSRange(location: 19, length: 6) // range starting at location 17 with a lenth of 7: "Strings"
            
            myString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(red: 43/256, green: 106/256, blue: 61/256, alpha: 1.0), range: myRange3)
            
            lblBrandName.attributedText = myString
        }
    }
    
    @IBOutlet weak var tablView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        btnNavigationBack.addTarget(self, action: #selector(btnNavigationBackPress), for: .touchUpInside)
        
        tablView.delegate = self
        tablView.dataSource = self
        self.view.backgroundColor = .white
        tablView.backgroundColor =  .white
        
        // print(employee?.employeeName as Any)
        
        
        self.rememberMe()
    }
    
    @objc func rememberMe() {
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
            //if (person["userId"] as! String) == "yes" {
            print(person as Any)
            
            if (person["deviceToken"] as! String) == "" {
                
                let defaults = UserDefaults.standard
                if let myString = defaults.string(forKey: "key_my_device_token") {
                    print("defaults savedString: \(myString)")
                    
                    self.str_user_device_token = "\(myString)"
                    
                    
                    
                    self.check_device_token_statusWB(str_user_id: "\(person["userId"]!)",
                                                     str_device_token:String(self.str_user_device_token) )
                    
                } else {
                    print("user disable notification")
                    
                }
                
            } else {
                self.push_after_remember_me()
            }
        }
    }
            
    
    @objc func check_device_token_statusWB(str_user_id:String ,
                                           str_device_token:String) {
        
            self.view.endEditing(true)
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            
            let params = update_device_token_status(action: "editprofile",
                                                    userId: String(str_user_id),
                                                    deviceToken: String(str_device_token))
            
            
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
                        
                        self.push_after_remember_me()
                        
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
                             
                            let alert = NewYorkAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), style: .alert)
                            
                            alert.addImage(UIImage.gif(name: "gif_alert"))
                            
                            let cancel = NewYorkButton(title: "Ok", style: .cancel)
                            alert.addButtons([cancel])
                            
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
    
    @objc func push_after_remember_me() {
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
            //if (person["userId"] as! String) == "yes" {
            print(person as Any)
            
        if (person["role"] as! String) == "Hospital" {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HPDashboardVC")
            self.navigationController?.pushViewController(push, animated: false)
            
        } else if (person["role"] as! String) == "Patient" {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPDashboardVC")
            self.navigationController?.pushViewController(push, animated: false)
            
        } else if (person["role"] as! String) == "Doctor" {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DPDashboardVC")
            self.navigationController?.pushViewController(push, animated: false)
            
        } else if (person["role"] as! String) == "Supplier" {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "dashboardVC")
            self.navigationController?.pushViewController(push, animated: false)
            
        } else if (person["role"] as! String) == "Lab" {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardDLPVC")
            self.navigationController?.pushViewController(push, animated: false)
            
        } else if (person["role"] as! String) == "Pharmacy" {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardDLPVC")
            self.navigationController?.pushViewController(push, animated: false)
            
        }
        
        
        
    }
        
    }
        
    @objc func btnNavigationBackPress(){
        navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:registerOptionTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell") as! registerOptionTableViewCell
        
        cell.backgroundColor = .white
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.btnClinic.setTitle("Patient", for: .normal)
        
        cell.btnDignosticLabs.addTarget(self, action: #selector(btnDignosticLabsPress), for: .touchUpInside)
        cell.btnPharmacy.addTarget(self, action: #selector(btnPharmacyPress), for: .touchUpInside)
        cell.btnDoctors.addTarget(self, action: #selector(btnDoctorsPress), for: .touchUpInside)
        cell.btnHospital.addTarget(self, action: #selector(btnHospitalPress), for: .touchUpInside)
        cell.btnClinic.addTarget(self, action: #selector(btnClinicPress), for: .touchUpInside)
        cell.btSupplier.addTarget(self, action: #selector(btnSuppliersPress), for: .touchUpInside)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 590
    }
    
    /*@objc func btnClinicPress(){
     
     let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPDashboardVC") as? PPDashboardVC
     
     self.navigationController?.pushViewController(push!, animated: true)
     }
     
     @objc func btnHospitalPress(){
     
     let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HPRegisterVC") as? HPRegisterVC
     
     self.navigationController?.pushViewController(push!, animated: true)
     }
     
     @objc func btnPharmacyPress(){
     
     let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPRegisterVC") as? PPRegisterVC
     
     self.navigationController?.pushViewController(push!, animated: true)
     }
     
     @objc func btnDoctorsPress(){
     
     let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DPRegisterVC") as? DPRegisterVC
     
     self.navigationController?.pushViewController(push!, animated: true)
     }
     
     
     @objc func btnDignosticLabsPress(){
     
     let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DLRegisterVC") as? DLRegisterVC
     
     self.navigationController?.pushViewController(push!, animated: true)
     }
     
     @objc func btSupplierPress(){
     
     let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "registerVC") as? registerVC
     
     self.navigationController?.pushViewController(push!, animated: true)
     
     }*/
    
    
    @objc func btnClinicPress() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "logInVC") as? logInVC
        push!.strUserLoginProfile = "Patient"
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    @objc func btnHospitalPress() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "welcomeVC") as? welcomeVC
        push!.strProfileName = "Hospital"
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    @objc func btnPharmacyPress() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "welcomeVC") as? welcomeVC
        push!.strProfileName = "Pharmacy"
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    @objc func btnDoctorsPress() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "welcomeVC") as? welcomeVC
        push!.strProfileName = "Doctors"
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    @objc func btnCreateNewAccountPress() {
        
        // let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "welcomeVC") as? welcomeVC
        
        // self.navigationController?.pushViewController(push!, animated: true)
    }
    
    @objc func btnDignosticLabsPress() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "welcomeVC") as? welcomeVC
        push!.strProfileName = "Diagnostic"
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    @objc func btnSuppliersPress() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "welcomeVC") as? welcomeVC
        push!.strProfileName = "Supplier"
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    
    
}
