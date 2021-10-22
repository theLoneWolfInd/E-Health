//
//  PPDashboardCollectionViewCell.swift
//  E health App
//
//  Created by Ranjan on 03/09/21.
//

import UIKit

class PPDashboardCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet weak var viewCellBG:UIView! {
        didSet {
            viewCellBG.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            viewCellBG.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            viewCellBG.layer.shadowOpacity = 1.0
            viewCellBG.layer.shadowRadius = 15.0
            viewCellBG.layer.masksToBounds = false
            viewCellBG.layer.cornerRadius = 50
            viewCellBG.backgroundColor = .white
            viewCellBG.layer.masksToBounds = true
            viewCellBG.layer.borderWidth = 2
            viewCellBG.layer.borderColor = UIColor.systemGreen.cgColor
        }
    }
    
    @IBOutlet weak var imgDashboard:UIImageView!{
        didSet{
            imgDashboard.tintColor = .systemYellow
            imgDashboard.layer.borderWidth = 0
            imgDashboard.layer.borderColor = UIColor.systemGreen.cgColor
            imgDashboard.layer.masksToBounds = true
            imgDashboard.isHidden = false
        }
    }
    
    @IBOutlet weak var imgPanicFullImage:UIImageView! /*{
        didSet{
            imgDashboard.tintColor = .systemYellow
            imgDashboard.layer.borderWidth = 0
            imgDashboard.layer.borderColor = UIColor.systemGreen.cgColor
            imgDashboard.layer.masksToBounds = true
            imgDashboard.isHidden = false
        }
    }*/
    
    @IBOutlet weak var lblDashboard:UILabel!
    
}
