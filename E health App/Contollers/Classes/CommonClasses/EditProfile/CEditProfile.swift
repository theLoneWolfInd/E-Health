//
//  CEditProfile.swift
//  Alien Broccoli
//
//  Created by Apple on 07/10/20.
//

import UIKit
import Alamofire
import SDWebImage

class CEditProfile: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    let cellReuseIdentifier = "cEditTotalTableCell"
    
    var imageStr1:String!
    var imgData1:Data!
    
    // MARK:- CUSTOM NAVIGATION BAR -
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            // navigationBar.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }

    // MARK:- CUSTOM NAVIGATION TITLE -
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "EDIT PROFILE"
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.tintColor = .white
            
        }
    }
    
    // MARK:- TABLE VIEW -
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            self.tbleView.delegate = self
            self.tbleView.dataSource = self
            self.tbleView.backgroundColor = .white
            self.tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        //Looks for single or multiple taps.
             /*let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

            //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
            //tap.cancelsTouchesInView = false

            view.addGestureRecognizer(tap)*/
        
        self.imageStr1 = "0"
        
        self.tbleView.separatorColor = .clear
        
        
        
        // self.sideBarMenuClick()
        
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
        
        
        self.fetchLoginUserDataForEdit()
    }

    
    //Calls this function when the tap is recognized.
    /*@objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }*/
    
    // login user data
    @objc func fetchLoginUserDataForEdit() {
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
        
            if person["role"] as! String == "Patient" {
            
                let indexPath = IndexPath.init(row: 0, section: 0)
                let cell = self.tbleView.cellForRow(at: indexPath) as! CEditTotalTableCell
                
                cell.imgProfile.backgroundColor = .clear
                
                cell.txtEmail.text          = (person["email"] as! String)
                cell.txtUsername.text       = (person["fullName"] as! String)
                cell.txtPhoneNumber.text    = (person["contactNumber"] as! String)
                cell.txtAddress.text        = (person["address"] as! String)
                
                cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell.imgProfile.sd_setImage(with: URL(string: (person["image"] as! String)), placeholderImage: UIImage(named: "logo"))
            
            } else {
            
                // print(person as Any)
                
                /*
                 ["state": , "gender": , "RoutingNo": , "logitude": , "role": Member, "AccountHolderName": , "wallet": 0, "address": [Address[addressLines=[0:"Unnamed Road, Sector 6, Sector 10 Dwarka, Dwarka, Delhi, 110075, India"],feature=Unnamed Road,admin=Delhi,sub-admin=South West Delhi,locality=Delhi,thoroughfare=Unnamed Road,postalCode=110075,countryCode=IN,countryName=India,hasL, "AutoInsurance": , "latitude": 28.5871237, "AccountNo": , "userId": 71, "country": , "TotalCartItem": 4, "lastName": , "drivlingImage": , "image": , "dob": , "deviceToken": 111111111111111111111, "accountType": , "ssnImage": , "contactNumber": 9865986434, "zipCode": , "device": iOS, "fullName": Mobile Gaming iPhone X, "longitude": , "middleName": , "BankName": , "socialId": , "socialType": , "firebaseId": , "email": ios@gmail.com]
                 */
                
                
                let indexPath = IndexPath.init(row: 0, section: 0)
                let cell = self.tbleView.cellForRow(at: indexPath) as! CEditTotalTableCell
                
                cell.txtEmail.text          = (person["email"] as! String)
                cell.txtUsername.text       = (person["fullName"] as! String)
                cell.txtPhoneNumber.text    = (person["contactNumber"] as! String)
                cell.txtAddress.text        = (person["address"] as! String)
                
                cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell.imgProfile.sd_setImage(with: URL(string: (person["image"] as! String)), placeholderImage: UIImage(named: "logo"))
            }
            
        }
        
    }
    
   
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func sideBarMenuClick() {
        
        let defaults = UserDefaults.standard
        defaults.setValue("", forKey: "keyBackOrSlide")
        defaults.setValue(nil, forKey: "keyBackOrSlide")
        
        if revealViewController() != nil {
        btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
          }
    }
    
    @objc func validationBeforeSubmit() {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! CEditTotalTableCell
        
        if cell.txtUsername.text == "" {
            
            let alert = UIAlertController(title: String("Error!"), message: String("Username should not be Empty."), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                 
            }))
            self.present(alert, animated: true, completion: nil)
        } else if cell.txtPhoneNumber.text == "" {
            
            let alert = UIAlertController(title: String("Error!"), message: String("Phone number should not be Empty."), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                 
            }))
            self.present(alert, animated: true, completion: nil)
        } else if cell.txtAddress.text == "" {
            
            let alert = UIAlertController(title: String("Error!"), message: String("Address should not be Empty."), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                 
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            
            self.editProfileWithoutImage()
        }
        
    }
    
    // MARK:- WEBSERVICE ( EDIT PROFILE WITHOUT IMAGE ) -
    @objc func editProfileWithoutImage() {
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "editing...")
        
        self.view.endEditing(true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
         // let str:String = person["role"] as! String
        
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let indexPath = IndexPath.init(row: 0, section: 0)
            let cell = self.tbleView.cellForRow(at: indexPath) as! CEditTotalTableCell
            
            let params = EditUserWithoutImage(action: "editprofile",
                                              userId: String(myString),
                                              fullName: String(cell.txtUsername.text!),
                                              contactNumber: String(cell.txtPhoneNumber.text!),
                                              address: String(cell.txtAddress.text!))
        
            // print(params as Any)
            
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
                        
                        // var strSuccess2 : String!
                        // strSuccess2 = JSON["msg"]as Any as? String
                        
                        /*
                         City = Dwarka;
                         Zipcode = 110075;
                         address = "Unnamed Road, Sector 6, Sector 10 Dwarka, Dwarka, Delhi, 110075, IndiaOk";
                         addressId = 17;
                         addressLine2 = "";
                         company = "";
                         country = "";
                         deliveryType = Evs;
                         firstName = Dishant;
                         lastName = Rajput;
                         mobile = 8287632340;
                         state = Delhi;
                         */
                        
                        if strSuccess == String("success") {
                            print("yes")
                            ERProgressHud.sharedInstance.hide()
                           
                            var dict: Dictionary<AnyHashable, Any>
                            dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                            
                             let defaults = UserDefaults.standard
                             defaults.setValue(dict, forKey: "keyLoginFullData")
                            
                            self.tbleView.delegate = self
                            self.tbleView.dataSource = self
                            self.tbleView.reloadData()
                            
                        } else {
                            print("no")
                            ERProgressHud.sharedInstance.hide()
                            
                            var strSuccess2 : String!
                            strSuccess2 = JSON["msg"]as Any as? String
                            
                            let alert = UIAlertController(title: String("Error!"), message: String(strSuccess2), preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
                            // Utils.showAlert(alerttitle: String(strSuccess), alertmessage: String(strSuccess2), ButtonTitle: "Ok", viewController: self)
                            
                        }
                        
                    case let .failure(error):
                        print(error)
                        ERProgressHud.sharedInstance.hide()
                        
                        let alert = UIAlertController(title: String("Error!"), message: String("Server issue"), preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                             
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                        // Utils.showAlert(alerttitle: SERVER_ISSUE_TITLE, alertmessage: SERVER_ISSUE_MESSAGE, ButtonTitle: "Ok", viewController: self)
                    }
            }
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
        let cell = self.tbleView.cellForRow(at: indexPath) as! CEditTotalTableCell
        
        cell.imgProfile.isHidden = false
        let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        cell.imgProfile.image = image_data // show image on profile
        let imageData:Data = image_data!.pngData()!
        imageStr1 = imageData.base64EncodedString()
        self.dismiss(animated: true, completion: nil)
        imgData1 = image_data!.jpegData(compressionQuality: 0.2)!
               //print(type(of: imgData)) // data
               
        self.imageStr1 = "1"
           
           
            self.uploadDataWithImage()
       }
       
    
    // MARK:- WEBSERVICE ( UPLOAD IMAGE )
    @objc func uploadDataWithImage() {
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
            
            
            
            let indexPath = IndexPath.init(row: 0, section: 0)
            let cell = self.tbleView.cellForRow(at: indexPath) as! CEditTotalTableCell
            
            var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

        //Set Your Parameter
            let parameterDict = NSMutableDictionary()
            parameterDict.setValue("editprofile", forKey: "action")
            parameterDict.setValue(String(myString), forKey: "userId")
            parameterDict.setValue(String(cell.txtUsername.text!), forKey: "fullName")
            parameterDict.setValue(String(cell.txtPhoneNumber.text!), forKey: "contactNumber")
            parameterDict.setValue(String(cell.txtAddress.text!), forKey: "address")

        //Set Image Data
        // let imgData = self.img_photo.image!.jpegData(compressionQuality: 0.5)!

        /*
         let params = EditUserWithoutImage(action: "editprofile",
         userId: String(myString),
         fullName: String(cell.txtUsername.text!),
         contactNumber: String(cell.txtPhoneNumber.text!),
         address: String(cell.txtAddress.text!))
         */
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
            multiPart.append(self.imgData1, withName: "image", fileName: "editProfilePicture.png", mimeType: "image/png")
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
                            
                            var dict: Dictionary<AnyHashable, Any>
                            dict = dictionary["data"] as! Dictionary<AnyHashable, Any>
                            
                             let defaults = UserDefaults.standard
                             defaults.setValue(dict, forKey: "keyLoginFullData")
                            ERProgressHud.sharedInstance.hide()
                            
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

extension CEditProfile: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell:CEditTotalTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! CEditTotalTableCell
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.backgroundColor = .white
        
        // image one
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(CEditProfile.cellTappedMethod1(_:)))

        cell.imgProfile.isUserInteractionEnabled = true
        // imgProfile.tag = indexPath.row
        cell.imgProfile.addGestureRecognizer(tapGestureRecognizer1)
        
        
        cell.btnUpdate.addTarget(self, action: #selector(validationBeforeSubmit), for: .touchUpInside)
        
        cell.txtUsername.delegate = self
        cell.txtEmail.delegate = self
        cell.txtAddress.delegate = self
        cell.txtPhoneNumber.delegate = self
        
        return cell
        
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return 1000
    }
    
}

extension CEditProfile: UITableViewDelegate {
    
}
