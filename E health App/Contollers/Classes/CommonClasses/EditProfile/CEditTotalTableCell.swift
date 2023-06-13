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
            txtEmail.backgroundColor = .white
            txtEmail.textColor = .black
        }
    }
    @IBOutlet weak var txtUsername:UITextField! {
        didSet {
            txtUsername.backgroundColor = .white
            txtUsername.textColor = .black
        }
    }
    @IBOutlet weak var txtPhoneNumber:UITextField! {
        didSet {
            txtPhoneNumber.backgroundColor = .white
            txtPhoneNumber.textColor = .black
        }
    }
    @IBOutlet weak var txtAddress:UITextField! {
        didSet {
            txtAddress.backgroundColor = .white
            txtAddress.textColor = .black
        }
    }
    
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
