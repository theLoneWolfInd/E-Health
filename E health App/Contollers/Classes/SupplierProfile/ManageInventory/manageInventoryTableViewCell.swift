//
//  manageInventoryTableViewCell.swift
//  E health App
//
//  Created by Ranjan on 19/08/21.
//

import UIKit

class manageInventoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblMedicineName:UILabel!
    
    @IBOutlet weak var lblMedicinePrice:UILabel!
    
    @IBOutlet weak var imgMedicine:UIImageView! {
        didSet{
            imgMedicine.layer.cornerRadius = 12
            imgMedicine.clipsToBounds =  true
            imgMedicine.layer.borderWidth = 2
            imgMedicine.layer.borderColor = UIColor.systemTeal.cgColor
        }
    }
    
    @IBOutlet weak var viewBackground:UIView!{
        didSet{
            
            viewBackground.backgroundColor = .white
            //viewBackground.layer.cornerRadius = 10.0
            viewBackground.clipsToBounds = true
            //viewBackground.layer.borderWidth = 1.0
            //viewBackground.layer.borderColor = UIColor.red.cgColor
            viewBackground.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            viewBackground.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            viewBackground.layer.shadowOpacity = 1.0
            viewBackground.layer.shadowRadius = 15.0
            viewBackground.layer.masksToBounds = false
            viewBackground.layer.cornerRadius = 15
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
