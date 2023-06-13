//
//  BuyNow.swift
//  E health App
//
//  Created by apple on 16/09/21.
//

import UIKit
import SDWebImage

class BuyNow: UIViewController {

    var strProductImage:String!
    var strProductName:String!
    var strProductQuantity:String!
    var strProductPrice:String!
    
    var getDictForBuyNowPayment:NSDictionary!
    
    @IBOutlet weak var viewNavigationBar:UIView!
    
    @IBOutlet weak var btnDashboardMenu:UIButton!
    
    @IBOutlet weak var lblNavigationBar:UILabel! {
        didSet {
            lblNavigationBar.text = "BUY NOW"
        }
    }
    
    @IBOutlet weak var viewbgMedicinesDetails:UIView! {
        didSet {
            viewbgMedicinesDetails.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            viewbgMedicinesDetails.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            viewbgMedicinesDetails.layer.shadowOpacity = 1.0
            viewbgMedicinesDetails.layer.shadowRadius = 15.0
            viewbgMedicinesDetails.layer.masksToBounds = false
            viewbgMedicinesDetails.layer.cornerRadius = 15
            viewbgMedicinesDetails.backgroundColor = .white
        }
    }
    
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
    
    @IBOutlet weak var lblMedName:UILabel! {
        didSet {
            lblMedName.textColor = .black
        }
    }
    @IBOutlet weak var lblQuantity:UILabel! {
        didSet {
            lblQuantity.textColor = .black
        }
    }
    @IBOutlet weak var lblPrice:UILabel! {
        didSet {
            lblPrice.textColor = .black
        }
    }
    
    @IBOutlet weak var btnBuyNow:UIButton!{
        didSet{
            btnBuyNow.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btnBuyNow.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btnBuyNow.layer.shadowOpacity = 1.0
            btnBuyNow.layer.shadowRadius = 15.0
            btnBuyNow.layer.masksToBounds = false
            btnBuyNow.layer.cornerRadius = 15
            btnBuyNow.backgroundColor = .systemGreen
            btnBuyNow.setTitleColor(.white, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        self.btnDashboardMenu.addTarget(self, action: #selector(btnNavigationBackPress), for: .touchUpInside)
        
        /*print(strProductImage as Any)
        print(strProductName as Any)
        print(strProductQuantity as Any)
        print(strProductPrice as Any)
        print(self.getDictForBuyNowPayment as Any)*/
        
        self.imgMedicine.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        self.imgMedicine.sd_setImage(with: URL(string: strProductImage), placeholderImage: UIImage(named: "1024"))
        
        self.lblMedName.text = String(self.strProductName)
        self.lblQuantity.text = String(self.strProductQuantity)
        self.lblPrice.text = String(self.strProductPrice)
        
        let doubleQuantity = Double(self.strProductQuantity)
        let doublePrice = Double(self.strProductPrice)
        
        let calculateTotalPrice = Double(doubleQuantity!)*Double(doublePrice!)
        
        let totalPriceToPay = String(calculateTotalPrice)
        
        self.btnBuyNow.setTitle("Pay ($"+totalPriceToPay+")", for: .normal)
        
        self.btnBuyNow.addTarget(self, action: #selector(buyNowClickMethod), for: .touchUpInside)
        
        /*
         action : saveorder( )
                 hospitalId = 88
                 supplierId = 85
                 quantity = 10
                 medicine_id = 141026
                 address =
                 contact_person =
                 mobile = 9999999999
                 delivery_date =
                 special_note =
         */
        
    }
    
    @objc func btnNavigationBackPress() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func buyNowClickMethod() {
        
        let x : Int = self.getDictForBuyNowPayment["supplierId"] as! Int
        let myString = String(x)
        
        let x2 : Int = self.getDictForBuyNowPayment["medicineId"] as! Int
        let myString2 = String(x2)
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "InformationVC") as? InformationVC
        
        push!.strGetSupplierId = String(myString)
        push!.strGetQuantity = String(self.strProductQuantity)
        push!.strGetMedicineId = String(myString2)
        
        
        
        let doubleQuantity = Double(self.strProductQuantity)
        let doublePrice = Double(self.strProductPrice)
        
        let calculateTotalPrice = Double(doubleQuantity!)*Double(doublePrice!)
        let totalPriceToPay = String(calculateTotalPrice)
        push!.strGetTotal = String(totalPriceToPay)
        
        
        
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
     
    
}
