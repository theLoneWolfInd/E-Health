//
//  PPAppointmentHospitalListTableViewCell.swift
//  E health App
//
//  Created by Ranjan on 07/09/21.
//

import UIKit

class PPAppointmentHospitalListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewBg:UIView! {
        didSet{
            viewBg.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            viewBg.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            viewBg.layer.shadowOpacity = 1.0
            viewBg.layer.shadowRadius = 15.0
            viewBg.layer.masksToBounds = false
            viewBg.layer.cornerRadius = 15
            viewBg.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var imgHospital:UIImageView!{
        didSet{
            imgHospital.layer.cornerRadius = 7.0
            imgHospital.clipsToBounds = true
            
            imgHospital.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            imgHospital.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            imgHospital.layer.shadowOpacity = 1.0
            imgHospital.layer.shadowRadius = 7.0
            imgHospital.layer.masksToBounds = false
        }
    }
    
    @IBOutlet weak var lblDistance:UILabel! {
        didSet {
            lblDistance.isHidden = true
        }
    }
    @IBOutlet weak var lblHospitalName:UILabel! {
        didSet {
            lblHospitalName.textColor = .black
        }
    }
    
    @IBOutlet weak var btnHospitalAddress:UIButton! {
        didSet {
            btnHospitalAddress.setTitleColor(.darkGray, for: .normal)
        }
    }

    @IBOutlet weak var btnHospitalDetails:UIButton! {
        didSet {
            btnHospitalDetails.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btnHospitalDetails.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btnHospitalDetails.layer.shadowOpacity = 1.0
            btnHospitalDetails.layer.shadowRadius = 7.0
            btnHospitalDetails.layer.masksToBounds = false
            btnHospitalDetails.setTitle("Details", for: .normal)
            btnHospitalDetails.backgroundColor = .systemOrange
            btnHospitalDetails.layer.cornerRadius = 8
            btnHospitalDetails.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btnHospitalBookAnAppoitment:UIButton! {
        didSet {
            btnHospitalBookAnAppoitment.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btnHospitalBookAnAppoitment.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btnHospitalBookAnAppoitment.layer.shadowOpacity = 1.0
            btnHospitalBookAnAppoitment.layer.shadowRadius = 7.0
            btnHospitalBookAnAppoitment.layer.masksToBounds = false
            btnHospitalBookAnAppoitment.setTitle("Book an appointment", for: .normal)
            btnHospitalBookAnAppoitment.backgroundColor = .systemGreen
            btnHospitalBookAnAppoitment.layer.cornerRadius = 8
            btnHospitalBookAnAppoitment.clipsToBounds = true
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
