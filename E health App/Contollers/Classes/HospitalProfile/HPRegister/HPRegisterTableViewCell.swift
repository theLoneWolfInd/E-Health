//
//  HPRegisterTableViewCell.swift
//  E health App
//
//  Created by Ranjan on 08/09/21.
//

import UIKit

class HPRegisterTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var txtName:UITextField!{
        didSet {
            
            Utils.txtUitextField(textField: txtName, placeholderName: "Hospital/ClinicName", setLeftPadding: 20)
            
            if let myImage = UIImage(systemName: "person.fill"){
                txtName.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
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
            
            Utils.txtUitextField(textField: txtPhone, placeholderName: "Contact Number", setLeftPadding: 20 )
            
            if let myImage = UIImage(systemName: "iphone.homebutton"){
                
                txtPhone.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
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
    
    @IBOutlet weak var txtAddress:UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtAddress, placeholderName: "Address", setLeftPadding: 20 )
            
            if let myImage = UIImage(systemName: "location.north"){
                
                txtAddress.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
            
        }
    }
    
    @IBOutlet weak var txtDescription:UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtDescription, placeholderName: "Description", setLeftPadding: 20 )
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
            
            let myRange1 = NSRange(location: 0, length: 26)
            
            myString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range:myRange1 )
            btnSignIn.setAttributedTitle(myString, for: .normal)

        }
    }

    @IBOutlet weak var viewOne:UIView! {
        didSet {
            viewOne.backgroundColor = UIColor.init(red: 232.0/255.0, green: 68.0/255.0, blue: 70.0/255.0, alpha: 1)
        }
    }
    
    @IBOutlet weak var viewTwo:UIView! {
        didSet {
            viewTwo.backgroundColor = .clear
        }
    }

    @IBOutlet weak var imgBackground:UIImageView!{
        didSet {
            
            imgBackground.layer.cornerRadius = 45.0
            imgBackground.clipsToBounds = true
            imgBackground.image = UIImage(named: "1024")
            imgBackground.layer.borderWidth = 2
            imgBackground.layer.borderColor = UIColor.darkGray.cgColor
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
