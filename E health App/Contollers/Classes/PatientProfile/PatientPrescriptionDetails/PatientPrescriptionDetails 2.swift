//
//  PatientPrescriptionDetails.swift
//  E health App
//
//  Created by apple on 21/09/21.
//

import UIKit
import Alamofire
import SDWebImage

class PatientPrescriptionDetails: UIViewController {
    
    var getDoctorlId:String!
    var getHospitalId:String!
    var getAppointmentId:String!
    
    var isHospitalAvailaible:String!
    
    // prescription details
    var arrPrescriptionDetails:NSMutableArray = []
    
    var arrPrescriptionTotalImages:NSMutableArray = []
    
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    @IBOutlet weak var viewNavigationbar:UIView!
    @IBOutlet weak var btnDashboardMenu: UIButton!
    @IBOutlet weak var lblNavationbar:UILabel!{
        didSet {
            
            lblNavationbar.text = "Prescriptions Details"
        }
    }
    
    @IBOutlet weak var tbleView:UITableView! {
        didSet {
            // tbleView.delegate = self
            // tbleView.dataSource = self
            tbleView.backgroundColor =  .white
            tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tbleView.separatorStyle = UITableViewCell.SeparatorStyle.none
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        self.tbleView.separatorColor = .black
        
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
        
        self.getPrescriptionDetails()
        print(self.getDoctorlId as Any)
        print(self.getHospitalId as Any)
        
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
    
    
    @objc func getPrescriptionDetails() {
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        
        self.view.endEditing(true)
        // print(self.getAppointmentId as Any)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            let params = Patient_List_of_all_Prescription(action: "prescriptiondetails",
                                                          userId: String(myString),
                                                          doctorId: String(self.getDoctorlId),
                                                          hospitalId: String(self.getHospitalId),
                                                          appointmentId: String(self.getAppointmentId))
            
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
                            strSuccess = JSON["status"]as Any as? String
                            
                            if strSuccess == String("success") {
                                print("yes")
                                
                                ERProgressHud.sharedInstance.hide()
                                
                                var dict: Dictionary<AnyHashable, Any>
                                dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                
                                
                                
                                // 1
                                if (dict["prescription_image"] as! String) == "" {
                                    
                                } else {
                                    
                                    // save prescription image
                                    let myDictionary2: [String:String] = [
                                        
                                        "image" : (dict["prescription_image"] as! String),
                                        "tag"   : ""
                                    ]
                                    
                                    self.arrPrescriptionTotalImages.add(myDictionary2)
                                    
                                }
                                
                                // 2
                                if (dict["prescription_image_2"] as! String) == "" {
                                    
                                } else {
                                    
                                    // save prescription image
                                    let myDictionary2: [String:String] = [
                                        
                                        "image" : (dict["prescription_image_2"] as! String),
                                        "tag"   : ""
                                    ]
                                    
                                    self.arrPrescriptionTotalImages.add(myDictionary2)
                                    
                                }
                                
                                // 3
                                if (dict["prescription_image_3"] as! String) == "" {
                                    
                                } else {
                                    
                                    // save prescription image
                                    let myDictionary2: [String:String] = [
                                        
                                        "image" : (dict["prescription_image_3"] as! String),
                                        "tag"   : ""
                                    ]
                                    
                                    self.arrPrescriptionTotalImages.add(myDictionary2)
                                    
                                }
                                
                                // 4
                                if (dict["prescription_image_4"] as! String) == "" {
                                    
                                } else {
                                    
                                    // save prescription image
                                    let myDictionary2: [String:String] = [
                                        
                                        "image" : (dict["prescription_image_4"] as! String),
                                        "tag"   : ""
                                    ]
                                    
                                    self.arrPrescriptionTotalImages.add(myDictionary2)
                                    
                                }
                                
                                // 5
                                if (dict["prescription_image_5"] as! String) == "" {
                                    
                                } else {
                                    
                                    // save prescription image
                                    let myDictionary2: [String:String] = [
                                        
                                        "image" : (dict["prescription_image_5"] as! String),
                                        "tag"   : ""
                                    ]
                                    
                                    self.arrPrescriptionTotalImages.add(myDictionary2)
                                    
                                }
                                
                                print(self.arrPrescriptionTotalImages as Any)
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                self.arrPrescriptionDetails.add(dict)
                                
                                self.tbleView.delegate = self
                                self.tbleView.dataSource = self
                                self.tbleView.reloadData()
                                
                            } else {
                                print("no")
                                ERProgressHud.sharedInstance.hide()
                                
                                var strSuccess2 : String!
                                strSuccess2 = JSON["msg"]as Any as? String
                                
                                let alert = UIAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), preferredStyle: .alert)
                                
                                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
                                    action in
                                    self.navigationController?.popViewController(animated: true)
                                }))
                                
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
    
}

