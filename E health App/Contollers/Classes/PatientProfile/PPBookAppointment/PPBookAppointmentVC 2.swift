//
//  PPBookAppointmentVC.swift
//  E health App
//
//  Created by Ranjan on 07/09/21.
//

import UIKit
import SDWebImage

class PPBookAppointmentVC: UIViewController {
    
    var dictGetHospitalDetails:NSDictionary!
    var fetchDoctorDataInDetailsScreen:NSDictionary!
    
    @IBOutlet weak var viewNavigationBar:UIView!
    @IBOutlet weak var btnNavigationBack:UIButton!
    @IBOutlet weak var lblNavigationBar:UILabel!{
        didSet {
            
            lblNavigationBar.text = "BOOK AN APPOINTMENT"
        }
    }

    @IBOutlet weak var tablView:UITableView!

    @IBOutlet weak var btnBookAppointment:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        tablView.backgroundColor =  .white
        self.navigationController?.isNavigationBarHidden = true
        tablView.delegate = self
        tablView.dataSource = self
        self.tablView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        btnBookAppointment.addTarget(self, action: #selector(btnBookAppointmentPress), for: .touchUpInside)
        
        
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
    
    @objc func btnBookAppointmentPress() {
//        Patient_Book_Appoitment
        
        // print(self.dictGetHospitalDetails as Any)
        // print(self.fetchDoctorDataInDetailsScreen as Any)
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPBookAppointmentSelectDateVC") as? PPBookAppointmentSelectDateVC
        
        push!.fetchHospitalDataForBooking = self.dictGetHospitalDetails as NSDictionary?
        push!.fetchDoctorDataForBooking = self.fetchDoctorDataInDetailsScreen
        
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
}

extension PPBookAppointmentVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell:PPBookAppointmentTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell") as! PPBookAppointmentTableViewCell
        
        cell.backgroundColor = .white
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
         // print(self.dictGetHospitalDetails as Any)
        // print(self.fetchDoctorDataForBooking as Any)
        
        /*
         address = "ramprastha ";
         city = "";
         contactNumber = 95684567777;
         country = Afghanistan;
         department = "N.A.";
         description = "New hospital ";
         device = iOS;
         deviceToken = "";
         dob = "";
         email = "newios@gmail.com";
         eyeColor = "";
         firebaseId = "";
         fullName = "new iOS";
         gender = "";
         height = "";
         image = "";
         lastName = "";
         latitude = "";
         longitude = "";
         medicalCardID = "";
         middleName = "";
         practiceDate = "";
         registeredDt = "";
         role = Hospital;
         socialId = "";
         socialType = "";
         specialty = "N.A.";
         state = "";
         status = 1;
         userId = 163;
         zipCode = "";
         */
        
        cell.btnAddress.setTitle(" "+(self.dictGetHospitalDetails["address"] as! String), for: .normal)
        
        cell.lblHospitalName.text = (self.dictGetHospitalDetails["fullName"] as! String)
        cell.lblPhone.text = (self.dictGetHospitalDetails["contactNumber"] as! String)
        cell.lblEmail.text = (self.dictGetHospitalDetails["email"] as! String)
        
        cell.imgBanner.image = UIImage(named: "background")
        
        // cell.imgProfile.image = UIImage(named: "daze")
        
        cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.imgProfile.sd_setImage(with: URL(string: (self.dictGetHospitalDetails["image"] as! String)), placeholderImage: UIImage(named: "1024"))
        
        cell.lblHospitalAbout.text = (self.dictGetHospitalDetails["description"] as! String)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
}
