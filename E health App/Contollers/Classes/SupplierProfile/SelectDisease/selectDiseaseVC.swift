//
//  selectDiseaseVC.swift
//  E health App
//
//  Created by Ranjan on 18/08/21.
//

import UIKit
import Alamofire
import Firebase

class selectDiseaseVC: UIViewController , UITableViewDelegate , UITableViewDataSource , UISearchBarDelegate {
    
    var arr1 = ["Abscess","Appendicitis","Allergy","Aseptic meningitis","Beriberi","Breast cancer","Bubonic plague","Cancer","Cholera","COVID-19","Dengue Fever","Dehydration","Diabetes mellitus","Ear infection","Ebola","HIV","Hepatitis B"]
    
    var arrListOfAllDisease : NSMutableArray! = []
    
    @IBOutlet weak var viewNavigationBar:UIView!
    @IBOutlet weak var btnDashboardMenu:UIButton!
    @IBOutlet weak var lblNavigationBar:UILabel!{
        didSet {
            
            lblNavigationBar.text = "SELECT DISEASE"
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var filtered:[String] = []
    
    var searchActive : Bool =  false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        searchBar.delegate =  self
        self.view.backgroundColor = .white
        tableView.backgroundColor =  .white
        self.navigationController?.isNavigationBarHidden = true
        
        self.tableView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        
        // Do any additional setup after loading the view.
        self.sideBarMenuClick()
        
        self.listOfAllDiseaseWB()
        
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
        } else {
            
            return  self.arrListOfAllDisease.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:selectDiseaseTableViewCell  =  tableView.dequeueReusableCell(withIdentifier: "cell") as! selectDiseaseTableViewCell
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        let item = self.arrListOfAllDisease[indexPath.row] as? [String:Any]
        // print(item as Any)
        /*
         ["name": Acute Flaccid Myelitis (AFM), "DiseaseId": 2]
         */
        
        if searchActive {
            
            cell.lblDiseaseName.text =  filtered[indexPath.row]
        } else {
            
            cell.lblDiseaseName.text =  (item!["name"] as! String)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = self.arrListOfAllDisease[indexPath.row] as? [String:Any]
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "manageInventoryVC") as? manageInventoryVC
        push!.strWhereAreYouFrom = "supplierProfile"
        push!.dictGetClickedDiseaseData = item as NSDictionary?
        self.navigationController?.pushViewController(push!, animated: true)
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 77
    }
    
    //Searchbar Delegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = arr1.filter({ (text) -> Bool in
            
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
            
        })
        
        if(filtered.count == 0) {
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    // MARK: - LIST OF ALL DISEASE -
    @objc func listOfAllDiseaseWB() {
        // self.arrListOfAllDoctors.removeAllObjects()
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        
        
        let params = List_Of_All_Disease(action: "diseases",
                                         keyword: "")
        
        
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
                    
                    // var strSuccess2 : String!
                    // strSuccess2 = JSON["msg"]as Any as? String
                    
                    // self.cartList(strCartSuccessMessage: strSuccess2)
                    var ar : NSArray!
                    ar = (JSON["data"] as! Array<Any>) as NSArray
                    self.arrListOfAllDisease.addObjects(from: ar as! [Any])
                    
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
                    
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
