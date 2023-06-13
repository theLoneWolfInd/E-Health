//
//  HPAddNewDoctorTableViewCell.swift
//  E health App
//
//  Created by Ranjan on 02/09/21.
//

import UIKit

class HPAddNewDoctorTableViewCell: UITableViewCell {

    @IBOutlet weak var txtDoctorName: UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtDoctorName, placeholderName: "Name", setLeftPadding: 20 )
            
            txtDoctorName.backgroundColor = .white
            
            if let myImage = UIImage(systemName: "person.fill"){
                
                txtDoctorName.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
        }
    }
    
    @IBOutlet weak var txtDoctorEmail: UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtDoctorEmail, placeholderName: "Email", setLeftPadding: 20 )
            
            txtDoctorEmail.backgroundColor = .white
            
            if let myImage = UIImage(systemName: "envelope"){
                
                txtDoctorEmail.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
        }
    }
    
    @IBOutlet weak var txtDoctorPassword: UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtDoctorPassword, placeholderName: "Password", setLeftPadding: 20 )
            
            txtDoctorPassword.backgroundColor = .white
            
            if let myImage = UIImage(systemName: "envelope"){
                
                txtDoctorEmail.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
        }
    }
    
    @IBOutlet weak var txtDoctorPhone: UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtDoctorPhone, placeholderName: "Phone", setLeftPadding: 20 )
            
            txtDoctorPhone.backgroundColor = .white
            
            if let myImage = UIImage(systemName: "iphone.homebutton"){
                
                txtDoctorPhone.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
        }
    }
    
    @IBOutlet weak var txtDoctorAddress: UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtDoctorAddress, placeholderName: "Address", setLeftPadding: 20 )
            
            txtDoctorAddress.backgroundColor = .white
            
            if let myImage = UIImage(systemName: "location.north"){
                
                txtDoctorAddress.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
        }
    }
    
    @IBOutlet weak var txtDoctorSpeciality: UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtDoctorSpeciality, placeholderName: "Speciality", setLeftPadding: 20 )
            
            txtDoctorSpeciality.backgroundColor = .white
            
            if let myImage = UIImage(systemName: "chevron.down"){
                
                txtDoctorSpeciality.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
        }
    }
    
    @IBOutlet weak var lblPracticeStartDate: UILabel!
    @IBOutlet weak var btnDoctorDoctorSpeciality:UIButton!
    
    @IBOutlet weak var txtDoctorDepartment: UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtDoctorDepartment, placeholderName: "Department", setLeftPadding: 20 )
            
            txtDoctorDepartment.backgroundColor = .white
            
            if let myImage = UIImage(systemName: "chevron.down"){
                
                txtDoctorDepartment.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
        }
    }
    
    @IBOutlet weak var lblDepartment: UILabel!
    @IBOutlet weak var btnDoctorDoctorDepartment:UIButton!
    
    @IBOutlet weak var txtDoctorPracticeStartDate: UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtDoctorPracticeStartDate, placeholderName: "Practice Start Date", setLeftPadding: 20 )
            
            txtDoctorPracticeStartDate.backgroundColor = .white
            
            if let myImage = UIImage(systemName: "calendar"){
                
                txtDoctorPracticeStartDate.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
        }
    }
    
    @IBOutlet weak var btnDoctorPracticeStartDate:UIButton!
    
    @IBOutlet weak var txtCountry:UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtCountry, placeholderName: "Country", setLeftPadding: 20 )
            
            if let myImage = UIImage(systemName: "chevron.down") {
                
                txtCountry.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
            
        }
    }
    
    @IBOutlet weak var btnCountry:UIButton!
    
    @IBOutlet weak var btnSubmit:UIButton!{
        
        didSet{
            btnSubmit.layer.cornerRadius = 27.5
            btnSubmit.clipsToBounds = true
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
