//
//  AddImages.swift
//  E health App
//
//  Created by Apple on 22/09/21.
//

import UIKit
import Alamofire
import SDWebImage

import AVFoundation
import Photos

class AddImages: UIViewController , UINavigationControllerDelegate , UIImagePickerControllerDelegate  {

    var strShowImageDetailsFor:String!
    
    var strActionData:String!
    var getAppointmentDetailsIn:NSDictionary!
    
    var arrTotalImagesList:NSMutableArray! = []
    var addInitialMutable:NSMutableArray! = []
    
    var arr_list_of_all_test_from_labs:NSArray!
    var dict_get_pharmacy_prescription:NSDictionary!
    
    var imageStr1:String!
    var imgData1:Data!
    
    var strSaveAppointmentId:String!
    var strSaveDoctorId:String!
    var strSaveHospitalId:String!
    var strSavePatientId:String!
    var strSavePrescriptionId:String! = "0"
    
    var strSaveTestId:String! = "0"
    
    var strClickedCellIndex:String!
    
    
    var addImageOrEditImage:String! = "0"
    
    var arrShowServerDataImageSaved:NSMutableArray! = []
    
    var arrSaveTestsDetails:NSMutableArray! = []
    var strSaveTestName:String! = ""
    var saveTestIdOnlyForEdit:String!
    
    @IBOutlet weak var viewNavigationbar:UIView!
    @IBOutlet weak var btnDashboardMenu: UIButton!
    @IBOutlet weak var lblNavationbar:UILabel!{
        didSet {
            lblNavationbar.text = ""
        }
    }
    
