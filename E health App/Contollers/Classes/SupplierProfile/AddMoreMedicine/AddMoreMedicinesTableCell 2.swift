//
//  AddMoreMedicinesTableCell.swift
//  E health App
//
//  Created by apple on 07/10/21.
//

import UIKit

class AddMoreMedicinesTableCell: UITableViewCell {

    @IBOutlet weak var cell1ViewBG:UIView! {
        didSet {
            cell1ViewBG.backgroundColor = .white
            cell1ViewBG.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            cell1ViewBG.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            cell1ViewBG.layer.shadowOpacity = 1.0
            cell1ViewBG.layer.shadowRadius = 15.0
            cell1ViewBG.layer.masksToBounds = false
            cell1ViewBG.layer.cornerRadius = 15.0
            cell1ViewBG.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var cell1MedicineProfile:UIImageView!
    
    // cell 2
    @IBOutlet weak var cell2ViewBG:UIView! {
        didSet {
            cell2ViewBG.backgroundColor = .white
            cell2ViewBG.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            cell2ViewBG.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            cell2ViewBG.layer.shadowOpacity = 1.0
            cell2ViewBG.layer.shadowRadius = 15.0
            cell2ViewBG.layer.masksToBounds = false
            cell2ViewBG.layer.cornerRadius = 15.0
            cell2ViewBG.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lblCell2MedicineName:UILabel! {
        didSet {
            lblCell2MedicineName.textColor = .black
            lblCell2MedicineName.text = "Enter medicine name here..."
            lblCell2MedicineName.textAlignment = .left
            lblCell2MedicineName.layer.cornerRadius = 0
            lblCell2MedicineName.clipsToBounds = true
            lblCell2MedicineName.layer.borderWidth = 1
            lblCell2MedicineName.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    @IBOutlet weak var btnCell2TypeMedicineName:UIButton!
    
    @IBOutlet weak var txtMedicinePrice:UITextField! {
        didSet {
            txtMedicinePrice.backgroundColor = .white
            txtMedicinePrice.layer.cornerRadius = 22
            txtMedicinePrice.clipsToBounds = true
            txtMedicinePrice.setLeftPaddingPoints(20)
            txtMedicinePrice.keyboardType = .decimalPad
            txtMedicinePrice.layer.borderWidth = 1
            txtMedicinePrice.layer.borderColor = UIColor.lightGray.cgColor
            txtMedicinePrice.placeholder = "price..."
        }
    }
    
    @IBOutlet weak var txtMedicineQuantity:UITextField! {
        didSet {
            txtMedicineQuantity.backgroundColor = .white
            txtMedicineQuantity.layer.cornerRadius = 22
            txtMedicineQuantity.clipsToBounds = true
            txtMedicineQuantity.setLeftPaddingPoints(20)
            txtMedicineQuantity.keyboardType = .numberPad
            txtMedicineQuantity.layer.borderWidth = 1
            txtMedicineQuantity.layer.borderColor = UIColor.lightGray.cgColor
            txtMedicineQuantity.placeholder = "quantity..."
        }
    }
    
    @IBOutlet weak var btnAddOrEditMedicine:UIButton! {
        didSet {
            btnAddOrEditMedicine.backgroundColor = .systemOrange
            btnAddOrEditMedicine.layer.cornerRadius = 22
            btnAddOrEditMedicine.clipsToBounds = true
            btnAddOrEditMedicine.setTitle("Add Medicine", for: .normal)
            btnAddOrEditMedicine.setTitleColor(.white, for: .normal)
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
