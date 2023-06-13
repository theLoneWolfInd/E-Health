//
//  registerTableViewCell.swift
//  E health App
//
//  Created by Ranjan on 17/08/21.
//

import UIKit

class registerTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var txtName:UITextField!{
        didSet {
            
            Utils.txtUitextField(textField: txtName, placeholderName: "Name", setLeftPadding: 20)
            
            if let myImage = UIImage(systemName: "person.fill"){
                txtName.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
    
            txtName.delegate = self
            
        }
    }
    @IBOutlet weak var txtEmail:UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtEmail, placeholderName: "mail", setLeftPadding: 20 )
            
            if let myImage = UIImage(systemName: "envelope"){
                
                txtEmail.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
            
            txtEmail.delegate = self
        }
    }
    
    @IBOutlet weak var btn_eye_old_pass:UIButton! {
        didSet {
            btn_eye_old_pass.setImage(UIImage(systemName: "eye"), for: .normal)
        }
    }
    
    @IBOutlet weak var txtPassword:UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtPassword, placeholderName: "Password", setLeftPadding: 20 )
            
//            if let myImage = UIImage(systemName: "lock.fill"){
//                
//                txtPassword.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
//            }
            
            txtPassword.delegate = self
        }
    }
    @IBOutlet weak var txtPhone:UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtPhone, placeholderName: "Phone", setLeftPadding: 20 )
            
            if let myImage = UIImage(systemName: "iphone.homebutton"){
                
                txtPhone.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
            
            txtPhone.delegate = self
        }
    }
    @IBOutlet weak var txtCountry:UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtCountry, placeholderName: "Country", setLeftPadding: 20 )
            
            if let myImage = UIImage(systemName: "chevron.down"){
                
                txtCountry.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
            
            txtCountry.delegate = self
        }
    }
    
    @IBOutlet weak var btnCountry:UIButton!
    
    @IBOutlet weak var txtAddress:UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtAddress, placeholderName: "Address", setLeftPadding: 20 )
            
            if let myImage = UIImage(systemName: "location.north"){
                
                txtAddress.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
            
            txtAddress.delegate = self
        }
    }
    @IBOutlet weak var txtSpecialty:UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtSpecialty, placeholderName: "About", setLeftPadding: 20 )
            
            if let myImage = UIImage(systemName: ""){
                
                txtSpecialty.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
            
            txtSpecialty.delegate = self
        }
    }
    @IBOutlet weak var btnSignUp:UIButton!{
        
        didSet{
            btnSignUp.layer.cornerRadius = 27.5
            btnSignUp.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnSignIn:UIButton!{
        didSet{
            
            
            let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "Avenir Heavy", size: 20.0)!]
            
            let myString = NSMutableAttributedString(string: "Already have an account - Sign In", attributes: myAttribute )
            
            var myRange1 = NSRange(location: 0, length: 26)
            
            myString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range:myRange1 )
            
            /*var myRange2 = NSRange(location: 11, length: 6)
            myString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range:myRange2 )
            
            let attrString = NSAttributedString(string: " eHealth", attributes: myAttribute)
            myString.append(attrString)
                        
            var myRange3 = NSRange(location: 19, length: 6) // range starting at location 17 with a lenth of 7: "Strings"
            
            myString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(red: 43/256, green: 106/256, blue: 61/256, alpha: 1.0), range: myRange3)*/
            
            
            
            btnSignIn.setAttributedTitle(myString, for: .normal)

        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
