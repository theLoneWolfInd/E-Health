//
//  welcomeVC.swift
//  E health App
//
//  Created by Ranjan on 16/08/21.
//

import UIKit

class welcomeVC: UIViewController {
    
    var strProfileName:String!
    
    @IBOutlet weak var viewNavigationbar:UIView!
    @IBOutlet weak var lblNavationbar:UILabel!{
        didSet {
            
            lblNavationbar.text = "GET STARTED NOW"
        }
    }
    
    @IBOutlet weak var imgBackground:UIImageView!{
        didSet {
            
            imgBackground.layer.cornerRadius = 45.0
            imgBackground.clipsToBounds = true
            imgBackground.image = UIImage(named: "1024")
        }
    }
    
    @IBOutlet weak var imgBrandName:UIImageView!{
        didSet {
            imgBrandName.image = UIImage(named: "ehealth")
        }
    }
    
  @IBOutlet weak var btnSign:UIButton!{
        didSet {
            btnSign.layer.cornerRadius = 27.5
        }
    }
    
    @IBOutlet weak var btnCreateNewAccount:UIButton!{
        didSet {
            btnCreateNewAccount.layer.cornerRadius = 27.5
        }
    }

    @IBOutlet weak var lblTitle:UILabel!
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.tintColor = .white
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.lblTitle.text = "Welcome to Africa eHealth, "+strProfileName
        self.lblTitle.textColor = .black
        
        btnSign.addTarget(self, action: #selector(btnSignInpress), for: .touchUpInside)
        btnCreateNewAccount.addTarget(self, action: #selector(btnCreateNewAccountPress), for: .touchUpInside)
        
        self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        print(self.strProfileName as Any)
        
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnSignInpress() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "logInVC") as? logInVC
        push!.strUserLoginProfile = self.strProfileName
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func btnCreateNewAccountPress() {
        
        if self.strProfileName == "Hospital" {
            
             let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HPRegisterVC") as? HPRegisterVC
             self.navigationController?.pushViewController(push!, animated: true)
            
        }
        else if self.strProfileName == "Doctors"{
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DPRegisterVC") as? DPRegisterVC
            self.navigationController?.pushViewController(push!, animated: true)
           
           
        }
        
        else if self.strProfileName == "Pharmacy"{
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPRegisterVC") as? PPRegisterVC
            self.navigationController?.pushViewController(push!, animated: true)
        }
        else if self.strProfileName == "Diagnostic"{
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DLRegisterVC") as? DLRegisterVC
            self.navigationController?.pushViewController(push!, animated: true)
            
        } else if self.strProfileName == "Supplier"{
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "registerVC") as? registerVC
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        
        // let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "registerOptionVC") as? registerOptionVC
        // self.navigationController?.pushViewController(push!, animated: true)
        //
        
    }
    
}
