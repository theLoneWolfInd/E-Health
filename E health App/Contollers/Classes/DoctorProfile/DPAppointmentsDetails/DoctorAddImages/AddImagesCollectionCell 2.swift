//
//  AddImagesCollectionCell.swift
//  E health App
//
//  Created by Apple on 22/09/21.
//

import UIKit

class AddImagesCollectionCell: UICollectionViewCell {
    
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
        }
    }
    
}
