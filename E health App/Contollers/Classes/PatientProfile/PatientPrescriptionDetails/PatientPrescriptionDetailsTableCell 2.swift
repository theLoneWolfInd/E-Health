//
//  PatientPrescriptionDetailsTableCell.swift
//  E health App
//
//  Created by apple on 21/09/21.
//

import UIKit

class PatientPrescriptionDetailsTableCell: UITableViewCell , UIScrollViewDelegate {

    // cell 1 : patient name
    @IBOutlet weak var lblPatientName:UILabel! {
        didSet {
            lblPatientName.textColor = .black
        }
    }
    
    // cell 2 : prescription image
    @IBOutlet weak var imgPrescriptionImage:UIImageView! {
        didSet {
            imgPrescriptionImage.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            imgPrescriptionImage.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            imgPrescriptionImage.layer.shadowOpacity = 1.0
            imgPrescriptionImage.layer.shadowRadius = 15.0
            imgPrescriptionImage.layer.masksToBounds = false
            imgPrescriptionImage.layer.cornerRadius = 15
            imgPrescriptionImage.backgroundColor = .white
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
        }
    }
    
    // cell 3 : doctor's details
    @IBOutlet weak var viewDoctorDetails:UIView! {
        didSet {
            viewDoctorDetails.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            viewDoctorDetails.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            viewDoctorDetails.layer.shadowOpacity = 1.0
            viewDoctorDetails.layer.shadowRadius = 15.0
            viewDoctorDetails.layer.masksToBounds = false
            viewDoctorDetails.layer.cornerRadius = 15
            viewDoctorDetails.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var lblName:UILabel! {
        didSet {
            lblName.textColor = .black
        }
    }
    
    @IBOutlet weak var lblEmail:UILabel! {
        didSet {
            lblEmail.textColor = .black
        }
    }
    
    @IBOutlet weak var lblAddress:UILabel! {
        didSet {
            lblAddress.textColor = .black
        }
    }
    
    @IBOutlet weak var lblPhoneNumber:UILabel! {
        didSet {
            lblPhoneNumber.textColor = .black
        }
    }
    
    // cell 4 : hospital's details
    @IBOutlet weak var viewHospitalDetails:UIView! {
        didSet {
            viewHospitalDetails.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            viewHospitalDetails.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            viewHospitalDetails.layer.shadowOpacity = 1.0
            viewHospitalDetails.layer.shadowRadius = 15.0
            viewHospitalDetails.layer.masksToBounds = false
            viewHospitalDetails.layer.cornerRadius = 15
            viewHospitalDetails.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var lblHospitalName:UILabel! {
        didSet {
            lblHospitalName.textColor = .black
        }
    }
    
    @IBOutlet weak var lblHospitalEmail:UILabel! {
        didSet {
            lblHospitalEmail.textColor = .black
        }
    }
    
    @IBOutlet weak var lblHospitalAddress:UILabel! {
        didSet {
            lblHospitalAddress.textColor = .black
        }
    }
    
    @IBOutlet weak var lblHospitalPhoneNumber:UILabel! {
        didSet {
            lblHospitalPhoneNumber.textColor = .black
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
