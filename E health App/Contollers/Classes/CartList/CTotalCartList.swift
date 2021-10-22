//
//  CTotalCartList.swift
//  Alien Broccoli
//
//  Created by Apple on 05/10/20.
//

import UIKit

import Alamofire
import SDWebImage

class CTotalCartList: UIViewController {
    
    var strFromSidebarMenu:String!
     
    let cellReuseIdentifier = "cTotalCartListTableCell"
    
    var arrAddAllValues:NSMutableArray! = []
    
    // save add to cart food
    var addInitialMutable:NSMutableArray = []
    
    // MARK:- ARRAY -
    var arrListOfAllMyOrders:NSMutableArray! = []
    var page : Int! = 1
    var loadMore : Int! = 1
    
    let sumPriceInCart:String! = "0"
    
    // multiple supplier id
    var arrAppendSuppliersId:NSMutableArray! = []
    var strSaveMultipleSupllierId:String! = "0"
    
    // multiple medicine id
    var arrAppendMedicineId:NSMutableArray! = []
    var strSaveMultipleMedicineId:String! = "0"
    
    // multiple quantity
    var arrAppendQuantityId:NSMutableArray! = []
    var strSaveMultipleQuantityId:String! = "0"
    
    // total price is
    var strSaveTotalAmount:String! = "0"
    
    @IBOutlet weak var lblShippingPriceIs:UILabel!
    @IBOutlet weak var lblSubTotal:UILabel!
    
    @IBOutlet weak var lblFinalTotalPrice:UILabel!
    
