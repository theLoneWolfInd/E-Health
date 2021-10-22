//
//  adminApprovalVC.swift
//  E health App
//
//  Created by Ranjan on 17/08/21.
//

import UIKit

class adminApprovalVC: UIViewController {
    
    @IBOutlet weak var viewNavigationBar:UIView!
    @IBOutlet weak var btnNavigationBack:UIButton!
    @IBOutlet weak var lblNavigationBar:UILabel!{
        didSet {
            
            lblNavigationBar.text = "ADMIN APPROVAL"
        }
    }

    @IBOutlet weak var imgApproval:UIImageView!{
        didSet{
            imgApproval.image = UIImage(named: "waiting")
        }
    }
    
    @IBOutlet weak var lblApproval:UILabel!{
        didSet{
            lblApproval.text = "Waiting for an approval"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        btnNavigationBack.addTarget(self, action: #selector(btnNavigationBackPress), for: .touchUpInside)
        self.view.backgroundColor = .white

    }
    @objc func btnNavigationBackPress(){
        
        navigationController?.popViewController(animated: true)
    }
    
}
