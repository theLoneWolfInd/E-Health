//
//  inventory detailsVC.swift
//  E health App
//
//  Created by Ranjan on 20/08/21.
//

import UIKit
import SDWebImage
import Alamofire
import SwiftGifOrigin

import NewYorkAlert

class inventoryDetailsVC: UIViewController,UITableViewDelegate, UITableViewDataSource , UITextFieldDelegate {
   
    var whichProfileYouAreFrom:String!
    
    var getDictInventoryDetails:NSDictionary!
    
    var productQuantity:String! = "0"
    var productQuantityWithTextSaved:String! = "0"
    var totalQuantityMutArrau:NSMutableArray! = []
    
    // MARK:- SELECT GENDER -
    let regularFont = UIFont.systemFont(ofSize: 16)
    let boldFont = UIFont.boldSystemFont(ofSize: 16)
    
    var saveProductImage:String!
    var saveProductName:String!
    var saveProductPrice:String!
    
    var strUpdatedQuantityIs:String! = "0"
    
    @IBOutlet weak var viewNavigationBar:UIView!
    @IBOutlet weak var btnNavigationBack:UIButton!
    @IBOutlet weak var lblNavigationBar:UILabel!{
        didSet {
            
            lblNavigationBar.text = "MEDICINE DETAILS"
        }
    }
    
    @IBOutlet weak var tablView: UITableView! {
        didSet {
            tablView.delegate = self
            tablView.dataSource = self
            tablView.backgroundColor = .white
            tablView.separatorColor = .clear
        }
    }

