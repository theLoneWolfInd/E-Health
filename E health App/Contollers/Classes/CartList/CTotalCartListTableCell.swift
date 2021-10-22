//
//  CTotalCartListTableCell.swift
//  Alien Broccoli
//
//  Created by Apple on 05/10/20.
//

import UIKit

class CTotalCartListTableCell: UITableViewCell {

    @IBOutlet weak var viewCellBG:UIView! {
        didSet {
            viewCellBG.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            viewCellBG.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            viewCellBG.layer.shadowOpacity = 1.0
            viewCellBG.layer.shadowRadius = 15.0
            viewCellBG.layer.masksToBounds = false
            viewCellBG.layer.cornerRadius = 15
            viewCellBG.backgroundColor = .white
        }
    }
    @IBOutlet weak var imgProductImage:UIImageView! {
        didSet {
            imgProductImage.layer.cornerRadius = 8
            imgProductImage.clipsToBounds = true
            imgProductImage.layer.borderWidth = 2
            imgProductImage.layer.borderColor = UIColor.systemTeal.cgColor
        }
    }
    
    @IBOutlet weak var lblProductDetails:UILabel!
    @IBOutlet weak var lblProductRealPrice:UILabel!
    
    @IBOutlet weak var btnDeleteItem:UIButton! {
        didSet {
            btnDeleteItem.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btnDeleteItem.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btnDeleteItem.layer.shadowOpacity = 1.0
            btnDeleteItem.layer.shadowRadius = 15.0
            btnDeleteItem.layer.masksToBounds = false
            btnDeleteItem.layer.cornerRadius = 8
            btnDeleteItem.setTitle(" Remove", for: .normal)
            btnDeleteItem.setTitleColor(.white, for: .normal)
            btnDeleteItem.backgroundColor = .systemRed
            btnDeleteItem.tintColor = .white
        }
    }
    
    @IBOutlet weak var btnBuyNow:UIButton! {
        didSet {
            btnBuyNow.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btnBuyNow.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btnBuyNow.layer.shadowOpacity = 1.0
            btnBuyNow.layer.shadowRadius = 15.0
            btnBuyNow.layer.masksToBounds = false
            btnBuyNow.layer.cornerRadius = 8
            btnBuyNow.setTitle("Buy Now", for: .normal)
            btnBuyNow.setTitleColor(.white, for: .normal)
            btnBuyNow.backgroundColor = .systemGreen
        }
    }
    
    @IBOutlet weak var viewItemIncDec:UIView! {
        didSet {
            viewItemIncDec.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            viewItemIncDec.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            viewItemIncDec.layer.shadowOpacity = 1.0
            viewItemIncDec.layer.shadowRadius = 15.0
            viewItemIncDec.layer.masksToBounds = false
            viewItemIncDec.layer.cornerRadius = 15
            viewItemIncDec.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var btnCounterIncrease:UIButton!
    @IBOutlet weak var btnCounterDecrease:UIButton!
    @IBOutlet weak var btnCounterTitle:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
