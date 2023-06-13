//
//  AddMoreMedicines.swift
//  E health App
//
//  Created by apple on 07/10/21.
//

import UIKit
import Alamofire
import SDWebImage

class AddMoreMedicines: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var imageStr1:String!
    var imgData1:Data!
    
    var getProfileInfo:String!
    var getDictOfThatMedicine:NSDictionary!
    
    var getDieseaaseId:String!
    var strSaveMedicineId:String! = ""
    var strSaveMedicineName:String! = ""
    var strSaveMedicineImage:String! = ""
    
    @IBOutlet weak var viewNavigationBar:UIView!
    
    @IBOutlet weak var btnDashboardMenu:UIButton! {
        didSet {
            btnDashboardMenu.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        }
    }
    
    @IBOutlet weak var lblNavigationBar:UILabel!{
        didSet {
            
            lblNavigationBar.text = "ADD MEDICINE"
        }
    }
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            tbleView.delegate = self
            tbleView.dataSource = self
            tbleView.backgroundColor =  .white
            tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        }
    }
    
    var str_call_only:String! = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        self.tbleView.separatorColor = .clear
        
        self.btnDashboardMenu.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        let defaults = UserDefaults.standard
        
        if let myString = defaults.string(forKey: "key_medicine_id") {
            print("defaults savedString: \(myString)")
            
            self.strSaveMedicineId = "\(myString)"
        } else {
            self.strSaveMedicineId = ""
        }
        
        if let myString2 = defaults.string(forKey: "key_medicine_name") {
            print("defaults savedString: \(myString2)")
            
            self.strSaveMedicineName = "\(myString2)"
            
        } else {
            self.strSaveMedicineName = ""
        }
        
        if let myString3 = defaults.string(forKey: "key_medicine_image") {
            print("defaults savedString: \(myString3)")
            
            self.strSaveMedicineImage = "\(myString3)"
            
        } else {
            self.strSaveMedicineImage = ""
        }
        
        
        print(self.strSaveMedicineId as Any)
        print(self.strSaveMedicineName as Any)
        print(self.strSaveMedicineImage as Any)
        
        
        
        
        self.tbleView.reloadData()
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func validationBeforeAddMedicine() {
        
        if self.getProfileInfo == "edit_medicine" {
            
            print("Edit Medicine")
            
            // print(self.strSaveMedicineImage as Any)
            if self.imageStr1 == "1" {
                
                self.edit_medicine_with_image(imageData: imgData1 as NSData)
                
            } else {
            
                if String(self.strSaveMedicineImage) != "" {
                    print("with image")
                    
                    let url = URL(string: self.strSaveMedicineImage)
                    print(url as Any)
                    
                    do {
                        let imageData = try Data(contentsOf: url!)
                        
                         // print(imageData as Any)
                        // self.addMedicineWithImageWB(imageData: imageData as NSData)
                        
                        self.edit_medicine_with_image(imageData: imageData as NSData)
                        
                    } catch {
                        print("Unable to load data: \(error)")
                    }
                    
                } else {
                    print("without image")
                }
                
            }
            
            
             
            
            
        } else {
            //
            if self.strSaveMedicineImage == "" {
                self.addMedicineWithoutImage()
            } else {
                
                if self.imageStr1 == "1" {
                    self.uploadDataWithImage()
                } else {
                    self.addMedicineWithImage()
                }
                
            }
            
        }
        
        
    }
    
    // MARK: - EDIT MEDICINE WITHOUT IMAGE -
    @objc func editMedicineWithoutImage() {
        
        let indexPath = IndexPath.init(row: 3, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! AddMoreMedicinesTableCell
        
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            
            let params =  Edit_Medicine_Without_Image(action: "editmedicine",
                                                      sm_id: String(""),
                                                      supplierId: String(myString),
                                                      diseaseId: String(self.getDieseaaseId),
                                                      name: String(self.strSaveMedicineName),
                                                      price: String(cell.txtMedicinePrice.text!),
                                                      quantity: String(cell.txtMedicineQuantity.text!),
                                                      medicine_id: String(self.strSaveMedicineId))
            
            
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
    
    @objc func addMedicineWithoutImage() {
        let indexPath = IndexPath.init(row: 3, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! AddMoreMedicinesTableCell
        
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            
            let params =  Add_New_Medicine_Without_Image(action: "addmedicine",
                                                         supplierId: String(myString),
                                                         diseaseId: String(self.getDieseaaseId),
                                                         name: String(self.strSaveMedicineName),
                                                         price: String(cell.txtMedicinePrice.text!),
                                                         quantity: String(cell.txtMedicineQuantity.text!),
                                                         medicine_id: String(self.strSaveMedicineId))
            
            
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
    
    @objc func addMedicineWithImage() {
        
        let url = URL(string: self.strSaveMedicineImage)
        
        do {
            let imageData = try Data(contentsOf: url!)
            // print(imageData as Any)
            self.addMedicineWithImageWB(imageData: imageData as NSData)
        } catch {
            print("Unable to load data: \(error)")
        }
        
        
    }
    
    
    
    
    
    @objc func cellTappedMethod1(_ sender:AnyObject) {
        print("you tap image number: \(sender.view.tag)")
        
        let alert = UIAlertController(title: "Upload Profile Image", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            print("User click Approve button")
            self.openCamera1()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default , handler:{ (UIAlertAction)in
            print("User click Edit button")
            self.openGallery1()
        }))
        
        alert.addAction(UIAlertAction(title: "In-Appropriate terms", style: .default , handler:{ (UIAlertAction)in
            print("User click Delete button")
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }
    
    @objc func openCamera1() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera;
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    @objc func openGallery1() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary;
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! AddMoreMedicinesTableCell
        
        if self.getProfileInfo == "edit_medicine" {
            
            cell.cell1MedicineProfile.isHidden = false
            let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            cell.cell1MedicineProfile.image = image_data // show image on profile
            let imageData:Data = image_data!.pngData()!
            self.imageStr1 = imageData.base64EncodedString()
            self.dismiss(animated: true, completion: nil)
            self.imgData1 = image_data!.jpegData(compressionQuality: 0.2)!
            
            self.imageStr1 = "1"
            
        } else {
            
            cell.cell1MedicineProfile.isHidden = false
            let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            cell.cell1MedicineProfile.image = image_data // show image on profile
            let imageData:Data = image_data!.pngData()!
            self.imageStr1 = imageData.base64EncodedString()
            self.dismiss(animated: true, completion: nil)
            self.imgData1 = image_data!.jpegData(compressionQuality: 0.2)!
            
            self.imageStr1 = "1"
            self.strSaveMedicineImage = "1"
            
        }
        
    }
    
    
    // MARK:- WEBSERVICE ( UPLOAD IMAGE )
    @objc func uploadDataWithImage() {
        let indexPath = IndexPath.init(row: 3, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! AddMoreMedicinesTableCell
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        //Set Your URL
        let api_url = APPLICATION_BASE_URL
        guard let url = URL(string: api_url) else {
            return
        }
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // let str:String = person["role"] as! String
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            
            //Set Your Parameter
            let parameterDict = NSMutableDictionary()
            parameterDict.setValue("addmedicine", forKey: "action")
            parameterDict.setValue(String(myString), forKey: "supplierId")
            parameterDict.setValue(String(self.getDieseaaseId), forKey: "diseaseId")
            parameterDict.setValue(String(self.strSaveMedicineName), forKey: "name")
            parameterDict.setValue(String(cell.txtMedicinePrice.text!), forKey: "price")
            parameterDict.setValue(String(cell.txtMedicineQuantity.text!), forKey: "quantity")
            parameterDict.setValue(String(self.strSaveMedicineId), forKey: "medicine_id")
            
            print(parameterDict as Any)
            
            
            // Now Execute
            AF.upload(multipartFormData: { multiPart in
                for (key, value) in parameterDict {
                    if let temp = value as? String {
                        multiPart.append(temp.data(using: .utf8)!, withName: key as! String)
                    }
                    if let temp = value as? Int {
                        multiPart.append("\(temp)".data(using: .utf8)!, withName: key as! String)
                    }
                    if let temp = value as? NSArray {
                        temp.forEach({ element in
                            let keyObj = key as! String + "[]"
                            if let string = element as? String {
                                multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                            } else
                            if let num = element as? Int {
                                let value = "\(num)"
                                multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                            }
                        })
                    }
                }
                multiPart.append(self.imgData1, withName: "image", fileName: "medicineName.png", mimeType: "image/png")
            }, with: urlRequest)
            .uploadProgress(queue: .main, closure: { progress in
                //Current upload progress of file
                print("Upload Progress: \(progress.fractionCompleted)")
            })
            .responseJSON(completionHandler: { data in
                
                switch data.result {
                    
                case .success(_):
                    do {
                        
                        let dictionary = try JSONSerialization.jsonObject(with: data.data!, options: .fragmentsAllowed) as! NSDictionary
                        
                        print("Success!")
                        print(dictionary)
                        
                        ERProgressHud.sharedInstance.hide()
                        
                        var strSuccess : String!
                        strSuccess = (dictionary["msg"]as Any as? String)
                        
                        let alert = NewYorkAlertController(title: "Success", message: String(strSuccess), style: .alert)
                        
                        alert.addImage(UIImage.gif(name: "success3"))
                        
                        let cancel = NewYorkButton(title: "dismiss", style: .cancel) { _ in
                            self.navigationController?.popViewController(animated: true)
                        }
                        alert.addButtons([cancel])
                        
                        self.present(alert, animated: true)
                        
                    }
                    catch {
                        // catch error.
                        print("catch error")
                        ERProgressHud.sharedInstance.hide()
                    }
                    break
                    
                case .failure(_):
                    print("failure")
                    ERProgressHud.sharedInstance.hide()
                    break
                    
                }
                
                
            })
            
        }}
    
    
    @objc func addMedicineWithImageWB(imageData:NSData) {
        let indexPath = IndexPath.init(row: 3, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! AddMoreMedicinesTableCell
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        //Set Your URL
        let api_url = APPLICATION_BASE_URL
        guard let url = URL(string: api_url) else {
            return
        }
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // let str:String = person["role"] as! String
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            
            //Set Your Parameter
            let parameterDict = NSMutableDictionary()
            parameterDict.setValue("addmedicine", forKey: "action")
            parameterDict.setValue(String(myString), forKey: "supplierId")
            parameterDict.setValue(String(self.getDieseaaseId), forKey: "diseaseId")
            parameterDict.setValue(String(self.strSaveMedicineName), forKey: "name")
            parameterDict.setValue(String(cell.txtMedicinePrice.text!), forKey: "price")
            parameterDict.setValue(String(cell.txtMedicineQuantity.text!), forKey: "quantity")
            parameterDict.setValue(String(self.strSaveMedicineId), forKey: "medicine_id")
            
            print(parameterDict as Any)
            
            
            // Now Execute
            AF.upload(multipartFormData: { multiPart in
                for (key, value) in parameterDict {
                    if let temp = value as? String {
                        multiPart.append(temp.data(using: .utf8)!, withName: key as! String)
                    }
                    if let temp = value as? Int {
                        multiPart.append("\(temp)".data(using: .utf8)!, withName: key as! String)
                    }
                    if let temp = value as? NSArray {
                        temp.forEach({ element in
                            let keyObj = key as! String + "[]"
                            if let string = element as? String {
                                multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                            } else
                            if let num = element as? Int {
                                let value = "\(num)"
                                multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                            }
                        })
                    }
                }
                multiPart.append(imageData as Data, withName: "image", fileName: "medicineName.png", mimeType: "image/png")
            }, with: urlRequest)
            .uploadProgress(queue: .main, closure: { progress in
                //Current upload progress of file
                print("Upload Progress: \(progress.fractionCompleted)")
            })
            .responseJSON(completionHandler: { data in
                
                switch data.result {
                    
                case .success(_):
                    do {
                        
                        let dictionary = try JSONSerialization.jsonObject(with: data.data!, options: .fragmentsAllowed) as! NSDictionary
                        
                        print("Success!")
                        print(dictionary)
                        
                        // var dict: Dictionary<AnyHashable, Any>
                        // dict = dictionary["data"] as! Dictionary<AnyHashable, Any>
                        
                        /*let defaults = UserDefaults.standard
                         defaults.setValue(dict, forKey: "keyLoginFullData")*/
                        ERProgressHud.sharedInstance.hide()
                        
                        var strSuccess : String!
                        strSuccess = (dictionary["msg"]as Any as? String)
                        
                        let alert = NewYorkAlertController(title: "Success", message: String(strSuccess), style: .alert)
                        
                        alert.addImage(UIImage.gif(name: "success3"))
                        
                        let cancel = NewYorkButton(title: "dismiss", style: .cancel) { _ in
                            self.navigationController?.popViewController(animated: true)
                        }
                        alert.addButtons([cancel])
                        
                        self.present(alert, animated: true)
                        
                    }
                    catch {
                        // catch error.
                        print("catch error")
                        ERProgressHud.sharedInstance.hide()
                    }
                    break
                    
                case .failure(_):
                    print("failure")
                    ERProgressHud.sharedInstance.hide()
                    break
                    
                }
                
                
            })
            
        }}
    
    
    @objc func edit_medicine_with_image(imageData:NSData) {
        let indexPath = IndexPath.init(row: 3, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! AddMoreMedicinesTableCell
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        //Set Your URL
        let api_url = APPLICATION_BASE_URL
        guard let url = URL(string: api_url) else {
            return
        }
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // let str:String = person["role"] as! String
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            
            /*
             print(self.getDictOfThatMedicine as Any)
             diseaseId = 2;
             image = "https://demo4.evirtualservices.net/ehealth/img/uploads/medicines/1639742398medicineName.png";
             medicineId = 141061;
             name = "(AENC) DISINFECTANT WATER-FREE HAND FOAM (POLIHEXANIDE) SOLUTION YANTAI DONGKE LVZHIYUAN DISINFECTION PHARMACEUTICAL CO., LTD.";
             price = 5;
             quantity = 1003;
             "sm_id" = 1;
             subdetails = "";
             supplierId = 14;
             weight = "";
             
             [action] => editmedicine
                 [sm_id] => 5
                 [supplierId] => 14
                 [medicineId] => 141085
                 [name] => (AENC) DISINFECTANT WATER-FREE HAND FOAM (POLIHEXANIDE) SOLUTION YANTAI DONGKE LVZHIYUAN DISINFECTION PHARMACEUTICAL CO., LTD.
                 [price] => 12
                 [quantity] => 1000
             
             */
            //Set Your Parameter
            let parameterDict = NSMutableDictionary()
            parameterDict.setValue("editmedicine", forKey: "action")
            parameterDict.setValue(String(myString), forKey: "supplierId")
            
            parameterDict.setValue(String(cell.txtMedicinePrice.text!), forKey: "price")
            parameterDict.setValue(String(cell.txtMedicineQuantity.text!), forKey: "quantity")
            
            parameterDict.setValue("\(self.getDictOfThatMedicine["sm_id"]!)", forKey: "sm_id")
            parameterDict.setValue(String(self.strSaveMedicineName), forKey: "name")
            parameterDict.setValue(String(self.strSaveMedicineId), forKey: "medicine_id")

            print(parameterDict as Any)
            
            
            // Now Execute
            AF.upload(multipartFormData: { multiPart in
                for (key, value) in parameterDict {
                    if let temp = value as? String {
                        multiPart.append(temp.data(using: .utf8)!, withName: key as! String)
                    }
                    if let temp = value as? Int {
                        multiPart.append("\(temp)".data(using: .utf8)!, withName: key as! String)
                    }
                    if let temp = value as? NSArray {
                        temp.forEach({ element in
                            let keyObj = key as! String + "[]"
                            if let string = element as? String {
                                multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                            } else
                            if let num = element as? Int {
                                let value = "\(num)"
                                multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                            }
                        })
                    }
                }
                multiPart.append(imageData as Data, withName: "image", fileName: "edit_medicine.png", mimeType: "image/png")
            }, with: urlRequest)
            .uploadProgress(queue: .main, closure: { progress in
                //Current upload progress of file
                print("Upload Progress: \(progress.fractionCompleted)")
            })
            .responseJSON(completionHandler: { data in
                
                switch data.result {
                    
                case .success(_):
                    do {
                        
                        let dictionary = try JSONSerialization.jsonObject(with: data.data!, options: .fragmentsAllowed) as! NSDictionary
                        
                        print("Success!")
                        print(dictionary)
                        
                        // var dict: Dictionary<AnyHashable, Any>
                        // dict = dictionary["data"] as! Dictionary<AnyHashable, Any>
                        
                        /*let defaults = UserDefaults.standard
                         defaults.setValue(dict, forKey: "keyLoginFullData")*/
                        ERProgressHud.sharedInstance.hide()
                        
                        var strSuccess : String!
                        strSuccess = (dictionary["msg"]as Any as? String)
                        
                        let alert = NewYorkAlertController(title: "Success", message: String(strSuccess), style: .alert)
                        
                        alert.addImage(UIImage.gif(name: "success3"))
                        
                        let cancel = NewYorkButton(title: "dismiss", style: .cancel) { _ in
                            self.navigationController?.popViewController(animated: true)
                        }
                        alert.addButtons([cancel])
                        
                        self.present(alert, animated: true)
                        
                    }
                    catch {
                        // catch error.
                        print("catch error")
                        ERProgressHud.sharedInstance.hide()
                    }
                    break
                    
                case .failure(_):
                    print("failure")
                    ERProgressHud.sharedInstance.hide()
                    break
                    
                }
                
                
            })
            
        }}
    
}

extension AddMoreMedicines : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell:AddMoreMedicinesTableCell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! AddMoreMedicinesTableCell
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.backgroundColor = .white
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            /*
             diseaseId = 2;
             image = "";
             medicineId = 141028;
             name = "";
             price = 100;
             quantity = 14;
             "sm_id" = 6;
             subdetails = "";
             supplierId = 236;
             weight = "";
             */
            
            
            let defaults = UserDefaults.standard
            
            if self.getProfileInfo == "edit_medicine" {
                
                // print(self.getDictOfThatMedicine as Any)
                
               
                
                if let myString3 = defaults.string(forKey: "key_medicine_image") {
                    print("defaults savedString: \(myString3)")
                    
                    self.strSaveMedicineImage = "\(myString3)"
                    
                    cell.cell1MedicineProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                    cell.cell1MedicineProfile.sd_setImage(with: URL(string: self.strSaveMedicineImage), placeholderImage: UIImage(named: "1024"))
                    
                    defaults.set(nil, forKey: "key_medicine_image")
                    
                } else {
                    // self.strSaveMedicineImage = ""
                    
                    self.strSaveMedicineImage = (self.getDictOfThatMedicine["image"] as! String)
                    cell.cell1MedicineProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                    cell.cell1MedicineProfile.sd_setImage(with: URL(string: self.strSaveMedicineImage), placeholderImage: UIImage(named: "1024"))
                    
                }
                
                
                
                
                
                
                
                if let myString3 = defaults.string(forKey: "key_medicine_id") {
                    print("defaults savedString: \(myString3)")
                    
                    self.strSaveMedicineId = "\(myString3)"
                    
                     
                    
                    defaults.set(nil, forKey: "key_medicine_id")
                    
                } else {
                    // self.strSaveMedicineImage = ""
                    print(self.getDictOfThatMedicine as Any)
                    self.strSaveMedicineId = "\(self.getDictOfThatMedicine["medicineId"]!)"
                    print(self.strSaveMedicineId as Any)
                }
                
            } else {
                
                if self.strSaveMedicineName != "" {
                    
                    cell.cell1MedicineProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                    cell.cell1MedicineProfile.sd_setImage(with: URL(string: self.strSaveMedicineImage), placeholderImage: UIImage(named: "1024"))
                    
                }
                
            }
            
            let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(AddMoreMedicines.cellTappedMethod1(_:)))
            cell.cell1MedicineProfile.isUserInteractionEnabled = true
            cell.cell1MedicineProfile.addGestureRecognizer(tapGestureRecognizer1)
            
            return cell
            
            
        } else if indexPath.row == 1 {
            
            let cell:AddMoreMedicinesTableCell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! AddMoreMedicinesTableCell
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.backgroundColor = .white
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            let defaults = UserDefaults.standard
            
            if let myString3 = defaults.string(forKey: "key_medicine_name") {
                print("defaults savedString: \(myString3)")
                
                self.strSaveMedicineName = "\(myString3)"
                cell.lblCell2MedicineName.text = String(self.strSaveMedicineName)
                
                defaults.set(nil, forKey: "key_medicine_name")
                
            } else {
                // self.strSaveMedicineImage = ""
                
                if self.getProfileInfo == "edit_medicine" {
                
                    self.strSaveMedicineName = (self.getDictOfThatMedicine["name"] as! String)
                    cell.lblCell2MedicineName.text = String(self.strSaveMedicineName)
                    
                } else {
                    
                    cell.lblCell2MedicineName.text = String(self.strSaveMedicineName)
                }
                
                
            }
            
            cell.btnCell2TypeMedicineName.addTarget(self, action: #selector(selectMedicineNameClickMethod), for: .touchUpInside)
            
            return cell
            
            
        } else if indexPath.row == 2 {
            
            let cell:AddMoreMedicinesTableCell = tableView.dequeueReusableCell(withIdentifier: "cell3") as! AddMoreMedicinesTableCell
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.backgroundColor = .white
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.accessoryType = .disclosureIndicator
            
            return cell
            
            
        } else if indexPath.row == 3 {
            
            let cell:AddMoreMedicinesTableCell = tableView.dequeueReusableCell(withIdentifier: "cell4") as! AddMoreMedicinesTableCell
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.backgroundColor = .white
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            if self.getProfileInfo == "edit_medicine" {
                
                // print(self.getDictOfThatMedicine as Any)
                
                cell.txtMedicinePrice.text      = (self.getDictOfThatMedicine["price"] as! String)
                cell.txtMedicineQuantity.text   = (self.getDictOfThatMedicine["quantity"] as! String)
                cell.btnAddOrEditMedicine.setTitle("Edit Medicine", for: .normal)
                
            } else {
                
                cell.btnAddOrEditMedicine.setTitle("Add Medicine", for: .normal)
                
            }
            
            cell.btnAddOrEditMedicine.addTarget(self, action: #selector(validationBeforeAddMedicine), for: .touchUpInside)
            
            return cell
            
        } else {
            
            let cell:AddMoreMedicinesTableCell = tableView.dequeueReusableCell(withIdentifier: "cell5") as! AddMoreMedicinesTableCell
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            return cell
            
        }
        
    }
    
    @objc func selectMedicineNameClickMethod() {
        let alert = NewYorkAlertController.init(title: "Medicine name", message: "Please enter the medicine name here.", style: .alert)
        
        alert.addImage(UIImage(named: "medicine"))
        
        alert.addTextField { tf in
            
            if self.strSaveMedicineName == "" {
                tf.placeholder = "enter medicine name..."
            } else {
                tf.text = String(self.strSaveMedicineName)
            }
            
            tf.keyboardType = .default
            tf.tag = 1
        }
        
        let ok = NewYorkButton(title: "Update", style: .default) { [unowned alert] _ in
            alert.textFields.forEach { tf in
                let text = tf.text ?? ""
                switch tf.tag {
                case 1:
                    print("quantity: \(text)")
                    
                    self.strSaveMedicineName = "\(text)"
                    
                    self.tbleView.reloadData()
                    
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // click list of all medicines
        if indexPath.row == 2 {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListOfAllMedicinesId") as? ListOfAllMedicines
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            
            return 200
            
        } else if indexPath.row == 1 {
            
            return UITableView.automaticDimension
            
        } else if indexPath.row == 2 {
            
            return 60
            
        } else if indexPath.row == 3 {
            
            return 260
            
        } else if indexPath.row == 4 {
            
            return 500
            
        }  else {
            
            return 0
            
        }
    }
    
}
