//
//  RequestedAccetedVC.swift
//  E health App
//
//  Created by Ranjan on 25/08/21.
//

import UIKit

class RequestedAccetedVC: UIViewController {
    @IBOutlet weak var viewnavigationBar: UIView!
    
    @IBOutlet weak var btnNavigationBack: UIButton!
    
    @IBOutlet weak var lblNavigationBar: UILabel!
    
    @IBOutlet weak var lblTotalItem: UILabel!
    @IBOutlet weak var viewSupplierInfoBG: UIView!{
        didSet{
         
            viewSupplierInfoBG.backgroundColor = .clear
            viewSupplierInfoBG.layer.borderColor = UIColor.lightGray.cgColor
            viewSupplierInfoBG.layer.borderWidth = 1
            viewSupplierInfoBG.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            viewSupplierInfoBG.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            viewSupplierInfoBG.layer.shadowOpacity = 1.0
            viewSupplierInfoBG.layer.shadowRadius = 15.0
            viewSupplierInfoBG.layer.masksToBounds = false
        }
    }
    
    @IBOutlet weak var lblBookingDateNTime: UILabel!
    
    @IBOutlet weak var imgSupplierProfileImage: UIImageView!
    
    @IBOutlet weak var lblSupplierName: UILabel!
    
    @IBOutlet weak var btnToSupplierCall: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .white
        imgSupplierProfileImage.image = UIImage(named: "daze")
        lblSupplierName.text = "Kevin Senon Jhonson"
        lblBookingDateNTime.text = "Wed 25 Aug 21, 12:25PM"
        lblTotalItem.text =  "Total items: " + "25"
    }
    
}
