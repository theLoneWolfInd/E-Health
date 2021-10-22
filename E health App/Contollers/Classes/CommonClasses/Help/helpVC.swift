//
//  helpVC.swift
//  E health App
//
//  Created by Ranjan on 21/08/21.
//

import UIKit
import SDWebImage
import Alamofire

class helpVC: UIViewController {
    
    @IBOutlet weak var viewNavigationbar:UIView!
    @IBOutlet weak var btnDashBoardMenu:UIButton!
    @IBOutlet weak var lblNavationbar:UILabel!{
        didSet {
            
            lblNavationbar.text = "HELP"
        }
    }
    
    @IBOutlet weak var imgBackground:UIImageView!{
        didSet {
            
            imgBackground.layer.cornerRadius = 45.0
            imgBackground.clipsToBounds = true
            imgBackground.image = UIImage(named: "1024")
        }
    }
    
    @IBOutlet weak var imgBrandName:UIImageView!{
        didSet{
            imgBrandName.image = UIImage(named: "ehealth")
        }
    }
    
    @IBOutlet weak var btnEmail:UIButton!
    @IBOutlet weak var btnPhone:UIButton!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .white
        
        
        if let myLoadedString = UserDefaults.standard.string(forKey: "keySetToBackOrMenu") {
            print(myLoadedString)
            
            if myLoadedString == "backOrMenu" {
                // menu
                self.btnDashBoardMenu.setImage(UIImage(systemName: "list.dash"), for: .normal)
                self.sideBarMenuClick()
            } else {
                // back
                self.btnDashBoardMenu.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
            }
        } else {
            // back
            self.btnDashBoardMenu.setImage(UIImage(systemName: "arrow.left"), for: .normal)
            self.btnDashBoardMenu.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
        
    }
    
    @objc func sideBarMenuClick() {
        
        UserDefaults.standard.set("", forKey: "keySetToBackOrMenu")
        UserDefaults.standard.set(nil, forKey: "keySetToBackOrMenu")
        
        self.view.endEditing(true)
        
        if revealViewController() != nil {
            
            btnDashBoardMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }

}
