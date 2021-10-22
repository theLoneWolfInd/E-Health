//
//  PPPatientPrescriptionCollectionViewCell.swift
//  E health App
//
//  Created by Ranjan on 27/08/21.
//

import UIKit

class PPPatientPrescriptionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgPrescription:UIImageView!
    @IBOutlet weak var lblUploadedTimeNDate:UILabel!{
        didSet{
            lblUploadedTimeNDate.backgroundColor = .black
            lblUploadedTimeNDate.textColor = .white
        }
    }
    
}
