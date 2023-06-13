//
//  SupplierOrderHistoryDetails.swift
//  E health App
//
//  Created by apple on 07/10/21.
//

import UIKit
import Alamofire
import SDWebImage

class SupplierOrderHistoryDetails: UIViewController  {

    var dictGetAllSupplierDetails:NSDictionary!
    
    @IBOutlet weak var viewNavigationBar:UIView!
    
    @IBOutlet weak var btnDashboardMenu:UIButton! {
        didSet {
            btnDashboardMenu.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        }
    }
    
    @IBOutlet weak var lblNavigationBar:UILabel!{
        didSet {
            
            lblNavigationBar.text = "ORDER DETAILS"
        }
    }
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            // tbleView.delegate = self
            // tbleView.dataSource = self
            tbleView.backgroundColor =  .white
            tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        print(self.dictGetAllSupplierDetails as Any)
        
        self.btnDashboardMenu.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        self.orderDetailsWB()
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func orderDetailsWB() {
        
        /*
         date = "2021-09-23T12:11:59+0530";
         "delivery_address" = "Anand vihar b block S2";
         "delivery_status" = 0;
         hospitalId = 153;
         "hospital_email" = "mona@mailinator.com";
         "hospital_name" = Mona;
         "hospital_number" = 9865321427;
         image = "";
         orderId = 49;
         supplierId = "99,99";
         "supplier_email" = "sup1@mailinator.com";
         "supplier_name" = "sup1 one";
         "supplier_number" = 9865325552;
         total = 130;
         userId = "";
         */
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "please wait...")
        
        let x : Int = (self.dictGetAllSupplierDetails["orderId"] as! Int)
        let myString = String(x)
        
        
        
        var supplierIdIs:String!
        
        if self.dictGetAllSupplierDetails["supplierId"] is String {
                          
            print("Yes, it's a String")
            
            supplierIdIs = (self.dictGetAllSupplierDetails["supplierId"] as! String)
            
        } else if self.dictGetAllSupplierDetails["supplierId"] is Int {
          
            print("It is Integer")
          
            let x : Int = (self.dictGetAllSupplierDetails["supplierId"] as! Int)
            let myString = String(x)
            
            supplierIdIs = myString
            
        }
        
        
        let params =  Order_Details_WB(action: "orderdetails",
                                       orderId: String(myString),
                                       supplierId:String(supplierIdIs))
        
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
                    
                    // arrListOfAllMedicines
                    
                    self.dictGetAllSupplierDetails = JSON["data"] as! Dictionary<AnyHashable, Any> as NSDictionary
                    
                    // print(self.dictGetAllordersDetails as Any)
                    
                    self.tbleView.delegate = self
                    self.tbleView.dataSource = self
                    self.tbleView.reloadData()
                    
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

extension SupplierOrderHistoryDetails : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell:SupplierOrderHistoryDetailsTableCell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! SupplierOrderHistoryDetailsTableCell
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.backgroundColor = .white
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            
            
