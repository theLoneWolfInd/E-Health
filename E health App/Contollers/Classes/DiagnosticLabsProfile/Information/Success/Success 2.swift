//
//  Success.swift
//  E health App
//
//  Created by apple on 05/10/21.
//

import UIKit
import SwiftGifOrigin

class Success: UIViewController {
    
    @IBOutlet weak var imgView:UIImageView!
    @IBOutlet weak var btnHome:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.btnHome.addTarget(self, action: #selector(pushToHomePage), for: .touchUpInside)
        
        self.gifAnimate()
        
    }

    @objc func pushToHomePage() {
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
         
            if person["role"] as! String == "Doctor" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "DPDashboardVC")
                self.navigationController?.pushViewController(push, animated: true)
                
            } else if person["role"] as! String == "Hospital" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "HPDashboardVC")
                self.navigationController?.pushViewController(push, animated: true)
                
            } else if person["role"] as! String == "Pharmacy" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "DashboardDLPVC")
                self.navigationController?.pushViewController(push, animated: true)
                
            }
        }
        
    }
    
    @objc func gifAnimate() {
    
        self.imgView.image = UIImage.gif(name: "success3")
    }
    
}