    @IBOutlet weak var clView:UICollectionView! {
        didSet {
            clView.backgroundColor = .white
            // clView.delegate = self
            // clView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
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
        
        
        
        if self.strShowImageDetailsFor == "prescription" {
            var ar : NSArray!
            ar = (self.getAppointmentDetailsIn["prescription"] as! Array<Any>) as NSArray
            // print(ar as Any)
            
            self.arrTotalImagesList.add(ar as Any)
            
            if ar.count == 0 {
                
                self.strSavePrescriptionId = "0"
                self.lblNavationbar.text = "Prescriptions"
                
                let myDictionary2: [String:String] = [
                    
                    "image" : "",
                    "tag"   : "addPicture"
                ]
                
                self.arrShowServerDataImageSaved.add(myDictionary2)
                
            } else {
                
                
                /*appointmentId = 110;
                 created = "2021-09-24T17:15:10+0530";
                 doctorId = 192;
                 hospitalId = 182;
                 image = "https://demo4.evirtualservices.net/ehealth//img/uploads/prescription/1632483910uploadPrescription.png";
                 "image_2" = "https://demo4.evirtualservices.net/ehealth//img/uploads/prescription/1632484902uploadPrescription.png";
                 "image_3" = "";
                 "image_4" = "";
                 "image_5" = "";
                 permission = 0;
                 prescriptionId = 41;
                 status = 1;
                 userId = 189;*/
                
                self.lblNavationbar.text = "Prescriptions"
                
                let item2 = ar[0] as? [String:Any]
                let x5 : Int = (item2!["prescriptionId"] as! Int)
                let myString5 = String(x5)
                self.strSavePrescriptionId = String(myString5)
                
                let item = ar[0] as? [String:Any]
                
                if (item!["image"] as! String) == "" {
                    
                } else {
                    
                    let myDictionary2: [String:String] = [
                        
                        "image" : (item!["image"] as! String),
                        "tag"   : ""
                    ]
                    
                    self.arrShowServerDataImageSaved.add(myDictionary2)
                }
                
                // image 2
                if (item!["image_2"] as! String) == "" {
                    
                } else {
                    
                    let myDictionary2: [String:String] = [
                        
                        "image" : (item!["image_2"] as! String),
                        "tag"   : ""
                    ]
                    
                    self.arrShowServerDataImageSaved.add(myDictionary2)
                    
                }
                
                // image 3
                if (item!["image_3"] as! String) == "" {
                    
                } else {
                    
                    let myDictionary2: [String:String] = [
                        
                        "image" : (item!["image_3"] as! String),
                        "tag"   : ""
                    ]
                    
                    self.arrShowServerDataImageSaved.add(myDictionary2)
                    
                }
                
                // image 4
                if (item!["image_4"] as! String) == "" {
                    
                } else {
                    
                    let myDictionary2: [String:String] = [
                        
                        "image" : (item!["image_4"] as! String),
                        "tag"   : ""
                    ]
                    
                    self.arrShowServerDataImageSaved.add(myDictionary2)
                    
                }
                
                // image 5
                if (item!["image_5"] as! String) == "" {
                    
                } else {
                    
                    let myDictionary2: [String:String] = [
                        
                        "image" : (item!["image_5"] as! String),
                        "tag"   : ""
                    ]
                    
                    self.arrShowServerDataImageSaved.add(myDictionary2)
                    
                }
                
                
                
                
                // add extra cell
                let myDictionary2: [String:String] = [
                    
                    "image" : "",
                    "tag"   : "addPicture"
                ]
                
                self.arrShowServerDataImageSaved.add(myDictionary2)
                
                
                 // print(self.arrShowServerDataImageSaved as Any)
                // print(self.arrShowServerDataImageSaved.count as Any)
                
                
                
                
            }
            
        } else if self.strShowImageDetailsFor == "test" {
            
            print("i am from test")
            self.lblNavationbar.text = "Test"
             print(self.getAppointmentDetailsIn as Any)
            
            var ar : NSArray!
            ar = (self.getAppointmentDetailsIn["tests"] as! Array<Any>) as NSArray
             // print(ar as Any)
            
            if ar.count == 0 {
                
                let myDictionary2: [String:String] = [
                    
                    "image" : "",
                    "content" : String(self.strSaveTestName),
                    "testsId" : "",
                    "tag"   : "addPicture"
                ]
                    
                self.arrShowServerDataImageSaved.add(myDictionary2)
                
                // self.arrShowServerDataImageSaved.add(ar as Any)
                
            } else {
                
                let item = ar[0] as? [String:Any]
                let x5 : Int = (item!["testsId"] as! Int)
                let myString5 = String(x5)
                self.strSaveTestId = String(myString5)
                
                for indexx in 0..<ar.count {
                    
                    let item = ar[indexx] as? [String:Any]
                    
                    let x5 : Int = (item!["testsId"] as! Int)
                    let myString5 = String(x5)
                    
                    let myDictionary2: [String:String] = [
                            
                        "image" : (item!["image"] as! String),
                        "content" : (item!["content"] as! String),
                        "testsId" : String(myString5),
                        "tag"   : ""
                    ]
                        
                    self.arrShowServerDataImageSaved.add(myDictionary2)
                    
                }
                
                // add extra cell
                let myDictionary3: [String:String] = [
                        
                    "image" : "",
                    "content" : String(self.strSaveTestName),
                    "testsId" : "",
                    "tag"   : "addPicture"
                ]
                
                self.arrShowServerDataImageSaved.add(myDictionary3)
                
                // self.arrShowServerDataImageSaved.add(ar as Any)
                
            }
            
               print(self.arrShowServerDataImageSaved as Any)
            
        } else if self.strShowImageDetailsFor == "test_list_from_labs" {
            
            print("i am from test from labs")
            self.lblNavationbar.text = "Test"
            // print(self.getAppointmentDetailsIn as Any)
            
            print(self.arr_list_of_all_test_from_labs as Any)
            var ar : NSArray!
            ar = self.arr_list_of_all_test_from_labs
             // print(ar as Any)
            
            if ar.count == 0 {
                
                let myDictionary2: [String:String] = [
                    
                    "image" : "",
                    "content" : String(self.strSaveTestName),
                    "testId" : "",
                    "tag"   : "addPicture"
                ]
                    
                self.arrShowServerDataImageSaved.add(myDictionary2)
                
                // self.arrShowServerDataImageSaved.add(ar as Any)
                
            } else {
                
                let item = ar[0] as? [String:Any]
                let x5 : Int = (item!["testId"] as! Int)
                let myString5 = String(x5)
                self.strSaveTestId = String(myString5)
                
                for indexx in 0..<ar.count {
                    
                    let item = ar[indexx] as? [String:Any]
                    
                    let x5 : Int = (item!["testId"] as! Int)
                    let myString5 = String(x5)
                    
                    let myDictionary2: [String:String] = [
                            
                        "image" : (item!["testImage"] as! String),
                        "content" : (item!["content"] as! String),
                        "testId" : String(myString5),
                        "tag"   : ""
                    ]
                        
                    self.arrShowServerDataImageSaved.add(myDictionary2)
                    
                }
                
                // add extra cell
                let myDictionary3: [String:String] = [
                        
                    "image" : "",
                    "content" : String(self.strSaveTestName),
                    "testId" : "",
                    "tag"   : "addPicture"
                ]
                
                self.arrShowServerDataImageSaved.add(myDictionary3)
                
                // self.arrShowServerDataImageSaved.add(ar as Any)
                
            }
            
               print(self.arrShowServerDataImageSaved as Any)
            
            
            
        } else if self.strShowImageDetailsFor == "prescription_list_from_pharmacy" {
            
            print(self.dict_get_pharmacy_prescription as Any)
            
            for indexx in 0...4 {
               
                
                if indexx == 0 {
                    
                    if (self.dict_get_pharmacy_prescription["prescription_image"] as! String) == "" {
                        
                    } else {
                        
                        let myDictionary2: [String:String] = [
                            
                            "image" : (self.dict_get_pharmacy_prescription["prescription_image"] as! String),
                            "tag"   : ""
                        ]
                        
                        self.arrShowServerDataImageSaved.add(myDictionary2)
                    }
                    
                } else if indexx == 1 {
                    
                    if (self.dict_get_pharmacy_prescription["prescription_image_2"] as! String) == "" {
                        
                    } else {
                        
                        let myDictionary2: [String:String] = [
                            
                            "image" : (self.dict_get_pharmacy_prescription["prescription_image_2"] as! String),
                            "tag"   : ""
                        ]
                        
                        self.arrShowServerDataImageSaved.add(myDictionary2)
                    }
                    
                } else if indexx == 2 {
                    
                    if (self.dict_get_pharmacy_prescription["prescription_image_3"] as! String) == "" {
                        
                    } else {
                        
                        let myDictionary2: [String:String] = [
                            
                            "image" : (self.dict_get_pharmacy_prescription["prescription_image_3"] as! String),
                            "tag"   : ""
                        ]
                        
                        self.arrShowServerDataImageSaved.add(myDictionary2)
                    }
                    
                } else if indexx == 3 {
                    
                    if (self.dict_get_pharmacy_prescription["prescription_image_4"] as! String) == "" {
                        
                    } else {
                        
                        let myDictionary2: [String:String] = [
                            
                            "image" : (self.dict_get_pharmacy_prescription["prescription_image_4"] as! String),
                            "tag"   : ""
                        ]
                        
                        self.arrShowServerDataImageSaved.add(myDictionary2)
                    }
                    
                } else {
                    
                    if (self.dict_get_pharmacy_prescription["prescription_image_5"] as! String) == "" {
                        
                    } else {
                        
                        let myDictionary2: [String:String] = [
                            
                            "image" : (self.dict_get_pharmacy_prescription["prescription_image_5"] as! String),
                            "tag"   : ""
                        ]
                        
                        self.arrShowServerDataImageSaved.add(myDictionary2)
                    }
                    
                }
                
                
                
                
                
                
                
                
                
                
                
            }
            
            
            
            
            
            
            
            
            
            
            
        }
        
        print(self.arrShowServerDataImageSaved as Any)
        
        
        self.clView.delegate = self
        self.clView.dataSource = self
        self.clView.reloadData()
        
        // print(self.strSavePrescriptionId as Any)
    }

    /*override func viewDidAppear(_ animated: Bool) {
        
      let status = PHPhotoLibrary.authorizationStatus()
      if status != .authorized {
        PHPhotoLibrary.requestAuthorization() {
          status in
        }
      } else {
          // user not authorize
          print("user not authorize")
      }
        
    }*/
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func sideBarMenuClick() {
        
        UserDefaults.standard.set("", forKey: "keySetToBackOrMenu")
        UserDefaults.standard.set(nil, forKey: "keySetToBackOrMenu")
        
        self.view.endEditing(true)
        
        if revealViewController() != nil {
            
            btnDashboardMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    @objc func cellTappedMethod1(_ sender:AnyObject) {
        print("you tap image number: \(sender.view.tag)")
        
        
        print(self.arrShowServerDataImageSaved as Any)
        
        
        self.strClickedCellIndex = "\(sender.view.tag)"
        
        // print(self.addInitialMutable[sender.view.tag-1])
        
        // let item = self.arrShowServerDataImageSaved[sender.view.tag-1] as? [String:Any]
        // print(item as Any)
        
        if self.strShowImageDetailsFor == "prescription_list_from_pharmacy" {
            
            let item = self.arrShowServerDataImageSaved[sender.view.tag-1] as? [String:Any]
            print(item as Any)
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ShowImageId") as? ShowImage
            
            push!.imgGetMedicalHistory = (item!["image"] as! String)
            push!.strImageStatus = "Patient_Prescreption_List"
            
            self.navigationController?.pushViewController(push!, animated: true)
            
        } else {
           
            if self.strShowImageDetailsFor == "test" {
                let item = self.arrShowServerDataImageSaved[sender.view.tag-1] as? [String:Any]
                print(item as Any)
                print(self.strSaveTestId as Any)
                
                
                if (item!["tag"] as! String) == "addPicture" {
                    
                    showInputDialog(title: "Test Name",
                                    subtitle: "Please enter the Test Name.",
                                    actionTitle: "Add",
                                    cancelTitle: "Cancel",
                                    inputPlaceholder: "test name...",
                                    inputKeyboardType: .default, actionHandler:
                                        { (input:String?) in
                        print("The new number is \(input ?? "")")
                        
                        self.addImageOrEditImage = "0"
                        
                        self.strSaveTestName = "\(input ?? "")"
                        self.openCameraOrGalleryOption()
                    })
                    
                    
                   // for edit
                } else {
                    
                    self.saveTestIdOnlyForEdit = (item!["testsId"] as! String)
                    
                    showInputDialog(title: "Test Name",
                                    subtitle: "Please enter the Test Name.",
                                    actionTitle: "Add",
                                    cancelTitle: "Cancel",
                                    inputPlaceholder: "test name...",
                                    alreadyInputText: (item!["content"] as! String),
                                    inputKeyboardType: .default, actionHandler:
                                        { (input:String?) in
                        print("The new number is \(input ?? "")")
                        
                        self.addImageOrEditImage = "1" // for edit
                        
                        self.strSaveTestName = "\(input ?? "")"
                        self.openCameraOrGalleryOption()
                    })
                    
                    
                }
                
                
                /*if self.strSaveTestId == "0" {
                    self.addImageOrEditImage = "0" // for add
                } else {
                    self.addImageOrEditImage = "1" // for edit
                }*/
                
            } else {
                
                print(self.strSavePrescriptionId as Any)
                
                if self.strSavePrescriptionId == "0" {
                    self.addImageOrEditImage = "0" // for add
                } else {
                    self.addImageOrEditImage = "1" // for edit
                }
                
                self.openCameraOrGalleryOption()
                
            }
            
        }
        
        
        
        
        
    }
    
    @objc func openCameraOrGalleryOption() {
        print(self.strSaveTestName as Any)
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
        
        let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        let imageData:Data = image_data!.pngData()!
        imageStr1 = imageData.base64EncodedString()
        self.dismiss(animated: true, completion: nil)
        imgData1 = image_data!.jpegData(compressionQuality: 0.2)!
        
        
        self.imageStr1 = "1"
        
        if self.strShowImageDetailsFor == "test" {
            
            if self.strSaveTestId == "0" {
                
                if self.addImageOrEditImage == "0" {
                    self.uploadDataWithImage()
                } else {
                    self.editPrescriptionWB()
                }
                
            } else {
                // self.editPrescriptionWB()
                
                if self.addImageOrEditImage == "0" {
                    self.uploadDataWithImage()
                } else {
                    self.editPrescriptionWB()
                }
                
            }
            
        } else {
            
            if self.strSavePrescriptionId == "0" {
                self.uploadDataWithImage()
            } else {
                self.editPrescriptionWB()
            }
            
        }
        
        
    }
    
    // MARK:- WEBSERVICE ( UPLOAD IMAGE )
    @objc func uploadDataWithImage() {
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Uploading...")
        
        //Set Your URL
        let api_url = APPLICATION_BASE_URL
        
        guard let url = URL(string: api_url) else {
            return
        }
        
        /*if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
         // let str:String = person["role"] as! String
         
         let x : Int = person["userId"] as! Int
         let myString = String(x)*/
        
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //Set Your Parameter
        let parameterDict = NSMutableDictionary()
        
        if self.strShowImageDetailsFor == "test" {
            parameterDict.setValue("addtest", forKey: "action")
        } else {
            parameterDict.setValue("addprescription", forKey: "action")
        }
        
        
        parameterDict.setValue(String(self.strSavePatientId), forKey: "userId")
        parameterDict.setValue(String(self.strSaveDoctorId), forKey: "doctorId")
        parameterDict.setValue(String(self.strSaveHospitalId), forKey: "hospitalId")
        parameterDict.setValue(String(self.strSaveAppointmentId), forKey: "appointmentId")
        parameterDict.setValue(String(self.strSaveTestName), forKey: "content")
        
        print(parameterDict as Any)
        
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
            
            
            print(self.strClickedCellIndex as Any)
            
            multiPart.append(self.imgData1, withName: "image", fileName: "uploadPrescription.png", mimeType: "image/png")
            
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
                        self.navigationController?.popViewController(animated: true)
                        /*
                         msg = "Prescription confirm succssfully";
                         prescriptionId = 38;
                         status = success;
                         */
                        /*var dict: Dictionary<AnyHashable, Any>
                         dict = dictionary["data"] as! Dictionary<AnyHashable, Any>
                         
                         let defaults = UserDefaults.standard
                         defaults.setValue(dict, forKey: "keyLoginFullData")*/
                        
                        
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
        
        // }
        
    }
    
    // MARK:- WEBSERVICE ( UPLOAD IMAGE )
    @objc func editPrescriptionWB() {
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Editing...")
        
        //Set Your URL
        let api_url = APPLICATION_BASE_URL
        guard let url = URL(string: api_url) else {
            return
        }
        
        /*if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
         // let str:String = person["role"] as! String
         
         let x : Int = person["userId"] as! Int
         let myString = String(x)*/
        
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //Set Your Parameter
        let parameterDict = NSMutableDictionary()
        
        if self.strShowImageDetailsFor == "test" {
            
            parameterDict.setValue("edittest", forKey: "action")
            parameterDict.setValue(String(self.saveTestIdOnlyForEdit), forKey: "testId")
            parameterDict.setValue(String(self.strSaveTestName), forKey: "content")
            
        } else {
            parameterDict.setValue("editprescription", forKey: "action")
            parameterDict.setValue(String(self.strSavePrescriptionId), forKey: "prescriptionId")
        }
        
        print(parameterDict as Any)
        
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
            
             print(self.addImageOrEditImage as Any)
             print(self.strClickedCellIndex as Any)
            
            // self.strClickedCellIndex
             // edit
                
                if self.strClickedCellIndex == "1" { // collection view index ( count se +1 )
                    
                    multiPart.append(self.imgData1, withName: "image", fileName: "uploadPrescription.png", mimeType: "image/png")
                    
                } else {
                    
                    // let a: Int? = Int(firstTextField.text)
                    multiPart.append(self.imgData1, withName: "image_"+String(self.strClickedCellIndex), fileName: "uploadPrescription.png", mimeType: "image/png")
                    
                }
                
            
            
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
                        self.navigationController?.popViewController(animated: true)
                        
                        /*
                         msg = "Prescription confirm succssfully";
                         prescriptionId = 38;
                         status = success;
                         */
                        /*var dict: Dictionary<AnyHashable, Any>
                         dict = dictionary["data"] as! Dictionary<AnyHashable, Any>
                         
                         let defaults = UserDefaults.standard
                         defaults.setValue(dict, forKey: "keyLoginFullData")*/ ERProgressHud.sharedInstance.hide()
                        
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
        
        // }
        
    }
    
    
    
}

// MARK:- COLLECTION VIEW -
extension AddImages: UICollectionViewDelegate {
    
    //UICollectionViewDatasource methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
         return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        
        if self.strShowImageDetailsFor == "prescription" {
            
            print(self.arrShowServerDataImageSaved.count)
            
            if self.arrShowServerDataImageSaved.count > 5 {
                return 5
            } else if self.arrShowServerDataImageSaved.count <= 5 {
                return self.arrShowServerDataImageSaved.count
            } else {
                return self.arrShowServerDataImageSaved.count
            }
            
            
        } else if self.strShowImageDetailsFor == "test" {
            return self.arrShowServerDataImageSaved.count
        } else if self.strShowImageDetailsFor == "test_list_from_labs" || self.strShowImageDetailsFor == "prescription_list_from_pharmacy" {
            return self.arrShowServerDataImageSaved.count
        } else {
            return 0
        }
        
        
        
        
        
        
        
    }
    
    //Write Delegate Code Here
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addImagesCollectionCell", for: indexPath as IndexPath) as! AddImagesCollectionCell
       
        // MARK:- CELL CLASS -
        cell.layer.cornerRadius = 6
        cell.clipsToBounds = true
        cell.backgroundColor = .clear
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            if (person["role"] as! String) == "Patient" {
                
                if self.strShowImageDetailsFor == "prescription" {
                    
                    let item = self.arrShowServerDataImageSaved[indexPath.row] as? [String:Any]
                    // print(item as Any)
                    
                    /*
                     ["prescriptionId": 35, "userId": 189, "tag": , "image": , "doctorId": 192, "created": 2021-09-24T11:43:14+0530, "status": 1, "permission": 0, "hospitalId": 182, "appointmentId": 110]
                     */
                    
                    if (item!["tag"] as! String) == "addPicture" {
                        
                        cell.imgProfile.layer.borderColor = UIColor.clear.cgColor
                        cell.imgProfile.layer.borderWidth = 10
                        cell.imgProfile.layer.cornerRadius = 12
                        cell.imgProfile.clipsToBounds = true
                        cell.imgProfile.backgroundColor = .clear
                        
                        cell.imgProfile.image = UIImage(named: "add1")
                        cell.lblAddImageTitle.isHidden = true
                        
                    } else {
                        
                        cell.imgProfile.layer.borderColor = UIColor.lightGray.cgColor
                        cell.imgProfile.layer.borderWidth = 1
                        cell.imgProfile.layer.cornerRadius = 12
                        cell.imgProfile.clipsToBounds = true
                        cell.lblAddImageTitle.isHidden = true
                        
                        cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                        cell.imgProfile.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "1024"))
                        
                    }
                    cell.imgProfile.isHidden = false
                    
                } else if self.strShowImageDetailsFor == "test" {
                    let item = self.arrShowServerDataImageSaved[indexPath.row] as? [String:Any]
                    print(item as Any)
                    
                    if (item!["tag"] as! String) == "addPicture" {
                        
                        cell.imgProfile.layer.borderColor = UIColor.clear.cgColor
                        cell.imgProfile.layer.borderWidth = 10
                        cell.imgProfile.layer.cornerRadius = 12
                        cell.imgProfile.clipsToBounds = true
                        cell.imgProfile.backgroundColor = .clear
                        
                        cell.imgProfile.image = UIImage(named: "add1")
                        cell.lblAddImageTitle.isHidden = true
                        
                    } else {
                        
                        cell.imgProfile.layer.borderColor = UIColor.lightGray.cgColor
                        cell.imgProfile.layer.borderWidth = 1
                        cell.imgProfile.layer.cornerRadius = 12
                        cell.imgProfile.clipsToBounds = true
                        
                        if (item!["content"] as! String) == "" {
                            cell.lblAddImageTitle.text = "N.A."
                        } else {
                            cell.lblAddImageTitle.text = (item!["content"] as! String)
                        }
                        
                        
                        cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                        cell.imgProfile.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "1024"))
                        
                    }
                    
