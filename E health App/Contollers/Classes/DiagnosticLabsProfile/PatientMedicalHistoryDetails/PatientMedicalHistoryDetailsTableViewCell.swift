//
//  PatientMedicalHistoryDetailsTableViewCell.swift
//  E health App
//
//  Created by Ranjan on 24/08/21.
//

import UIKit

class PatientMedicalHistoryDetailsTableViewCell: UITableViewCell {
    
    //cell-1 outlets
    
    @IBOutlet weak var lblPatientName:UILabel!
    @IBOutlet weak var btnAddress:UIButton!
    
    //cell-2 outlets
    @IBOutlet weak var viewPhoneBG:UIView!{
        didSet{
            viewPhoneBG.backgroundColor = .white
            viewPhoneBG.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            viewPhoneBG.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            viewPhoneBG.layer.shadowOpacity = 1.0
            viewPhoneBG.layer.shadowRadius = 15.0
            viewPhoneBG.layer.masksToBounds = false
            viewPhoneBG.layer.cornerRadius = 15
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
            viewEmailBG.layer.cornerRadius = 15
        }
    }
    @IBOutlet weak var lblEmail:UILabel!

    //cell-3 outlets
    @IBOutlet weak var lblDieases:UILabel!
    
    //cell-4 outlets
    @IBOutlet weak var lblGender:UILabel!
    
    //cell-5 outlets
    @IBOutlet weak var lblTakingMedciene:UILabel!
    
    //cell-6 outlets
    @IBOutlet weak var lblMedicationAlergies:UILabel!
    
    //cell-7 outlets
    @IBOutlet weak var lblTobaccoAlcohol:UILabel!
    
    //cell-8 outlets
    @IBOutlet weak var lblEmpty:UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