            if self.dictGetAllSupplierDetails["total"] is String {
                              
                print("Yes, it's a String")
              
                cell.lblPrice.text = "$"+(self.dictGetAllSupplierDetails["total"] as! String)

            } else if self.dictGetAllSupplierDetails["total"] is Int {
              
                print("It is Integer")
              
                let x : Int = (self.dictGetAllSupplierDetails["total"] as! Int)
                let myString = String(x)
                cell.lblPrice.text = "$"+myString
                
            } else {
                
            }
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                
                if (person["role"] as! String) == "Hospital" || (person["role"] as! String) == "Pharmacy"  {
                    
                    cell.lblSupplierName.text = (self.dictGetAllSupplierDetails["supplier_name"] as! String)
                    cell.lblPhone.text = (self.dictGetAllSupplierDetails["supplier_number"] as! String)
                    cell.lblEmail.text = (self.dictGetAllSupplierDetails["supplier_email"] as! String)
                    cell.btnSupplierAddress.setTitle((self.dictGetAllSupplierDetails["supplier_address"] as! String), for: .normal)
                    
                    cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                    cell.imgProfile.sd_setImage(with: URL(string: (self.dictGetAllSupplierDetails["supplier_image"] as! String)), placeholderImage: UIImage(named: "1024"))
                    
                } else {
                    
                    cell.lblSupplierName.text = (self.dictGetAllSupplierDetails["hospital_name"] as! String)
                    cell.lblPhone.text = (self.dictGetAllSupplierDetails["hospital_number"] as! String)
                    cell.lblEmail.text = (self.dictGetAllSupplierDetails["hospital_email"] as! String)
                    cell.btnSupplierAddress.setTitle((self.dictGetAllSupplierDetails["hospital_address"] as! String), for: .normal)
                    
                    cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                    cell.imgProfile.sd_setImage(with: URL(string: (self.dictGetAllSupplierDetails["hospital_image"] as! String)), placeholderImage: UIImage(named: "1024"))
                    
                }
                
            }
            
            // cell.lblAddress.text = (self.dictGetAllordersDetails["address"] as! String)
            
            cell.btnSupplierAddress.titleLabel?.lineBreakMode = .byCharWrapping
            
            cell.imgBanner.image = UIImage(named: "1024")
            // cell.imgProfile.image = UIImage(named: "daze")

            // cell.imgBanner.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            // cell.imgBanner.sd_setImage(with: URL(string: (self.dictGetAllSupplierDetails["hospital_image"] as! String)), placeholderImage: UIImage(named: "1024"))
            
            
            
            return cell
            
        } else if indexPath.row == 1 {
            
            let cell:SupplierOrderHistoryDetailsTableCell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! SupplierOrderHistoryDetailsTableCell
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.backgroundColor = .white
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            if self.dictGetAllSupplierDetails["delivery_status"] is String {
                
                if (self.dictGetAllSupplierDetails["delivery_status"] as! String) == "0" {
                    
                    cell.lblDeliveryStatus.text = "Not Delivered"
                    cell.imgMarkAsDelivered.isHidden = true
                    
                } else {
                    
                    cell.lblDeliveryStatus.text = "Delivered"
                    cell.imgMarkAsDelivered.isHidden = false
                    
                }
                
            } else if self.dictGetAllSupplierDetails["delivery_status"] is Int {
                
                let x : Int = (self.dictGetAllSupplierDetails["delivery_status"] as! Int)
                let myString = String(x)
                
                if myString == "0" {
                    
                    cell.lblDeliveryStatus.text = "Not Delivered"
                    cell.imgMarkAsDelivered.isHidden = true
                    
                } else {
                    
                    cell.lblDeliveryStatus.text = "Delivered"
                    cell.imgMarkAsDelivered.isHidden = false
                    
                }
                
            }
            
            return cell
            
        } else if indexPath.row == 2 {
            
            let cell:SupplierOrderHistoryDetailsTableCell = tableView.dequeueReusableCell(withIdentifier: "cell3") as! SupplierOrderHistoryDetailsTableCell
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.backgroundColor = .white
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.lblDeliveryTo.text = (self.dictGetAllSupplierDetails["contact_person"] as! String)
            
            return cell
            
        } else if indexPath.row == 3 {
            
            let cell:SupplierOrderHistoryDetailsTableCell = tableView.dequeueReusableCell(withIdentifier: "cell4") as! SupplierOrderHistoryDetailsTableCell
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.backgroundColor = .white
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.lblDeliveryLocation.text = (self.dictGetAllSupplierDetails["delivery_address"] as! String)
            
            return cell
            
        } else if indexPath.row == 4 {
            
            let cell:SupplierOrderHistoryDetailsTableCell = tableView.dequeueReusableCell(withIdentifier: "cell5") as! SupplierOrderHistoryDetailsTableCell
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.backgroundColor = .white
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.lblHospitalLocation.text = (self.dictGetAllSupplierDetails["hospital_address"] as! String)
            
            return cell
            
        } else if indexPath.row == 5 {
            
            let cell:SupplierOrderHistoryDetailsTableCell = tableView.dequeueReusableCell(withIdentifier: "cell6") as! SupplierOrderHistoryDetailsTableCell
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.backgroundColor = .white
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.lblDeliveryDate.text = (self.dictGetAllSupplierDetails["delivery_date"] as! String)
            
            return cell
            
        } else if indexPath.row == 6 {
            
            let cell:SupplierOrderHistoryDetailsTableCell = tableView.dequeueReusableCell(withIdentifier: "cell7") as! SupplierOrderHistoryDetailsTableCell
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.backgroundColor = .white
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            // cell.accessoryType = .disclosureIndicator
            
            cell.lblNotes.text = (self.dictGetAllSupplierDetails["special_note"] as! String)
            
            return cell
            
        } else if indexPath.row == 7 {
            
            let cell:SupplierOrderHistoryDetailsTableCell = tableView.dequeueReusableCell(withIdentifier: "cell8") as! SupplierOrderHistoryDetailsTableCell
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.backgroundColor = .white
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            // cell.accessoryType = .disclosureIndicator
            
            cell.lblSupplierAddress.text = (self.dictGetAllSupplierDetails["supplier_address"] as! String)
            
            return cell
            
        } else if indexPath.row == 8 {
            
            let cell:SupplierOrderHistoryDetailsTableCell = tableView.dequeueReusableCell(withIdentifier: "cell9") as! SupplierOrderHistoryDetailsTableCell
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.backgroundColor = .white
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.accessoryType = .disclosureIndicator
            
            // cell.lblNotes.text = (self.dictGetAllSupplierDetails["delivery_date"] as! String)
            
            return cell
            
        } else if indexPath.row == 9 {
            
            let cell:SupplierOrderHistoryDetailsTableCell = tableView.dequeueReusableCell(withIdentifier: "cell10") as! SupplierOrderHistoryDetailsTableCell
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.backgroundColor = .white
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            if self.dictGetAllSupplierDetails["delivery_status"] is String {
                
                if (self.dictGetAllSupplierDetails["delivery_status"] as! String) == "0" {
                    
                    cell.btnMarkAsDelivered.backgroundColor = .systemOrange
                    cell.btnMarkAsDelivered.isUserInteractionEnabled = true
                    // cell.btnMarkAsDelivered.setImage(UIImage.gif(name: "OnMyWay"), for: .normal)
                    cell.btnMarkAsDelivered.setTitle("Mark as Delivered", for: .normal)
                    cell.btnMarkAsDelivered.addTarget(self, action: #selector(markAsDeliveredPopup), for: .touchUpInside)
                    
                } else {
                    
                    cell.btnMarkAsDelivered.backgroundColor = .systemGreen
                    cell.btnMarkAsDelivered.isUserInteractionEnabled = false
                    cell.btnMarkAsDelivered.setTitle("Delivered", for: .normal)
                    
                }
                
            } else if self.dictGetAllSupplierDetails["delivery_status"] is Int {
                
                let x : Int = (self.dictGetAllSupplierDetails["delivery_status"] as! Int)
                let myString = String(x)
                
                if myString == "0" {
                    
                    cell.btnMarkAsDelivered.backgroundColor = .systemOrange
                    cell.btnMarkAsDelivered.isUserInteractionEnabled = true
                    // cell.btnMarkAsDelivered.setImage(UIImage.gif(name: "OnMyWay"), for: .normal)
                    cell.btnMarkAsDelivered.setTitle("Mark as Delivered", for: .normal)
                    cell.btnMarkAsDelivered.addTarget(self, action: #selector(markAsDeliveredPopup), for: .touchUpInside)
                    
                } else {
                    
                    cell.btnMarkAsDelivered.backgroundColor = .systemGreen
                    cell.btnMarkAsDelivered.isUserInteractionEnabled = false
                    cell.btnMarkAsDelivered.setTitle("Delivered", for: .normal)
                    
                }
                
            }
            
            return cell
            
        } else {
            
            let cell:SupplierOrderHistoryDetailsTableCell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! SupplierOrderHistoryDetailsTableCell
            
            return cell
            
        }
          
    }
    
    @objc func markAsDeliveredPopup() {
        
        let alert = NewYorkAlertController(title: "Mark as Delivered", message: "Are you sure you want to mark this product as Delivered ?", style: .alert)

        // alert.addImage(UIImage(named: "497-truck-delivery-outline"))
         alert.addImage(UIImage(named: "delivered"))
        let ok = NewYorkButton(title: "Yes, Mark", style: .default) { _ in
            print("Tapped OK")
            
            self.btnMarkAsDeliveredClickMethod()
            
        }
        ok.setDynamicColor(.purple)
        let cancel = NewYorkButton(title: "Cancel", style: .cancel)
        alert.addButtons([ok, cancel])

        present(alert, animated: true)
        
    }
    
    @objc func btnMarkAsDeliveredClickMethod() {
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "please wait...")
        
        
            let x : Int = (self.dictGetAllSupplierDetails["orderId"] as! Int)
            let myString = String(x)
           
            let params =  Mark_As_Delivered(action: "orderstatus",
                                            orderId: String(myString),
                                            delivery_status: "1")
            
            
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
                        
                        var strSuccess : String!
                        strSuccess = (JSON["msg"]as Any as? String)
                        
                        let alert = NewYorkAlertController(title: "Success", message: String(strSuccess), style: .alert)

                        alert.addImage(UIImage.gif(name: "success3"))
                        
                        let cancel = NewYorkButton(title: "OK", style: .cancel) { _ in
                            // self.navigationController?.popViewController(animated: true)
                            self.orderDetailsWB()
                        }
                        alert.addButtons([cancel])

                        self.present(alert, animated: true)
                        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 8 {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OrderItemsId") as? OrderItems
            push!.dictGetAllDataOnlyForItems = self.dictGetAllSupplierDetails
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            
            return 380
            
        } else if indexPath.row == 1 {
            
            return 110
            
        } else if indexPath.row == 9 {
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                
                if (person["role"] as! String) == "Hospital"
                    || (person["role"] as! String) == "Doctor"
                    || (person["role"] as! String) == "Patient"
                    || (person["role"] as! String) == "Lab"
                    || (person["role"] as! String) == "Pharmacy"{
                    
                    return 0
                    
                } else {
                    
                    if self.dictGetAllSupplierDetails["delivery_status"] is String {
                        
                        if (self.dictGetAllSupplierDetails["delivery_status"] as! String) == "0" {
                            return 80
                        } else {
                            return 0
                        }
                        
                    } else if self.dictGetAllSupplierDetails["delivery_status"] is Int {
                        
                        let x : Int = (self.dictGetAllSupplierDetails["delivery_status"] as! Int)
                        let myString = String(x)
                        
                        if myString == "0" {
                            return 80
                        } else {
                            return 0
                        }
                        
                    } else {
                        return 0
                    }
                    
                }
                
            } else {
                return 0
            }
            
            
        } else if indexPath.row == 4 {
            
            return 0
            
        } else {
            
            return UITableView.automaticDimension
            
        }
    }
    
}
