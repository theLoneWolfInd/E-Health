//
//  PPOrderDetailsVC.swift
//  E health App
//
//  Created by Ranjan on 30/08/21.
//

import UIKit
import Alamofire
import SDWebImage
import SwiftGifOrigin

class PPOrderDetailsVC: UIViewController {
    
    var dictGetAllordersDetails:NSDictionary!
    
    @IBOutlet weak var viewNavigationBar:UIView!
    @IBOutlet weak var btnNavigationBack:UIButton!
    @IBOutlet weak var lblNavigationBar:UILabel!{
        didSet {
            
            lblNavigationBar.text = "OREDER DETAILS"
        }
    }

    @IBOutlet weak var tablView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // tablView.dataSource = self
        // tablView.delegate = self
        
        tablView.backgroundColor = .white
        self.view.backgroundColor = .white
        self.tablView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        self.navigationController?.isNavigationBarHidden = true
        
        // print(self.dictGetAllordersDetails as Any)
        // markAsDeliveredPopup()
        self.btnNavigationBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
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
        
        let x : Int = (self.dictGetAllordersDetails["orderId"] as! Int)
        let myString = String(x)
        
        let x2 : Int = (self.dictGetAllordersDetails["supplierId"] as! Int)
        let myString2 = String(x2)
        
        
        let params =  Order_Details_WB(action: "orderdetails",
                                       orderId: String(myString),
                                       supplierId:String(myString2))
        
        
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
                    
                    self.dictGetAllordersDetails = JSON["data"] as! Dictionary<AnyHashable, Any> as NSDictionary
                    
                    // print(self.dictGetAllordersDetails as Any)
                    
                    self.tablView.delegate = self
                    self.tablView.dataSource = self
                    self.tablView.reloadData()
                    
                    /*var ar : NSArray!
                     ar = (JSON["data"] as! Array<Any>) as NSArray
                     self.arrListOfAllHistory.addObjects(from: ar as! [Any])
                     
                     if self.arrListOfAllHistory.count == 0 {
                     
                     let alert = UIAlertController(title: "Alert", message: "No Data found.", preferredStyle: .alert)
                     alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                     self.present(alert, animated: true)
                     
                     } else {
                     self.tablView.delegate = self
                     self.tablView.dataSource = self
                     self.tablView.reloadData()
                     }*/
                    
                    
                    /*var strSuccess2 : String!
                     strSuccess2 = JSON["msg"]as Any as? String
                     
                     let alert = UIAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), preferredStyle: .alert)
                     
                     alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action  in
                     
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

extension PPOrderDetailsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /*
         date = "2021-09-16T20:27:05+0530";
         "delivery_address" = "ramprastha ";
         "delivery_status" = 1;
         hospitalId = 163;
         "hospital_email" = "newios@gmail.com";
         "hospital_name" = "new iOS";
         "hospital_number" = 95684567777;
         image = "https://demo4.evirtualservices.net/ehealth/img/uploads/product/";
         orderId = 19;
         orderproducts =         (
                         {
                 date = "2021-09-16T20:27:05+0530";
                 "medicine_id" = "";
                 name = "(AENC) DISINFECTANT WATER-FREE HAND FOAM (POLIHEXANIDE) SOLUTION YANTAI DONGKE LVZHIYUAN DISINFECTION PHARMACEUTICAL CO., LTD.";
                 orderproductId = 9;
                 price = "";
                 quantity = 5;
             }
         );
         "sender_address" = "9/1, Block C, Yojna Vihar, Anand Vihar, Ghaziabad, Uttar Pradesh 110092, India";
         supplierId = 99;
         "supplier_name" = "sup1 one";
         total = 50;
         userId = "";
         */
       
        // self.dictGetAllordersDetails
        
