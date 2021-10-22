//
//  ListOfAllMedicinesTableCell.swift
//  E health App
//
//  Created by apple on 07/10/21.
//

import UIKit

class ListOfAllMedicinesTableCell: UITableViewCell {

    @IBOutlet weak var cellBGView:UIView! {
        didSet {
            cellBGView.backgroundColor = .white
            cellBGView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            cellBGView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            cellBGView.layer.shadowOpacity = 1.0
            cellBGView.layer.shadowRadius = 15.0
            cellBGView.layer.masksToBounds = false
            cellBGView.layer.cornerRadius = 15.0
            cellBGView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var imgMedicineProfile:UIImageView! {
        didSet {
            // imgMedicineProfile.l
            imgMedicineProfile.layer.cornerRadius = 35
            imgMedicineProfile.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lblMedicineName:UILabel! {
        didSet {
            lblMedicineName.textColor = .black
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
