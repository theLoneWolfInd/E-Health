//
//  orderHistoryVC.swift
//  E health App
//
//  Created by Ranjan on 21/08/21.
//

import UIKit
import Alamofire
import SDWebImage

class orderHistoryVC: UIViewController,UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {
    
    var arrListOfAllHistory : NSMutableArray! = []
    
    @IBOutlet weak var viewNavigationBar:UIView!
    @IBOutlet weak var btnDashboardMenu:UIButton!
    @IBOutlet weak var lblNavigationBar:UILabel!{
        didSet {
            
            lblNavigationBar.text = "ORDER HISTORY"
        }
    }
    
    @IBOutlet weak var tablView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var filtered:[String] = []
    
    var searchActive : Bool =  false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tablView.delegate = self
        tablView.dataSource = self
        // searchBar.delegate = self
        self.view.backgroundColor = .white
        tablView.backgroundColor =  .white
        self.navigationController?.isNavigationBarHidden = true
        
        self.tablView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        
        //self.tablView.separatorStyle = UITableViewCell.SeparatorStyle.none
         
        
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
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.orderHistoryWB()
    }
    @objc func sideBarMenuClick() {
        
        let defaults = UserDefaults.standard
        defaults.setValue("", forKey: "keyBackOrSlide")
        defaults.setValue(nil, forKey: "keyBackOrSlide")
        
        if revealViewController() != nil {
            btnDashboardMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchActive {
            
            return filtered.count
        }
        
        else {
            
            return  arrListOfAllHistory.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:orderHistoryTableViewCell  =  tablView.dequeueReusableCell(withIdentifier: "cell") as! orderHistoryTableViewCell
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        let item = self.arrListOfAllHistory[indexPath.row] as? [String:Any]
        
        /*
         date = "2021-09-16T18:06:22+0530";
         "delivery_address" = India;
         hospitalId = 67;
         image = "https://demo4.evirtualservices.net/ehealth/img/uploads/product/";
         orderId = 15;
         "sender_address" = "138, Block L 2, Devli, Sangam Vihar, New Delhi, Delhi 110062, India";
         supplierId = 85;
         "supplier_name" = supplier;
         total = 500;
         userId = "";
         */
        
        
        
        if searchActive {
            
            
            cell.lblCustomerName.text =  filtered[indexPath.row]
        }
        
        else {
            
            cell.imgCustomer.image = UIImage(named: "daze")
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                
                if (person["role"] as! String) == "Hospital" {
                    
                    cell.lblCustomerName.text = (item!["supplier_name"] as! String)
                    
                    
                    cell.imgCustomer.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                    cell.imgCustomer.sd_setImage(with: URL(string: (item!["supplier_image"] as! String)), placeholderImage: UIImage(named: "1024"))
                    
                } else {
                    
                    cell.lblCustomerName.text = (item!["hospital_name"] as! String)
                    
                    cell.imgCustomer.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                    cell.imgCustomer.sd_setImage(with: URL(string: (item!["hospital_image"] as! String)), placeholderImage: UIImage(named: "1024"))
                    
                }
                
            }
            
            
            
            cell.lblDate.text = "Date: "+(item!["date"] as! String)
            cell.lblOptional.text = (item!["delivery_address"] as! String)
            
            
            
            
            
            // delivery status
            if item!["delivery_status"] is String {
                
                if (item!["delivery_status"] as! String) == "0" {
                    cell.imgMarkAsDelivered.isHidden = true
                } else {
                    cell.imgMarkAsDelivered.isHidden = false
                }
                
            } else if item!["delivery_status"] is Int {
                
                let x : Int = (item!["delivery_status"] as! Int)
                let myString = String(x)
                
                if myString == "0" {
                    cell.imgMarkAsDelivered.isHidden = true
                } else {
                    cell.imgMarkAsDelivered.isHidden = false
                }
                
            }
            
            
            
            
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = self.arrListOfAllHistory[indexPath.row] as? [String:Any]
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            if person["role"] as! String == "Supplier" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SupplierOrderHistoryDetailsId") as? SupplierOrderHistoryDetails
                push!.dictGetAllSupplierDetails = item as NSDictionary?
                self.navigationController?.pushViewController(push!, animated: true)
                
            } else {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SupplierOrderHistoryDetailsId") as? SupplierOrderHistoryDetails
                push!.dictGetAllSupplierDetails = item as NSDictionary?
                self.navigationController?.pushViewController(push!, animated: true)
                
                /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPOrderDetailsVC") as? PPOrderDetailsVC
                push!.dictGetAllordersDetails = item as NSDictionary?
                self.navigationController?.pushViewController(push!, animated: true)*/
                
            }
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90
    }
    
    
    //Searchbar Delegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        /*filtered = arrListOfAllHistory.filter({ (text) -> Bool in
         let tmp: NSString = text as NSString
         let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
         return range.location != NSNotFound
         })
         
         if(filtered.count == 0){
         searchActive = false;
         } else {
         searchActive = true;
         }
         self.tablView.reloadData()*/
    }
    
    
    
    
    
    @objc func orderHistoryWB() {
        
        self.arrListOfAllHistory.removeAllObjects()
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            let params =  OrderHistory(action: "orderhistory",
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
                        
                        // arrListOfAllMedicines
                        
                        var ar : NSArray!
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
                        }
                        
                        
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
    
    
    
    
}
