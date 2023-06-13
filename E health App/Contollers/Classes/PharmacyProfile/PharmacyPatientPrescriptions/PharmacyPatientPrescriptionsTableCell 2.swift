//
//  PharmacyPatientPrescriptionsTableCell.swift
//  E health App
//
//  Created by apple on 21/10/21.
//

import UIKit

class PharmacyPatientPrescriptionsTableCell: UITableViewCell {

    @IBOutlet weak var viewCellBG:UIView! {
        didSet {
            viewCellBG.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            viewCellBG.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            viewCellBG.layer.shadowOpacity = 1.0
            viewCellBG.layer.shadowRadius = 15.0
            viewCellBG.layer.masksToBounds = false
            viewCellBG.layer.cornerRadius = 15
            viewCellBG.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var imgPatientProfile:UIImageView! {
        didSet {
            imgPatientProfile.layer.cornerRadius = 40
            imgPatientProfile.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lblPatientName:UILabel! {
        didSet {
            lblPatientName.textColor = .black
        }
    }
    
    @IBOutlet weak var lblPatientEmail:UILabel! {
        didSet {
            lblPatientEmail.textColor = .black
        }
    }
    
    @IBOutlet weak var lblPatientAddress:UILabel! {
        didSet {
            lblPatientAddress.textColor = .black
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
