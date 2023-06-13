//
//  MedicalHistoryTableViewCell.swift
//  E health App
//
//  Created by Ranjan on 26/08/21.
//

import UIKit

class MedicalHistoryTableViewCell: UITableViewCell , UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView:UIScrollView! {
        didSet {
            scrollView.delegate = self
        }
    }
    
    @IBOutlet weak var btnLeftScroll:UIButton! {
        didSet {
            btnLeftScroll.tintColor = .white
            btnLeftScroll.layer.cornerRadius = 8
            btnLeftScroll.clipsToBounds = true
            btnLeftScroll.layer.masksToBounds = false
            btnLeftScroll.layer.cornerRadius = 8
            btnLeftScroll.layer.backgroundColor = UIColor.black.cgColor
            btnLeftScroll.layer.borderColor = UIColor.clear.cgColor
            btnLeftScroll.layer.shadowColor = UIColor.black.cgColor
            btnLeftScroll.layer.shadowOffset = CGSize(width: 0, height: 0)
            btnLeftScroll.layer.shadowOpacity = 0.4
            btnLeftScroll.layer.shadowRadius = 4
            btnLeftScroll.isHidden = true
        }
    }
    
    @IBOutlet weak var btnRightScroll:UIButton! {
        didSet {
            btnRightScroll.tintColor = .white
            btnRightScroll.layer.cornerRadius = 8
            btnRightScroll.clipsToBounds = true
            btnRightScroll.layer.masksToBounds = false
            btnRightScroll.layer.cornerRadius = 8
            btnRightScroll.layer.backgroundColor = UIColor.black.cgColor
            btnRightScroll.layer.borderColor = UIColor.clear.cgColor
            btnRightScroll.layer.shadowColor = UIColor.black.cgColor
            btnRightScroll.layer.shadowOffset = CGSize(width: 0, height: 0)
            btnRightScroll.layer.shadowOpacity = 0.4
            btnRightScroll.layer.shadowRadius = 4
            btnRightScroll.isHidden = true
        }
    }
    
    @IBOutlet weak var imgProfileImage:UIImageView! {
        didSet {
            imgProfileImage.layer.cornerRadius = 12
            imgProfileImage.clipsToBounds = true
            imgProfileImage.isHidden = true
        }
    }
    
    @IBOutlet weak var txtDiseasename:UITextField! {
        
        didSet {
            
            Utils.txtUitextField(textField: txtDiseasename, placeholderName: "Disease name if any", setLeftPadding: 20 )
            
            txtDiseasename.backgroundColor = .white
            txtDiseasename.isSecureTextEntry = false
        }
    }
    @IBOutlet weak var txtGender:UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtGender, placeholderName: "What is your gender", setLeftPadding: 20 )
            
            txtGender.backgroundColor = .white
            txtGender.isSecureTextEntry = false
            if let myImage = UIImage(systemName: "chevron.down"){
                
                txtGender.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
        }
    }
    
    @IBOutlet weak var btnGender:UIButton!
    
    @IBOutlet weak var btnYesForMedication:UIButton!
    @IBOutlet weak var btnNOForMedication:UIButton!
    @IBOutlet weak var txtAboutMedication:UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtAboutMedication, placeholderName: "About Medication", setLeftPadding: 20 )
            txtAboutMedication.isUserInteractionEnabled = false
            txtAboutMedication.backgroundColor = .white
            txtAboutMedication.isSecureTextEntry = false
        }
    }
    
    @IBOutlet weak var btnYesForMedicationAllergies:UIButton!
    @IBOutlet weak var btnNOForMedicationAllergies:UIButton!
    @IBOutlet weak var txtAboutMedicationAllergies:UITextField!{
        
        didSet {
            
            Utils.txtUitextField(textField: txtAboutMedicationAllergies, placeholderName: "About Medication Allergies", setLeftPadding: 20 )
            txtAboutMedicationAllergies.isUserInteractionEnabled = false
            txtAboutMedicationAllergies.backgroundColor = .white
            txtAboutMedicationAllergies.isSecureTextEntry = false
            
        }
    }
    
    @IBOutlet weak var btnYesForHistoryDrug:UIButton!
    @IBOutlet weak var btnNOForHistoryDrug:UIButton!
    @IBOutlet weak var txtAboutHistoryDrug:UITextField! {
        didSet {
            
            Utils.txtUitextField(textField: txtAboutHistoryDrug, placeholderName: "Any Drugs", setLeftPadding: 20 )
            txtAboutHistoryDrug.isUserInteractionEnabled = false
            txtAboutHistoryDrug.backgroundColor = .white
            txtAboutHistoryDrug.isSecureTextEntry = false
        }
    }
    
    @IBOutlet weak var btnUploadReport:UIButton!
    @IBOutlet weak var txtUploadReport:UITextField!{
        didSet {
            
            Utils.txtUitextField(textField: txtUploadReport, placeholderName: "Upload Report", setLeftPadding: 20 )
            txtUploadReport.isUserInteractionEnabled = false
            txtUploadReport.backgroundColor = .white
            txtUploadReport.isSecureTextEntry = false
            
            if let myImage = UIImage(systemName: "square.and.arrow.up") {
                
                txtUploadReport.withImage(direction: .Right, image: myImage, colorSeparator: UIColor.white, colorBorder: UIColor.black)
            }
        }
    }
    
    @IBOutlet weak var btnSaveDetails:UIButton!{
        didSet{
            btnSaveDetails.layer.cornerRadius = 27.5
            btnSaveDetails.clipsToBounds = true
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
