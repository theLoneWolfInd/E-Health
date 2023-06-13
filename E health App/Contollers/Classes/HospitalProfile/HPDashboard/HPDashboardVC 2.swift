//
//  HPDashboardVC.swift
//  E health App
//
//  Created by Ranjan on 01/09/21.
//

import UIKit
import Alamofire
import SDWebImage

class HPDashboardVC: UIViewController {
    
    @IBOutlet weak var viewNavigationBar:UIView!
    @IBOutlet weak var btnDashboardMenu:UIButton!
    @IBOutlet weak var btnCalendar:UIButton!
    
    
    @IBOutlet weak var lblNavigationBar:UILabel! {
        didSet {
            lblNavigationBar.text = "DASHBOARD"
        }
    }

    @IBOutlet weak var tablView:UITableView! {
        didSet {
            tablView.backgroundColor =  .white
            tablView.delegate = self
            tablView.dataSource = self
            tablView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        }
    }

    @IBOutlet weak var btnCheckAppointments:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        //self.btnDashboardMenuPress()
        
        self.btnCheckAppointments.addTarget(self, action: #selector(btnCheckAppointmentsPress), for: .touchUpInside)
        self.btnCalendar.addTarget(self, action: #selector(btnCalendarClickMethod), for: .touchUpInside)
        
        self.tablView.separatorColor = .clear
        
        self.menuOrBack()
    }
    
    @objc func btnCalendarClickMethod() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DPAppointmentsVC") as? DPAppointmentsVC
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func menuOrBack() {
        
        self.sideBarMenuClick()
        
        /*if let myLoadedString = UserDefaults.standard.string(forKey: "keySetToBackOrMenu") {
            print(myLoadedString)
            
            if myLoadedString == "backOrMenu" {
                // menu
                self.btnDashboardMenu.setImage(UIImage(systemName: "list.dash"), for: .normal)
                self.sideBarMenuClick()
            } else {
                // back
                self.btnDashboardMenu.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
            }
        } else {
            // back
            self.btnDashboardMenu.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }*/
        
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @objc func sideBarMenuClick() {
        
        UserDefaults.standard.set("", forKey: "keySetToBackOrMenu")
        UserDefaults.standard.set(nil, forKey: "keySetToBackOrMenu")
        
        self.view.endEditing(true)
        
        if revealViewController() != nil {
            
            btnDashboardMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    @objc func btnCheckAppointmentsPress() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DPSearchReportId") as? DPSearchReport
        push!.str_back_or_menu = "yes"
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func btnPatientPress() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HPPatientPrescriptionVC") as? HPPatientPrescriptionVC
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func btnPharmacyPress() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HPPharmacyVC") as? HPPharmacyVC
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func btnDoctorsPress() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HPDoctorsVC") as? HPDoctorsVC
        self.navigationController?.pushViewController(push!, animated: true)
        
    }

}

extension HPDashboardVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:HPDashboardTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell") as! HPDashboardTableViewCell
        
        cell.backgroundColor = .white
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
            
            print(person as Any)
            
            if (person["role"] as! String) == "Hospital" {
                
                /*
                 ["userId": 108, "state": , "city": , "status": 1, "latitude": , "department": N.A., "firebaseId": , "address": 121212, "dob": , "medicalCardID": , "socialId": , "lastName": , "countryId": , "role": Hospital, "practiceDate": , "description": 1212122re, "zipCode": , "registeredDt": , "specialty": N.A., "hospitalName": Africa E-health, "eyeColor": , "approveByAdmin": 1, "gender": , "longitude": , "email": testios@gmail.com, "height": , "socialType": , "device": iOS, "middleName": , "image": , "deviceToken": , "contactNumber": 8283828382, "fullName": Test iOS]
                 */
                
                cell.btnAddress.setTitle((person["address"] as! String), for: .normal)
                cell.btnAddress.titleLabel?.lineBreakMode = .byWordWrapping
                cell.btnAddress.setTitleColor(.black, for: .normal)
                
                cell.lblHospitalName.text = (person["fullName"] as! String)
                cell.lblHospitalName.textColor = .black
                
                cell.lblPhone.text      = (person["contactNumber"] as! String)
                cell.lblEmail.text      = (person["email"] as! String)
                cell.imgBanner.image    = UIImage(named: "1024")
                cell.imgProfile.image   = UIImage(named: "daze")
                
                cell.lblHospitalDetail.text = (person["description"] as! String)
                
                cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell.imgProfile.sd_setImage(with: URL(string: (person["image"] as! String)), placeholderImage: UIImage(named: "1024"))
                
                cell.btnEdit.addTarget(self, action: #selector(editPuchMethod), for: .touchUpInside)
                cell.btnHistory.addTarget(self, action: #selector(btnCheckAppointmentsPress), for: .touchUpInside)
            }
            
            cell.btnDoctors.addTarget(self, action: #selector(doctorClickMethod), for: .touchUpInside)
            cell.btnLabs.addTarget(self, action: #selector(labsClickMethod), for: .touchUpInside)
            cell.btnPharmacy.addTarget(self, action: #selector(pharmacyClickMethod), for: .touchUpInside)
            cell.btnPatient.addTarget(self, action: #selector(patientClickMethod), for: .touchUpInside)
            
        } else {
            print("session has been expired. Login time.")
        }
        
        return cell
        
    }
    
    @objc func editPuchMethod() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CEditProfileId") as? CEditProfile
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func doctorClickMethod() {
       
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HPDoctorsVC") as? HPDoctorsVC
        push!.strMyProfileIs = "FromHospitalProfileToDoctors"
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func labsClickMethod() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HPDoctorsVC") as? HPDoctorsVC
        push!.strMyProfileIs = "FromHospitalProfileToLabs"
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func pharmacyClickMethod() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HPPharmacyVC") as? HPPharmacyVC
        push!.strMyProfileIs = "FromHospitalProfileToPharmacy"
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func patientClickMethod() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HPDoctorsVC") as? HPDoctorsVC
        push!.strMyProfileIs = "FromHospitalProfileToPatient"
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 700
    }
    
}
