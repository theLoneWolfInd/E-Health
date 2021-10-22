//
//  PatientPrescriptionList.swift
//  E health App
//
//  Created by apple on 20/09/21.
//

import UIKit
import Alamofire
import SDWebImage

class PatientPrescriptionList: UIViewController {
    
    // list of all prescription
    var arrListOfAllPrescription:NSMutableArray = []
    
    @IBOutlet weak var viewNavigationbar:UIView!
    @IBOutlet weak var btnDashboardMenu: UIButton!
    @IBOutlet weak var lblNavationbar:UILabel!{
        didSet {
            
            lblNavationbar.text = "Prescriptions"
        }
    }
    
    @IBOutlet weak var tablView:UITableView! {
        didSet {
            tablView.backgroundColor =  .white
            tablView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tablView.separatorStyle = UITableViewCell.SeparatorStyle.none
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
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
        
        
        // print(self.arrListOfAllPrescription as Any)
        
        self.listOfAllPrescription()
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
    
    @objc func listOfAllPrescription() {
        self.arrListOfAllPrescription.removeAllObjects()
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        
        self.view.endEditing(true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            let params = Patient_List_of_all_Prescription(action: "prescriptionlist",
                                                          userId: String(myString),
                                                          doctorId: "",
                                                          hospitalId: "",
                                                          appointmentId: "")
            
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
                    
                    // var strSuccess2 : String!
                    // strSuccess2 = JSON["msg"]as Any as? String
                    
                    if strSuccess == String("success") {
                        print("yes")
                        
                        ERProgressHud.sharedInstance.hide()
                        
                        
                        var ar : NSArray!
                        ar = (JSON["data"] as! Array<Any>) as NSArray
                        self.arrListOfAllPrescription.addObjects(from: ar as! [Any])
                        
                        
                        /*var dict: Dictionary<AnyHashable, Any>
                         dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                         print(dict as Any)
                         self.arrListOfAllPrescription.add(dict)*/
                        
                        self.tablView.delegate = self
                        self.tablView.dataSource = self
                        self.tablView.reloadData()
                        
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

extension PatientPrescriptionList:UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrListOfAllPrescription.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:PatientPrescriptionTableCell = tablView.dequeueReusableCell(withIdentifier: "patientPrescriptionTableCell") as! PatientPrescriptionTableCell
        
        cell.backgroundColor = .white
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        // cell.lblPatientName.text = arr[indexPath.row]
        
        /*
         ["created": 2021-09-21 11:51:00, "PatientfullName": Mee, "PatientNumber": 98456666666, "DoctorLastName": , "prescriptionId": 13, "disease": , "HospitalfullName": New West one, "HospitalLastName": , "DoctorfullName": Ndoc2, "HospitalAddress": 9/1, Block C, Yojna Vihar, Anand Vihar, Ghaziabad, Uttar Pradesh 110092, India, "PatientLastName": new, "DoctorAddress": Ramprastha b block, "userId": 181, "doctorId": 142, "DoctorEmail": ndoc2@mailinator.com, "prescription_image": https://demo4.evirtualservices.net/ehealth/img/uploads/prescription/16322053011623222872640.png, "PatientEmail": meeone@mailinator.com, "DoctorNumber": 8989700081, "hospitalId": 140, "PatientAddress": Ramprastha address New Delhi 10075, "permission": Decline]
         */
        
        let item = self.arrListOfAllPrescription[indexPath.row] as? [String:Any]
        // print(item as Any)
        
        cell.lblDoctorTitle.text    = (item!["DoctorfullName"] as! String)
        
        if (item!["HospitalfullName"] as! String) == "" {
            cell.lblHospitalText.text = "Email"
            cell.lblHospitalNameTitle.text  = (item!["DoctorEmail"] as! String)+"\n\n at: "+(item!["created"] as! String)
        } else {
            cell.lblHospitalText.text = "Hopital"
            cell.lblHospitalNameTitle.text  = (item!["HospitalfullName"] as! String)+"\n\n at: "+(item!["created"] as! String)
        }
        
        cell.imgViewprofile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.imgViewprofile.sd_setImage(with: URL(string: (item!["prescription_image"] as! String)), placeholderImage: UIImage(named: "1024"))
        
       // cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    @objc func cellTappedMethod1(_ sender:AnyObject) {
        
        print("you tap image number: \(sender.view.tag)")
        
        /*let item = self.arrListOfAppoitmentList[sender.view.tag] as? [String:Any]
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPAppointmentDetailsVC") as? PPAppointmentDetailsVC
        push!.getPatientAppointmentDetails = item as NSDictionary?
        self.navigationController?.pushViewController(push!, animated: true)*/
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = self.arrListOfAllPrescription[indexPath.row] as? [String:Any]
        // print(item as Any)
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PatientPrescriptionDetailsId") as? PatientPrescriptionDetails
        
        if item!["hospitalId"] is String {
                          
            print("Yes, it's a String")
          
            let x : Int = (item!["doctorId"] as! Int)
            let myString = String(x)
            
            push!.getDoctorlId = String(myString)
            push!.getHospitalId = String("")
            push!.isHospitalAvailaible = "no"
            
             

        } else if item!["hospitalId"] is Int {
          
            print("It is Integer")
          
            let x : Int = (item!["doctorId"] as! Int)
            let myString = String(x)
            
            let x2 : Int = (item!["hospitalId"] as! Int)
            let myString2 = String(x2)
            
            push!.getDoctorlId = String(myString)
            push!.getHospitalId = String(myString2)
            push!.isHospitalAvailaible = "yes"
            
        }
        
        let x3 : Int = (item!["appointmentId"] as! Int)
        let myString3 = String(x3)
        push!.getAppointmentId = String(myString3)
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    @objc func pushToAllDoctorsList() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPBookAppointmentSelectDoctorVC") as? PPBookAppointmentSelectDoctorVC
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
}
