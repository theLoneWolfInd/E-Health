//
//  PPRegisterTableViewCell.swift
//  E health App
//
//  Created by Ranjan on 27/08/21.
//

import UIKit

class PPRegisterTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var txtPharmacyName:UITextField!{
        didSet {
            
            Utils.txtUitextField(textField: txtPharmacyName, placeholderName: "Pharmacy Name", setLeftPadding: 20)
            
            if let myImage = UIImage(systemName: "person.fill"){
                txtPharmacyName.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
            
        }
    }
    @IBOutlet weak var txtEmail:UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtEmail, placeholderName: "Contact Email", setLeftPadding: 20 )
            
            if let myImage = UIImage(systemName: "envelope"){
                
                txtEmail.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
            
        }
    }
    @IBOutlet weak var txtPassword:UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtPassword, placeholderName: "Password", setLeftPadding: 20 )
            
            if let myImage = UIImage(systemName: "lock.fill"){
                
                txtPassword.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
        }
    }
    @IBOutlet weak var txtPhone:UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtPhone, placeholderName: "Contact Phone", setLeftPadding: 20 )
            
            if let myImage = UIImage(systemName: "iphone.homebutton"){
                
                txtPhone.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
            
        }
    }
    @IBOutlet weak var txtAddress:UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtAddress, placeholderName: "Address", setLeftPadding: 20 )
            
            if let myImage = UIImage(systemName: "location.north"){
                
                txtAddress.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
            
        }
    }
    
    @IBOutlet weak var txtCountry:UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtCountry, placeholderName: "Country", setLeftPadding: 20 )
            
            if let myImage = UIImage(systemName: "chevron.down"){
                
                txtCountry.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
            
        }
    }
    
    @IBOutlet weak var btnCountry:UIButton!
    
    @IBOutlet weak var txtTiming:UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtTiming, placeholderName: "Open Timing", setLeftPadding: 20 )
        }
    }
    
    @IBOutlet weak var btnOpenTime:UIButton!
    @IBOutlet weak var btnCloseTime:UIButton!
    
    @IBOutlet weak var txt_close_Timing:UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txt_close_Timing, placeholderName: "Close Timing", setLeftPadding: 20 )
        }
    }
    
    @IBOutlet weak var txtAbout:UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtAbout, placeholderName: "About", setLeftPadding: 20 )
            
            if let myImage = UIImage(systemName: ""){
                
                txtAbout.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }

        }
    }
    
    @IBOutlet weak var btnSelectHospitalNClicnic:UIButton!
    
    @IBOutlet weak var btnOtherHospitalNClicnic:UIButton!
    
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
            
            let myRange1 = NSRange(location: 0, length: 26)
            
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

