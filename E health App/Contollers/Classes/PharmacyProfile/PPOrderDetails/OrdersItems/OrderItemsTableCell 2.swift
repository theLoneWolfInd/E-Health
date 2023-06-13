//
//  OrderItemsTableCell.swift
//  E health App
//
//  Created by apple on 05/10/21.
//

import UIKit

class OrderItemsTableCell: UITableViewCell {

    @IBOutlet weak var viewBG:UIView! {
        didSet {
            viewBG.backgroundColor = .white
            viewBG.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            viewBG.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            viewBG.layer.shadowOpacity = 1.0
            viewBG.layer.shadowRadius = 15.0
            viewBG.layer.masksToBounds = false
            viewBG.layer.cornerRadius = 15.0
            viewBG.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var imgProfile:UIImageView! {
        didSet {
            imgProfile.layer.cornerRadius = 40
            imgProfile.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lblMedicineName:UILabel! {
        didSet {
            lblMedicineName.textColor = .black
            lblMedicineName.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var lblQuantity:UILabel! {
        didSet {
            // lblQuantity.setTitleColor(.systemOrange, for: .normal)
            // lblQuantity.setTitle("", for: .normal)
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
