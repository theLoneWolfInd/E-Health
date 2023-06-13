//
//  changePasswordVC.swift
//  E health App
//
//  Created by Ranjan on 21/08/21.
//

import UIKit
import Alamofire

class changePasswordVC: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var viewNavigationbar:UIView!
    @IBOutlet weak var btnDashboardMenu:UIButton!
    @IBOutlet weak var lblNavationbar:UILabel!{
        didSet {
            
            lblNavationbar.text = "CHANGE PASSWORD"
        }
    }

    
    @IBOutlet weak var txtCurrentPassword:UITextField!{
        didSet {
            
            Utils.txtUitextField(textField: txtCurrentPassword, placeholderName: "Current Password", setLeftPadding: 20)
            
            if let myImage = UIImage(systemName: "eye"){
                txtCurrentPassword.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
    
            txtCurrentPassword.delegate = self
            
        }
    }
    @IBOutlet weak var txtNewPassword:UITextField!{
    
    didSet {
        
        Utils.txtUitextField(textField: txtNewPassword, placeholderName: "New Password", setLeftPadding: 20 )
        
        if let myImage = UIImage(systemName: "eye"){
            
            txtNewPassword.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
        }
        
        txtNewPassword.delegate = self
    }
}
    
    @IBOutlet weak var txtConfirmNewPassword:UITextField!{
    
    didSet {
        
        Utils.txtUitextField(textField: txtConfirmNewPassword, placeholderName: "Confirm Password", setLeftPadding: 20 )
        
        if let myImage = UIImage(systemName: "eye"){
            
            txtConfirmNewPassword.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
        }
        
        txtConfirmNewPassword.delegate = self
    }
}
    
    @IBOutlet weak var btnUpdatePassword:UIButton!{
        
        didSet{
            btnUpdatePassword.layer.cornerRadius = 27.5
            btnUpdatePassword.clipsToBounds = true
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .white
        
        self.btnUpdatePassword.addTarget(self, action: #selector(validationBeforeChangePassword), for: .touchUpInside)
        
        self.btnDashboardMenuPress()
    }

    @objc func btnDashboardMenuPress(){
        
        if revealViewController() != nil {
            btnDashboardMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
    }

    
    
    @objc func validationBeforeChangePassword() {
        
        if self.txtCurrentPassword.text == "" {
            
            let alert = UIAlertController(title: String("Error!"), message: String("Current Password should not be Empty."), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                 
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else if self.txtNewPassword.text == "" {
            
            let alert = UIAlertController(title: String("Error!"), message: String("New Password should not be Empty."), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                 
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else if self.txtConfirmNewPassword.text == "" {
            
            let alert = UIAlertController(title: String("Error!"), message: String("Confirm Password should not be Empty."), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                 
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else if self.txtNewPassword.text != self.txtConfirmNewPassword.text {
            
            let alert = UIAlertController(title: String("Error!"), message: String("Password not match."), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                 
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            self.changePasswordWB()
        }
        
        
    }
    
    @objc func changePasswordWB() {
         ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        self.view.endEditing(true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
         // let str:String = person["role"] as! String
        
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
        let params = ChangePasswordW(action: "changePassword",
                                         userId: String(myString),
                                         oldPassword: String(txtCurrentPassword.text!),
                                         newPassword: String(txtNewPassword.text!))
        
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
                        
                         var strSuccess2 : String!
                         strSuccess2 = JSON["msg"]as Any as? String
                        
                        if strSuccess == String("success") {
                            print("yes")
                            ERProgressHud.sharedInstance.hide()
                           
                            let alert = UIAlertController(title: String(strSuccess), message: String(strSuccess2), preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                                
                                self.txtCurrentPassword.text = ""
                                self.txtNewPassword.text = ""
                                self.txtConfirmNewPassword.text = ""
                                
                            }))
                            self.present(alert, animated: true, completion: nil)
                            
                            
                            
                            
                        } else {
                            
                            print("no")
                            ERProgressHud.sharedInstance.hide()
                            
                            var strSuccess2 : String!
                            strSuccess2 = JSON["msg"]as Any as? String
                            
                            let alert = UIAlertController(title: String(strSuccess), message: String(strSuccess2), preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        
                    case let .failure(error):
                        print(error)
                        ERProgressHud.sharedInstance.hide()
                        
                        let alert = UIAlertController(title: String("Error!"), message: String("Server Issue"), preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
        }
    }
    }
    
}
