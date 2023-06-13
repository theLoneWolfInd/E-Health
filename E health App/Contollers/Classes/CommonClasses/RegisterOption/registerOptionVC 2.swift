//
//  registerOptionVC.swift
//  E health App
//
//  Created by Ranjan on 17/08/21.
//

import UIKit

class registerOptionVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
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
        
        self.rememberMe()
    }
    
    @objc func rememberMe() {
        
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
             
            
            
        } else {
            print("session has been expired. Login time.")
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
