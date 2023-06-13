//
//  orderHistoryTableViewCell.swift
//  E health App
//
//  Created by Ranjan on 21/08/21.
//

import UIKit

class orderHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblCustomerName:UILabel! {
        didSet {
            lblCustomerName.textColor = .black
        }
    }
    @IBOutlet weak var lblDate:UILabel!
    @IBOutlet weak var lblOptional:UILabel!
    @IBOutlet weak var imgCustomer:UIImageView! {
        didSet{
            imgCustomer.layer.cornerRadius = 15.0
            imgCustomer.clipsToBounds =  true
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
