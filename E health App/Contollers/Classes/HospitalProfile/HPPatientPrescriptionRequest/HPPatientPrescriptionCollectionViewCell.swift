//
//  HPPatientPrescriptionCollectionViewCell.swift
//  E health App
//
//  Created by Ranjan on 02/09/21.
//

import UIKit

class HPPatientPrescriptionCollectionViewCell: UICollectionViewCell {
    
    
   /* @IBOutlet weak var viewPrescriptionBG:UIView!{
        didSet{
            
            viewPrescriptionBG.backgroundColor = .white
            /*viewPrescriptionBG.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            viewPrescriptionBG.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            viewPrescriptionBG.layer.shadowOpacity = 1.0
            viewPrescriptionBG.layer.shadowRadius = 15.0
            viewPrescriptionBG.layer.masksToBounds = false*/
            viewPrescriptionBG.layer.cornerRadius = 7.0
            viewPrescriptionBG.clipsToBounds = true
            viewPrescriptionBG.layer.borderWidth = 2.0
            viewPrescriptionBG.layer.borderColor = UIColor.black.cgColor
        }
    }*/
    
    @IBOutlet weak var imgPrescription:UIImageView!
    @IBOutlet weak var lblUploadedTimeNDate:UILabel!{
        didSet{
            lblUploadedTimeNDate.backgroundColor = .black
            lblUploadedTimeNDate.textColor = .white
        }
    }
    
}
