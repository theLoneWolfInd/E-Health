//
//  MedicalHistoryAddImagesCollectionCell.swift
//  E health App
//
//  Created by apple on 12/10/21.
//

import UIKit

class MedicalHistoryAddImagesCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imgProfile:UIImageView! {
        didSet {
            imgProfile.layer.borderColor = UIColor.lightGray.cgColor
            imgProfile.layer.borderWidth = 1
            imgProfile.layer.cornerRadius = 12
            imgProfile.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lblAddImageTitle:UILabel! {
        didSet {
            lblAddImageTitle.textColor = .black
            lblAddImageTitle.isHidden = true
        }
    }
    
}
