//
//  registerOptionTableViewCell.swift
//  E health App
//
//  Created by Ranjan on 17/08/21.
//

import UIKit

class registerOptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btnHospital: UIButton!{
        
        didSet{
            btnHospital.layer.cornerRadius = 27.5
            btnHospital.clipsToBounds = true
            btnHospital.setTitle("Hospital / Clinic", for: .normal)
        }
    }
    @IBOutlet weak var btnClinic: UIButton!{
        
        didSet{
            btnClinic.layer.cornerRadius = 27.5
            btnClinic.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnDoctors: UIButton!{
        
        didSet{
            btnDoctors.layer.cornerRadius = 27.5
            btnDoctors.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnDignosticLabs: UIButton!{
        
        didSet{
            btnDignosticLabs.layer.cornerRadius = 27.5
            btnDignosticLabs.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnPharmacy: UIButton!{
        
        didSet{
            btnPharmacy.layer.cornerRadius = 27.5
            btnPharmacy.clipsToBounds = true
        }
    }
    @IBOutlet weak var btSupplier: UIButton!{
        
        didSet{
            btSupplier.layer.cornerRadius = 27.5
            btSupplier.clipsToBounds = true
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
