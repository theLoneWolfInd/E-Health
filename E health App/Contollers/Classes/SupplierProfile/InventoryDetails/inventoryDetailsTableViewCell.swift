//
//  inventoryDetailsTableViewCell.swift
//  E health App
//
//  Created by Ranjan on 20/08/21.
//

import UIKit

class inventoryDetailsTableViewCell: UITableViewCell,UITextFieldDelegate {
    
    @IBOutlet weak var imgMedicine:UIImageView!{ // index 0
        didSet{
            imgMedicine.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            imgMedicine.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            imgMedicine.layer.shadowOpacity = 1.0
            imgMedicine.layer.shadowRadius = 15.0
            imgMedicine.layer.masksToBounds = false
            imgMedicine.layer.cornerRadius = 15
        }
    }
    
    @IBOutlet weak var imgOutOfStocks:UIImageView!{ // index 0
        didSet{
            imgOutOfStocks.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            imgOutOfStocks.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            imgOutOfStocks.layer.shadowOpacity = 1.0
            imgOutOfStocks.layer.shadowRadius = 15.0
            imgOutOfStocks.layer.masksToBounds = false
            imgOutOfStocks.layer.cornerRadius = 15
            imgOutOfStocks.image = UIImage(named: "OutOfStocks")
            imgOutOfStocks.isHidden = true
        }
    }
    
    @IBOutlet weak var lblMedName:UILabel! // index 1
    @IBOutlet weak var lblMedComposition:UILabel! // index 2
    @IBOutlet weak var lblMedWeight:UILabel! // index 3
    @IBOutlet weak var lblMedPrice:UILabel! // index 4
    @IBOutlet weak var lblStock:UILabel! // index 5
    
    @IBOutlet weak var viewTxtBG:UIView!{
        didSet{
            viewTxtBG.layer.cornerRadius = 5.0
            viewTxtBG.clipsToBounds = true
        }
    }
    @IBOutlet weak var txtStock:UITextField!{
        didSet{
            
            Utils.txtUitextField(textField: txtStock, placeholderName: "Enter Quantity", setLeftPadding: 20)
            txtStock.layer.cornerRadius = 5.0
            txtStock.clipsToBounds = true
            txtStock.delegate = self
        }
    }
    
    @IBOutlet weak var btnAddToCart:UIButton!{
        didSet{
            btnAddToCart.layer.cornerRadius = 12
            btnAddToCart.clipsToBounds = true
            btnAddToCart.backgroundColor = .clear
            btnAddToCart.setTitle("Add to Cart", for: .normal)
            btnAddToCart.setTitleColor(.black, for: .normal)
        }
    }
    
    @IBOutlet weak var btnUpdate:UIButton!{
        didSet{
            btnUpdate.layer.cornerRadius = 6
            btnUpdate.clipsToBounds = true
            btnUpdate.backgroundColor = .white
            btnUpdate.setTitle("Quantity (0)", for: .normal)
            btnUpdate.setTitleColor(.black, for: .normal)
        }
    }
    
    @IBOutlet weak var btnAddMoreItem:UIButton!{
        didSet{
            btnAddMoreItem.layer.cornerRadius = 5.0
            btnAddMoreItem.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btnBuyNow:UIButton!{
        didSet{
            btnBuyNow.layer.cornerRadius = 8
            btnBuyNow.clipsToBounds = true
            btnBuyNow.backgroundColor = .systemOrange
            btnBuyNow.setTitle("Buy Now", for: .normal)
            btnBuyNow.setTitleColor(.black, for: .normal)
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
