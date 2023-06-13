//
//  PatientEhealthCard.swift
//  E health App
//
//  Created by apple on 20/09/21.
//

import UIKit
import SDWebImage
import Alamofire

class PatientEhealthCard: UIViewController {

    @IBOutlet weak var btnDashboardMenu: UIButton!
    
    
    @IBOutlet weak var viewCardBG:UIView! {
        didSet {
            viewCardBG.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            viewCardBG.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            viewCardBG.layer.shadowOpacity = 1.0
            viewCardBG.layer.shadowRadius = 15.0
            viewCardBG.layer.masksToBounds = false
            viewCardBG.layer.cornerRadius = 15
            viewCardBG.backgroundColor = .white
            viewCardBG.layer.cornerRadius = 12
            viewCardBG.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var imgViewProfile:UIImageView! {
        didSet {
            imgViewProfile.layer.cornerRadius = 8
            imgViewProfile.clipsToBounds = true
            imgViewProfile.layer.borderWidth = 1
            imgViewProfile.layer.borderColor = UIColor.lightGray.cgColor
            imgViewProfile.image = UIImage(named: "1024")
        }
    }
    @IBOutlet weak var lblFirstName:UILabel! {
        didSet {
            lblFirstName.textColor = .black
            lblFirstName.text = ""
        }
    }
    @IBOutlet weak var lblMiddleName:UILabel! {
        didSet {
            lblMiddleName.textColor = .black
            lblMiddleName.text = ""
        }
    }
    @IBOutlet weak var lblLastName:UILabel! {
        didSet {
            lblLastName.textColor = .black
            lblLastName.text = ""
        }
    }
    @IBOutlet weak var lblUniqueIdName:UILabel! {
        didSet {
            lblUniqueIdName.textColor = .black
            lblUniqueIdName.text = ""
            lblUniqueIdName.numberOfLines = 0
        }
    }
    @IBOutlet weak var lblIssueDate:UILabel! {
        didSet {
            lblIssueDate.textColor = .black
            lblIssueDate.text = ""
            lblIssueDate.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var lblExpDate:UILabel! {
        didSet {
            lblExpDate.textColor = .black
            lblExpDate.text = ""
            lblExpDate.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var btnDownload:UIButton! {
        didSet {
            btnDownload.backgroundColor = .systemOrange
            btnDownload.layer.cornerRadius = 22
            btnDownload.clipsToBounds = true
            btnDownload.setTitle("Download", for: .normal)
            btnDownload.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBOutlet weak var lblCountryName:UILabel! {
        didSet {
            lblCountryName.textColor = .systemRed
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblCountryName.isHidden = true
        
        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
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
        
        self.btnDownload.addTarget(self, action: #selector(saveThisCardToGallery), for: .touchUpInside)
        
        self.getPatientHealthCard()
        
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
    
    @objc func getPatientHealthCard() {
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        self.view.endEditing(true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            let params = PatientEHealthMedicalCard(action: "medicalcard",
                                                   userId: String(myString))
            
            print(params as Any)
            
            AF.request(APPLICATION_BASE_URL,
                       method: .post,
                       parameters: params,
                       encoder: JSONParameterEncoder.default).responseJSON { [self] response in
                        // debugPrint(response.result)
                        
                        switch response.result {
                        case let .success(value):
                            
                            let JSON = value as! NSDictionary
                            print(JSON as Any)
                            
                            var strSuccess : String!
                            strSuccess = JSON["status"]as Any as? String
                            
                            // var strSuccess2 : String!
                            // strSuccess2 = JSON["msg"]as Any as? String
                            
                            if strSuccess == String("success") {
                                print("yes")
                                
                                ERProgressHud.sharedInstance.hide()
                                
                                /*
                                 country = India;
                                 expireDate = "2022-09-22";
                                 fullName = Maxp1;
                                 image = "";
                                 issueDate = "2021-09-22";
                                 lastName = one;
                                 medicalCardID = "16323-82388";
                                 middleName = new;
                                 userId = 190;
                                 */
                                
                                self.lblCountryName.isHidden = false
                                
                                var dict: Dictionary<AnyHashable, Any>
                                dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                
                                self.lblFirstName.text      = (dict["fullName"] as! String)
                                self.lblMiddleName.text     = (dict["middleName"] as! String)
                                self.lblLastName.text       = (dict["lastName"] as! String)
                                self.lblUniqueIdName.text   = (dict["medicalCardID"] as! String)
                                self.lblIssueDate.text      = (dict["issueDate"] as! String)
                                self.lblExpDate.text        = (dict["expireDate"] as! String)
                                
                                // self.lblCountryName.text = (dict["country"] as! String)
                                let str =  (dict["country"] as! String)
                                let arr = str.map { String($0) }
                                print(arr)
                                
                                let formatter = ListFormatter()
                                if let string = formatter.string(from: arr) {
                                    print(string)
                                    
                                    let str1 = string.replacingOccurrences(of: " ", with: "")
                                    let str2 = str1.replacingOccurrences(of: ",and", with: ",")
                                    let str3 = str2.replacingOccurrences(of: ",", with: "\n")
                                    self.lblCountryName.text = str3.uppercased()
                                    
                                    // self.lblCountryName.transform = CGAffineTransform(rotationAngle:-CGFloat.pi/2)
                                }
                                
                                self.imgViewProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                                self.imgViewProfile.sd_setImage(with: URL(string: (dict["image"] as! String)), placeholderImage: UIImage(named: "1024"))
                                
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
    
    @objc func saveThisCardToGallery() {
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "downloading...")
        
        let image = self.viewCardBG.makeSnapshot()
        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        if let error = error {
            ERProgressHud.sharedInstance.hide()
            
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            
        } else {
            ERProgressHud.sharedInstance.hide()
            
            let ac = UIAlertController(title: "Saved!", message: "Your E - Health Card has been saved to your Gallery.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            
        }
        
    }

}

extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}

extension UIView {

    func takeScreenshot() -> UIImage {

        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)

        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)

        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
}

extension CALayer {
    func makeSnapshot() -> UIImage? {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(frame.size, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        render(in: context)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        return screenshot
    }
}

extension UIView {
    func makeSnapshot() -> UIImage? {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(size: frame.size)
            return renderer.image { _ in drawHierarchy(in: bounds, afterScreenUpdates: true) }
        } else {
            return layer.makeSnapshot()
        }
    }
}

class VerticalLabel : UILabel {
    
    private var _text : String? = nil
    
    override var text : String? {
        get {
            return _text
        }
        set {
            self.numberOfLines = 0
            self.textAlignment = .center
            self.lineBreakMode = .byWordWrapping
            _text = newValue
            if let t = _text {
                var s = ""
                for c in t {
                    s += "\(c)\n"
                }
                super.text = s
            }
        }
    }
    
}
