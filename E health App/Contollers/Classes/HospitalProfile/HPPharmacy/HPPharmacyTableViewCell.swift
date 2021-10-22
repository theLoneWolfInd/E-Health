//
//  HPPharmacyTableViewCell.swift
//  E health App
//
//  Created by Ranjan on 02/09/21.
//

import UIKit

class HPPharmacyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgPharmacyProfile:UIImageView! {
        didSet {
            imgPharmacyProfile.layer.cornerRadius = 25
            imgPharmacyProfile.clipsToBounds = true
            imgPharmacyProfile.layer.borderWidth = 1
            imgPharmacyProfile.layer.borderColor = UIColor.darkGray.cgColor
        }
    }
    @IBOutlet weak var lblPharmacyName:UILabel!{
        didSet{
            
            lblPharmacyName.textColor = .black
        }
    }
    @IBOutlet weak var lblPharmacyPhone:UILabel!{
        didSet{
            lblPharmacyPhone.textColor = .systemOrange
        }
    }
    @IBOutlet weak var btnPharmacyAddress:UIButton!
    
    @IBOutlet weak var btnDelete:UIButton!
    @IBOutlet weak var btnEdit:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
