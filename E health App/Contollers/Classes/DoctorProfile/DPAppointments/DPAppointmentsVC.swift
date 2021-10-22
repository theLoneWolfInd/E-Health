//
//  DPAppointmentsVC.swift
//  E health App
//
//  Created by Ranjan on 31/08/21.
//

import UIKit
import FSCalendar

import Alamofire
import SDWebImage

class DPAppointmentsVC: UIViewController,FSCalendarDelegate {
    
    var strSaveClickedDate:String! = "0"
    
    @IBOutlet weak var viewNavigationbar:UIView!
    @IBOutlet weak var btnNavigationBack: UIButton!
    @IBOutlet weak var lblNavationbar:UILabel!{
        didSet {
            
            lblNavationbar.text = "APPOINTMENTS"
        }
    }
    
    @IBOutlet weak var calendar:FSCalendar!
    @IBOutlet weak var btnCheckAppointments:UIButton!
    @IBOutlet weak var lblSelectedDate:UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        calendar.delegate = self
        lblSelectedDate.text = "Please select date"
        btnCheckAppointments.addTarget(self, action: #selector(btnCheckAppointmentsPress), for: .touchUpInside)
        
        
        if let myLoadedString = UserDefaults.standard.string(forKey: "keySetToBackOrMenu") {
            print(myLoadedString)
            
            if myLoadedString == "backOrMenu" {
                // menu
                self.btnNavigationBack.setImage(UIImage(systemName: "list.dash"), for: .normal)
                self.sideBarMenuClick()
            } else {
                // back
                self.btnNavigationBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
            }
        } else {
            // back
            self.btnNavigationBack.setImage(UIImage(systemName: "arrow.left"), for: .normal)
            self.btnNavigationBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
        
        
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func sideBarMenuClick() {
        
        UserDefaults.standard.set("", forKey: "keySetToBackOrMenu")
        UserDefaults.standard.set(nil, forKey: "keySetToBackOrMenu")
        
        self.view.endEditing(true)
        
        if revealViewController() != nil {
            
            btnNavigationBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let foramtter = DateFormatter()
        foramtter.dateFormat = "yyyy-MM-dd"
        let date = foramtter.string(from: date)
        lblSelectedDate.text = "Selected Date: " + date
        print("\(date)")
        
        self.strSaveClickedDate = "\(date)"
        
    }
    
    @objc func btnCheckAppointmentsPress() {
        
        if self.strSaveClickedDate == "" {
            
            let alert = UIAlertController(title: "Alert", message: "Please select Date.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            
        } else {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPAppointmentsVC") as? PPAppointmentsVC
            
            push!.strAppointmentDateCheck = self.strSaveClickedDate
            
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        
    }
    
}
