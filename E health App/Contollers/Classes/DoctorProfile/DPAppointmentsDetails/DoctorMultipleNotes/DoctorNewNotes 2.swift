//
//  DoctorNewNotes.swift
//  E health App
//
//  Created by apple on 24/09/21.
//

import UIKit
import Alamofire
import SDWebImage

class DoctorNewNotes: UIViewController {

    var strSaveAppointmentId:String!
    var strSaveDoctorId:String!
    var strSaveHospitalId:String!
    var strSavePatientId:String!
    var strSaveNotesId:String! = "0"
    
    var getAppointmentDetailsIn:NSDictionary!
    
    var strShowImageDetailsFor:String!
    var arrTotalImagesList:NSMutableArray! = []
    
    var arAppendAllNotes : NSArray!
    
    @IBOutlet weak var viewNavigationbar:UIView!
    @IBOutlet weak var btnDashboardMenu: UIButton!
    @IBOutlet weak var lblNavationbar:UILabel!{
        didSet {
            lblNavationbar.text = "Notes"
        }
    }
    
    @IBOutlet weak var notesView:UIView! {
        didSet {
            notesView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            notesView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            notesView.layer.shadowOpacity = 1.0
            notesView.layer.shadowRadius = 15.0
            notesView.layer.masksToBounds = false
            notesView.layer.cornerRadius = 15
            notesView.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var txtView:UITextView! {
        didSet {
            txtView.backgroundColor = .clear
            txtView.text = ""
            txtView.textColor = .black
            txtView.layer.borderWidth = 1
            txtView.layer.borderColor = UIColor.lightGray.cgColor
            txtView.layer.cornerRadius = 6
            txtView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btnSupplierAddress:UIButton! {
        didSet {
            btnSupplierAddress.layer.cornerRadius = 6
            btnSupplierAddress.clipsToBounds = true
            btnSupplierAddress.layer.borderColor = UIColor.clear.cgColor
            btnSupplierAddress.layer.borderWidth = 1
        }
    }
    
    @IBOutlet weak var btnPlus:UIButton! {
        didSet {
            btnPlus.tintColor = .white
        }
    }
    
    @IBOutlet weak var tbleView:UITableView! {
        didSet {
            tbleView.backgroundColor =  .white
            tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        // tablView.backgroundColor =  .white
        self.navigationController?.isNavigationBarHidden = true
        // self.tablView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        
        self.tbleView.separatorColor = .clear
        
         
        self.arAppendAllNotes = (self.getAppointmentDetailsIn["notes"] as! Array<Any>) as NSArray
        
        //
         // print(arAppendAllNotes as Any)
        // print(ar.count)
        /*
         appointmentId = 118;
         content = "New one of the";
         created = "2021-09-24T19:13:10+0530";
         doctorId = 193;
         hospitalId = 182;
         image = "";
         notesId = 34;
         permission = 0;
         status = 1;
         userId = 190;
         */
        // self.arrTotalImagesList = ((self.getAppointmentDetailsIn["notes"] as! Array<Any>) as! NSMutableArray)
        // print(self.arrTotalImagesList as Any)
        
        // self.arrTotalImagesList.add(ar as Any)
        
        self.tbleView.delegate = self
        self.tbleView.dataSource = self
        self.tbleView.reloadData()
        
        self.btnDashboardMenu.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        self.btnPlus.addTarget(self, action: #selector(plusClickMethod), for: .touchUpInside)
        
        
        
        
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
         
            if (person["role"] as! String) == "Patient" {
                self.btnPlus.isHidden = true
            } else {
                self.btnPlus.isHidden = false
            }
            
        }
        
        self.allNotesListWB()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let userDefaults = UserDefaults.standard

        let myString = userDefaults.string(forKey: "keySuccessSetNotes")
        
        if myString == "successSetNotes" {
            self.allNotesListWB()
        }
        
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func plusClickMethod() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddNewNoteId") as? AddNewNote
        push!.strAddOrEdit = "add"
        push!.getAllDataOfThatpatient = self.getAppointmentDetailsIn
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    @objc func allNotesListWB() {
        let userDefaults = UserDefaults.standard
        userDefaults.set("", forKey: "keySuccessSetNotes")
        userDefaults.set(nil, forKey: "keySuccessSetNotes")
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "please wait...")
        
        self.view.endEditing(true)
        
        let x : Int = (self.getAppointmentDetailsIn["appointmentId"] as! Int)
        let myString = String(x)
        
        let x2 : Int = (self.getAppointmentDetailsIn["doctorId"] as! Int)
        let myString2 = String(x2)
        
        /*var strHospitalId:String! = "0"
        // HOSPITAL
        if self.getAppointmentDetailsIn["hospitalId"] is String {
                          
            strHospitalId = (self.getAppointmentDetailsIn["hospitalId"] as! String)
            
        } else if self.getAppointmentDetailsIn["hospitalId"] is Int {
            
            let x3 : Int = (self.getAppointmentDetailsIn["hospitalId"] as! Int)
            let myString3 = String(x3)
             
            strHospitalId = String(myString3)
        }*/
        
        let x4 : Int = (self.getAppointmentDetailsIn["userId"] as! Int)
        let myString4 = String(x4)
        
        let params = Doctor_All_Notes_List(action: "noteslist",
                                           userId: String(myString4),
                                           doctorId: String(myString2),
                                           appointmentId: String(myString))
        
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
                        strSuccess = JSON["status"]as Any as? String
                        
                        // var strSuccess2 : String!
                        // strSuccess2 = JSON["msg"]as Any as? String
                        
                        if strSuccess == String("success") {
                            print("yes")
                            
                            ERProgressHud.sharedInstance.hide()
                            
                            self.arAppendAllNotes = (JSON["data"] as! Array<Any>) as NSArray
                            
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

extension DoctorNewNotes:UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arAppendAllNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:DoctorNewNotesTableCell = tableView.dequeueReusableCell(withIdentifier: "doctorNewNotesTableCell") as! DoctorNewNotesTableCell
        
        cell.backgroundColor = .white
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        // print(self.dictGetBookingDetailsForDoctors as Any)
        
        let item = self.arAppendAllNotes[indexPath.row] as? [String:Any]
        // print(item as Any)
        
        cell.lblTitle.text = (item!["content"] as! String)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = self.arAppendAllNotes[indexPath.row] as? [String:Any]
       
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddNewNoteId") as? AddNewNote
        push!.strAddOrEdit = "edit"
        push!.getAllDataOfThatpatient = item as NSDictionary?
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let item = self.arAppendAllNotes[indexPath.row] as? [String:Any]
        // print(item as Any)
        
        if (item!["content"] as! String).count > 100 {
            return 120
        } else {
            return 80
        }
        
    }
    
}
