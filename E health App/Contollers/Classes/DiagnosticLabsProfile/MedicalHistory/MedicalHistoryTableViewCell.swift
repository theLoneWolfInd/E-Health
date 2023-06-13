//
//  MedicalHistoryTableViewCell.swift
//  E health App
//
//  Created by Ranjan on 26/08/21.
//

import UIKit

class MedicalHistoryTableViewCell: UITableViewCell , UIScrollViewDelegate {
    
    @IBOutlet weak var view_cell_bg:UIView! {
        didSet {
            view_cell_bg.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_cell_bg.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            view_cell_bg.layer.shadowOpacity = 1.0
            view_cell_bg.layer.shadowRadius = 15.0
            view_cell_bg.layer.masksToBounds = false
            view_cell_bg.layer.cornerRadius = 15
            view_cell_bg.backgroundColor = .white
        }
    }
    
    /*@IBOutlet weak var txt_field_answer:UITextField! {
        didSet {
            txt_field_answer.borderStyle = .none
            txt_field_answer.layer.masksToBounds = false
            txt_field_answer.layer.cornerRadius = 5.0;
            txt_field_answer.layer.backgroundColor = UIColor.white.cgColor
            txt_field_answer.layer.borderColor = UIColor.clear.cgColor
            txt_field_answer.layer.shadowColor = UIColor.black.cgColor
            txt_field_answer.layer.shadowOffset = CGSize(width: 0, height: 0)
            txt_field_answer.layer.shadowOpacity = 0.2
            txt_field_answer.layer.shadowRadius = 4.0
            txt_field_answer.setLeftPaddingPoints(20)
        }
    }*/
    
    @IBOutlet weak var txt_view_answer:UITextView! {
        didSet {
            
            txt_view_answer.layer.cornerRadius = 8
            txt_view_answer.clipsToBounds = true
            txt_view_answer.layer.borderColor = UIColor.lightGray.cgColor
            txt_view_answer.layer.borderWidth = 0.50
            txt_view_answer.backgroundColor = .white
            txt_view_answer.textColor = .black
            // txt_view_answer.borderStyle = .none
            /*txt_view_answer.layer.masksToBounds = false
            txt_view_answer.layer.cornerRadius = 5.0;
            txt_view_answer.layer.backgroundColor = UIColor.white.cgColor
            txt_view_answer.layer.borderColor = UIColor.clear.cgColor
            txt_view_answer.layer.shadowColor = UIColor.black.cgColor
            txt_view_answer.layer.shadowOffset = CGSize(width: 0, height: 0)
            txt_view_answer.layer.shadowOpacity = 0.2
            txt_view_answer.layer.shadowRadius = 4.0*/
            // txt_view_answer.setLeftPaddingPoints(20)
        }
    }
    
    @IBOutlet weak var lbl_question:UILabel! {
        didSet {
            lbl_question.backgroundColor = .clear
            lbl_question.textColor = .black
        }
    }
    
    @IBOutlet weak var btn_for_textField:UIButton! {
        didSet {
            btn_for_textField.setTitle("", for: .normal)
        }
    }
    
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
            Utils.txtUitextField(textField: txtDiseasename, placeholderName: "Disease name if any", setLeftPadding: 20)
            
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
    @IBOutlet weak var txtAboutHistoryDrug:UITextField!{
        
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
    
    @IBOutlet weak var btnSaveDetails:UIButton! {
        didSet {
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
