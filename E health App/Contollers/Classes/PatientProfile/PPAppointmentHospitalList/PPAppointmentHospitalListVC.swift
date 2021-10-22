//
//  PPAppointmentHospitalListVC.swift
//  E health App
//
//  Created by Ranjan on 07/09/21.
//

import UIKit
import Alamofire
import SDWebImage

class PPAppointmentHospitalListVC: UIViewController {

    var getHospitalListingOfThatDoctorInDictionary:NSDictionary!
    var getHospitalListingOfThatDoctor:NSMutableArray = []
    
    var getSelectedDoctorDetails:NSDictionary!
    
    var arr1 = ["Brigham and Women's Hospital Brigham and Women's Hospital", "Duke University Hospital","Mount Sinai Hospital", "Vanderbilt University Medical Center", "NYU Langone Hospitals (tie)", "Brigham and Women's Hospital","Duke University Hospital","Mount Sinai Hospital", "Vanderbilt University Medical Center", "NYU Langone Hospitals (tie)", "Brigham and Women's Hospital", "Duke University Hospital","Mount Sinai Hospital", "Vanderbilt University Medical Center", "NYU Langone Hospitals (tie)"]

    @IBOutlet weak var viewNavigationBar:UIView!
    @IBOutlet weak var btnDashboardMenu:UIButton!
    @IBOutlet weak var lblNavigationBar:UILabel!{
        didSet {
            
            lblNavigationBar.text = "HOSPITAL"
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
     var filtered:[String] = []
    
    
    
    var searchActive : Bool =  false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // searchBar.delegate =  self
        self.view.backgroundColor = .white
        tableView.backgroundColor =  .white
        self.navigationController?.isNavigationBarHidden = true
        
        self.tableView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        // print(self.getHospitalListingOfThatDoctorInDictionary as Any)
        // print(self.getHospitalListingOfThatDoctor as Any)
        
        var ar : NSArray!
        ar = (self.getHospitalListingOfThatDoctorInDictionary["data"] as! Array<Any>) as NSArray
        print(ar as Any)
        self.getHospitalListingOfThatDoctor.addObjects(from: ar as! [Any])
        
        
        
        // print(self.getHospitalListingOfThatDoctor as Any) // hospital data
        // print(self.getSelectedDoctorDetails as Any) // doctor data
        
        
        
        
        if let myLoadedString = UserDefaults.standard.string(forKey: "keySetToBackOrMenu") {
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
            self.btnDashboardMenu.setImage(UIImage(systemName: "arrow.left"), for: .normal)
            self.btnDashboardMenu.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
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

}

extension PPAppointmentHospitalListVC: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchActive {
            
            return filtered.count
        }
        else {
            return  self.getHospitalListingOfThatDoctor.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:PPAppointmentHospitalListTableViewCell  =  tableView.dequeueReusableCell(withIdentifier: "cell") as! PPAppointmentHospitalListTableViewCell
    
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.backgroundColor = .white
        
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
        
        let item = self.getHospitalListingOfThatDoctor[indexPath.row] as? [String:Any]
        // print(item as Any)
        
        if searchActive {
            
            
            cell.lblHospitalName.text =  filtered[indexPath.row]
        }
        
        else {
            
            cell.lblHospitalName.text =  (item!["fullName"] as! String)
            
            cell.lblDistance.text = ""
            cell.btnHospitalAddress.setTitle((item!["address"] as! String), for: .normal)
            cell.btnHospitalAddress.titleLabel?.lineBreakMode = .byWordWrapping
            
            cell.imgHospital.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.imgHospital.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "1024"))
            
            cell.btnHospitalDetails.tag = indexPath.row
            cell.btnHospitalDetails.addTarget(self, action: #selector(hospitalDetailsClickMethod), for: .touchUpInside)
            
            cell.btnHospitalBookAnAppoitment.tag = indexPath.row
            cell.btnHospitalBookAnAppoitment.addTarget(self, action: #selector(hospitalBookAppointnemtnClickMethod), for: .touchUpInside)
            
        }
        
        return cell
    }
    
    //MARK:- BOOK AN APPOITMENT CALENDAR PAGE -
    @objc func hospitalBookAppointnemtnClickMethod(_ sender:UIButton) {
        let item = self.getHospitalListingOfThatDoctor[sender.tag] as? [String:Any]
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "PPBookAppointmentSelectDateVC") as? PPBookAppointmentSelectDateVC
    
        push!.fetchHospitalDataForBooking = item as NSDictionary?
        push!.fetchDoctorDataForBooking = self.getSelectedDoctorDetails
        
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func hospitalDetailsClickMethod(_ sender:UIButton) {
    
        let item = self.getHospitalListingOfThatDoctor[sender.tag] as? [String:Any]
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "PPBookAppointmentVC") as? PPBookAppointmentVC
        
        push!.dictGetHospitalDetails = item as NSDictionary?
        push!.fetchDoctorDataInDetailsScreen = self.getSelectedDoctorDetails
        
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    //Searchbar Delegate
     
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
     
     
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
     
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = arr1.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        
        if(filtered.count == 0) {
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }

}
