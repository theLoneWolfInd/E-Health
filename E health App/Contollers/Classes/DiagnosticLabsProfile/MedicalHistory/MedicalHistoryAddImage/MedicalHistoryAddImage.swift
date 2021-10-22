//
//  MedicalHistoryAddImage.swift
//  E health App
//
//  Created by apple on 12/10/21.
//

import UIKit
import Alamofire
import SDWebImage

import AVFoundation
import Photos

class MedicalHistoryAddImage: UIViewController , UINavigationControllerDelegate , UIImagePickerControllerDelegate {

    var dictGetPatientMedical:NSDictionary!
    
    var arrTotalMedicalHistoryPage:NSMutableArray! = []
    
    var intWhichIndexClicked:Int!
    
    var imageStr1:String!
    var imgData1:Data!
    
    @IBOutlet weak var viewNavigationbar:UIView!
    @IBOutlet weak var btnDashboardMenu: UIButton!
    @IBOutlet weak var lblNavationbar:UILabel!{
        didSet {
            lblNavationbar.text = "UPLOAD MEDICAL REPORTS"
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
        
        
        // print(self.dictGetPatientMedical as Any)
        
        self.clView.delegate = self
        self.clView.dataSource = self
        self.clView.reloadData()
        
        // var ar : NSArray!
        // ar = (self.dictGetPatientMedical["prescription"] as! Array<Any>) as NSArray
        
        // print(ar as Any)
        // medical_history_image
        /*for indexx in 0...4 {
            
            
            
            
            
        }*/
        
        
        
        
        
        // print(self.arrTotalMedicalHistoryPage as Any)
        
    }

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
    
}

// MARK:- COLLECTION VIEW -
extension MedicalHistoryAddImage: UICollectionViewDelegate {
    
    //UICollectionViewDatasource methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
         return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 5
        
    }
    
    //Write Delegate Code Here
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "medicalHistoryAddImagesCollectionCell", for: indexPath as IndexPath) as! MedicalHistoryAddImagesCollectionCell
       
        // MARK:- CELL CLASS -
        cell.layer.cornerRadius = 6
        cell.clipsToBounds = true
        cell.backgroundColor = .clear
        
        if indexPath.row == 0 {
            
            cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.imgProfile.sd_setImage(with: URL(string: (self.dictGetPatientMedical["medical_history_image"] as! String)), placeholderImage: UIImage(named: "1024"))
            
        } else if indexPath.row == 1 {
              
            cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.imgProfile.sd_setImage(with: URL(string: (self.dictGetPatientMedical["medical_history_image_2"] as! String)), placeholderImage: UIImage(named: "1024"))
            
        } else if indexPath.row == 2 {
            
            cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.imgProfile.sd_setImage(with: URL(string: (self.dictGetPatientMedical["medical_history_image_3"] as! String)), placeholderImage: UIImage(named: "1024"))
            
        } else if indexPath.row == 3 {
            
            cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.imgProfile.sd_setImage(with: URL(string: (self.dictGetPatientMedical["medical_history_image_4"] as! String)), placeholderImage: UIImage(named: "1024"))
            
        } else if indexPath.row == 4 {
          
            cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.imgProfile.sd_setImage(with: URL(string: (self.dictGetPatientMedical["medical_history_image_5"] as! String)), placeholderImage: UIImage(named: "1024"))
            
        }
        
        
        return cell
    }
    
}

extension MedicalHistoryAddImage: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("clicked")
        
        self.intWhichIndexClicked = indexPath.row+1
        print(self.intWhichIndexClicked as Any)
        
        /*let x : Int = self.intWhichIndexClicked!
        let myString = String(x)
        
        print(self.dictGetPatientMedical["medical_history_image_"+myString] as! String)*/
        
        self.uploadMedicalHistoryImages()
        
    }
    
    
    @objc func uploadMedicalHistoryImages() {
        // print(self.strSaveTestName as Any)
        let alert = UIAlertController(title: "Upload Medical History", message: nil, preferredStyle: .actionSheet)
        
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
        self.imageStr1 = imageData.base64EncodedString()
        self.dismiss(animated: true, completion: nil)
        self.imgData1 = image_data!.jpegData(compressionQuality: 0.2)!
        
        self.imageStr1 = "1"
        
        /*
         if self.addImageOrEditImage == "0" {
         self.uploadDataWithImage()
         } else {
         self.editPrescriptionWB()
         }
         */
        
        self.uploadMedicalHistoryImageToServerWB()
        
    }
    
    @objc func uploadMedicalHistoryImageToServerWB() {
        
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
        let x : Int = self.dictGetPatientMedical["medicalhistoryId"] as! Int
        let myString = String(x)
        
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //Set Your Parameter
        let parameterDict = NSMutableDictionary()
        
        parameterDict.setValue("editmedicalhistory", forKey: "action")
        parameterDict.setValue(String(myString), forKey: "medicalHistoryId")
        
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
            
            
            if self.intWhichIndexClicked == 1 {
                multiPart.append(self.imgData1, withName: "image", fileName: "uploadMedicalHistory.png", mimeType: "image/png")
            } else {
                multiPart.append(self.imgData1, withName: "image_\(self.intWhichIndexClicked!)", fileName: "uploadMedicalHistory.png", mimeType: "image/png")
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
                        
                        if (dictionary["status"] as! String) == "success" {
                            
                            let alert = NewYorkAlertController(title: "Success", message: (dictionary["msg"] as! String), style: .alert)

                            alert.addImage(UIImage.gif(name: "success3"))
                            
                            let cancel = NewYorkButton(title: "Ok", style: .cancel) { _ in
                                self.backClickMethod()
                            }
                            alert.addButtons([cancel])

                            self.present(alert, animated: true)
                            
                            
                            
                        } else {
                            
                            let alert = NewYorkAlertController(title: "Alert", message: (dictionary["msg"] as! String), style: .alert)
                            
                            alert.addImage(UIImage(named: "sorry"))
                            
                            let cancel = NewYorkButton(title: "Ok", style: .cancel)
                            alert.addButtons([cancel])
                            
                            self.present(alert, animated: true)
                            
                        }
                        
                        
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

extension MedicalHistoryAddImage: UICollectionViewDelegateFlowLayout {
    
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

