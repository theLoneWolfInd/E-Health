//
//  PPBookAppointmentSelectDoctorTableViewCell.swift
//  E health App
//
//  Created by Ranjan on 07/09/21.
//

import UIKit

class PPBookAppointmentSelectDoctorTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imgDoctorProfile: UIImageView!
    
    @IBOutlet weak var lblDoctorName: UILabel!
    
    @IBOutlet weak var lblDoctorSpeciality: UILabel!
    
    
    @IBOutlet weak var btnBook: UIButton! {
        didSet{
            btnBook.layer.cornerRadius = 15.0
            btnBook.clipsToBounds =  true
            btnBook.backgroundColor = .systemYellow
            
            //btnBook.applyGradient(colors: [UIColor.green.cgColor, UIColor.black.cgColor])
            
            // Apply Gradient Color
            let gradientLayer:CAGradientLayer = CAGradientLayer()
            gradientLayer.frame.size = btnBook.frame.size
            gradientLayer.colors =
                [UIColor.white.cgColor,UIColor.green.withAlphaComponent(1).cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
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
