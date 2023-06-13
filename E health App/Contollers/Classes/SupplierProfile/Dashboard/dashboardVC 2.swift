//
//  dashboardVC.swift
//  E health App
//
//  Created by Ranjan on 18/08/21.
//

import UIKit
import SDWebImage

import Alamofire

class dashboardVC: UIViewController {
   
    var dictSupplierLoginData:NSDictionary!
    
    @IBOutlet weak var viewNavigationBar:UIView!
    @IBOutlet weak var btnDashboardMenu:UIButton!
    @IBOutlet weak var lblNavigationBar:UILabel! {
        didSet {
            lblNavigationBar.text = "DASHBOARD"
        }
    }

    @IBOutlet weak var tablView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        tablView.backgroundColor =  .white
        self.navigationController?.isNavigationBarHidden = true
        tablView.delegate = self
        tablView.dataSource = self
        self.btnDashboardMenuPress()
        self.tablView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
       
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
        
        // self.getInviteFriendAPI()
        
        
    }
    
    @objc func yesLogout() {
        
        UserDefaults.standard.set("", forKey: "keyLoginFullData")
        UserDefaults.standard.set(nil, forKey: "keyLoginFullData")
        
        UserDefaults.standard.set("", forKey: "keySetToBackOrMenu")
        UserDefaults.standard.set(nil, forKey: "keySetToBackOrMenu")
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "registerVC") as? registerVC
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func btnDashboardMenuPress(){
    
        if revealViewController() != nil {
            
            btnDashboardMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        }
        
    }
    
    
    func getInviteFriendAPI() {
        
        let urlString:String = ("https://api.dictionaryapi.dev/api/v2/entries/en/word").addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
        
        let url : URL = URL(string: urlString)!
        let request: URLRequest = URLRequest(url:url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if(error != nil) {
                print(error?.localizedDescription ?? "")
            }
            else {
                do {
                    
                    let jsonData:NSArray = (try! JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSArray)!
                    
                    print(jsonData as Any)
                    
                    let JSON = jsonData
                    let firstResult = JSON[0] as! [String:Any] // do not change
                    print(firstResult)
                    
                    var ar:NSArray!
                    ar = (firstResult["meanings"] as! Array<Any>) as NSArray
                    print(ar as Any)
                    print(type(of: firstResult))
                    
                    let item = ar[0] as! [String:Any] // change this zero
                    print(item["partOfSpeech"] as! String)
                    
                    // get definitions
                    
                    
                    
                    
                }
                /*catch{
                    print(error.localizedDescription)
                }*/
            }
        };
        task.resume()
        
    }
       
}

extension dashboardVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell:dashboardTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell1") as! dashboardTableViewCell
            
            cell.backgroundColor = .white
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            // print(self.dictSupplierLoginData as Any)
            cell.btnAddress.setTitle(" "+(self.dictSupplierLoginData["address"] as! String), for: .normal)
            cell.btnAddress.titleLabel?.lineBreakMode = .byWordWrapping
            cell.btnAddress.setTitleColor(.black, for: .normal)
            
            cell.btnEdit.addTarget(self, action: #selector(editClickMethod), for: .touchUpInside)
            cell.btnHistory.addTarget(self, action: #selector(historyClickMethod), for: .touchUpInside)
            
            cell.lblSupplierName.text = (self.dictSupplierLoginData["fullName"] as! String)
            
            cell.lblPhone.text = (self.dictSupplierLoginData["contactNumber"] as! String)
            cell.lblEmail.text = (self.dictSupplierLoginData["email"] as! String)
            cell.imgBanner.image = UIImage(named: "1024")
            cell.imgProfile.image = UIImage(named: "daze")
            
            cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.imgProfile.sd_setImage(with: URL(string: (self.dictSupplierLoginData["image"] as! String)), placeholderImage: UIImage(named: "1024"))
            
            return cell
        }
         
        else if indexPath.row == 1 {
            
            let cell:dashboardTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell2") as! dashboardTableViewCell
            
            cell.backgroundColor = .white
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.lblSpecialist.text = (self.dictSupplierLoginData["description"] as! String)
            
            return cell
        }
        
        else if indexPath.row == 2 {
            
            let cell:dashboardTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell3") as! dashboardTableViewCell
            
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
            
            let cell:dashboardTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell4") as! dashboardTableViewCell
            cell.backgroundColor = .white
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.btnManageInventory.addTarget(self, action: #selector(manageInventoryClickMethod), for: .touchUpInside)
            cell.btnOrderHistory.addTarget(self, action: #selector(historyClickMethod), for: .touchUpInside)
            
            return cell
        }
        
    }
    
    @objc func editClickMethod() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CEditProfileId") as? CEditProfile
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func historyClickMethod() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "orderHistoryVC") as? orderHistoryVC
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func manageInventoryClickMethod() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "selectDiseaseVC") as? selectDiseaseVC
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            
            return 310
        }
        else if indexPath.row == 1 {
            
            return UITableView.automaticDimension
        }
        else if indexPath.row == 2 {
            
            return UITableView.automaticDimension
        }
        else {
            
            return 150
        }
    }
    
}
