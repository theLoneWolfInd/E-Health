//
//  CEditTotalTableCell.swift
//  Alien Broccoli
//
//  Created by Apple on 07/10/20.
//

import UIKit

class CEditTotalTableCell: UITableViewCell {

    @IBOutlet weak var imgProfile:UIImageView! {
        didSet {
            imgProfile.layer.cornerRadius = 8
            imgProfile.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var txtEmail:UITextField! {
        didSet {
            txtEmail.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var txtUsername:UITextField!
    @IBOutlet weak var txtPhoneNumber:UITextField!
    @IBOutlet weak var txtAddress:UITextField!
    
    @IBOutlet weak var btnUpdate:UIButton! {
        didSet {
            btnUpdate.layer.cornerRadius = 4
            btnUpdate.clipsToBounds = true
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