    @IBOutlet weak var btnCart:UIButton! {
        didSet {
            btnCart.tintColor = .white
            btnCart.isHidden = true
            btnCart.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var lblCartCounter:UILabel! {
        didSet {
            lblCartCounter.textColor = .white
            lblCartCounter.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.hideKeyboardWhenTappedAround()
        
        self.tablView.separatorColor = .clear
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.navigationController?.isNavigationBarHidden = true
        
        btnNavigationBack.addTarget(self, action: #selector(btnNavigationBackPress), for: .touchUpInside)
        
        
        
        if self.whichProfileYouAreFrom == "supplierProfile" {
            
            self.btnCart.isHidden = true
            
        } else {
            
            self.btnCart.isHidden = false
            self.btnCart.addTarget(self, action: #selector(pushToCartList), for: .touchUpInside)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if self.whichProfileYouAreFrom == "supplierProfile" {
            
        } else {
            self.initialCartList()
        }
        
    }
    
    @objc func pushToCartList() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "CTotalCartListId") as? CTotalCartList
        push!.strFromSidebarMenu = "no"
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    @objc func btnNavigationBackPress() {
        
        navigationController?.popViewController(animated: true)
    }
   
    @objc func initialCartList() {
        // self.arrListOfAllDoctors.removeAllObjects()
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = CartList(action: "cartlist",
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
                                
                                let x : Int = JSON["TotalCartItem"] as! Int
                                let myString = String(x)
                                
                                if myString == "0" || myString == "" {
                                    
                                    self.btnCart.isHidden = true
                                    self.lblCartCounter.isHidden = true
                                    
                                } else {
                                    
                                    self.btnCart.isHidden = false
                                    self.lblCartCounter.isHidden = false
                                }
                                
                                self.lblCartCounter.text = String(myString)
                                
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // let indexPath = IndexPath.init(row: 3, section: 0)
        // let cell = self.tbleView.cellForRow(at: indexPath) as! AddMoreMedicinesTableCell
        
        return (string.containsValidCharacter)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /*
         // print(self.getDictInventoryDetails as Any)
         
         image = "";
         medicineId = 141034;
         name = "test 2";
         price = 500;
         quantity = 20;
         subdetails = "";
         supplierId = 85;
         weight = "";
          
         */
        
        
        if indexPath.row == 0 {
            
            let cell:inventoryDetailsTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell1") as! inventoryDetailsTableViewCell
            cell.backgroundColor = .white
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            
            cell.imgMedicine.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.imgMedicine.sd_setImage(with: URL(string: (self.getDictInventoryDetails["image"] as! String)), placeholderImage: UIImage(named: "1024"))
            
            self.saveProductImage = (self.getDictInventoryDetails["image"] as! String)
            
            if (self.getDictInventoryDetails["quantity"] as! String) == "0" ||
                (self.getDictInventoryDetails["quantity"] as! String) == "" {
                
                cell.imgOutOfStocks.isHidden = false
                
            } else {
                
                cell.imgOutOfStocks.isHidden = true
                
            }
            
            return cell
            
        } else if indexPath.row == 1 {
            
            let cell:inventoryDetailsTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell2") as! inventoryDetailsTableViewCell
            
            cell.backgroundColor = .white
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.lblMedName.text = (self.getDictInventoryDetails["name"] as! String)
            
            self.saveProductName = (self.getDictInventoryDetails["name"] as! String)
            
            return cell
            
        } else if indexPath.row == 2 {
            
            let cell:inventoryDetailsTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell3") as! inventoryDetailsTableViewCell
            
            cell.backgroundColor = .white
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            if (self.getDictInventoryDetails["subdetails"] as! String) == "" {
                cell.lblMedComposition.text = "N.A."
            } else {
                cell.lblMedComposition.text = (self.getDictInventoryDetails["subdetails"] as! String)
            }
            
            
            
            
            return cell
            
        } else if indexPath.row == 3 {
            
            let cell:inventoryDetailsTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell4") as! inventoryDetailsTableViewCell
            
            cell.backgroundColor = .white
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            // print(self.self.getDictInventoryDetails as Any)
            if self.getDictInventoryDetails!["quantity"] is String {
                              
                print("Yes, it's a String")
                // IN STOCKS
                if (self.getDictInventoryDetails["quantity"] as! String) == "" {
                    cell.lblMedWeight.text = "Out of Stocks"
                } else {
                    cell.lblMedWeight.text = "Total Quantity Availaible : "+(self.getDictInventoryDetails["quantity"] as! String)
                }
                
            } else if self.getDictInventoryDetails!["quantity"] is Int {
                let x1212 : Int = self.getDictInventoryDetails["quantity"] as! Int
                let myString1212 = String(x1212)
                
                if (self.getDictInventoryDetails["quantity"] as! String) == "" {
                    cell.lblMedWeight.text = "Out of Stocks"
                } else {
                    cell.lblMedWeight.text = "Total Quantity Availaible : "+myString1212
                }
                
            }
            
            return cell
            
        } else if indexPath.row == 4 {
            
            let cell:inventoryDetailsTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell5") as! inventoryDetailsTableViewCell
            
            cell.backgroundColor = .white
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            if (self.getDictInventoryDetails["price"] as! String) == "" {
                cell.lblMedPrice.text = "PRICE :$ N.A."
            } else {
                cell.lblMedPrice.text = "Price: $"+(self.getDictInventoryDetails["price"] as! String)
            }
            
            self.saveProductPrice = (self.getDictInventoryDetails["price"] as! String)
            
            return cell
            
        } else if indexPath.row == 5 {
            
            let cell:inventoryDetailsTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell6") as! inventoryDetailsTableViewCell
            
            cell.backgroundColor = .white
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            print(self.getDictInventoryDetails["quantity"] as! String)
            
            cell.btnAddToCart.layer.cornerRadius = 25
            cell.btnAddToCart.clipsToBounds = true
            
            if self.whichProfileYouAreFrom == "supplierProfile" {
                
                if (self.getDictInventoryDetails["quantity"] as! String) == "0" ||
                    (self.getDictInventoryDetails["quantity"] as! String) == "" {
                    
                    cell.btnUpdate.setTitle("Out of Stocks", for: .normal)
                    
                } else {
                    
                    self.productQuantity = (self.getDictInventoryDetails["quantity"] as! String)
                    cell.btnUpdate.setTitle("Update Quantity ("+self.productQuantity+")", for: .normal)
                    
                    cell.btnAddToCart.setImage(UIImage.gif(name: "plus-button"), for: .normal)
                    cell.btnAddToCart.addTarget(self, action: #selector(addmoreQuantityClickMethod), for: .touchUpInside)
                }
                
            } else {
               
                if (self.getDictInventoryDetails["quantity"] as! String) == "0" ||
                    (self.getDictInventoryDetails["quantity"] as! String) == "" {
                    
                    cell.btnUpdate.setTitle("Out of Stocks", for: .normal)
                    
                } else {
                    
                    self.productQuantity = (self.getDictInventoryDetails["quantity"] as! String)
                    
                    cell.btnUpdate.setTitle("Quantity ("+productQuantityWithTextSaved+")", for: .normal)
                    cell.btnUpdate.addTarget(self, action: #selector(selectQuantity), for: .touchUpInside)
                    
                }
                
                cell.btnAddToCart.addTarget(self, action: #selector(addToCartClickMethod), for: .touchUpInside)
                
            }
                
            return cell
            
        } else if indexPath.row == 6 {
            
            let cell:inventoryDetailsTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell7") as! inventoryDetailsTableViewCell
            
            cell.backgroundColor = .white
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            
            if (self.getDictInventoryDetails["quantity"] as! String) == "0" ||
                (self.getDictInventoryDetails["quantity"] as! String) == "" {
                
                cell.btnBuyNow.setTitle("Out Of Stocks", for: .normal)
                // cell.btnBuyNow.addTarget(self, action: #selector(buyNowClickMethod), for: .touchUpInside)
                
            } else {
                
                cell.btnBuyNow.setTitle("Buy Now", for: .normal)
                cell.btnBuyNow.addTarget(self, action: #selector(buyNowClickMethod), for: .touchUpInside)
                
            }
            
            return cell
            
        } else {
            
            let cell:inventoryDetailsTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell1") as! inventoryDetailsTableViewCell
            
            return cell
            
        }
        
    }
    
    @objc func addmoreQuantityClickMethod() {
        
        let alert = NewYorkAlertController.init(title: "Update Quantity", message: "You can update the quantity of your product.", style: .alert)

        alert.addImage(UIImage(named: "Quantity"))
        
        alert.addTextField { tf in
            tf.placeholder = "update quantity..."
            tf.keyboardType = .default
            tf.delegate = self
            tf.tag = 1
        }

        let ok = NewYorkButton(title: "Update", style: .default) { [unowned alert] _ in
            alert.textFields.forEach { tf in
                let text = tf.text ?? ""
                switch tf.tag {
                case 1:
                    print("quantity: \(text)")
                    
                    self.strUpdatedQuantityIs = "\(text)"
                    self.editMedicineQuantity()
                default:
                    break
                }
            }
        }
        
        let cancel = NewYorkButton(title: "Cancel", style: .cancel)
        alert.addButtons([ok, cancel])

        alert.isTapDismissalEnabled = false

        present(alert, animated: true)
        
    }
    
    @objc func buyNowClickMethod(_ sender:UIButton) {
        
        let playPauseBtn = sender
        playPauseBtn.transform = CGAffineTransform.init(scaleX: 0.6, y: 0.6)

        UIView.animate(withDuration: 0.3, animations: { () -> Void in

            playPauseBtn.transform = CGAffineTransform.init(scaleX: 1, y: 1)

        })
        
        if self.productQuantityWithTextSaved == "0" {
            
            let alert = UIAlertController(title: "Alert", message: "Please select quantity", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Select Quantity", style: .default, handler:  { action in
                
                self.selectQuantity()
                
            }))
            
            self.present(alert, animated: true)
            
        } else {
             
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "BuyNow") as? BuyNow
            
            push!.strProductImage       = String(self.saveProductImage)
            push!.strProductName        = String(self.saveProductName)
            push!.strProductQuantity    = String(self.productQuantityWithTextSaved)
            push!.strProductPrice       = String(self.saveProductPrice)
            
            push!.getDictForBuyNowPayment = self.getDictInventoryDetails
            self.navigationController?.pushViewController(push!, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 230
        } else if indexPath.row == 1 {
            return UITableView.automaticDimension
        } else if indexPath.row == 2 {
            
            if (self.getDictInventoryDetails["subdetails"] as! String) == "" {
                return 0
            } else {
                return UITableView.automaticDimension
            }
            
        } else if indexPath.row == 3 {
            return UITableView.automaticDimension
        } else if indexPath.row == 4 {
            return UITableView.automaticDimension
        } else if indexPath.row == 5 {
            return 90
        } else if indexPath.row == 6 {
            
            if self.whichProfileYouAreFrom == "supplierProfile" {
                return 0
            } else {
                return 90
            }
            
        } else {
            return 100
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
    }
    
    @objc func addToCartClickMethod(_ sender:UIButton) {
        
        let playPauseBtn = sender
        playPauseBtn.transform = CGAffineTransform.init(scaleX: 0.6, y: 0.6)

        UIView.animate(withDuration: 0.3, animations: { () -> Void in

            playPauseBtn.transform = CGAffineTransform.init(scaleX: 1, y: 1)

        })
        
        if self.productQuantityWithTextSaved == "0" {
            
            let alert = UIAlertController(title: "Alert", message: "Please select quantity", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Select Quantity", style: .default, handler: { action in
                
                self.selectQuantity()
                
            }))
            self.present(alert, animated: true)
            
        } else {
            
            self.addToCart()
        }
         
    }
    
    @objc func selectQuantity() {
        
        self.totalQuantityMutArrau.removeAllObjects()
        
        if productQuantity == "0" {
            
            // quantity is zero. so you can not order this item
        } else {
            
            let myString1 = productQuantity
            let myInt1 = Int(myString1!)
            
            for qList in 1..<(myInt1)!+1 {
                
                // convert int quantity to string then save to nutable array
                let x : Int = qList
                let myString = String(x)
                
                totalQuantityMutArrau.add(myString)
            }
            
            let redAppearance = YBTextPickerAppearanceManager.init(
                pickerTitle         : "Select Quantity",
                titleFont           : boldFont,
                titleTextColor      : .white,
                titleBackground     : .systemGreen,
                searchBarFont       : regularFont,
                searchBarPlaceholder: "search quantity",
                closeButtonTitle    : "Cancel",
                closeButtonColor    : .darkGray,
                closeButtonFont     : regularFont,
                doneButtonTitle     : "Okay",
                doneButtonColor     : .brown,
                doneButtonFont      : boldFont,
                checkMarkPosition   : .Right,
                itemCheckedImage    : UIImage(named:"red_ic_checked"),
                itemUncheckedImage  : UIImage(named:"red_ic_unchecked"),
                itemColor           : .black,
                itemFont            : regularFont
            )
            
            // MARK:- CONVERT MUTABLE ARRAY TO ARRAY -
            let array: [String] = totalQuantityMutArrau.copy() as! [String]
            
            let arrGender = array
            let picker = YBTextPicker.init(with: arrGender, appearance: redAppearance,
                                           onCompletion: { (selectedIndexes, selectedValues) in
                                            if let selectedValue = selectedValues.first {
                                                if selectedValue == arrGender.last! {
                                                    
                                                    self.productQuantityWithTextSaved = "\(selectedValue)"
                                                    
                                                    self.tablView.reloadData()
                                                    
                                                } else {
                                                    
                                                    self.productQuantityWithTextSaved = "\(selectedValue)"
                                                    
                                                    self.tablView.reloadData()
                                                }
                                            } else {
                                                // self.btnGenderPicker.setTitle("What's your gender?", for: .normal)
                                                // cell.txtSelectGender.text = "What's your gender?"
                                                
                                                print()
                                                
                                            }
                                           },
                                           onCancel: {
                                            print("Cancelled")
                                           })
            
            picker.show(withAnimation: .FromBottom)
        }
        
    }
    
    
    @objc func addToCart() {
        // self.arrListOfAllDoctors.removeAllObjects()
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            
            
            let x2 : Int = self.getDictInventoryDetails["medicineId"] as! Int
            let myString2 = String(x2)
            
            let x3 : Int = self.getDictInventoryDetails["supplierId"] as! Int
            let myString3 = String(x3)
            
            
            let params = AddToCart(action: "addtocart",
                                   userId: String(myString),
                                   medicine_id: String(myString2),
                                   quantity: String(self.productQuantityWithTextSaved),
                                   price: String(self.saveProductPrice),
                                   supplierId: String(myString3),
                                   updateCart: String("0"))
            
            
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
                                
                                var strSuccess2 : String!
                                strSuccess2 = JSON["msg"]as Any as? String
                                
                                self.cartList(strCartSuccessMessage: strSuccess2)
                                /*var ar : NSArray!
                                ar = (JSON["data"] as! Array<Any>) as NSArray
                                self.arrListOfAllDoctors.addObjects(from: ar as! [Any])*/
                                
                                /*self.tablView.delegate = self
                                self.tablView.dataSource = self
                                self.tablView.reloadData()*/
                                
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
    
    @objc func cartList(strCartSuccessMessage:String) {
        // self.arrListOfAllDoctors.removeAllObjects()
        
        self.view.endEditing(true)
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            
            
             
            let params = CartList(action: "cartlist",
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
                                
                                let x : Int = JSON["TotalCartItem"] as! Int
                                let myString = String(x)
                                
                                if myString == "0" || myString == "" {
                                    
                                    self.btnCart.isHidden = true
                                    self.lblCartCounter.isHidden = true
                                    
                                } else {
                                    
                                    self.btnCart.isHidden = false
                                    self.lblCartCounter.isHidden = false
                                }
                                
                                self.lblCartCounter.text = String(myString)
                                
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
    
    
    @objc func editMedicineQuantity() {
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "updating...")
        self.view.endEditing(true)
        
        // print(self.getDictInventoryDetails as Any)
        
        /*
         diseaseId = 2;
         image = "https://dailymed.nlm.nih.gov/dailymed/image.cfm?setid=da9b26bb-d2d7-4113-a0f9-c6c2280f4875&name=trovan-image01.jpg";
         medicineId = 141028;
         name = "(AENC) DISINFECTANT WATER-FREE HAND FOAM (POLIHEXANIDE) SOLUTION YANTAI DONGKE LVZHIYUAN DISINFECTION PHARMACEUTICAL CO., LTD.";
         price = 100;
         quantity = 508;
         "sm_id" = 6;
         subdetails = "";
         supplierId = 236;
         weight = "";
         */
        
        let intAddOldQuantityWithNewQuantity = Int(self.getDictInventoryDetails["quantity"] as! String)!+Int(self.strUpdatedQuantityIs)!
        // print(intAddOldQuantityWithNewQuantity as Any)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let x2 : Int = self.getDictInventoryDetails["sm_id"] as! Int
            let myString2 = String(x2)
            
            let x3 : Int = self.getDictInventoryDetails["medicineId"] as! Int
            let myString3 = String(x3)
            
            let params =  Edit_Medicine_Quantity(action: "editmedicine",
                                                 sm_id: String(myString2),
                                                 supplierId: String(myString),
                                                 medicineId: String(myString3),
                                                 quantity: String(intAddOldQuantityWithNewQuantity))
            
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
    }
    
}

extension UIButton {
   func press(completion:@escaping ((Bool) -> Void)) {
            UIView.animate(withDuration: 0.05, animations: {
                self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8) }, completion: { (finish: Bool) in
                    UIView.animate(withDuration: 0.1, animations: {
                        self.transform = CGAffineTransform.identity
                        completion(finish)
                    })
            })
    }
}



extension String {

var containsValidCharacter: Bool {
    
    guard self != "" else { return true }
    let hexSet = CharacterSet(charactersIn: "1234567890")
    let newSet = CharacterSet(charactersIn: self)
    return hexSet.isSuperset(of: newSet)
    
  }
}
