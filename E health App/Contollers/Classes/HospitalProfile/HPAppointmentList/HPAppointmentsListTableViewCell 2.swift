//
//  HPAppointmentsListTableViewCell.swift
//  E health App
//
//  Created by Ranjan on 01/09/21.
//

import UIKit

class HPAppointmentsListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblPatientName:UILabel!
    
    @IBOutlet weak var lblDate:UILabel!
    
    @IBOutlet weak var lblDoctorName:UILabel!
    
    @IBOutlet weak var viewProfileBG:UIView!{
        didSet{
            viewProfileBG.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var imgProfile:UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
