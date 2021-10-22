//
//  MenuControllerVC.swift
//  SidebarMenu
//
//  Created by Apple  on 16/10/19.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class MenuControllerVC: UIViewController {

    let cellReuseIdentifier = "menuControllerVCTableCell"
    
    var bgImage: UIImageView?
    
    var roleIs:String!
    
    @IBOutlet weak var navigationBar:UIView!
    
    @IBOutlet weak var viewUnderNavigation:UIView! {
        didSet {
            // viewUnderNavigation.backgroundColor = .black
            viewUnderNavigation.backgroundColor = .systemYellow // UIColor.init(red: 237.0/255.0, green: 186.0/255.0, blue: 204.0/255.0, alpha: 1)
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "DASHBOARD"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var imgSidebarMenuImage:UIImageView! {
        didSet {
           // imgSidebarMenuImage.backgroundColor = .clear
            //imgSidebarMenuImage.layer.cornerRadius = 2
            //imgSidebarMenuImage.clipsToBounds = true
            imgSidebarMenuImage.image = UIImage(named: "supplier")
            imgSidebarMenuImage.layer.borderWidth = 5.0
            imgSidebarMenuImage.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    
    
    // hospital
    var arrHospitalTitle = ["Home",
                            "Edit Profile",
                            "Booked Appointments",
                            "Doctors",
                            "Labs",
                            "Pharmacies",
                            "Patients",
                            "Cart",
                            "Contact Suppliers",
                            "Supplier Request",
                            "Order History",
                            "Change Password",
                            "Help",
                            "Signout"]
    
    var arrHospitalImage = ["home",
                            "edit_profile",
                            "sidebarmenuEdit",
                            "sidebarmenuDoctor",
                            "sidebarmenuLaabs",
                            "sidebarmenuPharmacies",
                            "sidebarmenuPatient",
                            "sidebarmenuPatient",
                            "sidebarmenuSuppliers",
                            "sidebarmenuSuppliers",
                            "edit_profile",
                            "edit_profile",
                            "lock",
                            "help",
                            "logout"]
    
    
    
    // patient
    var arrPatientTitle = ["Home",
                            "Edit Profile",
                            "Book an appointment",
                            "Medical History",
                            "E - Health Card",
                            "Change Password",
                            "Help",
                            "Signout"]
    
    var arrPatientImage = ["home",
                            "edit_profile",
                            "edit_profile",
                            "edit_profile",
                            "edit_profile",
                            "lock",
                            "help",
                            "logout"]
    
    
    // doctor
    var arrDoctorTitle = ["Home",
                            "Edit Profile",
                            "Booked Appointment",
                            "Order History",
                            "Contact Suppliers",
                            "Supplier Request",
                          "Cart",
                            "Help",
                          "Change Password",
                            "Signout"]
    
    var arrDoctorImage = ["home",
                          "edit_profile",
                          "edit_profile",
                          "edit_profile",
                          "edit_profile",
                          "cart",
                          "lock",
                          "help",
                          "lock",
                          "logout"]
    
    // supplier
    var arrSupplierTitle = ["Home",
                            "Edit Profile",
                            "Manage Inventory",
                            "Order History",
                            "Change Password",
                            "Help",
                            "Signout"]
    
    var arrSupplierImage = ["home",
                            "edit_profile",
                            "medical",
                            "medical",
                            "lock",
                            "help",
                            "logout"]
    
    // lab
    var arrLabTitle = ["Home",
                       "Edit Profile",
                       "Patient Test",
                       "Order History",
                       "Patients",
                       "Contact Suppliers",
                       "Request Supplier",
                       "Cart",
                       "Change Password",
                       "Help",
                       "Signout"]
    
    var arrLabImage = ["home",
                       "edit_profile",
                       "medical",
                       "medical",
                       "medical",
                       "medical",
                       "medical",
                       "cart",
                       "lock",
                       "help",
                       "logout"]
    
    
    // pharmacy
    var arrPharmacyTitle = ["Home",
                       "Edit Profile",
                       "Patient Prescription",
                       "Order History",
                       "Patients",
                       "Contact Suppliers",
                       "Request Supplier",
                       "Cart",
                       "Change Password",
                       "Help",
                       "Signout"]
    
    var arrPharmacyImage = ["home",
                       "edit_profile",
                       "medical",
                       "medical",
                       "medical",
                       "medical",
                       "medical",
                       "cart",
                       "lock",
                       "help",
                       "logout"]
    
    
    @IBOutlet weak var lblUserName:UILabel! {
        didSet {
            lblUserName.text = "Applo Medical Center"
            lblUserName.textColor = .white
        }
    }
    @IBOutlet weak var lblPhoneNumber:UILabel! {
        didSet {
            lblPhoneNumber.textColor = .white
            lblPhoneNumber.text = "1800-4267-3923"
        }
    }
    
    @IBOutlet var menuButton:UIButton!
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            tbleView.delegate = self
            tbleView.dataSource = self
            tbleView.tableFooterView = UIView.init()
            //tbleView.backgroundColor = .blue
            // tbleView.separatorInset = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50)
            tbleView.separatorColor = .lightGray
        }
    }
    
    @IBOutlet weak var lblMainTitle:UILabel!
    @IBOutlet weak var lblAddress:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideBarMenuClick()
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.tbleView.separatorColor = .white // UIColor.init(red: 60.0/255.0, green: 110.0/255.0, blue: 160.0/255.0, alpha: 1)
        
        self.tbleView.backgroundColor = UIColor.init(red: 71.0/256.0, green: 119.0/256.0, blue: 81.0/256.0, alpha: 1)
        
        self.view.backgroundColor = .white // NAVIGATION_BACKGROUND_COLOR
        
        self.sideBarMenuClick()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
             
            print(person as Any)
            
            if (person["role"] as! String) == "Hospital" {
                
                /*
                 ["status": 1, "device": iOS, "lastName": , "description": 1212122re, "eyeColor": , "longitude": , "dob": , "height": , "gender": , "zipCode": , "countryId": , "contactNumber": 8283828382, "state": , "specialty": N.A., "hospitalName": Africa E-health, "registeredDt": , "image": , "userId": 108, "socialType": , "socialId": , "firebaseId": , "latitude": , "middleName": , "role": Hospital, "department": N.A., "address": 121212, "deviceToken": , "medicalCardID": , "practiceDate": , "approveByAdmin": 1, "email": testios@gmail.com, "city": , "fullName": Test iOS]

                 */
                
                self.lblUserName.text = (person["fullName"] as! String)
                self.lblUserName.textColor = .black
                
                self.lblPhoneNumber.text = (person["contactNumber"] as! String)
                self.lblPhoneNumber.textColor = .black
                
                self.imgSidebarMenuImage.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                self.imgSidebarMenuImage.sd_setImage(with: URL(string: (person["image"] as! String)), placeholderImage: UIImage(named: "1024"))
                
            } else if (person["role"] as! String) == "Patient" {
                
                self.lblUserName.text = (person["fullName"] as! String)
                self.lblUserName.textColor = .black
                
                self.lblPhoneNumber.text = (person["contactNumber"] as! String)
                self.lblPhoneNumber.textColor = .black
                
                self.imgSidebarMenuImage.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                self.imgSidebarMenuImage.sd_setImage(with: URL(string: (person["image"] as! String)), placeholderImage: UIImage(named: "1024"))
                
            } else if (person["role"] as! String) == "Doctor" {
                
                self.lblUserName.text = (person["fullName"] as! String)
                self.lblUserName.textColor = .black
                
                self.lblPhoneNumber.text = (person["contactNumber"] as! String)
                self.lblPhoneNumber.textColor = .black
                
                self.imgSidebarMenuImage.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                self.imgSidebarMenuImage.sd_setImage(with: URL(string: (person["image"] as! String)), placeholderImage: UIImage(named: "1024"))
                
            } else if (person["role"] as! String) == "Supplier" {
                
                self.lblUserName.text = (person["fullName"] as! String)
                self.lblUserName.textColor = .black
                
                self.lblPhoneNumber.text = (person["contactNumber"] as! String)
                self.lblPhoneNumber.textColor = .black
                self.lblPhoneNumber.textColor = .black
                self.lblPhoneNumber.textColor = .black
                
                self.imgSidebarMenuImage.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                self.imgSidebarMenuImage.sd_setImage(with: URL(string: (person["image"] as! String)), placeholderImage: UIImage(named: "1024"))
                
            } else {
                
                self.lblUserName.text = (person["fullName"] as! String)
                self.lblUserName.textColor = .black
                
                self.lblPhoneNumber.text = (person["contactNumber"] as! String)
                self.lblPhoneNumber.textColor = .black
                
                self.imgSidebarMenuImage.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                self.imgSidebarMenuImage.sd_setImage(with: URL(string: (person["image"] as! String)), placeholderImage: UIImage(named: "1024"))
                
            }
            
            
            
            
            
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    @objc func sideBarMenuClick() {
        
        if revealViewController() != nil {
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
          }
    }
}

extension MenuControllerVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
            
            if (person["role"] as! String) == "Hospital" {
                
                return arrHospitalTitle.count
                
            } else if (person["role"] as! String) == "Patient" {
                
                return arrPatientTitle.count
                
            } else if (person["role"] as! String) == "Doctor" {
                
                return arrDoctorTitle.count
                
            } else if (person["role"] as! String) == "Supplier" {
                
                return arrSupplierTitle.count
                
            } else if (person["role"] as! String) == "Lab" {
                
                return arrLabTitle.count
                
            } else if (person["role"] as! String) == "Pharmacy" {
                
                return arrPharmacyTitle.count
                
            } else {
                return 0
            }
            
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MenuControllerVCTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MenuControllerVCTableCell
        
        cell.backgroundColor = .clear
      
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
            
            if (person["role"] as! String) == "Hospital" {
                
                cell.lblName.text = arrHospitalTitle[indexPath.row]
                cell.imgProfile.image = UIImage(named: arrHospitalImage[indexPath.row])
                
            } else if (person["role"] as! String) == "Patient" {
                
                cell.lblName.text = arrPatientTitle[indexPath.row]
                cell.imgProfile.image = UIImage(named: arrPatientImage[indexPath.row])
                
            } else if (person["role"] as! String) == "Doctor" {
                
                cell.lblName.text = arrDoctorTitle[indexPath.row]
                cell.imgProfile.image = UIImage(named: arrDoctorImage[indexPath.row])
                
            } else if (person["role"] as! String) == "Supplier" {
                
                cell.lblName.text = arrSupplierTitle[indexPath.row]
                cell.imgProfile.image = UIImage(named: arrSupplierImage[indexPath.row])
                
            } else if (person["role"] as! String) == "Lab" {
                
                cell.lblName.text = arrLabTitle[indexPath.row]
                cell.imgProfile.image = UIImage(named: arrLabImage[indexPath.row])
                
            } else if (person["role"] as! String) == "Pharmacy" {
                
                cell.lblName.text = arrPharmacyTitle[indexPath.row]
                cell.imgProfile.image = UIImage(named: arrPharmacyImage[indexPath.row])
                
            }
            
            
            
        }
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
             
            print(person as Any)
            
            if (person["role"] as! String) == "Hospital" {
                
                if arrHospitalTitle[indexPath.row] == "Home" {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "HPDashboardVC")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrHospitalTitle[indexPath.row] == "Change Password" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "changePasswordVC")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrHospitalTitle[indexPath.row] == "Edit Profile" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "CEditProfileId")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrHospitalTitle[indexPath.row] == "Doctors" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = storyboard.instantiateViewController(withIdentifier: "HPDoctorsVC") as? HPDoctorsVC
                    destinationController!.strMyProfileIs = "FromHospitalProfileToDoctors"
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrHospitalTitle[indexPath.row] == "Labs" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = storyboard.instantiateViewController(withIdentifier: "HPDoctorsVC") as? HPDoctorsVC
                    destinationController!.strMyProfileIs = "FromHospitalProfileToLabs"
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrHospitalTitle[indexPath.row] == "Pharmacies" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = storyboard.instantiateViewController(withIdentifier: "HPPharmacyVC") as? HPPharmacyVC
                    destinationController!.strMyProfileIs = "FromHospitalProfileToDoctors"
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrHospitalTitle[indexPath.row] == "Patients" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = storyboard.instantiateViewController(withIdentifier: "HPDoctorsVC") as? HPDoctorsVC
                    destinationController!.strMyProfileIs = "FromHospitalProfileToPatient"
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrHospitalTitle[indexPath.row] == "Contact Suppliers" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = storyboard.instantiateViewController(withIdentifier: "HPDoctorsVC") as? HPDoctorsVC
                    destinationController!.strMyProfileIs = "FromHospitalProfileToSuppliers"
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrHospitalTitle[indexPath.row] == "Supplier Request" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = storyboard.instantiateViewController(withIdentifier: "manageInventoryVC") as? manageInventoryVC
                    // destinationController!.strMyProfileIs = "FromHospitalProfileToSuppliers"
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrHospitalTitle[indexPath.row] == "Cart" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = storyboard.instantiateViewController(withIdentifier: "CTotalCartListId")
                    let navigationController = UINavigationController(rootViewController: destinationController)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrHospitalTitle[indexPath.row] == "Order History" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = storyboard.instantiateViewController(withIdentifier: "orderHistoryVC")
                    let navigationController = UINavigationController(rootViewController: destinationController)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrHospitalTitle[indexPath.row] == "Booked Appointments" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "DPAppointmentsVC")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrHospitalTitle[indexPath.row] == "Signout" {
                    
                    let alert = UIAlertController(title: String("Logout"), message: String("Are you sure your want to logout ?"), preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "Yes, Logout", style: .default, handler: { action in
                        self.logoutWB()
                        
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    
                    
                } else if arrHospitalTitle[indexPath.row] == "Help" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "helpVC")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                }
                
            } else if (person["role"] as! String) == "Patient" {
                
                if arrPatientTitle[indexPath.row] == "Home" {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "PPDashboardVC")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrPatientTitle[indexPath.row] == "Signout" {
                    
                    let alert = UIAlertController(title: String("Logout"), message: String("Are you sure your want to logout ?"), preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "Yes, Logout", style: .default, handler: { action in
                        self.logoutWB()
                        
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    
                    
                } else if arrPatientTitle[indexPath.row] == "Book an appointment" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "PPAppointmentsVC")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                }  else if arrPatientTitle[indexPath.row] == "Edit Profile" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "CEditProfileId")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrPatientTitle[indexPath.row] == "Help" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "helpVC")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrPatientTitle[indexPath.row] == "Change Password" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "changePasswordVC")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrPatientTitle[indexPath.row] == "Medical History" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "MedicalHistoryVC")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrPatientTitle[indexPath.row] == "E - Health Card" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "PatientEhealthCardId")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrPatientTitle[indexPath.row] == "Prescription" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "PatientPrescriptionListId")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrPatientTitle[indexPath.row] == "Help" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "helpVC")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                }
                
                
                // PatientPrescriptionList
                
            } else if (person["role"] as! String) == "Doctor" {
                
                if arrDoctorTitle[indexPath.row] == "Home" {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "DPDashboardVC")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                }
                
                else
                    
                    if arrDoctorTitle[indexPath.row] == "Signout" {
                        
                        let alert = UIAlertController(title: String("Logout"), message: String("Are you sure your want to logout ?"), preferredStyle: UIAlertController.Style.alert)
                        
                        alert.addAction(UIAlertAction(title: "Yes, Logout", style: .default, handler: { action in
                            self.logoutWB()
                            
                        }))
                        
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    } else if arrDoctorTitle[indexPath.row] == "Edit Profile"  {
                        
                        let myString = "backOrMenu"
                        UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                        self.view.window?.rootViewController = sw
                        let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "CEditProfileId")
                        let navigationController = UINavigationController(rootViewController: destinationController!)
                        sw.setFront(navigationController, animated: true)
                        
                    } else if arrDoctorTitle[indexPath.row] == "Booked Appointment" {
                        
                        let myString = "backOrMenu"
                        UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                        self.view.window?.rootViewController = sw
                        let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "DPAppointmentsVC")
                        let navigationController = UINavigationController(rootViewController: destinationController!)
                        sw.setFront(navigationController, animated: true)
                        
                    } else if arrDoctorTitle[indexPath.row] == "Order History" {
                        
                        let myString = "backOrMenu"
                        UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                        self.view.window?.rootViewController = sw
                        let destinationController = storyboard.instantiateViewController(withIdentifier: "orderHistoryVC")
                        let navigationController = UINavigationController(rootViewController: destinationController)
                        sw.setFront(navigationController, animated: true)
                        
                    } else if arrDoctorTitle[indexPath.row] == "Contact Suppliers" {
                        
                        let myString = "backOrMenu"
                        UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                        self.view.window?.rootViewController = sw
                        let destinationController = storyboard.instantiateViewController(withIdentifier: "HPDoctorsVC") as? HPDoctorsVC
                        destinationController!.strMyProfileIs = "FromHospitalProfileToSuppliers"
                        let navigationController = UINavigationController(rootViewController: destinationController!)
                        sw.setFront(navigationController, animated: true)
                        
                    } else if arrDoctorTitle[indexPath.row] == "Supplier Request" {
                        
                        let myString = "backOrMenu"
                        UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                        self.view.window?.rootViewController = sw
                        let destinationController = storyboard.instantiateViewController(withIdentifier: "manageInventoryVC") as? manageInventoryVC
                        // destinationController!.strMyProfileIs = "FromHospitalProfileToSuppliers"
                        let navigationController = UINavigationController(rootViewController: destinationController!)
                        sw.setFront(navigationController, animated: true)
                        
                    } else if arrDoctorTitle[indexPath.row] == "Cart" {
                        
                        let myString = "backOrMenu"
                        UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                        self.view.window?.rootViewController = sw
                        let destinationController = storyboard.instantiateViewController(withIdentifier: "CTotalCartListId")
                        let navigationController = UINavigationController(rootViewController: destinationController)
                        sw.setFront(navigationController, animated: true)
                        
                    } else if arrDoctorTitle[indexPath.row] == "Help" {
                        
                        let myString = "backOrMenu"
                        UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                        self.view.window?.rootViewController = sw
                        let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "helpVC")
                        let navigationController = UINavigationController(rootViewController: destinationController!)
                        sw.setFront(navigationController, animated: true)
                        
                    } else if arrDoctorTitle[indexPath.row] == "Change Password" {
                        
                        let myString = "backOrMenu"
                        UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                        self.view.window?.rootViewController = sw
                        let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "changePasswordVC")
                        let navigationController = UINavigationController(rootViewController: destinationController!)
                        sw.setFront(navigationController, animated: true)
                        
                    }
                
                
            } else if (person["role"] as! String) == "Supplier" {
                
                if arrSupplierTitle[indexPath.row] == "Home" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "dashboardVC")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrSupplierTitle[indexPath.row] == "Edit Profile"  {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "CEditProfileId")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrSupplierTitle[indexPath.row] == "Manage Inventory"  {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "selectDiseaseVC")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrSupplierTitle[indexPath.row] == "Order History"  {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "orderHistoryVC")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrSupplierTitle[indexPath.row] == "Change Password" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "changePasswordVC")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrSupplierTitle[indexPath.row] == "Signout" {
                    
                    let alert = UIAlertController(title: String("Logout"), message: String("Are you sure your want to logout ?"), preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "Yes, Logout", style: .default, handler: { action in
                        self.logoutWB()
                        
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                } else if arrSupplierTitle[indexPath.row] == "Help" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "helpVC")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                }
                
            } else if (person["role"] as! String) == "Lab" {
                
                if arrLabTitle[indexPath.row] == "Home" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "DashboardDLPVC")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrLabTitle[indexPath.row] == "Patients"  {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    //
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "HPDoctorsVC") as? HPDoctorsVC
                    destinationController!.strMyProfileIs = "FromHospitalProfileToPatient"
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrLabTitle[indexPath.row] == "Edit Profile"  {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "CEditProfileId")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrLabTitle[indexPath.row] == "Contact Suppliers" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = storyboard.instantiateViewController(withIdentifier: "HPDoctorsVC") as? HPDoctorsVC
                    destinationController!.strMyProfileIs = "FromHospitalProfileToSuppliers"
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrLabTitle[indexPath.row] == "Request Supplier" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = storyboard.instantiateViewController(withIdentifier: "manageInventoryVC") as? manageInventoryVC
                    // destinationController!.strMyProfileIs = "FromHospitalProfileToSuppliers"
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrLabTitle[indexPath.row] == "Order History"  {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "orderHistoryVC")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrLabTitle[indexPath.row] == "Change Password" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "changePasswordVC")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrLabTitle[indexPath.row] == "Signout" {
                    
                    let alert = UIAlertController(title: String("Logout"), message: String("Are you sure your want to logout ?"), preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "Yes, Logout", style: .default, handler: { action in
                        self.logoutWB()
                        
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                } else if arrLabTitle[indexPath.row] == "Help" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "helpVC")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                }
                
            } else if (person["role"] as! String) == "Pharmacy" {
                
                if arrPharmacyTitle[indexPath.row] == "Help" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "helpVC")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrPharmacyTitle[indexPath.row] == "Signout" {
                    
                    let alert = UIAlertController(title: String("Logout"), message: String("Are you sure your want to logout ?"), preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Yes, Logout", style: .default, handler: { action in
                        self.logoutWB()
                        
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                     
                } else if arrPharmacyTitle[indexPath.row] == "Change Password" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "changePasswordVC")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrPharmacyTitle[indexPath.row] == "Home" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "DashboardDLPVC")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrPharmacyTitle[indexPath.row] == "Patients"  {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    //
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "HPDoctorsVC") as? HPDoctorsVC
                    destinationController!.strMyProfileIs = "FromHospitalProfileToPatient"
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrPharmacyTitle[indexPath.row] == "Edit Profile"  {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "CEditProfileId")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrPharmacyTitle[indexPath.row] == "Contact Suppliers" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = storyboard.instantiateViewController(withIdentifier: "HPDoctorsVC") as? HPDoctorsVC
                    destinationController!.strMyProfileIs = "FromHospitalProfileToSuppliers"
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrPharmacyTitle[indexPath.row] == "Request Supplier" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = storyboard.instantiateViewController(withIdentifier: "manageInventoryVC") as? manageInventoryVC
                    // destinationController!.strMyProfileIs = "FromHospitalProfileToSuppliers"
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrPharmacyTitle[indexPath.row] == "Patient Prescription" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = storyboard.instantiateViewController(withIdentifier: "HPDoctorsVC") as? HPDoctorsVC
                    destinationController!.strMyProfileIs = "FromLabToAllPatients"
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                }
                
            }
            
        }
        
    }
    
    @objc func logoutWB() {
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // let str:String = person["role"] as! String
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = logout_my_app(action: "logout",
                                       userId: String(myString))
            
            print(params as Any)
            
            AF.request(APPLICATION_BASE_URL,
                       method: .post,
                       parameters: params,
                       encoder: JSONParameterEncoder.default).responseJSON { response in
                // debugPrint(response.result)
                
                switch response.result {
                case let .success(value):
                    
                    let JSON = value as! NSDictionary
                    print(JSON as Any)
                    
                    var strSuccess : String!
                    strSuccess = (JSON["status"]as Any as? String)?.lowercased()
                    print(strSuccess as Any)
                    if strSuccess == String("success") {
                        print("yes")
                        
                        ERProgressHud.sharedInstance.hide()
                        
                        self.yesLogout()
                        
                        /*var strSuccess2 : String!
                        strSuccess2 = JSON["msg"]as Any as? String
                        
                        let alert = UIAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            
                        }))
                        
                        self.present(alert, animated: true)*/
                        
                    } else {
                        
                        print("no")
                        ERProgressHud.sharedInstance.hide()
                        
                        var strSuccess2 : String!
                        strSuccess2 = JSON["msg"]as Any as? String
                        
                        let alert = UIAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        
                        self.present(alert, animated: true)
                        
                    }
                    
                case let .failure(error):
                    print(error)
                    ERProgressHud.sharedInstance.hide()
                    
                    // Utils.showAlert(alerttitle: SERVER_ISSUE_TITLE, alertmessage: SERVER_ISSUE_MESSAGE, ButtonTitle: "Ok", viewController: self)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    @objc func yesLogout() {
        
        UserDefaults.standard.set("", forKey: "keyLoginFullData")
        UserDefaults.standard.set(nil, forKey: "keyLoginFullData")
        
        UserDefaults.standard.set("", forKey: "keySetToBackOrMenu")
        UserDefaults.standard.set(nil, forKey: "keySetToBackOrMenu")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
        self.view.window?.rootViewController = sw
        let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "registerOptionVC")
        let navigationController = UINavigationController(rootViewController: destinationController!)
        sw.setFront(navigationController, animated: true)
        
    }
}

extension MenuControllerVC: UITableViewDelegate {
    
}
