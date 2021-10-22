//
//  HPDashboardTableViewCell.swift
//  E health App
//
//  Created by Ranjan on 01/09/21.
//

import UIKit

class HPDashboardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewBannerImgBG:UIView!{
        didSet{
            viewBannerImgBG.backgroundColor = .clear
        }
    }
    @IBOutlet weak var imgBanner:UIImageView!
    @IBOutlet weak var lblHospitalName:UILabel!
    @IBOutlet weak var btnAddress:UIButton!
    
   @IBOutlet weak var viewProfileBG:UIView!{
        didSet{
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
            viewEditBtnBG.backgroundColor = .clear
        }
    }
    @IBOutlet weak var btnEdit:UIButton!
    
    @IBOutlet weak var viewHistoryBtnBG:UIView!{
        didSet{
            viewHistoryBtnBG.backgroundColor = .clear
            
        }
    }
    @IBOutlet weak var btnHistory:UIButton!
    
    @IBOutlet weak var viewPhoneBG:UIView!{
        didSet{
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
    @IBOutlet weak var lblPhone:UILabel! {
        didSet {
            lblPhone.textColor = .systemBlue
        }
    }
    
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
    
    @IBOutlet weak var lblEmail:UILabel! {
        didSet {
            lblEmail.textColor = .systemBlue
        }
    }
    
    @IBOutlet weak var lblHospitalDetail:UILabel!
    
    @IBOutlet weak var btnDoctors:UIButton!{
        didSet{
            btnDoctors.layer.cornerRadius = 27.7
            btnDoctors.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btnLabs:UIButton!{
        didSet{
            btnLabs.layer.cornerRadius = 27.7
            btnLabs.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btnPharmacy:UIButton!{
        didSet{
            btnPharmacy.layer.cornerRadius = 27.7
            btnPharmacy.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btnPatient:UIButton!{
        didSet{
            btnPatient.layer.cornerRadius = 27.7
            btnPatient.clipsToBounds = true
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
