//
//  LabsPatientDetailsTableCell.swift
//  E health App
//
//  Created by apple on 18/10/21.
//

import UIKit

class LabsPatientDetailsTableCell: UITableViewCell {

    @IBOutlet weak var viewBannerImgBG:UIView!{
        didSet{
            viewBannerImgBG.isHidden = false
            viewBannerImgBG.backgroundColor = .clear
        }
    }
    @IBOutlet weak var imgBanner:UIImageView!
    @IBOutlet weak var lblLabName:UILabel!
    @IBOutlet weak var btnAddress:UIButton!
    
    @IBOutlet weak var viewProfileBG:UIView!{
        didSet{
            viewProfileBG.isHidden = false
            viewProfileBG.backgroundColor = .clear
        }
    }
    @IBOutlet weak var imgProfile:UIImageView!{
        didSet{
            
            imgProfile.layer.borderWidth = 5.0
            imgProfile.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    @IBOutlet weak var viewEditBtnBG:UIView!{
        didSet{
            viewEditBtnBG.isHidden = false
            viewEditBtnBG.backgroundColor = .clear
        }
    }
    @IBOutlet weak var btnEdit:UIButton!
    
    @IBOutlet weak var viewHistoryBtnBG:UIView!{
        didSet{
            viewHistoryBtnBG.isHidden = false
            viewHistoryBtnBG.backgroundColor = .clear
        }
    }
    @IBOutlet weak var btnHistory:UIButton!
    
    @IBOutlet weak var viewPhoneBG:UIView!{
        didSet {
            viewPhoneBG.backgroundColor = .white
            viewPhoneBG.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            viewPhoneBG.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            viewPhoneBG.layer.shadowOpacity = 1.0
            viewPhoneBG.layer.shadowRadius = 15.0
            viewPhoneBG.layer.masksToBounds = false
            viewPhoneBG.layer.cornerRadius = 15.0
            viewPhoneBG.clipsToBounds = true
        }
    }
    @IBOutlet weak var lblPhone:UILabel!
    
    @IBOutlet weak var viewEmailBG:UIView!{
        didSet{
            
            viewEmailBG.backgroundColor = .white
            viewEmailBG.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            viewEmailBG.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            viewEmailBG.layer.shadowOpacity = 1.0
            viewEmailBG.layer.shadowRadius = 15.0
            viewEmailBG.layer.masksToBounds = false
            viewEmailBG.layer.cornerRadius = 15.0
            viewEmailBG.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lblEmail:UILabel!
    
    
    //cell2 outlets
    
    @IBOutlet weak var lblSpecialist:UILabel!
    
    //cell3 outlets
    @IBOutlet weak var lblHospitalName:UILabel!
    
    //cell4 outlets
    @IBOutlet weak var lblLocation:UILabel!
    
    //cell5 outlets
    @IBOutlet weak var btnAllPatient:UIButton! {
        didSet {
            btnAllPatient.layer.cornerRadius = 27.5
            btnAllPatient.clipsToBounds = true
            btnAllPatient.setTitle("Check Medical History", for: .normal)
        }
    }
    
    @IBOutlet weak var btnRqstSupplier:UIButton! {
        didSet {
            btnRqstSupplier.layer.cornerRadius = 27.5
            btnRqstSupplier.clipsToBounds = true
            btnRqstSupplier.setTitle("View Tests", for: .normal)
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
