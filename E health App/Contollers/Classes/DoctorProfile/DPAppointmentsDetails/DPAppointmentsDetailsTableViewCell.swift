//
//  DPAppointmentsDetailsTableViewCell.swift
//  E health App
//
//  Created by Ranjan on 31/08/21.
//

import UIKit

class DPAppointmentsDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var viewBG:UIView! {
        didSet {
            viewBG.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            viewBG.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            viewBG.layer.shadowOpacity = 1.0
            viewBG.layer.shadowRadius = 15.0
            viewBG.layer.masksToBounds = false
            viewBG.layer.cornerRadius = 15
            viewBG.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var imgPatientProfile:UIImageView! {
        didSet{
            imgPatientProfile.layer.cornerRadius = 30.0
            imgPatientProfile.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lblTitle:UILabel! {
        didSet {
            lblTitle.textColor = .black
        }
    }
    
    @IBOutlet weak var lblPatientOrHospitalName:UILabel! {
        didSet {
            lblPatientOrHospitalName.textColor = .black
        }
    }
    @IBOutlet weak var lblPatientOrHospitalPhone:UILabel! {
        didSet {
            lblPatientOrHospitalPhone.textColor = .black
        }
    }
    @IBOutlet weak var lblPatientOrHospitalAddress:UILabel! {
        didSet {
            lblPatientOrHospitalAddress.textColor = .black
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
