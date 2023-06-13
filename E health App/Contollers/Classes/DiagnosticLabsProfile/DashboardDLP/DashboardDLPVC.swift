//
//  DashboardDLPVC.swift
//  E health App
//
//  Created by Ranjan on 23/08/21.
//

import UIKit
import Alamofire
import SDWebImage

class DashboardDLPVC: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    var dictSupplierLoginData:NSDictionary!
    
    @IBOutlet weak var viewNavigationBar:UIView!
    @IBOutlet weak var btnDashboardMenu:UIButton!
    @IBOutlet weak var lblNavigationBar:UILabel!{
        didSet {
            lblNavigationBar.text = "DASHBOARD"
        }
    }

    @IBOutlet weak var tablView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        tablView.dataSource = self
        tablView.delegate = self
        tablView.backgroundColor = .white
        self.tablView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        
        self.sideBarMenuClick()
        
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
            
            // print(person as Any)
            
            self.dictSupplierLoginData = person as NSDictionary
            
        } else {
            
            let alert = UIAlertController(title: String("Logout"), message: String("Are you sure your want to logout ?"), preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Yes, Logout", style: .default, handler: { action in
                self.yesLogout()
                
            }))
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        if indexPath.row == 0 {
            
            let cell:DLDashbaordTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell1") as! DLDashbaordTableViewCell
            
            cell.backgroundColor = .white
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            print(self.dictSupplierLoginData as Any)
            
            for n in 1...5 {
                print(n, terminator: "")
            }
            
            cell.btnAddress.setTitle(" "+(self.dictSupplierLoginData["address"] as! String), for: .normal)
            cell.btnAddress.titleLabel?.lineBreakMode = .byWordWrapping
            
            cell.lblLabName.text = (self.dictSupplierLoginData["fullName"] as! String)
            
            cell.lblPhone.text = (self.dictSupplierLoginData["contactNumber"] as! String)
            cell.lblEmail.text = (self.dictSupplierLoginData["email"] as! String)
            
            cell.imgBanner.image = UIImage(named: "background")
            cell.imgProfile.image = UIImage(named: "daze")

            // cell.btnRqstSupplier.addTarget(self, action: #selector(request_supplier_click_method), for: .touchUpInside)
            
            cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.imgProfile.sd_setImage(with: URL(string: (self.dictSupplierLoginData["image"] as! String)), placeholderImage: UIImage(named: "1024"))
            
            return cell
        }
        
        else if indexPath.row == 1 {
            
            let cell:DLDashbaordTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell2") as! DLDashbaordTableViewCell
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.backgroundColor = .white
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.lblSpecialist.text = (self.dictSupplierLoginData["description"] as! String)
            
            return cell
        }
        else if indexPath.row == 2 {
            
            let cell:DLDashbaordTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell3") as! DLDashbaordTableViewCell
            cell.backgroundColor = .white
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.lblHospitalName.text = (self.dictSupplierLoginData["hospitalName"] as! String)
            
            return cell
        }
        else if indexPath.row == 3 {
            
            let cell:DLDashbaordTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell4") as! DLDashbaordTableViewCell
            
            cell.backgroundColor = .white
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.lblLocation.text = (self.dictSupplierLoginData["address"] as! String)
            
            return cell
        }
        
        else {
            
            let cell:DLDashbaordTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell5") as! DLDashbaordTableViewCell
            cell.backgroundColor = .white
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView

            cell.btnAllPatient.addTarget(self, action: #selector(allPatientsClickMethod), for: .touchUpInside)
            cell.btnRqstSupplier.addTarget(self, action: #selector(request_supplier_click_method), for: .touchUpInside)
            
            return cell
        }
    }
    
    @objc func request_supplier_click_method() {
        
        // let item = self.arrListOfAllDisease[indexPath.row] as? [String:Any]
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "selectDiseaseVC") as? selectDiseaseVC
        // push!.strWhereAreYouFrom = "supplierProfile"
        // push!.dictGetClickedDiseaseData = item as NSDictionary?
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func allPatientsClickMethod() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HPDoctorsVC") as? HPDoctorsVC
        push!.strMyProfileIs = "FromLabToAllPatients"
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func allTestClickMethod() {
        
        /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddImagesId") as? AddImages
        push!.strShowImageDetailsFor = "test"
        self.navigationController?.pushViewController(push!, animated: true)*/
    }
    
    // else if self.strMyProfileIs == "FromHospitalProfileToLabs" {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            
            return 310
            
        }
        
        else if indexPath.row == 1 {
            
            return UITableView.automaticDimension
            
        }
        else if indexPath.row == 2 {
            
            if (self.dictSupplierLoginData["hospitalName"] as! String) == "" {
                return 0
            } else {
                return UITableView.automaticDimension
            }
            
        }
        else if indexPath.row == 3 {
            
            return UITableView.automaticDimension
            
        }
        else {
            
            return 140
            
        }
    }
    
}
