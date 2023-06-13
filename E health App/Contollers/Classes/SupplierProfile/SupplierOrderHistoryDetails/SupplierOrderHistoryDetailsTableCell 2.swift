//
//  SupplierOrderHistoryDetailsTableCell.swift
//  E health App
//
//  Created by apple on 07/10/21.
//

import UIKit

class SupplierOrderHistoryDetailsTableCell: UITableViewCell {

     
    @IBOutlet weak var btnSupplierAddress:UIButton!
    
    @IBOutlet weak var viewBannerImgBG:UIView!{
        didSet{
            viewBannerImgBG.backgroundColor = .clear
        }
    }
    @IBOutlet weak var imgBanner:UIImageView!
    @IBOutlet weak var lblSupplierName:UILabel!
    @IBOutlet weak var btnAddress:UIButton!
    
    @IBOutlet weak var lblPrice:UILabel! {
        didSet {
            lblPrice.textColor = .black
        }
    }
    
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
    
    @IBOutlet weak var viewEditBtnBG:UIView! {
        didSet {
            viewEditBtnBG.backgroundColor = .clear
        }
    }
    @IBOutlet weak var btnEdit:UIButton! {
        didSet {
            btnEdit.isHidden = true
        }
    }
    
    @IBOutlet weak var viewPhoneBG:UIView! {
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
    
    @IBOutlet weak var viewEmailBG:UIView! {
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
    
    @IBOutlet weak var lblDeliveryStatus:UILabel! {
        didSet {
            lblDeliveryStatus.textColor = .black
        }
    }
    
    @IBOutlet weak var lblDeliveryTo:UILabel! {
        didSet {
            lblDeliveryTo.textColor = .black
        }
    }
    
    @IBOutlet weak var lblDeliveryLocation:UILabel! {
        didSet {
            lblDeliveryLocation.textColor = .black
        }
    }
    
    @IBOutlet weak var lblHospitalLocation:UILabel! {
        didSet {
            lblHospitalLocation.textColor = .black
        }
    }
    
    @IBOutlet weak var lblDeliveryDate:UILabel! {
        didSet {
            lblDeliveryDate.textColor = .black
        }
    }
    
    @IBOutlet weak var lblNotes:UILabel! {
        didSet {
            lblNotes.textColor = .black
        }
    }
    
    @IBOutlet weak var lblSupplierAddress:UILabel! {
        didSet {
            lblSupplierAddress.textColor = .black
        }
    }
    
    @IBOutlet weak var btnMarkAsDelivered:UIButton! {
        didSet {
            btnMarkAsDelivered.backgroundColor = .systemOrange
            btnMarkAsDelivered.layer.cornerRadius = 8
            btnMarkAsDelivered.clipsToBounds = true
            btnMarkAsDelivered.setTitle("Mark as Delivered", for: .normal)
        }
    }
    
    @IBOutlet weak var imgMarkAsDelivered:UIImageView! {
        didSet {
            imgMarkAsDelivered.isHidden = true
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