        if indexPath.row == 0 {
            
            let cell:PPOrderDetailsTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell1") as! PPOrderDetailsTableViewCell
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.backgroundColor = .white
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            // cell.btnSupplierAddress.setTitle((self.dictGetAllordersDetails[""] as! String), for: .normal)
            
            // cell.lblSupplierName.text = (self.dictGetAllordersDetails[""] as! String)
            
            // cell.lblPhone.text = (self.dictGetAllordersDetails[""] as! String)
            // cell.lblEmail.text = (self.dictGetAllordersDetails[""] as! String)
            
            cell.lblPhone.text = (self.dictGetAllordersDetails["hospital_name"] as! String)
            cell.lblEmail.text = (self.dictGetAllordersDetails["hospital_email"] as! String)
            // cell.lblAddress.text = (self.dictGetAllordersDetails["address"] as! String)
            cell.btnSupplierAddress.setTitle((self.dictGetAllordersDetails["hospital_address"] as! String), for: .normal)
            
            cell.imgBanner.image = UIImage(named: "background")
            cell.imgProfile.image = UIImage(named: "daze")

            cell.imgBanner.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.imgBanner.sd_setImage(with: URL(string: (self.dictGetAllordersDetails["hospital_image"] as! String)), placeholderImage: UIImage(named: "1024"))
            
            cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.imgProfile.sd_setImage(with: URL(string: (self.dictGetAllordersDetails["supplier_image"] as! String)), placeholderImage: UIImage(named: "1024"))
            
            return cell
        }
        
        else if indexPath.row == 1 {
            
            let cell:PPOrderDetailsTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell2") as! PPOrderDetailsTableViewCell
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.backgroundColor = .white
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.lblDeliverto.text = (self.dictGetAllordersDetails["hospital_address"] as! String)
            
            return cell
        }
        else if indexPath.row == 2 {
            
            let cell:PPOrderDetailsTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell3") as! PPOrderDetailsTableViewCell
            
            cell.backgroundColor = .white
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.lblLocation.text = (self.dictGetAllordersDetails["sender_address"] as! String)
            
            return cell
        }
        else if indexPath.row == 3 {
            
            let cell:PPOrderDetailsTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell4") as! PPOrderDetailsTableViewCell
            
            cell.backgroundColor = .white
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.lblDeliveryDate.text = (self.dictGetAllordersDetails["delivery_date"] as! String)
            
            return cell
        }
        
        else if indexPath.row == 4 {
            
            let cell:PPOrderDetailsTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell5") as! PPOrderDetailsTableViewCell
            
            cell.backgroundColor = .white
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.lblItems.text = "Click here to see all items."

            cell.accessoryType = .disclosureIndicator
            
            return cell
        } else {
            let cell:PPOrderDetailsTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell6") as! PPOrderDetailsTableViewCell
            
            cell.backgroundColor = .white
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
           
            if self.dictGetAllordersDetails["delivery_status"] is String {
                
                if (self.dictGetAllordersDetails["delivery_status"] as! String) == "0" {
                    
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
                
                
            } else if self.dictGetAllordersDetails["delivery_status"] is Int {
                
                let x : Int = (self.dictGetAllordersDetails["delivery_status"] as! Int)
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
        
        
            let x : Int = (self.dictGetAllordersDetails["orderId"] as! Int)
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
                        
                        let cancel = NewYorkButton(title: "dismiss", style: .cancel) { _ in
                            self.navigationController?.popViewController(animated: true)
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
        
        if indexPath.row == 4 {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OrderItemsId") as? OrderItems
            push!.dictGetAllDataOnlyForItems = self.dictGetAllordersDetails
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            if person["role"] as! String == "Supplier" {
                
                if indexPath.row == 0 {
                    
                    return 310
                }
                else if indexPath.row == 1 {
                    
                    return UITableView.automaticDimension
                }
                else if indexPath.row == 2 {
                    
                    return UITableView.automaticDimension
                }
                else if indexPath.row == 3 {
                    
                    return UITableView.automaticDimension
                } else if indexPath.row == 4 {
                    return UITableView.automaticDimension
                    
                }
                else {
                    
                    return 80
                }
                
            } else {
                
                if indexPath.row == 0 {
                    
                    return 310
                }
                else if indexPath.row == 1 {
                    
                    return UITableView.automaticDimension
                }
                else if indexPath.row == 2 {
                    
                    return UITableView.automaticDimension
                }
                else if indexPath.row == 3 {
                    
                    return UITableView.automaticDimension
                } else if indexPath.row == 4 {
                    return UITableView.automaticDimension
                    
                }
                else {
                    return 0
                    
                }
                
            }
            
            
        } else {
            return 0
        }
        
    }
    
}
