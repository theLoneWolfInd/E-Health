//
//  PharmacyPrescriptionListTableCell.swift
//  E health App
//
//  Created by apple on 09/02/22.
//

import UIKit

class PharmacyPrescriptionListTableCell: UITableViewCell , UIScrollViewDelegate {

    @IBOutlet weak var view_bg:UIView! {
        didSet {
            view_bg.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_bg.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            view_bg.layer.shadowOpacity = 1.0
            view_bg.layer.shadowRadius = 15.0
            view_bg.layer.masksToBounds = false
            view_bg.layer.cornerRadius = 15
            view_bg.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var lbl_patient_name:UILabel! {
        didSet {
            lbl_patient_name.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_created:UILabel! {
        didSet {
            lbl_created.textColor = .lightGray
        }
    }
    
    @IBOutlet weak var img_profile:UIImageView! {
        didSet {
            img_profile.layer.cornerRadius = 30
            img_profile.clipsToBounds = true
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
