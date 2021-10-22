//
//  PPBookingInformationVC.swift
//  E health App
//
//  Created by Ranjan on 08/09/21.
//

import UIKit

class PPBookingInformationVC: UIViewController {
    
    var strAppointmentId:String!
    
    @IBOutlet weak var viewNavigationbar:UIView!
    @IBOutlet weak var btnNavigationBack: UIButton! {
        didSet {
            btnNavigationBack.isHidden = true
        }
    }
    @IBOutlet weak var lblNavationbar:UILabel!{
        didSet {
            
            lblNavationbar.text = "BOOKING INFORMATIONS"
        }
    }

    @IBOutlet weak var lbl:UILabel!
    
    @IBOutlet weak var lblAppointmentId:UILabel! {
        didSet {
            
        }
    }
    @IBOutlet weak var btnMainMenu:UIButton!{
        didSet{
            btnMainMenu.layer.cornerRadius = 27.5
            btnMainMenu.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnBookAnotherAppointment:UIButton!{
        didSet{
            btnBookAnotherAppointment.layer.cornerRadius = 27.5
            btnBookAnotherAppointment.clipsToBounds = true
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.btnBookAnotherAppointment.addTarget(self, action: #selector(btnMainMenuPress), for: .touchUpInside)
        self.btnMainMenu.addTarget(self, action: #selector(btnMainMenuPress), for: .touchUpInside)
        
        self.lblAppointmentId.text = "Appointment ID : "+String(strAppointmentId)
        
        lbl.text = """
                    Thank you for booking your
                    appointment, Please find below
                    your appointment details.
                    """

    }
    
    @objc func btnMainMenuPress(){
        
         let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPDashboardVC") as? PPDashboardVC
         self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
}
