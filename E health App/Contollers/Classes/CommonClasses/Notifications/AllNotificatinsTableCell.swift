//
//  AllNotificatinsTableCell.swift
//  E health App
//
//  Created by apple on 03/02/22.
//

import UIKit

class AllNotificatinsTableCell: UITableViewCell {

    @IBOutlet weak var view_bg:UIView! {
        didSet {
            view_bg.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_bg.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            view_bg.layer.shadowOpacity = 1.0
            view_bg.layer.shadowRadius = 15.0
            view_bg.layer.masksToBounds = false
            view_bg.layer.cornerRadius = 15
            view_bg.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var lbl_title:UILabel! {
        didSet {
            lbl_title.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_email:UILabel! {
        didSet {
            lbl_email.textColor = .darkGray
        }
    }
    
    @IBOutlet weak var lbl_phone:UILabel! {
        didSet {
            lbl_phone.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_access_for:UILabel! {
        didSet {
            lbl_access_for.textColor = .black
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