    // MARK:- CUSTOM NAVIGATION BAR -
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            // navigationBar.backgroundColor = NAVIGATION_COLOR
        }
    }

    // MARK:- CUSTOM NAVIGATION TITLE -
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "MY CART"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.tintColor = .white
            // btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
    }
    
    
    @IBOutlet weak var btnCheckOut:UIButton! {
        didSet {
            btnCheckOut.backgroundColor = .systemGreen
            btnCheckOut.setTitleColor(.white, for: .normal)
        }
    }
    
    // MARK:- TABLE VIEW -
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            // self.tbleView.delegate = self
            // self.tbleView.dataSource = self
            self.tbleView.backgroundColor = .white
            self.tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.tbleView.separatorColor = .clear
        
        self.btnCheckOut.addTarget(self, action: #selector(checkOutClickMethid), for: .touchUpInside)
        
        
        
        if let myLoadedString = UserDefaults.standard.string(forKey: "keySetToBackOrMenu") {
            print(myLoadedString)
            
            if myLoadedString == "backOrMenu" {
                // menu
                self.btnBack.setImage(UIImage(systemName: "list.dash"), for: .normal)
                self.sideBarMenuClick()
            } else {
                // back
                self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
            }
        } else {
            // back
            self.btnBack.setImage(UIImage(systemName: "arrow.left"), for: .normal)
            self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
        
        
        
        
        self.gradientNavigation()
        
        self.totalItemsInCart(strLoaderStatus: "yes")
    }
    
    @objc func sideBarMenuClick() {
        
        UserDefaults.standard.set("", forKey: "keySetToBackOrMenu")
        UserDefaults.standard.set(nil, forKey: "keySetToBackOrMenu")
        
        self.view.endEditing(true)
        
        if revealViewController() != nil {
            
            btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:- GRADIENT ANIMATOR -
    @objc func gradientNavigation() {
        
    }

    
    // MARK:- WEBSERVICE ( TOTAL ITEMS IN CART ) -
    @objc func totalItemsInCart(strLoaderStatus:String) {
        self.arrListOfAllMyOrders.removeAllObjects()
        self.arrAddAllValues.removeAllObjects()
        
        if strLoaderStatus == "yes"{
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        }
        
        
        self.view.endEditing(true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            let params = CartList(action: "cartlist",
                                  userId: String(myString))
            
            AF.request(APPLICATION_BASE_URL,
                       method: .post,
                       parameters: params,
                       encoder: JSONParameterEncoder.default).responseJSON { response in
                        // debugPrint(response.result)
                        
                        switch response.result {
                        case let .success(value):
                            
                            let JSON = value as! NSDictionary
                             // print(JSON as Any)
                            
                            var strSuccess : String!
                            strSuccess = JSON["status"]as Any as? String
                            
                            // var strSuccess2 : String!
                            // strSuccess2 = JSON["msg"]as Any as? String
                            
                            if strSuccess == String("success") {
                                print("yes")
                                
                                ERProgressHud.sharedInstance.hide()
                                
                                
                                var ar : NSArray!
                                ar = (JSON["data"] as! Array<Any>) as NSArray
                                self.arrListOfAllMyOrders.addObjects(from: ar as! [Any])
                                
                                
                                var doubleQuantity :Double!
                                var doublePrice :Double!
                                
                                for addPriceWithQuantity in 0..<self.arrListOfAllMyOrders.count {
                                    
                                    let item = self.arrListOfAllMyOrders[addPriceWithQuantity] as? [String:Any]
                                    
                                    let x : Int = (item!["quantity"] as! Int)
                                    let myString = String(x)
                                    
                                    if myString == "" {
                                        doubleQuantity = Double(0)
                                    } else {
                                        doubleQuantity = Double(myString)
                                    }
                                    
                                    if (item!["price"] as! String) == "" {
                                        doublePrice = Double(0)
                                    } else {
                                        doublePrice = Double(item!["price"] as! String)
                                    }
                                    
                                    let c = +(doubleQuantity*doublePrice)
                                    self.arrAddAllValues.add(c)
                                    
                                    // join supplier id
                                    let xSP : Int = item!["supplierId"] as! Int
                                    let myStringxSP = String(xSP)
                                    self.arrAppendSuppliersId.add(myStringxSP)
                                    
                                    // join medicine id
                                    let xMD : Int = item!["medicineId"] as! Int
                                    let myStringxxMD = String(xMD)
                                    self.arrAppendMedicineId.add(myStringxxMD)
                                    
                                    // join quantity
                                    let xQU : Int = item!["quantity"] as! Int
                                    let myStringxQU = String(xQU)
                                    self.arrAppendQuantityId.add(myStringxQU)
                                    
                                }
                                
                                /*var arrAppendQuantityId:NSMutableArray! = []
                                 var strSaveMultipleQuantityId:String! = "0"*/
                                
                                let array: [String] = self.arrAppendSuppliersId.copy() as! [String]
                                let list = array.joined(separator: ",")
                                 self.strSaveMultipleSupllierId = list
                                
                                
                                // joind medicine ids
                                let array2: [String] = self.arrAppendMedicineId.copy() as! [String]
                                let list2 = array2.joined(separator: ",")
                                 self.strSaveMultipleMedicineId = list2
                                
                                // joind quantitys
                                let array3: [String] = self.arrAppendQuantityId.copy() as! [String]
                                let list3 = array3.joined(separator: ",")
                                 self.strSaveMultipleQuantityId = list3
                                
                                
                                let objCMutableArray = NSMutableArray(array: self.arrAddAllValues)
                                let swiftArray = objCMutableArray as NSArray as! [Float]
                                
                                let numbers = swiftArray // [1, 12, 2, 9, 27]
                                let total = numbers.reduce(0, +)
                                
                                // sub total
                                let x121 : Float = (total)
                                let myString121 = String(x121)
                                // print(myString121 as Any)
                                // self.lblSubTotal.text = "$ "+String(myString121)
                                
                                self.btnCheckOut.setTitle("Checkout ($"+String(myString121)+")", for: .normal)
                                
                                // save total price
                                self.strSaveTotalAmount = String(myString121)
                                
                                
                                
                                
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
    
    
    @objc func checkOutClickMethid() {
        self.addInitialMutable.removeAllObjects()
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "InformationVC") as? InformationVC
        
        push!.strGetSupplierId  = String(self.strSaveMultipleSupllierId)
        push!.strGetQuantity    = String(self.strSaveMultipleQuantityId)
        push!.strGetMedicineId  = String(self.strSaveMultipleMedicineId)
        push!.strGetTotal       = String(self.strSaveTotalAmount)
        
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func addOneItemToCart(_ sender:UIButton) {
        // self.arrListOfAllDoctors.removeAllObjects()
        
        let item = self.arrListOfAllMyOrders[sender.tag] as? [String:Any]
        print(item as Any)
        
        /*
         Optional(["quantity": 14, "userId": 67, "supplierId": 0, "price": 500, "image": , "name": , "medicineId": 141028])
         */
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let x2 : Int = item!["medicineId"] as! Int
            let myString2 = String(x2)
            
            let x3 : Int = item!["supplierId"] as! Int
            let myString3 = String(x3)
            
            /*let addOneQuantityWithQuantity = item!["quantity"] as! Int+1
             let x3 : Int = addOneQuantityWithQuantity
             let myString3 = String(x3)*/
            
            let params = AddToCart(action: "addtocart",
                                   userId: String(myString),
                                   medicine_id: String(myString2),
                                   quantity: String("1"),
                                   price: (item!["price"] as! String),
                                   supplierId: String(myString3),
                                   updateCart: String("1"))
            
            
            print(params as Any)
            
            AF.request(APPLICATION_BASE_URL,
                       method: .post,
                       parameters: params,
                       encoder: JSONParameterEncoder.default).responseJSON { response in
                // debugPrint(response.result)
                
                switch response.result {
                case let .success(value):
                    
                    let JSON = value as! NSDictionary
                    // print(JSON as Any)
                    
                    var strSuccess : String!
                    strSuccess = (JSON["status"]as Any as? String)?.lowercased()
                    print(strSuccess as Any)
                    
                    if strSuccess == String("success") {
                        print("yes")
                        
                        // ERProgressHud.sharedInstance.hide()
                        
                        self.totalItemsInCart(strLoaderStatus: "no")
                        
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
    
    @objc func deleteOneItemToCart(_ sender:UIButton) {
        // self.arrListOfAllDoctors.removeAllObjects()
        
        let item = self.arrListOfAllMyOrders[sender.tag] as? [String:Any]
        print(item as Any)
        
        let x2 : Int = (item!["quantity"] as! Int)
        let myString2 = String(x2)
        
        self.view.endEditing(true)
        
        if myString2 == "1" {
            
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "removing...")
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                
                let x : Int = person["userId"] as! Int
                let myString = String(x)
                
                let x2 : Int = item!["medicineId"] as! Int
                let myString2 = String(x2)
                
                let params = DeleteCart(action: "deletecarts",
                                        userId: String(myString),
                                        medicineId: String(myString2))
                
                print(params as Any)
                
                AF.request(APPLICATION_BASE_URL,
                           method: .post,
                           parameters: params,
                           encoder: JSONParameterEncoder.default).responseJSON { response in
                    // debugPrint(response.result)
                    
                    switch response.result {
                    case let .success(value):
                        
                        let JSON = value as! NSDictionary
                        // print(JSON as Any)
                        
                        var strSuccess : String!
                        strSuccess = (JSON["status"]as Any as? String)?.lowercased()
                        print(strSuccess as Any)
                        
                        if strSuccess == String("success") {
                            print("yes")
                            
                            // ERProgressHud.sharedInstance.hide()
                            
                            self.totalItemsInCart(strLoaderStatus: "no")
                            
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
            
            
        } else {
            
            self.view.endEditing(true)
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                
                let x : Int = person["userId"] as! Int
                let myString = String(x)
                
                let x2 : Int = item!["medicineId"] as! Int
                let myString2 = String(x2)
                
                let x3 : Int = item!["supplierId"] as! Int
                let myString3 = String(x3)
                
                
                /*let addOneQuantityWithQuantity = item!["quantity"] as! Int+1
                let x3 : Int = addOneQuantityWithQuantity
                let myString3 = String(x3)*/
                
                /*let params = DeleteCart(action: "deletecarts",
                                       userId: String(myString),
                                       medicineId: String(myString2))*/
                
                let params = AddToCart(action: "addtocart",
                                       userId: String(myString),
                                       medicine_id: String(myString2),
                                       quantity: String("-1"),
                                       price: (item!["price"] as! String),
                                       supplierId: String(myString3),
                                       updateCart: String("1"))
                
                
                print(params as Any)
                
                AF.request(APPLICATION_BASE_URL,
                           method: .post,
                           parameters: params,
                           encoder: JSONParameterEncoder.default).responseJSON { response in
                            // debugPrint(response.result)
                            
                            switch response.result {
                            case let .success(value):
                                
                                let JSON = value as! NSDictionary
                                // print(JSON as Any)
                                
                                var strSuccess : String!
                                strSuccess = (JSON["status"]as Any as? String)?.lowercased()
                                print(strSuccess as Any)
                                if strSuccess == String("success") {
                                    print("yes")
                                    
                                     // ERProgressHud.sharedInstance.hide()
                                    
                                    self.totalItemsInCart(strLoaderStatus: "no")
                                    
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
        
        
        
        /*
         Optional(["quantity": 14, "userId": 67, "supplierId": 0, "price": 500, "image": , "name": , "medicineId": 141028])
         */
        
        
    }
    
    
    @objc func deleteCartFromItems(_ sender:UIButton) {
        
        let item = self.arrListOfAllMyOrders[sender.tag] as? [String:Any]
        // print(item as Any)
        
        let alert = UIAlertController(title: String("Remove Item"), message: String("Are you sure you want to remove.")+"' "+(item!["name"] as! String)+" '"+" from your cart ?",
                                      
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes, Delete", style: .default, handler: { action in
             
            // let x : Int = (item!["productId"] as! Int)
            // let myString = String(x)
            
            self.deleteItemFromCart(getDict: item! as NSDictionary)
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { action in
             
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK:- DELETE ITEM FROM CART -
    @objc func deleteItemFromCart(getDict:NSDictionary) {
        // self.arrListOfAllDoctors.removeAllObjects()
        
        let item = getDict
        print(item as Any)
        
        /*
         Optional(["quantity": 14, "userId": 67, "supplierId": 0, "price": 500, "image": , "name": , "medicineId": 141028])
         */
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "removing...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let x2 : Int = item["medicineId"] as! Int
            let myString2 = String(x2)
            
            
            
            /*let addOneQuantityWithQuantity = item!["quantity"] as! Int+1
            let x3 : Int = addOneQuantityWithQuantity
            let myString3 = String(x3)*/
            
            let params = DeleteCart(action: "deletecarts",
                                   userId: String(myString),
                                   medicineId: String(myString2))
            
            
            
            
            print(params as Any)
            
            AF.request(APPLICATION_BASE_URL,
                       method: .post,
                       parameters: params,
                       encoder: JSONParameterEncoder.default).responseJSON { response in
                        // debugPrint(response.result)
                        
                        switch response.result {
                        case let .success(value):
                            
                            let JSON = value as! NSDictionary
                            // print(JSON as Any)
                            
                            var strSuccess : String!
                            strSuccess = (JSON["status"]as Any as? String)?.lowercased()
                            print(strSuccess as Any)
                            if strSuccess == String("success") {
                                print("yes")
                                
                                 // ERProgressHud.sharedInstance.hide()
                                
                                self.totalItemsInCart(strLoaderStatus: "no")
                                
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


extension CTotalCartList: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrListOfAllMyOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CTotalCartListTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! CTotalCartListTableCell
        
        let item = self.arrListOfAllMyOrders[indexPath.row] as? [String:Any]
        print(item as Any)
        /*
         image = "";
         medicineId = 141033;
         name = "";
         price = 500;
         quantity = 17;
         supplierId = 0;
         userId = 67;
         */
        cell.lblProductDetails.text = (item!["name"] as! String)
        
        cell.imgProductImage.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.imgProductImage.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "logo"))
        
        
        
        cell.btnCounterTitle.tag = indexPath.row
        
        cell.lblProductRealPrice.text = "$"+(item!["price"] as! String)
        
        let x2 : Int = (item!["quantity"] as! Int)
        let myString2 = String(x2)
        cell.btnCounterTitle.setTitle(String(myString2), for: .normal)
        
        cell.btnDeleteItem.tag = indexPath.row
        cell.btnDeleteItem.addTarget(self, action: #selector(deleteCartFromItems), for: .touchUpInside)
        
        cell.lblProductDetails.textColor = .black
        
        
        if myString2 < (item!["total_quantity"] as! String) {
            
            cell.btnCounterIncrease.isHidden = false
            
        } else if myString2 == (item!["total_quantity"] as! String) {
            
            cell.btnCounterIncrease.isHidden = true
            
        }
        
        
        
        
        cell.btnCounterIncrease.tag = indexPath.row
        cell.btnCounterDecrease.tag = indexPath.row
        
        cell.btnCounterIncrease.addTarget(self, action: #selector(addOneItemToCart), for: .touchUpInside)
        cell.btnCounterDecrease.addTarget(self, action: #selector(deleteOneItemToCart), for: .touchUpInside)
        
        cell.btnBuyNow.tag = indexPath.row
        cell.btnBuyNow.addTarget(self, action: #selector(butNowClick), for: .touchUpInside)
        
        cell.backgroundColor = .white
        
        return cell
        
    }

    @objc func butNowClick(_ sender:UIButton) {
        let item = self.arrListOfAllMyOrders[sender.tag] as? [String:Any]
        print(item as Any)
        
        /*
         Optional(["price": 10, "medicineId": 141028, "total_quantity": 4, "supplierId": 99, "image": https://dailymed.nlm.nih.gov/dailymed/image.cfm?setid=da9b26bb-d2d7-4113-a0f9-c6c2280f4875&name=trovan-image01.jpg, "userId": 153, "name": (AENC) DISINFECTANT WATER-FREE HAND FOAM (POLIHEXANIDE) SOLUTION YANTAI DONGKE LVZHIYUAN DISINFECTION PHARMACEUTICAL CO., LTD., "quantity": 8])
         */
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "BuyNow") as? BuyNow
        
        let x2 : Int = (item!["quantity"] as! Int)
        let myString2 = String(x2)
        
        push!.strProductImage       = (item!["image"] as! String)
        push!.strProductName        = (item!["name"] as! String)
        push!.strProductQuantity    = String(myString2)
        push!.strProductPrice       = (item!["price"] as! String)
        
        push!.getDictForBuyNowPayment = item as NSDictionary?
        self.navigationController?.pushViewController(push!, animated: true)
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        let item = self.arrListOfAllMyOrders[indexPath.row] as? [String:Any]
        
        if (item!["name"] as! String).count > 100 {
            return UITableView.automaticDimension
        } else {
            return 160
        }
        
    }
    
}

extension CTotalCartList: UITableViewDelegate {
    
}