extension PatientPrescriptionDetails:UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /*
         DoctorAddress = "Ramprastha b block";
         DoctorEmail = "ndoc2@mailinator.com";
         DoctorLastName = "";
         DoctorNumber = 8989700081;
         DoctorfullName = Ndoc2;
         HospitalAddress = "";
         HospitalLastName = "";
         HospitalfullName = "New West one";
         PatientAddress = "Ramprastha address New Delhi 10075";
         PatientEmail = "meeone@mailinator.com";
         PatientLastName = new;
         PatientNumber = 98456666666;
         PatientfullName = Mee;
         created = "2021-09-21 11:51:00";
         disease = "";
         doctorId = 142;
         hospitalId = 140;
         permission = Decline;
         prescriptionId = 13;
         "prescription_image" = "";
         userId = 181;
         */
        
        let item = self.arrPrescriptionDetails[0] as? [String:Any]
        
        if indexPath.row == 0 {
            
            let cell:PatientPrescriptionDetailsTableCell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! PatientPrescriptionDetailsTableCell
            
            cell.backgroundColor = .white
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.lblPatientName.text = (item!["PatientfullName"] as! String)+" "+(item!["PatientLastName"] as! String)
            
            return cell
            
        } else if indexPath.row == 1 {
            
            let cell:PatientPrescriptionDetailsTableCell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! PatientPrescriptionDetailsTableCell
            
            cell.backgroundColor = .white
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            
            // self.arrShowServerDataImageSaved.add(myDictionary2)
            
            /*cell.imgPrescriptionImage.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.imgPrescriptionImage.sd_setImage(with: URL(string: (item!["prescription_image"] as! String)), placeholderImage: UIImage(named: "1024"))
            
            let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(PatientPrescriptionDetails.cellTappedMethod1(_:)))
            cell.imgPrescriptionImage.isUserInteractionEnabled = true
            cell.imgPrescriptionImage.addGestureRecognizer(tapGestureRecognizer1)*/
            
            
            cell.scrollView.isPagingEnabled = true
            for index in 0..<self.arrPrescriptionTotalImages.count {
                
                frame.origin.x = cell.scrollView.frame.size.width * CGFloat(index)
                frame.size = cell.scrollView.frame.size
                
                let item = arrPrescriptionTotalImages[index] as? [String:Any]
                print(item as Any)
                
                let imageView = UIImageView()
                
                imageView.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "1024"))
                
                imageView.frame = frame
                imageView.tag = index
                cell.scrollView.contentSize.width = cell.scrollView.frame.width * CGFloat(index + 1)
                cell.scrollView.addSubview(imageView)
                
                let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(PatientPrescriptionDetails.cellTappedMethod2(_:)))
                imageView.isUserInteractionEnabled = true
                imageView.addGestureRecognizer(tapGestureRecognizer1)
                
            }
            
            cell.btnLeftScroll.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
            cell.btnRightScroll.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
            
            cell.scrollView.contentSize = CGSize(width: cell.scrollView.frame.size.width * CGFloat(self.arrPrescriptionTotalImages.count), height: cell.scrollView.frame.size.height)
            cell.scrollView.delegate = self
            
            return cell
            
        } else if indexPath.row == 2 {
            
            let cell:PatientPrescriptionDetailsTableCell = tableView.dequeueReusableCell(withIdentifier: "cell4") as! PatientPrescriptionDetailsTableCell
            
            cell.backgroundColor = .white
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.lblHospitalName.text       = (item!["HospitalfullName"] as! String)
            cell.lblHospitalAddress.text    = (item!["HospitalAddress"] as! String)
            
            return cell
            
        } else if indexPath.row == 3 {
            
            let cell:PatientPrescriptionDetailsTableCell = tableView.dequeueReusableCell(withIdentifier: "cell3") as! PatientPrescriptionDetailsTableCell
            
            cell.backgroundColor = .white
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.lblName.text           = (item!["DoctorfullName"] as! String)
            cell.lblPhoneNumber.text    = (item!["DoctorNumber"] as! String)
            cell.lblEmail.text          = (item!["DoctorEmail"] as! String)
            cell.lblAddress.text        = (item!["DoctorAddress"] as! String)
            
            return cell
            
        } else {
            
            let cell:PatientPrescriptionDetailsTableCell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! PatientPrescriptionDetailsTableCell
            
            cell.backgroundColor = .white
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            return cell
            
        }
        
        
    }
    
    @objc func leftButtonTapped() {
        let indexPath = IndexPath.init(row: 1, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! PatientPrescriptionDetailsTableCell
        
         if cell.scrollView.contentOffset.x > 0 {
             cell.scrollView.contentOffset.x -=  cell.scrollView.bounds.width
         }
    }
    
    @objc func rightButtonTapped() {
        let indexPath = IndexPath.init(row: 1, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! PatientPrescriptionDetailsTableCell
        
        if cell.scrollView.contentOffset.x < cell.scrollView.bounds.width * CGFloat(self.arrPrescriptionTotalImages.count-1) {
            cell.scrollView.contentOffset.x +=  cell.scrollView.bounds.width
        }
        
    }
    
    // showw prescription multiple image in big screen
    @objc func cellTappedMethod2(_ sender:AnyObject) {
        print("you tap image number: \(sender.view.tag)")
        
        // print(self.arrPrescriptionTotalImages[sender.view.tag])
        
        let item = self.arrPrescriptionTotalImages[sender.view.tag] as? [String:Any]
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ShowImageId") as? ShowImage
        push!.strImageStatus = "Prescription_Details_Patient_Profile"
        push!.imgGetMedicalHistory = (item!["image"] as! String)
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func cellTappedMethod1(_ sender:AnyObject) {
        
        // print("you tap image number: \(sender.view.tag)")
        
        let item = self.arrPrescriptionDetails[0] as? [String:Any]
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ShowImageId") as? ShowImage
        push!.strImageStatus = "Prescription_Details_Patient_Profile"
        push!.imgGetMedicalHistory = (item!["prescription_image"] as! String)
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return UITableView.automaticDimension
        } else if indexPath.row == 1 {
            return 180
        } else if indexPath.row == 2 {
            
            if self.isHospitalAvailaible == "yes" {
                return UITableView.automaticDimension
            } else {
                return 0
            }
            
        } else if indexPath.row == 3 {
            return UITableView.automaticDimension
        } else {
            return 0
        }
        
    }
    
}
