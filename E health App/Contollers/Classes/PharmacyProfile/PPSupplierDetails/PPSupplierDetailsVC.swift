//
//  PPSupplierDetailsVC.swift
//  E health App
//
//  Created by Ranjan on 30/08/21.
//

import UIKit
import Alamofire
import SDWebImage

class PPSupplierDetailsVC: UIViewController {

    var getSupplierDetails:NSDictionary!
    
    @IBOutlet weak var viewNavigationBar:UIView!
    @IBOutlet weak var btnNavigationBack:UIButton!
    @IBOutlet weak var lblNavigationBar:UILabel!{
        didSet {
            
            lblNavigationBar.text = "SUPPLIER DETAILS"
        }
    }

    @IBOutlet weak var tablView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tablView.dataSource = self
        tablView.delegate = self
        tablView.backgroundColor = .white
        self.view.backgroundColor = .white
        self.tablView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        self.navigationController?.isNavigationBarHidden = true
        
        self.btnNavigationBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }

}

extension PPSupplierDetailsVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // print(self.getSupplierDetails as Any)
        /*
         address = "L-ist, 1898,Opposite. Asthal Mandir, Block L 2, Devli, Sangam Vihar, New Delhi, Delhi 110080, India";
         city = noida;
         contactNumber = 9835353456;
         countryId = 101;
         department = "";
         description = "";
         device = "";
         deviceToken = "";
         dob = "10 Sep, 2021";
         email = "lee@mailinator.com";
         eyeColor = black;
         firebaseId = "";
         fullName = "lee n";
         gender = Female;
         height = 5;
         image = "https://demo4.evirtualservices.net/ehealth/img/uploads/users/1631714214images(27).jpeg";
         lastName = msff;
         latitude = "28.6634107";
         longitude = "77.3239753";
         medicalCardID = "4Q72-L648-S8OH-NZ2S";
         middleName = ma;
         practiceDate = "";
         registeredDt = "15 Sep, 2021";
         role = Patient;
         socialId = "";
         socialType = "";
         specialty = "";
         state = "";
         status = 1;
         userId = 148;
         zipCode = 123123;
         */
       
        if indexPath.row == 0 {
            
            let cell:PPSupplierDetailsTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell1") as! PPSupplierDetailsTableViewCell
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.backgroundColor = .white
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.btnSupplierAddress.setTitle((self.getSupplierDetails["address"] as! String), for: .normal)
            cell.btnSupplierAddress.titleLabel?.lineBreakMode = .byWordWrapping
            cell.btnSupplierAddress.setTitleColor(.black, for: .normal)
            
            cell.lblSupplierName.text = (self.getSupplierDetails["fullName"] as! String)
            cell.lblSupplierName.textColor = .black
            
            cell.lblPhone.text = (self.getSupplierDetails["contactNumber"] as! String)
            cell.lblEmail.text = (self.getSupplierDetails["email"] as! String)
            
            cell.imgBanner.image = UIImage(named: "background")
            cell.imgProfile.image = UIImage(named: "daze")

            cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.imgProfile.sd_setImage(with: URL(string: (self.getSupplierDetails["image"] as! String)), placeholderImage: UIImage(named: "1024"))
            
            return cell
        }
        
        else if indexPath.row == 1 {
            
            let cell:PPSupplierDetailsTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell2") as! PPSupplierDetailsTableViewCell
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.backgroundColor = .white
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            if (self.getSupplierDetails["specialty"] as! String) == "" {
                cell.lblSubject.text = "N.A."
            } else {
                cell.lblSubject.text = (self.getSupplierDetails["specialty"] as! String)
            }
            
            
            return cell
        }
        else {
            
            let cell:PPSupplierDetailsTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell3") as! PPSupplierDetailsTableViewCell
            cell.backgroundColor = .white
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            if (self.getSupplierDetails["description"] as! String) == "" {
                cell.lblMessage.text = "N.A."
            } else {
                cell.lblMessage.text = (self.getSupplierDetails["description"] as! String)
            }
            
            

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 310
        }
        else if indexPath.row == 1 {
            return UITableView.automaticDimension
        } else {
            return UITableView.automaticDimension
        }
    }
}
