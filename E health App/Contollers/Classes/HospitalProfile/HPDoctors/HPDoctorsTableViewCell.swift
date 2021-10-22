//
//  HPDoctorsTableViewCell.swift
//  E health App
//
//  Created by Ranjan on 02/09/21.
//

import UIKit

class HPDoctorsTableViewCell: UITableViewCell {

    @IBOutlet weak var imgDoctorsProfile:UIImageView! {
        didSet {
            imgDoctorsProfile.layer.cornerRadius = 25
            imgDoctorsProfile.clipsToBounds = true
            imgDoctorsProfile.layer.borderWidth = 1
            imgDoctorsProfile.layer.borderColor = UIColor.darkGray.cgColor
        }
    }
    
    @IBOutlet weak var lblDoctorsName:UILabel!{
        didSet{
            
            lblDoctorsName.textColor = .black
            
        }
    }
    @IBOutlet weak var lblSpecialist:UILabel!{
        didSet{
            lblSpecialist.textColor = .systemOrange
        }
    }
    @IBOutlet weak var btnPhoneNumber:UIButton!
    @IBOutlet weak var btnDelete:UIButton!
    
    @IBOutlet weak var imgEdit:UIImageView!
    @IBOutlet weak var imgDelete:UIImageView!
    
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
