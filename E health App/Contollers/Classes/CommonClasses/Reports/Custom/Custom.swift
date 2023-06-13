//
//  Custom.swift
//  E health App
//
//  Created by apple on 07/02/22.
//

import UIKit

class Custom: UIViewController {

    @IBOutlet weak var view_bg:UIView! {
        didSet {
            view_bg.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_bg.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            view_bg.layer.shadowOpacity = 1.0
            view_bg.layer.shadowRadius = 15.0
            view_bg.layer.masksToBounds = false
            view_bg.layer.cornerRadius = 15
            view_bg.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var viewNavigationbar:UIView!
    @IBOutlet weak var btnDashboardMenu: UIButton!
    @IBOutlet weak var lblNavationbar:UILabel! {
        didSet {
            lblNavationbar.text = "Custom"
        }
    }
    
    @IBOutlet weak var txt_start_Date:UITextField!
    @IBOutlet weak var txt_end_Date:UITextField!
    
    @IBOutlet weak var btn_submit:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
