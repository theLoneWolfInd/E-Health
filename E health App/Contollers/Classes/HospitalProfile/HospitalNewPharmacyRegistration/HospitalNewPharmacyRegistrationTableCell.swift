//
//  HospitalNewPharmacyRegistrationTableCell.swift
//  E health App
//
//  Created by apple on 11/10/21.
//

import UIKit

class HospitalNewPharmacyRegistrationTableCell: UITableViewCell {

    @IBOutlet weak var imgBackground:UIImageView!{
        didSet {
            
            imgBackground.layer.cornerRadius = 45.0
            imgBackground.clipsToBounds = true
            imgBackground.image = UIImage(named: "1024")
            imgBackground.layer.borderWidth = 2
            imgBackground.layer.borderColor = UIColor.darkGray.cgColor
        }
    }
    
    @IBOutlet weak var txtPharmacyName:UITextField!{
        didSet {
            
            Utils.txtUitextField(textField: txtPharmacyName, placeholderName: "name...", setLeftPadding: 20)
            
            if let myImage = UIImage(systemName: "person.fill"){
                txtPharmacyName.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
            
        }
    }
    @IBOutlet weak var txtEmail:UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtEmail, placeholderName: "email...", setLeftPadding: 20 )
            
            if let myImage = UIImage(systemName: "envelope"){
                
                txtEmail.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
            
        }
    }
    @IBOutlet weak var txtPassword:UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtPassword, placeholderName: "password...", setLeftPadding: 20 )
            
            if let myImage = UIImage(systemName: "lock.fill"){
                
                txtPassword.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
        }
    }
    @IBOutlet weak var txtPhone:UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtPhone, placeholderName: "phone...", setLeftPadding: 20 )
            
            if let myImage = UIImage(systemName: "iphone.homebutton"){
                
                txtPhone.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
            
        }
    }
    @IBOutlet weak var txtAddress:UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtAddress, placeholderName: "address...", setLeftPadding: 20 )
            
            if let myImage = UIImage(systemName: "location.north"){
                
                txtAddress.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
            
        }
    }
    
    @IBOutlet weak var txtCountry:UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtCountry, placeholderName: "country...", setLeftPadding: 20 )
            
            if let myImage = UIImage(systemName: "chevron.down"){
                
                txtCountry.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
            
        }
    }
    
    @IBOutlet weak var btnCountry:UIButton!
    
    @IBOutlet weak var btnOpenTime:UIButton!
    @IBOutlet weak var btnCloseTime:UIButton!
    
    @IBOutlet weak var txtOpenTiming:UITextField!{
        didSet {
            Utils.txtUitextField(textField: txtOpenTiming, placeholderName: "open...", setLeftPadding: 20 )
        }
    }
    
    @IBOutlet weak var txtCloseTiming:UITextField!{
        didSet {
            Utils.txtUitextField(textField: txtCloseTiming, placeholderName: "close...", setLeftPadding: 20 )
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
    
    @IBOutlet weak var btnSignIn:UIButton!
    
    
    
    @IBOutlet weak var txtDescription:UITextField! {
        didSet {
            Utils.txtUitextField(textField: txtDescription, placeholderName: "Description", setLeftPadding: 20 )
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
