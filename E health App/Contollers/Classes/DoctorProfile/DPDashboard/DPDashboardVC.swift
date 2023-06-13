//
//  DPDashboardVC.swift
//  E health App
//
//  Created by Ranjan on 30/08/21.
//

import UIKit
import Alamofire
import SDWebImage

class DPDashboardVC: UIViewController {
    
    var dictDoctorLoginData:NSDictionary!
    
    @IBOutlet weak var viewNavigationBar:UIView!
    @IBOutlet weak var btnDashboardMenu:UIButton!
    @IBOutlet weak var lblNavigationBar:UILabel!{
        didSet {
            
            lblNavigationBar.text = "DASHBOARD"
        }
    }

    @IBOutlet weak var tablView:UITableView!

    @IBOutlet weak var btnCheckAppointments:UIButton!
    @IBOutlet weak var btnCalendar:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        tablView.backgroundColor =  .white
        self.navigationController?.isNavigationBarHidden = true
        tablView.delegate = self
        tablView.dataSource = self
        //self.btnDashboardMenuPress()
        self.tablView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        btnCheckAppointments.addTarget(self, action: #selector(btnCheckAppointmentsPress), for: .touchUpInside)

        self.btnCalendar.addTarget(self, action: #selector(calendarClickMethod), for: .touchUpInside)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
            
            // print(person as Any)
            
            self.dictDoctorLoginData = person as NSDictionary
            
        } else {
            
            let alert = UIAlertController(title: String("Logout"), message: String("Are you sure your want to logout ?"), preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Yes, Logout", style: .default, handler: { action in
                self.yesLogout()
                
            }))
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        // print(self.dictDoctorLoginData as Any)
        
        self.sideBarMenuClick()
    }
    
    @objc func calendarClickMethod() {
    
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DPAppointmentsVC") as? DPAppointmentsVC
        self.navigationController?.pushViewController(push!, animated: true)
        
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
    
    @objc func yesLogout() {
        
        UserDefaults.standard.set("", forKey: "keyLoginFullData")
        UserDefaults.standard.set(nil, forKey: "keyLoginFullData")
        
        UserDefaults.standard.set("", forKey: "keySetToBackOrMenu")
        UserDefaults.standard.set(nil, forKey: "keySetToBackOrMenu")
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "registerVC") as? registerVC
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func btnCheckAppointmentsPress() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ReportsId") as? Reports
        self.navigationController?.pushViewController(push!, animated: true)
        
    }

}

extension DPDashboardVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        // print(self.dictDoctorLoginData as Any)
        
        /*
         address = "Anand vihar b block S2";
         approveByAdmin = 1;
         city = "";
         contactNumber = 9865321427;
         countryId = "";
         department = "Plastic surgery ";
         description = "";
         device = iOS;
         deviceToken = "";
         dob = "";
         email = "mona@mailinator.com";
         eyeColor = "";
         firebaseId = "";
         fullName = Mona;
         gender = "";
         height = "";
         hospitalName = "New West one";
         image = "https://demo4.evirtualservices.net/ehealth/img/uploads/users/1631781210images(11).jpeg";
         lastName = "";
         latitude = "";
         longitude = "";
         medicalCardID = "";
         middleName = "";
         practiceDate = "14 Sep, 2020";
         registeredDt = "";
         role = Doctor;
         socialId = "";
         socialType = "";
         specialty = "Plastic surgery";
         state = "";
         status = 1;
         userId = 153;
         zipCode = "";
         */
         if indexPath.row == 0 {
             
             let cell:DPDashboardTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell1") as! DPDashboardTableViewCell
             
            cell.backgroundColor = .white
             
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
             
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
         
             cell.btnAddress.setTitle(" "+(self.dictDoctorLoginData["address"] as! String), for: .normal)
             cell.btnAddress.setTitleColor(.black, for: .normal)
             
             cell.lblDoctorName.text = (self.dictDoctorLoginData["fullName"] as! String)
             cell.lblDoctorName.textColor = .black
             
             cell.lblPhone.text = (self.dictDoctorLoginData["contactNumber"] as! String)
             cell.lblEmail.text = (self.dictDoctorLoginData["email"] as! String)
             
             cell.imgBanner.image = UIImage(named: "background")
             cell.imgProfile.image = UIImage(named: "daze")

             cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
             cell.imgProfile.sd_setImage(with: URL(string: (self.dictDoctorLoginData["image"] as! String)), placeholderImage: UIImage(named: "1024"))
             
             return cell
         }
         
         else if indexPath.row == 1 {
             
             let cell:DPDashboardTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell2") as! DPDashboardTableViewCell
            cell.backgroundColor = .white
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
             
             cell.lblDepartment.text = (self.dictDoctorLoginData["department"] as! String)
             return cell
         }
         else if indexPath.row == 2{
             
             let cell:DPDashboardTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell3") as! DPDashboardTableViewCell
             
            cell.backgroundColor = .white
             
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
             
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
             
             cell.lblSpecialist.text = (self.dictDoctorLoginData["specialty"] as! String)
             
             return cell
         }
    
         else if indexPath.row == 3 {
             
             let cell:DPDashboardTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell4") as! DPDashboardTableViewCell
             
            cell.backgroundColor = .white
             
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
             
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
             
             cell.lblHospital.text = (self.dictDoctorLoginData["hospitalName"] as! String)
             
             return cell
         }
    
         
         else {
             
             let cell:DPDashboardTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell5") as! DPDashboardTableViewCell
             
            cell.backgroundColor = .white
             
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
             
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
             
            cell.lblPracticeStartDate.text =  (self.dictDoctorLoginData["practiceDate"] as! String)
             
             return cell
         }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            
            return 310
            
        }
        
        else if indexPath.row == 1{
            
            return UITableView.automaticDimension
        }
        else if indexPath.row == 2{
            
            return UITableView.automaticDimension
            
        }
        
        else if indexPath.row == 3{
            
            return UITableView.automaticDimension
            
        }
        else if indexPath.row == 4{
            
            return UITableView.automaticDimension
            
        }
        else {
            
            return UITableView.automaticDimension
            
        }
    }
    
}
