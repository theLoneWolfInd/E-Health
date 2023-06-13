//
//  Reports.swift
//  E health App
//
//  Created by apple on 07/02/22.
//

import UIKit
import Alamofire
import SDWebImage

class Reports: UIViewController {
    
    var arr_list_of_all_reports:NSMutableArray = []
    
    var report_data = ["Today" , "Weekly" , "Monthly" , "Yearly" , "Custom"]
    
    var hospital_status_check:String!
    var str_payment_Status:String! = "1"
    
    var str_lab_test_Status:String!
    var str_pharmacy_prescription_Status:String!
    
    @IBOutlet weak var viewNavigationbar:UIView!
    @IBOutlet weak var btnDashboardMenu: UIButton!
    @IBOutlet weak var lblNavationbar:UILabel! {
        didSet {
            lblNavationbar.text = "Reports"
        }
    }
    
    @IBOutlet weak var tablView:UITableView! {
        didSet {
            tablView.delegate = self
            tablView.dataSource = self
            tablView.backgroundColor =  .white
            tablView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tablView.separatorStyle = UITableViewCell.SeparatorStyle.none
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
            if (person["role"] as! String) == "Hospital" {
                
                if self.hospital_status_check == "yes" {
                    self.lblNavationbar.text = "Appointments"
                } else {
                    self.lblNavationbar.text = "Reports"
                }
                
                
            } else if (person["role"] as! String) == "Doctor" {
                
                self.lblNavationbar.text = "APPOINTMENTS"
                
            } else if (person["role"] as! String) == "Lab" || (person["role"] as! String) == "Pharmacy"  {
                
                if self.str_pharmacy_prescription_Status != nil {
                    
                    self.lblNavationbar.text = "Prescriptions"
                    
                } else {
                    
                    if self.str_lab_test_Status == nil {
                        self.lblNavationbar.text = "Records"
                    } else {
                        self.lblNavationbar.text = "Tests"
                    }
                    
                }
                
                
                
                
            } else if (person["role"] as! String) == "Supplier" {
                
                self.lblNavationbar.text = "ORDERS"
                
            }
        }
        
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
    
    @objc func segment_control_click_method() {
        
        // str_payment_Status
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! ReportsTableCell
        
        print(cell.segment_controll.selectedSegmentIndex as Any)
        
        if cell.segment_controll.selectedSegmentIndex == 0 {
            
            self.str_payment_Status = "1"
            
        } else {
            
            self.str_payment_Status = "0"
            
        }
        
    }
    
    
    @objc func show_test_or_prescripption_images(str_action:String,
                                                 str_start_Date:String,
                                                 str_end_date:String,
                                                 str_keyword:String) {
        // self.arrListOfAppoitmentList.removeAllObjects()
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        self.view.endEditing(true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
            
            let params = test_or_prescription(action: String(str_action),
                                              userId: String(myString),
                                              start_date: String(str_start_Date),
                                              end_date: String(str_end_date),
                                              keyword: String(str_keyword))
            
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
                    strSuccess = JSON["status"]as Any as? String
                    
                    // var strSuccess2 : String!
                    // strSuccess2 = JSON["msg"]as Any as? String
                    
                    if strSuccess == String("success") {
                        print("yes")
                        
                        ERProgressHud.sharedInstance.hide()
                        
                        if str_action == "activetest" {
                            
                            var ar : NSArray!
                            ar = (JSON["data"] as! Array<Any>) as NSArray
                            // self.arrListOfAllHistory.addObjects(from: ar as! [Any])
                            
                            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddImagesId") as? AddImages
                            
                            // push!.imgGetMedicalHistory = (self.dictSupplierLoginData["image"] as! String)
                            push!.strShowImageDetailsFor = "test_list_from_labs"
                            push!.arr_list_of_all_test_from_labs = ar!
                            
                            self.navigationController?.pushViewController(push!, animated: true)
                            
                        } else {
                            
                            var ar : NSArray!
                            ar = (JSON["data"] as! Array<Any>) as NSArray
                            
                            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PharmacyPrescriptionListId") as? PharmacyPrescriptionList
                            
                            // push!.arr_mut_get_prescription_list = (ar! as! NSMutableArray)
                            push!.arr_ar_get_prescription_list = ar
                            self.navigationController?.pushViewController(push!, animated: true)
                            
                        }
                        
                        
                        
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
     let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddImagesId") as? AddImages
     
     // push!
     push!.strShowImageDetailsFor = "prescription_list_from_pharmacy"
     push!.dict_get_pharmacy_prescription = item! as NSDictionary
     
     self.navigationController?.pushViewController(push!, animated: true)
     */
}

extension Reports:UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0 {
            
            let cell:ReportsTableCell = tablView.dequeueReusableCell(withIdentifier: "cell1") as! ReportsTableCell
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.backgroundColor = .white
            
            cell.segment_controll.addTarget(self, action: #selector(segment_control_click_method), for: .valueChanged)
            
            return cell
            
        } else if indexPath.row == 1 {
            
            let cell:ReportsTableCell = tablView.dequeueReusableCell(withIdentifier: "cell2") as! ReportsTableCell
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.backgroundColor = .white
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
                
                if self.str_pharmacy_prescription_Status != nil {
                    
                    cell.lbl_cell_1.text = "Today Prescriptions"
                    
                } else {
                    
                    if self.str_lab_test_Status != nil {
                        cell.lbl_cell_1.text = "Today Tests"
                    } else {
                        
                        if (person["role"] as! String) == "Hospital" || (person["role"] as! String) == "Lab" || (person["role"] as! String) == "Pharmacy" {
                            
                            if self.hospital_status_check == "yes" {
                                cell.lbl_cell_1.text = "Today Appointments"
                            } else {
                                cell.lbl_cell_1.text = "Today Patients"
                            }
                            
                            
                        } else if (person["role"] as! String) == "Doctor" {
                            
                            cell.lbl_cell_1.text = "Today Appointments"
                            
                        } else if (person["role"] as! String) == "Supplier" {
                            
                            cell.lbl_cell_1.text = "Today Orders"
                            
                        }
                        
                    }
                    
                }
                
                
                
            } // end
            
            return cell
            
        } else if indexPath.row == 2 {
            
            let cell:ReportsTableCell = tablView.dequeueReusableCell(withIdentifier: "cell3") as! ReportsTableCell
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.backgroundColor = .white
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
                
                if self.str_pharmacy_prescription_Status != nil {
                    
                    cell.lbl_cell_2.text = "Weekly Prescriptions"
                    
                } else {
                    
                    if self.str_lab_test_Status != nil {
                        cell.lbl_cell_2.text = "Weekly Tests"
                    } else {
                        
                        if (person["role"] as! String) == "Hospital" || (person["role"] as! String) == "Lab" || (person["role"] as! String) == "Pharmacy" {
                            
                            if self.hospital_status_check == "yes" {
                                cell.lbl_cell_2.text = "Weekly Appointments"
                            } else {
                                cell.lbl_cell_2.text = "Weekly Patients"
                            }
                            
                            
                            
                        } else if (person["role"] as! String) == "Doctor" {
                            
                            cell.lbl_cell_2.text = "Weekly Appointments"
                            
                        } else if (person["role"] as! String) == "Supplier" {
                            
                            cell.lbl_cell_2.text = "Weekly Orders"
                            
                        }
                        
                    }
                }
                
            }
            
            return cell
            
        } else if indexPath.row == 3 {
            
            let cell:ReportsTableCell = tablView.dequeueReusableCell(withIdentifier: "cell4") as! ReportsTableCell
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.backgroundColor = .white
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
                
                if self.str_pharmacy_prescription_Status != nil {
                    
                    cell.lbl_cell_3.text = "Monthly Prescriptions"
                    
                } else {
                    
                    if self.str_lab_test_Status != nil {
                        cell.lbl_cell_3.text = "Monthly Tests"
                    } else {
                        
                        if (person["role"] as! String) == "Hospital" || (person["role"] as! String) == "Lab" || (person["role"] as! String) == "Pharmacy" {
                            
                            if self.hospital_status_check == "yes" {
                                cell.lbl_cell_3.text = "Monthly Appointments"
                            } else {
                                cell.lbl_cell_3.text = "Monthly Patients"
                            }
                        } else if (person["role"] as! String) == "Doctor" {
                            
                            cell.lbl_cell_3.text = "Monthly Appointments"
                            
                        } else if (person["role"] as! String) == "Supplier" {
                            
                            cell.lbl_cell_3.text = "Monthly Orders"
                            
                        }
                        
                    }
                }
                
            }
            
            return cell
            
        } else if indexPath.row == 4 {
            
            let cell:ReportsTableCell = tablView.dequeueReusableCell(withIdentifier: "cell5") as! ReportsTableCell
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.backgroundColor = .white
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
                
                if self.str_pharmacy_prescription_Status != nil {
                    
                    cell.lbl_cell_4.text = "Yearly Prescriptions"
                    
                } else {
                    
                    if self.str_lab_test_Status != nil {
                        cell.lbl_cell_4.text = "Yearly Tests"
                    } else {
                        
                        if (person["role"] as! String) == "Hospital" || (person["role"] as! String) == "Lab" || (person["role"] as! String) == "Pharmacy" {
                            
                            if self.hospital_status_check == "yes" {
                                cell.lbl_cell_4.text = "Yearly Appointments"
                            } else {
                                cell.lbl_cell_4.text = "Yearly Patients"
                            }
                        } else if (person["role"] as! String) == "Doctor" {
                            
                            cell.lbl_cell_4.text = "Yearly Appointments"
                        } else if (person["role"] as! String) == "Supplier" {
                            
                            cell.lbl_cell_4.text = "Yearly Orders"
                            
                        }
                        
                    }
                }
                
            }
            
            return cell
            
        } else {
            
            let cell:ReportsTableCell = tablView.dequeueReusableCell(withIdentifier: "cell6") as! ReportsTableCell
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.backgroundColor = .white
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
                
                if self.str_pharmacy_prescription_Status != nil {
                    
                    cell.lbl_cell_5.text = "Custom Prescriptions"
                    
                } else {
                    
                    if self.str_lab_test_Status != nil {
                        cell.lbl_cell_5.text = "Custom Tests"
                    } else {
                        
                        if (person["role"] as! String) == "Hospital" || (person["role"] as! String) == "Lab" || (person["role"] as! String) == "Pharmacy" {
                            
                            if self.hospital_status_check == "yes" {
                                cell.lbl_cell_5.text = "Custom Appointments"
                            } else {
                                cell.lbl_cell_5.text = "Custom Patients"
                            }
                            
                        } else if (person["role"] as! String) == "Doctor" {
                            
                            cell.lbl_cell_5.text = "Custom Appointments"
                        } else if (person["role"] as! String) == "Supplier" {
                            
                            cell.lbl_cell_5.text = "Custom Orders"
                            
                        }
                    }
                }
                
            }
            
