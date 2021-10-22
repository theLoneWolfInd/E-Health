//
//  InformationVC.swift
//  E health App
//
//  Created by Ranjan on 24/08/21.
//

import UIKit
import Alamofire
import SDWebImage

class InformationVC: UIViewController,UITextViewDelegate{
    
    var dictGetMedicineDetailsInAddresScreen:String!
    
    /*
     supplierId = 85
     quantity = 10
     medicine_id = 141026
     */
    
    var strGetSupplierId:String!
    var strGetQuantity:String!
    var strGetMedicineId:String!
    var strGetTotal:String!
    
    @IBOutlet weak var viewNavigationbar:UIView!
    @IBOutlet weak var btnNavigationBack:UIButton!
    @IBOutlet weak var lblNavationbar:UILabel!{
        didSet {
            
            lblNavationbar.text = "INFORMATION"
        }
    }
    
    @IBOutlet weak var lblNumOfItem:UILabel!
    @IBOutlet weak var lblTotalPrice:UILabel!
    
    @IBOutlet weak var tablView:UITableView! {
        didSet {
            tablView.delegate = self
            tablView.dataSource = self
            tablView.backgroundColor = .white
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.view.backgroundColor = .white
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.lblNumOfItem.text = "Quantity: "+String(self.strGetQuantity)
        self.lblTotalPrice.text =  "Price: $"+String(self.strGetTotal)
        
        print(self.strGetSupplierId as Any)
        print(self.strGetQuantity as Any)
        print(self.strGetMedicineId as Any)
        print(self.strGetTotal as Any)
        
        btnNavigationBack.addTarget(self, action: #selector(btnNavigationBackPress), for: .touchUpInside)
    }
    
    @objc func btnNavigationBackPress() {
        
        navigationController?.popViewController(animated: true)
        
    }
    
}


extension InformationVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:InformationTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell") as! InformationTableViewCell
        cell.backgroundColor = .white
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.btnDeliveryDate.addTarget(self, action: #selector(openDatePicker), for: .touchUpInside)
        cell.btnSubmit.addTarget(self, action: #selector(validateBeforeSubmitRequest), for: .touchUpInside)
        
        return cell
    }
    
    @objc func openDatePicker () {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! InformationTableViewCell
        
        RPicker.selectDate(title: "Delivery Date", didSelectDate: {[] (selectedDate) in
            // TODO: Your implementation for date
            cell.txtDeliveryDate.text = selectedDate.dateString("dd-MM-yyyy")
        })
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 800
    }
    
    
    
    @objc func validateBeforeSubmitRequest() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! InformationTableViewCell
        
        if String(cell.txtDeliveryAddress.text!) == "" {
            self.fieldShoulNotBeEmptyPopup(strTitle: "Delivery Address")
        } else if String(cell.txtContactPersonName.text!) == "" {
            self.fieldShoulNotBeEmptyPopup(strTitle: "Name of Contact Person")
        } else if String(cell.txtMobileNumber.text!) == "" {
            self.fieldShoulNotBeEmptyPopup(strTitle: "Mobile Number")
        } else if String(cell.txtDeliveryDate.text!) == "" {
            self.fieldShoulNotBeEmptyPopup(strTitle: "Delivery Date")
        } else  {
            self.submitOrderAfterPaymentToOurServer()
        }
        
    }
    
    @objc func fieldShoulNotBeEmptyPopup(strTitle:String) {
        
        let alert = UIAlertController(title: "Alert", message: String(strTitle)+" Field should not be empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true)
        
    }
    
    @objc func submitOrderAfterPaymentToOurServer() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! InformationTableViewCell
        
        /*
         print(self.strGetSupplierId as Any)
         print(self.strGetQuantity as Any)
         print(self.strGetMedicineId as Any)
         print(self.strGetTotal as Any)
         */
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "please wait...")
        
         if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
        
         let x : Int = person["userId"] as! Int
         let myString = String(x)
        
        let params =  SaveOrderAfterPayment(action: "saveorder",
                                            hospitalId: String(myString),
                                            supplierId: String(self.strGetSupplierId),
                                            quantity: String(self.strGetQuantity),
                                            medicine_id: String(self.strGetMedicineId),
                                            address: String(cell.txtDeliveryAddress.text!),
                                            contact_person: String(cell.txtContactPersonName.text!),
                                            mobile: String(cell.txtContactPersonName.text!),
                                            special_note: String(cell.txtViewNote.text!),
                                            total: String(self.strGetTotal),
                                            delivery_date: String(cell.txtDeliveryDate .text!))
        
        
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
                            
                            // ERProgressHud.sharedInstance.hide()
                            
                            // var strSuccess2 : String!
                             // strSuccess2 = JSON["msg"]as Any as? String
                             
                            self.deleteAllCart()
                            
                            
                            
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
    
    
    // MARK: - DELETE ALL CART -
    @objc func deleteAllCart() {
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
           
            let params = Delete_All_Cart(action: "deleteallcarts",
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
                        
                        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
                         
                            if person["role"] as! String == "Doctor" {
                                
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "DPDashboardVC")
                                self.navigationController?.pushViewController(push, animated: true)
                                
                            } else if person["role"] as! String == "Hospital" {
                                
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "SuccessId")
                                self.navigationController?.pushViewController(push, animated: true)
                                
                            }
                        }
                        
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
}
