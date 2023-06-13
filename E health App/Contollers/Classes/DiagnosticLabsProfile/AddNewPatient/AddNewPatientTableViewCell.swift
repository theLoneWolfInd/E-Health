//
//  AddNewPatientTableViewCell.swift
//  E health App
//
//  Created by Ranjan on 25/08/21.
//

import UIKit

class AddNewPatientTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgUploadBg:UIImageView!{
        didSet{
            // imgUploadBg.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            // imgUploadBg.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            // imgUploadBg.layer.shadowOpacity = 1.0
            // imgUploadBg.layer.shadowRadius = 15.0
            // imgUploadBg.layer.masksToBounds = false
            imgUploadBg.layer.borderWidth = 8
            imgUploadBg.layer.borderColor = UIColor.white.cgColor
            imgUploadBg.layer.cornerRadius = 32
            imgUploadBg.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btnDor: UIButton!
    @IBOutlet weak var btnDOB: UIButton!
    
    @IBOutlet weak var btn_disease: UIButton!
    @IBOutlet weak var btnCountry: UIButton!
    
    @IBOutlet weak var btnGender: UIButton!
    
    @IBOutlet weak var txtDateOfReg: UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtDateOfReg, placeholderName: "Date of Registration", setLeftPadding: 20 )
            
            txtDateOfReg.backgroundColor = .white
            
            if let myImage = UIImage(systemName: "calendar"){
                
                txtDateOfReg.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
        }
    }
    
    
    @IBOutlet weak var txtUID: UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtUID, placeholderName: "Unique Identification Card", setLeftPadding: 20 )
            txtUID.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var txtFirstName: UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtFirstName, placeholderName: "First Name", setLeftPadding: 20 )
            txtFirstName.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var txtMiddleName: UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtMiddleName, placeholderName: "Middle Name", setLeftPadding: 20 )
            txtMiddleName.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var txt_disease_name: UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txt_disease_name, placeholderName: "Disease name", setLeftPadding: 20 )
            txtMiddleName.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var txtLastName: UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtLastName, placeholderName: "Last Name", setLeftPadding: 20 )
            txtLastName.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var txtNickName: UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtNickName, placeholderName: "Other Name", setLeftPadding: 20 )
            txtNickName.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var txtDob: UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtDob, placeholderName: "Date of Birth", setLeftPadding: 20 )
            
            txtDob.backgroundColor = .white
            
            if let myImage = UIImage(systemName: "calendar") {
                
                txtDob.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
        }
    }
    
    @IBOutlet weak var txtAddress: UITextField!{
        didSet {
            Utils.txtUitextField(textField: txtAddress, placeholderName: "Address", setLeftPadding: 20 )
            
            txtAddress.backgroundColor = .white
            
            if let myImage = UIImage(systemName: "") {
                
                txtAddress.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
        }
    }
    
    
    @IBOutlet weak var txtCity: UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtCity, placeholderName: "City", setLeftPadding: 20 )
            txtCity.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var txtCountryName: UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtCountryName, placeholderName: "Country", setLeftPadding: 20 )
            txtCountryName.backgroundColor = .white
            
            if let myImage = UIImage(systemName: "chevron.down"){
                
                txtCountryName.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
        }
    }
    
    @IBOutlet weak var txtGender: UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtGender, placeholderName: "Gender", setLeftPadding: 20 )
            txtGender.backgroundColor = .white
            
            if let myImage = UIImage(systemName: "chevron.down"){
                
                txtGender.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
        }
    }
    
    @IBOutlet weak var txtHeight: UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtHeight, placeholderName: "Height", setLeftPadding: 20 )
            txtHeight.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var txtEyeColor: UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtEyeColor, placeholderName: "Eye Color", setLeftPadding: 20 )
            txtEyeColor.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var txtPinNumber: UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtPinNumber, placeholderName: "Pin number for security", setLeftPadding: 20 )
            txtPinNumber.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var txtUserName: UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtUserName, placeholderName: "Username", setLeftPadding: 20 )
            txtUserName.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var txtPhoneNumber: UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtPhoneNumber, placeholderName: "Phone", setLeftPadding: 20 )
            txtPhoneNumber.backgroundColor = .white
            
        }
    }
    
    @IBOutlet weak var txtEmail: UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtEmail, placeholderName: "Email Address", setLeftPadding: 20 )
            txtEmail.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var txtPassword: UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtPassword, placeholderName: "Password", setLeftPadding: 20 )
            txtPassword.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var txtConfirmPassword: UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtConfirmPassword, placeholderName: "Confirm Password", setLeftPadding: 20 )
            txtConfirmPassword.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var btnCheckUnchek: UIButton!
    
    @IBOutlet weak var btnSubmit: UIButton!{
        didSet{
            btnSubmit.layer.cornerRadius = 27.5
            btnSubmit.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btnAddMedicalHistory: UIButton!{
        didSet{
            btnAddMedicalHistory.layer.cornerRadius = 27.5
            btnAddMedicalHistory.clipsToBounds = true
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
