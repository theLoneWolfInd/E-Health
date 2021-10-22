//
//  PatientPrescriptionTableCell.swift
//  E health App
//
//  Created by apple on 20/09/21.
//

import UIKit

class PatientPrescriptionTableCell: UITableViewCell {

    @IBOutlet weak var viewBG:UIView! {
        didSet {
            viewBG.layer.cornerRadius = 8
            viewBG.clipsToBounds = true
            
            viewBG.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            viewBG.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            viewBG.layer.shadowOpacity = 1.0
            viewBG.layer.shadowRadius = 7.0
            viewBG.layer.masksToBounds = false
            viewBG.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var imgViewprofile:UIImageView! {
        didSet {
            imgViewprofile.layer.cornerRadius = 35
            imgViewprofile.clipsToBounds = true
            imgViewprofile.layer.borderWidth = 1
            imgViewprofile.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    @IBOutlet weak var lblDoctorTitle:UILabel! {
        didSet {
            lblDoctorTitle.textColor = .black
        }
    }
    
    @IBOutlet weak var lblHospitalText:UILabel! {
        didSet {
            lblHospitalText.textColor = .black
        }
    }
    
    @IBOutlet weak var lblHospitalNameTitle:UILabel! {
        didSet {
            lblHospitalNameTitle.textColor = .black
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
