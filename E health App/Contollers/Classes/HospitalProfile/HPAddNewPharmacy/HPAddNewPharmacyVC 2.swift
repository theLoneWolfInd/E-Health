//
//  HPAddNewPharmacyVC.swift
//  E health App
//
//  Created by Ranjan on 02/09/21.
//

import UIKit

class HPAddNewPharmacyVC: UIViewController {

    
    @IBOutlet weak var viewNavigationBar:UIView!
    @IBOutlet weak var btnNaviagtionBack:UIButton!
    @IBOutlet weak var lblNavigationBar:UILabel!{
        didSet {
            
            lblNavigationBar.text = "ADD NEW PHARMACY"
        }
    }
    
    @IBOutlet weak var viewBtnBG:UIView!{
        didSet{
            viewBtnBG.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var imgUploadBg:UIImageView!{
        didSet{
            imgUploadBg.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            imgUploadBg.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            imgUploadBg.layer.shadowOpacity = 1.0
            imgUploadBg.layer.shadowRadius = 15.0
            imgUploadBg.layer.masksToBounds = false
        }
    }
    @IBOutlet weak var btnImageUpload:UIButton!
    
    
    
    @IBOutlet weak var txtPharmacyName: UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtPharmacyName, placeholderName: "Pharmacy Name", setLeftPadding: 20 )
            
            txtPharmacyName.backgroundColor = .white
            
        }
    }
    
    @IBOutlet weak var txtPharmacyMail: UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtPharmacyMail, placeholderName: "Email Address", setLeftPadding: 20 )
            
            txtPharmacyMail.backgroundColor = .white
            
        }
    }
    
    @IBOutlet weak var txtPharmacyPhone: UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtPharmacyPhone, placeholderName: "Phone", setLeftPadding: 20 )
            
            txtPharmacyPhone.backgroundColor = .white
            
        }
    }
    
    @IBOutlet weak var txtPharmacyAddress: UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtPharmacyAddress, placeholderName: "Address", setLeftPadding: 20 )
            
            txtPharmacyAddress.backgroundColor = .white
            
        }
    }
    
    @IBOutlet weak var txtPharmacyAvailableTime: UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtPharmacyAvailableTime, placeholderName: "Available Time", setLeftPadding: 20 )
            
            txtPharmacyAvailableTime.backgroundColor = .white
            
        }
    }
    
    
    @IBOutlet weak var txtPharmacyZipCode: UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtPharmacyZipCode, placeholderName: "Zip Code", setLeftPadding: 20 )
            
            txtPharmacyZipCode.backgroundColor = .white
        
        }
    }

    
    @IBOutlet weak var btnSubmit:UIButton!{
        
        didSet{
            btnSubmit.layer.cornerRadius = 27.5
            btnSubmit.clipsToBounds = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .white
        
    }

}
