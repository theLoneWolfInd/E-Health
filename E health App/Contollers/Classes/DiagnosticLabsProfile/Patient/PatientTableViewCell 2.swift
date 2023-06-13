//
//  PatientTableViewCell.swift
//  E health App
//
//  Created by Ranjan on 25/08/21.
//

import UIKit

class PatientTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgPatientProfile:UIImageView!
    @IBOutlet weak var lblPatientName:UILabel!{
        didSet{
            lblPatientName.textColor = .black
        }
    }
    @IBOutlet weak var lblPaidAmount:UILabel!{
        didSet{
            lblPaidAmount.textColor = .systemOrange
        }
    }
    @IBOutlet weak var btnPhoneNumber:UIButton!
    @IBOutlet weak var btnDelete:UIButton!
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