            return cell
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let today_date = Date().today(format: "yyyy-MM-dd")
        
        
        if indexPath.row == 0 {
            
            
            
        } else if indexPath.row == 1 {
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
                
                if (person["role"] as! String) == "Hospital" || (person["role"] as! String) == "Lab" || (person["role"] as! String) == "Pharmacy" {
                    
                    if self.str_pharmacy_prescription_Status != nil {
                        
                        self.show_test_or_prescripption_images(str_action: "activeprescription",
                                                               str_start_Date: "\(today_date)",
                                                               str_end_date: "\(today_date)",
                                                               str_keyword: "")
                        
                    } else {
                        
                        if self.str_lab_test_Status != nil {
                            
                            self.show_test_or_prescripption_images(str_action: "activetest",
                                                                   str_start_Date: "\(today_date)",
                                                                   str_end_date: "\(today_date)",
                                                                   str_keyword: "")
                            
                        } else {
                            
                            if self.hospital_status_check == "yes" {
                                
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPAppointmentsVC") as? PPAppointmentsVC
                                
                                push!.str_appointment_type = "Hospital"
                                push!.str_appointment_start_Date = "\(today_date)"
                                push!.str_appointment_end_date = "\(today_date)"
                                push!.str_appointment_keyword = ""
                                
                                self.navigationController?.pushViewController(push!, animated: true)
                                
                            } else {
                                
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HPDoctorsVC") as? HPDoctorsVC
                                push!.strMyProfileIs = "FromHospitalProfileToPatient"
                                push!.str_from_reports = "yes"
                                push!.str_report_role = "Patient"
                                push!.str_start_Date = "\(today_date)"
                                push!.str_end_Date = "\(today_date)"
                                push!.str_paid = String(self.str_payment_Status)
                                push!.str_keyword = ""
                                
                                self.navigationController?.pushViewController(push!, animated: true)
                                
                            }
                        }
                    }
                    
                    
                    
                } else if (person["role"] as! String) == "Doctor" {
                    // doctor
                    
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPAppointmentsVC") as? PPAppointmentsVC
                    
                    push!.str_appointment_type = "Doctor"
                    push!.str_appointment_start_Date = "\(today_date)"
                    push!.str_appointment_end_date = "\(today_date)"
                    push!.str_appointment_keyword = ""
                    
                    self.navigationController?.pushViewController(push!, animated: true)
                    
                } else if (person["role"] as! String) == "Supplier" {
                    
                    
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "orderHistoryVC") as? orderHistoryVC
                    
                    push!.str_order_history_start_Date = "\(today_date)"
                    push!.str_order_history_end_Date = "\(today_date)"
                    push!.str_order_history_keyword = ""
                    
                    self.navigationController?.pushViewController(push!, animated: true)
                    
                }
                
            }
            
            
            
            // show_reports_Result
            
        } else if indexPath.row == 2 {
            
            
            let calendar = Calendar.current
            let addOneWeekToCurrentDate = calendar.date(byAdding: .weekOfYear, value: -1, to: Date())
            // print(addOneWeekToCurrentDate as Any)
            
            // let earlyDate = Calendar.current.date( byAdding: .hour, value: -1, to: Date())
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            let start_Date = df.string(from: addOneWeekToCurrentDate!)
            // print(start_Date as Any)
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
                
                if (person["role"] as! String) == "Hospital" || (person["role"] as! String) == "Lab" || (person["role"] as! String) == "Pharmacy" {
                    
                    if self.str_pharmacy_prescription_Status != nil {
                        
                        self.show_test_or_prescripption_images(str_action: "activeprescription",
                                                               str_start_Date: "\(start_Date)",
                                                               str_end_date: "\(today_date)",
                                                               str_keyword: "")
                        
                    } else {
                        
                        if self.str_lab_test_Status != nil {
                            
                            self.show_test_or_prescripption_images(str_action: "activetest",
                                                                   str_start_Date: "\(start_Date)",
                                                                   str_end_date: "\(today_date)",
                                                                   str_keyword: "")
                            
                        } else {
                            
                            if self.hospital_status_check == "yes" {
                                
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPAppointmentsVC") as? PPAppointmentsVC
                                
                                push!.str_appointment_type = "Hospital"
                                push!.str_appointment_start_Date = "\(start_Date)"
                                push!.str_appointment_end_date = "\(today_date)"
                                push!.str_appointment_keyword = ""
                                
                                self.navigationController?.pushViewController(push!, animated: true)
                                
                            } else {
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HPDoctorsVC") as? HPDoctorsVC
                                
                                push!.strMyProfileIs = "FromHospitalProfileToPatient"
                                push!.str_from_reports = "yes"
                                push!.str_report_role = "Patient"
                                push!.str_start_Date = "\(start_Date)"
                                push!.str_end_Date = "\(today_date)"
                                push!.str_paid = String(self.str_payment_Status)
                                push!.str_keyword = ""
                                
                                self.navigationController?.pushViewController(push!, animated: true)
                            }
                        }
                    }
                    
                } else if (person["role"] as! String) == "Doctor" {
                    
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPAppointmentsVC") as? PPAppointmentsVC
                    
                    push!.str_appointment_type = "Doctor"
                    push!.str_appointment_start_Date = "\(start_Date)"
                    push!.str_appointment_end_date = "\(today_date)"
                    push!.str_appointment_keyword = ""
                    
                    self.navigationController?.pushViewController(push!, animated: true)
                    
                }  else if (person["role"] as! String) == "Supplier" {
                    
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "orderHistoryVC") as? orderHistoryVC
                    
                    push!.str_order_history_start_Date = "\(start_Date)"
                    push!.str_order_history_end_Date = "\(today_date)"
                    push!.str_order_history_keyword = ""
                    
                    self.navigationController?.pushViewController(push!, animated: true)
                    
                }
                
            }
            
            
        } else if indexPath.row == 3 {
            
            
            let calendar = Calendar.current
            let addOneWeekToCurrentDate = calendar.date(byAdding: .month, value: -1, to: Date())
            // print(addOneWeekToCurrentDate as Any)
            
            // let earlyDate = Calendar.current.date( byAdding: .hour, value: -1, to: Date())
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            let start_Date = df.string(from: addOneWeekToCurrentDate!)
            print(start_Date as Any)
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
                
                if (person["role"] as! String) == "Hospital" || (person["role"] as! String) == "Lab" || (person["role"] as! String) == "Pharmacy" {
                    
                    if self.str_pharmacy_prescription_Status != nil {
                        
                        self.show_test_or_prescripption_images(str_action: "activeprescription",
                                                               str_start_Date: "\(start_Date)",
                                                               str_end_date: "\(today_date)",
                                                               str_keyword: "")
                        
                    } else {
                        
                        if self.str_lab_test_Status != nil {
                            
                            self.show_test_or_prescripption_images(str_action: "activetest",
                                                                   str_start_Date: "\(start_Date)",
                                                                   str_end_date: "\(today_date)",
                                                                   str_keyword: "")
                            
                        } else {
                            
                            if self.hospital_status_check == "yes" {
                                
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPAppointmentsVC") as? PPAppointmentsVC
                                
                                push!.str_appointment_type = "Hospital"
                                push!.str_appointment_start_Date = "\(start_Date)"
                                push!.str_appointment_end_date = "\(today_date)"
                                push!.str_appointment_keyword = ""
                                
                                self.navigationController?.pushViewController(push!, animated: true)
                                
                            } else {
                                
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HPDoctorsVC") as? HPDoctorsVC
                                
                                push!.strMyProfileIs = "FromHospitalProfileToPatient"
                                push!.str_from_reports = "yes"
                                push!.str_report_role = "Patient"
                                push!.str_start_Date = "\(start_Date)"
                                push!.str_end_Date = "\(today_date)"
                                push!.str_paid = String(self.str_payment_Status)
                                push!.str_keyword = ""
                                
                                self.navigationController?.pushViewController(push!, animated: true)
                            }
                        }
                    }
                    
                } else if (person["role"] as! String) == "Doctor" {
                    
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPAppointmentsVC") as? PPAppointmentsVC
                    
                    push!.str_appointment_type = "Doctor"
                    push!.str_appointment_start_Date = "\(start_Date)"
                    push!.str_appointment_end_date = "\(today_date)"
                    push!.str_appointment_keyword = ""
                    
                    self.navigationController?.pushViewController(push!, animated: true)
                    
                } else if (person["role"] as! String) == "Supplier" {
                    
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "orderHistoryVC") as? orderHistoryVC
                    
                    push!.str_order_history_start_Date = "\(start_Date)"
                    push!.str_order_history_end_Date = "\(today_date)"
                    push!.str_order_history_keyword = ""
                    
                    self.navigationController?.pushViewController(push!, animated: true)
                    
                }
                
            }
            
        } else if indexPath.row == 4 {
            
            
            let calendar = Calendar.current
            let addOneWeekToCurrentDate = calendar.date(byAdding: .year, value: -1, to: Date())
            // print(addOneWeekToCurrentDate as Any)
            
            // let earlyDate = Calendar.current.date( byAdding: .hour, value: -1, to: Date())
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            let start_Date = df.string(from: addOneWeekToCurrentDate!)
            print(start_Date as Any)
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
                
                if (person["role"] as! String) == "Hospital" || (person["role"] as! String) == "Lab" || (person["role"] as! String) == "Pharmacy" {
                    
                    if self.str_pharmacy_prescription_Status != nil {
                        
                        self.show_test_or_prescripption_images(str_action: "activeprescription",
                                                               str_start_Date: "\(start_Date)",
                                                               str_end_date: "\(today_date)",
                                                               str_keyword: "")
                        
                    } else {
                        
                        if self.str_lab_test_Status != nil {
                            
                            self.show_test_or_prescripption_images(str_action: "activetest",
                                                                   str_start_Date: "\(start_Date)",
                                                                   str_end_date: "\(today_date)",
                                                                   str_keyword: "")
                            
                        } else {
                            
                            if self.hospital_status_check == "yes" {
                                
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPAppointmentsVC") as? PPAppointmentsVC
                                
                                push!.str_appointment_type = "Hospital"
                                push!.str_appointment_start_Date = "\(start_Date)"
                                push!.str_appointment_end_date = "\(today_date)"
                                push!.str_appointment_keyword = ""
                                
                                self.navigationController?.pushViewController(push!, animated: true)
                                
                            } else {
                                
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HPDoctorsVC") as? HPDoctorsVC
                                
                                push!.strMyProfileIs = "FromHospitalProfileToPatient"
                                push!.str_from_reports = "yes"
                                push!.str_report_role = "Patient"
                                push!.str_start_Date = "\(start_Date)"
                                push!.str_end_Date = "\(today_date)"
                                push!.str_paid = String(self.str_payment_Status)
                                push!.str_keyword = ""
                                
                                self.navigationController?.pushViewController(push!, animated: true)
                            }
                        }
                    }
                    
                } else if (person["role"] as! String) == "Doctor" {
                    
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPAppointmentsVC") as? PPAppointmentsVC
                    
                    push!.str_appointment_type = "Doctor"
                    push!.str_appointment_start_Date = "\(start_Date)"
                    push!.str_appointment_end_date = "\(today_date)"
                    push!.str_appointment_keyword = ""
                    
                    self.navigationController?.pushViewController(push!, animated: true)
                    
                } else if (person["role"] as! String) == "Supplier" {
                    
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "orderHistoryVC") as? orderHistoryVC
                    
                    push!.str_order_history_start_Date = "\(start_Date)"
                    push!.str_order_history_end_Date = "\(today_date)"
                    push!.str_order_history_keyword = ""
                    
                    self.navigationController?.pushViewController(push!, animated: true)
                    
                }
                
            }
            
        } else {
            
        }
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
            
            if (person["role"] as! String) == "Hospital" {
                
                if self.hospital_status_check == "yes" {
                    
                    if indexPath.row == 0 {
                        return 0
                    } else {
                        return 60
                    }
                    
                } else {
                    return 60
                }
                
                
            } else if (person["role"] as! String) == "Lab" || (person["role"] as! String) == "Pharmacy" {
                
                if self.str_pharmacy_prescription_Status != nil {
                    
                    if indexPath.row == 0 {
                        return 0
                    } else {
                        return 60
                    }
                    
                } else {
                    
                    if self.str_lab_test_Status == nil {
                        return 60
                    } else {
                        
                        if indexPath.row == 0 {
                            return 0
                        } else {
                            return 60
                        }
                        
                    }
                    
                }
                
                
                
            } else if (person["role"] as! String) == "Supplier" {
                
                if indexPath.row == 0 {
                    return 0
                } else {
                    return 60
                }
                
            } else if (person["role"] as! String) == "Doctor" {
                
                if indexPath.row == 0 {
                    return 0
                } else {
                    return 60
                }
                
            } else {
                return 60
            }
            
            
        } else {
            return 0
        }
        
    }
    
}


extension Date {
    
    func today(format : String = "yyyy-MM-dd") -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
}
