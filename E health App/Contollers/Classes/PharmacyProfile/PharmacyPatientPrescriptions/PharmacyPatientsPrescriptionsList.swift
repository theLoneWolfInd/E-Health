//
//  PharmacyPatientsPrescriptionsList.swift
//  E health App
//
//  Created by apple on 21/10/21.
//

import UIKit
import Alamofire
import SDWebImage

class PharmacyPatientsPrescriptionsList: UIViewController {

    var arrListOfPrescription : NSMutableArray! = []
    
    @IBOutlet weak var viewNavigationBar:UIView!
    @IBOutlet weak var btnDashboardMenu:UIButton! {
        didSet {
            btnDashboardMenu.setImage(UIImage(systemName: "arrow.left"), for: .normal)
            btnDashboardMenu.addTarget(self, action: #selector(backClickMethods), for: .touchUpInside)
        }
    }
    @IBOutlet weak var lblNavigationBar:UILabel!{
        didSet {
            lblNavigationBar.text = "PRESCRIPTIONS LIST"
        }
    }

    @IBOutlet weak var tablView:UITableView! {
        didSet {
            tablView.dataSource = self
            tablView.delegate = self
            tablView.backgroundColor = .white
            tablView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tablView.separatorColor = .clear
        
        
        // print(self.arrListOfPrescription as Any)
    }
    
    @objc func backClickMethods() {
        self.navigationController?.popViewController(animated: true)
    }

    
    @objc func ask_permission_wb(dictGetPatientDetails:NSDictionary) {
        print(dictGetPatientDetails as Any)
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        self.view.endEditing(true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            // let x2 : Int = (self.getPatientRegistrationDetails["userId"] as! Int)
            // let myString2 = String(x2)
            
            var hospitalIdInString:String!
            // var medicalHistoryIdInString:String!
            
            // hospital id
            if (dictGetPatientDetails["hospitalId"] is String) {
                
                print("Yes, it's a String")
                
                hospitalIdInString = (dictGetPatientDetails["hospitalId"] as! String)
                
            } else if dictGetPatientDetails["hospitalId"] is Int {
                
                print("It is Integer")
                
                let x2 : Int = (dictGetPatientDetails["hospitalId"] as! Int)
                let myString2 = String(x2)
                hospitalIdInString = String(myString2)
                
            }
            
            let x21 : Int = (dictGetPatientDetails["prescriptionId"] as! Int)
            let myString21 = String(x21)
            
            let x22 : Int = (dictGetPatientDetails["userId"] as! Int)
            let myString22 = String(x22)
            
            let params = ask_permission_for_patient_prescription(action: "requestprescription",
                                                                 userId: String(myString22),
                                                                 login_id: String(myString),
                                                                 hospitalId: String(hospitalIdInString),
                                                                 prescriptionId: String(myString21))
            
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
                    
                     var strSuccess2 : String!
                     strSuccess2 = JSON["msg"]as Any as? String
                    
                    if strSuccess == String("success") {
                        print("yes")
                        
                        ERProgressHud.sharedInstance.hide()
                        
                        
                        let alert = NewYorkAlertController(title: "Success", message: String(strSuccess2), style: .alert)
                        
                        alert.addImage(UIImage.gif(name: "success3"))
                        
                        let cancel = NewYorkButton(title: "Ok", style: .cancel)
                        alert.addButtons([cancel])
                        
                        self.present(alert, animated: true)
                        
                        
                    } else {
                        
                        print("no")
                        ERProgressHud.sharedInstance.hide()
                        
                        var strSuccess1 : String!
                        strSuccess1 = JSON["status"]as Any as? String
                        
                        var strSuccess : String!
                        strSuccess = JSON["msg"]as Any as? String
                        
                        let alert = NewYorkAlertController(title: strSuccess1, message: String(strSuccess), style: .alert)
                        
                        alert.addImage(UIImage(named: "user_not_found"))
                        
                        let cancel = NewYorkButton(title: "Ok", style: .cancel)
                        alert.addButtons([cancel])
                        
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

extension PharmacyPatientsPrescriptionsList: UITableViewDelegate , UITableViewDataSource {
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrListOfPrescription.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:PharmacyPatientPrescriptionsTableCell  =  tablView.dequeueReusableCell(withIdentifier: "pharmacyPatientPrescriptionsTableCell") as! PharmacyPatientPrescriptionsTableCell
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        let item = self.arrListOfPrescription[indexPath.row] as? [String:Any]
        
        cell.lblPatientName.text       = (item!["PatientfullName"] as! String)+" "+(item!["PatientLastName"] as! String)
        cell.lblPatientEmail.text      = (item!["PatientNumber"] as! String)
        cell.lblPatientAddress.text    = (item!["PatientAddress"] as! String)
        
        cell.imgPatientProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.imgPatientProfile.sd_setImage(with: URL(string: (item!["PatientImage"] as! String)), placeholderImage: UIImage(named: "1024"))
        
        // cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = self.arrListOfPrescription[indexPath.row] as? [String:Any]
        print(item as Any)
        
        if (item!["permission"] as! String) == "Decline" {
            
            let alert = NewYorkAlertController(title: "Permission", message: String("You don't have permission to access Patient's Medical History."), style: .alert)
            
            alert.addImage(UIImage(named: "medical_permission"))
            
            let send_permission = NewYorkButton(title: "Ask Permission", style: .default) {
                _ in
                
                self.ask_permission_wb(dictGetPatientDetails: item! as NSDictionary)
            }
            
            let cancel = NewYorkButton(title: "Dismiss", style: .cancel)
            alert.addButtons([send_permission,cancel])
            
            self.present(alert, animated: true)
            
        } else {
            
            // push to precription page
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddImagesId") as? AddImages
            
            // push!
            push!.strShowImageDetailsFor = "prescription_list_from_pharmacy"
            push!.dict_get_pharmacy_prescription = item! as NSDictionary
            
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 110
    }
    
}