                    cell.imgProfile.isHidden = false
                }
                
            } else if (person["role"] as! String) == "Hospital" {
                
                if self.strShowImageDetailsFor == "prescription" {
                    
                    let item = self.arrShowServerDataImageSaved[indexPath.row] as? [String:Any]
                    // print(item as Any)
                    
                    /*
                     ["prescriptionId": 35, "userId": 189, "tag": , "image": , "doctorId": 192, "created": 2021-09-24T11:43:14+0530, "status": 1, "permission": 0, "hospitalId": 182, "appointmentId": 110]
                     */
                    
                    if (item!["tag"] as! String) == "addPicture" {
                        
                        cell.imgProfile.layer.borderColor = UIColor.clear.cgColor
                        cell.imgProfile.layer.borderWidth = 10
                        cell.imgProfile.layer.cornerRadius = 12
                        cell.imgProfile.clipsToBounds = true
                        cell.imgProfile.backgroundColor = .clear
                        
                        cell.imgProfile.image = UIImage(named: "add1")
                        cell.lblAddImageTitle.isHidden = true
                        
                    } else {
                        
                        cell.imgProfile.layer.borderColor = UIColor.lightGray.cgColor
                        cell.imgProfile.layer.borderWidth = 1
                        cell.imgProfile.layer.cornerRadius = 12
                        cell.imgProfile.clipsToBounds = true
                        cell.lblAddImageTitle.isHidden = true
                        
                        cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                        cell.imgProfile.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "1024"))
                        
                    }
                    cell.imgProfile.isHidden = false
                    
                } else if self.strShowImageDetailsFor == "test" {
                    let item = self.arrShowServerDataImageSaved[indexPath.row] as? [String:Any]
                    print(item as Any)
                    
                    if (item!["tag"] as! String) == "addPicture" {
                        
                        cell.imgProfile.layer.borderColor = UIColor.clear.cgColor
                        cell.imgProfile.layer.borderWidth = 10
                        cell.imgProfile.layer.cornerRadius = 12
                        cell.imgProfile.clipsToBounds = true
                        cell.imgProfile.backgroundColor = .clear
                        
                        cell.imgProfile.image = UIImage(named: "add1")
                        cell.lblAddImageTitle.isHidden = true
                        
                    } else {
                        
                        cell.imgProfile.layer.borderColor = UIColor.lightGray.cgColor
                        cell.imgProfile.layer.borderWidth = 1
                        cell.imgProfile.layer.cornerRadius = 12
                        cell.imgProfile.clipsToBounds = true
                        
                        if (item!["content"] as! String) == "" {
                            cell.lblAddImageTitle.text = "N.A."
                        } else {
                            cell.lblAddImageTitle.text = (item!["content"] as! String)
                        }
                        
                        
                        cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                        cell.imgProfile.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "1024"))
                        
                    }
                    
                    cell.imgProfile.isHidden = false
                }
                
            } else if (person["role"] as! String) == "Lab" {
                
                if self.strShowImageDetailsFor == "prescription_list_from_labs" {
                    
                    let item = self.arrShowServerDataImageSaved[indexPath.row] as? [String:Any]
                    // print(item as Any)
                    
                    /*
                     ["prescriptionId": 35, "userId": 189, "tag": , "image": , "doctorId": 192, "created": 2021-09-24T11:43:14+0530, "status": 1, "permission": 0, "hospitalId": 182, "appointmentId": 110]
                     */
                    
                    if (item!["tag"] as! String) == "addPicture" {
                        
                        cell.imgProfile.layer.borderColor = UIColor.clear.cgColor
                        cell.imgProfile.layer.borderWidth = 10
                        cell.imgProfile.layer.cornerRadius = 12
                        cell.imgProfile.clipsToBounds = true
                        cell.imgProfile.backgroundColor = .clear
                        
                        cell.imgProfile.image = UIImage(named: "add1")
                        cell.lblAddImageTitle.isHidden = true
                        
                    } else {
                        
                        cell.imgProfile.layer.borderColor = UIColor.lightGray.cgColor
                        cell.imgProfile.layer.borderWidth = 1
                        cell.imgProfile.layer.cornerRadius = 12
                        cell.imgProfile.clipsToBounds = true
                        cell.lblAddImageTitle.isHidden = true
                        
                        cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                        cell.imgProfile.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "1024"))
                        
                    }
                    cell.imgProfile.isHidden = false
                    
                } else if self.strShowImageDetailsFor == "test_list_from_labs" {
                    let item = self.arrShowServerDataImageSaved[indexPath.row] as? [String:Any]
                    print(item as Any)
                    
                    if (item!["tag"] as! String) == "addPicture" {
                        
                        cell.imgProfile.layer.borderColor = UIColor.clear.cgColor
                        cell.imgProfile.layer.borderWidth = 10
                        cell.imgProfile.layer.cornerRadius = 12
                        cell.imgProfile.clipsToBounds = true
                        cell.imgProfile.backgroundColor = .clear
                        
                        cell.imgProfile.image = UIImage(named: "add1")
                        cell.lblAddImageTitle.isHidden = true
                        
                    } else {
                        
                        cell.imgProfile.layer.borderColor = UIColor.lightGray.cgColor
                        cell.imgProfile.layer.borderWidth = 1
                        cell.imgProfile.layer.cornerRadius = 12
                        cell.imgProfile.clipsToBounds = true
                        
                        if (item!["content"] as! String) == "" {
                            cell.lblAddImageTitle.text = "N.A."
                        } else {
                            cell.lblAddImageTitle.text = (item!["content"] as! String)
                        }
                        
                        
                        cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                        cell.imgProfile.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "1024"))
                        
                    }
                    
                    cell.imgProfile.isHidden = false
                }
                
            } else {
                
                if self.strShowImageDetailsFor == "prescription" {
                    
                    let item = self.arrShowServerDataImageSaved[indexPath.row] as? [String:Any]
                    // print(item as Any)
                    
                    /*
                     ["prescriptionId": 35, "userId": 189, "tag": , "image": , "doctorId": 192, "created": 2021-09-24T11:43:14+0530, "status": 1, "permission": 0, "hospitalId": 182, "appointmentId": 110]
                     */
                    
                    if (item!["tag"] as! String) == "addPicture" {
                        
                        cell.imgProfile.layer.borderColor = UIColor.systemTeal.cgColor
                        cell.imgProfile.layer.borderWidth = 10
                        cell.imgProfile.layer.cornerRadius = 12
                        cell.imgProfile.clipsToBounds = true
                        
                        cell.imgProfile.image = UIImage(named: "add")
                        
                    } else {
                        
                        cell.imgProfile.layer.borderColor = UIColor.lightGray.cgColor
                        cell.imgProfile.layer.borderWidth = 1
                        cell.imgProfile.layer.cornerRadius = 12
                        cell.imgProfile.clipsToBounds = true
                        
                        cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                        cell.imgProfile.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "1024"))
                        
                    }
                    
                    cell.imgProfile.tag = indexPath.row+1
                    
                    let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(AddImages.cellTappedMethod1(_:)))
                    cell.imgProfile.isUserInteractionEnabled = true
                    cell.imgProfile.addGestureRecognizer(tapGestureRecognizer1)
                    
                } else if self.strShowImageDetailsFor == "test" {
                    let item = self.arrShowServerDataImageSaved[indexPath.row] as? [String:Any]
                    print(item as Any)
                    
                    if (item!["tag"] as! String) == "addPicture" {
                        
                        cell.imgProfile.layer.borderColor = UIColor.systemTeal.cgColor
                        cell.imgProfile.layer.borderWidth = 10
                        cell.imgProfile.layer.cornerRadius = 12
                        cell.imgProfile.clipsToBounds = true
                        
                        cell.lblAddImageTitle.text = ""
                        
                        cell.imgProfile.image = UIImage(named: "add")
                        
                    } else {
                        
                        cell.imgProfile.layer.borderColor = UIColor.lightGray.cgColor
                        cell.imgProfile.layer.borderWidth = 1
                        cell.imgProfile.layer.cornerRadius = 12
                        cell.imgProfile.clipsToBounds = true
                        
                        if (item!["content"] as! String) == "" {
                            cell.lblAddImageTitle.text = "N.A."
                        } else {
                            cell.lblAddImageTitle.text = (item!["content"] as! String)
                        }
                        
                        
                        cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                        cell.imgProfile.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "1024"))
                        
                    }
                    
                    cell.imgProfile.tag = indexPath.row+1
                    
                    let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(AddImages.cellTappedMethod1(_:)))
                    cell.imgProfile.isUserInteractionEnabled = true
                    cell.imgProfile.addGestureRecognizer(tapGestureRecognizer1)
                    
                    
                } else if self.strShowImageDetailsFor == "prescription_list_from_pharmacy" {
                    
                    let item = self.arrShowServerDataImageSaved[indexPath.row] as? [String:Any]
                    // print(item as Any)
                    
                    /*
                     ["prescriptionId": 35, "userId": 189, "tag": , "image": , "doctorId": 192, "created": 2021-09-24T11:43:14+0530, "status": 1, "permission": 0, "hospitalId": 182, "appointmentId": 110]
                     */
                    
                    if (item!["tag"] as! String) == "addPicture" {
                        
                        cell.imgProfile.layer.borderColor = UIColor.systemTeal.cgColor
                        cell.imgProfile.layer.borderWidth = 10
                        cell.imgProfile.layer.cornerRadius = 12
                        cell.imgProfile.clipsToBounds = true
                        
                        cell.imgProfile.image = UIImage(named: "add")
                        
                    } else {
                        
                        cell.lblAddImageTitle.text = ""
                        
                        cell.imgProfile.layer.borderColor = UIColor.lightGray.cgColor
                        cell.imgProfile.layer.borderWidth = 1
                        cell.imgProfile.layer.cornerRadius = 12
                        cell.imgProfile.clipsToBounds = true
                        
                        cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                        cell.imgProfile.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "1024"))
                        
                    }
                    
                    cell.imgProfile.tag = indexPath.row+1
                    
                    let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(AddImages.cellTappedMethod1(_:)))
                    cell.imgProfile.isUserInteractionEnabled = true
                    cell.imgProfile.addGestureRecognizer(tapGestureRecognizer1)
                    
                } else if self.strShowImageDetailsFor == "test" {
                    let item = self.arrShowServerDataImageSaved[indexPath.row] as? [String:Any]
                    print(item as Any)
                    
                    if (item!["tag"] as! String) == "addPicture" {
                        
                        cell.imgProfile.layer.borderColor = UIColor.systemTeal.cgColor
                        cell.imgProfile.layer.borderWidth = 10
                        cell.imgProfile.layer.cornerRadius = 12
                        cell.imgProfile.clipsToBounds = true
                        
                        cell.lblAddImageTitle.text = ""
                        
                        cell.imgProfile.image = UIImage(named: "add")
                        
                    } else {
                        
                        cell.imgProfile.layer.borderColor = UIColor.lightGray.cgColor
                        cell.imgProfile.layer.borderWidth = 1
                        cell.imgProfile.layer.cornerRadius = 12
                        cell.imgProfile.clipsToBounds = true
                        
                        if (item!["content"] as! String) == "" {
                            cell.lblAddImageTitle.text = ""
                        } else {
                            cell.lblAddImageTitle.text = ""
                        }
                        
                        
                        cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                        cell.imgProfile.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "1024"))
                        
                    }
                    
                    cell.imgProfile.tag = indexPath.row+1
                    
                    let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(AddImages.cellTappedMethod1(_:)))
                    cell.imgProfile.isUserInteractionEnabled = true
                    cell.imgProfile.addGestureRecognizer(tapGestureRecognizer1)
                    
                }
                
            }
            
        }
        
        
        return cell
    }
    
}

extension AddImages: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("clicked")
        
        let item = self.arrShowServerDataImageSaved[indexPath.row] as? [String:Any]
        print(item as Any)
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ShowImageId") as? ShowImage
        
        push!.imgGetMedicalHistory = (item!["image"] as! String)
        push!.strImageStatus = "Patient_Prescreption_List"
        
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
}

extension AddImages: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var sizes: CGSize
        let result = UIScreen.main.bounds.size
        NSLog("%f",result.height)
        
        if result.height == 844 {
            
            print("i am iPhone 12")
            sizes = CGSize(width: 128, height: 180)
        } else if result.height == 812 {
            
            print("i am iPhone 12 mini")
            sizes = CGSize(width: 120, height: 180)
        } else {
            
            sizes = CGSize(width: 130, height: 180)
         }
        
        return sizes
        
        
     }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
            return 1
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        // var sizes: CGSize
        let result = UIScreen.main.bounds.size
        NSLog("%f",result.height)
        
        if result.height == 926 {
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        } else {
            return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        }
        
    }
    
    
}

