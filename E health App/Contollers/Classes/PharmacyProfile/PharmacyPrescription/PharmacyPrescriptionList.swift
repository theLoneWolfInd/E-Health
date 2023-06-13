//
//  PharmacyPrescriptionList.swift
//  E health App
//
//  Created by apple on 09/02/22.
//

import UIKit
import Alamofire
import SDWebImage

class PharmacyPrescriptionList: UIViewController {

    var arr_mut_get_prescription_list:NSMutableArray! = []
    
    var arr_ar_get_prescription_list:NSArray!
    
    var prescription_image_array : NSArray!
    
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    @IBOutlet weak var viewNavigationbar:UIView!
    @IBOutlet weak var btnDashboardMenu: UIButton!
    @IBOutlet weak var lblNavationbar:UILabel!{
        didSet {
            
            lblNavationbar.text = "Prescriptions"
        }
    }
    
    @IBOutlet weak var tablView:UITableView! {
        didSet {
            tablView.backgroundColor =  .white
            tablView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        }
    }
    
    @IBOutlet weak var lbl_no_Data_found:UILabel! {
        didSet {
            lbl_no_Data_found.textColor = .black
            lbl_no_Data_found.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tablView.separatorColor = .clear
        
        //
        
        self.manage_prescription()
        
        
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
    
    @objc func manage_prescription() {
        
        // print(self.arr_ar_get_prescription_list as Any)
        
        
        for indexx in 0..<self.arr_ar_get_prescription_list.count {
            
            let item = self.arr_ar_get_prescription_list[indexx] as? [String:Any]
            // print(item as Any)
            
            
            
            let custom_dict = ["patient_image"      : (item!["PatientImage"] as! String),
                               "patient_first_name" : (item!["PatientfullName"] as! String),
                               "patient_last_name"  : (item!["PatientLastName"] as! String),
                               "patient_created"    : (item!["created"] as! String),
                               
                               "prescription_images":[
                                
                                ["prescription_image":(item!["prescription_image"] as! String)],
                                ["prescription_image":(item!["prescription_image_2"] as! String)],
                                ["prescription_image":(item!["prescription_image_3"] as! String)],
                                ["prescription_image":(item!["prescription_image_4"] as! String)],
                                ["prescription_image":(item!["prescription_image_5"] as! String)],
                                
                               ]
                               
            ] as [String : Any]
            
            
            // print(custom_dict as Any)
        
            self.arr_mut_get_prescription_list.add(custom_dict)
            
        }
        
        // print(self.arr_mut_get_prescription_list as Any)
        
        self.tablView.delegate = self
        self.tablView.dataSource = self
        self.tablView.reloadData()
        
    }
    
}

extension PharmacyPrescriptionList:UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arr_mut_get_prescription_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:PharmacyPrescriptionListTableCell = tablView.dequeueReusableCell(withIdentifier: "pharmacyPrescriptionListTableCell") as! PharmacyPrescriptionListTableCell
        
        cell.backgroundColor = .white
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        let item = self.arr_mut_get_prescription_list[indexPath.row] as? [String:Any]
        // print(item as Any)
        
        cell.lbl_patient_name.text = (item!["patient_first_name"] as! String)+" "+(item!["patient_last_name"] as! String)
        
        cell.lbl_patient_name.text = (item!["patient_first_name"] as! String)+" "+(item!["patient_last_name"] as! String)
        
        cell.lbl_created.text = (item!["patient_created"] as! String)
        
        cell.img_profile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.img_profile.sd_setImage(with: URL(string: (item!["patient_image"] as! String)), placeholderImage: UIImage(named: "1024"))
        
        
        
        self.prescription_image_array = (item!["prescription_images"] as! Array<Any>) as NSArray
        // print(self.prescription_image_array as Any)
        
        // cell.btnRightScroll.isHidden = false
        // cell.btnLeftScroll.isHidden = false
        cell.scrollView.isHidden = false
        
        cell.scrollView.isPagingEnabled = true
        for index in 0..<self.prescription_image_array.count {
            
            let item = self.prescription_image_array[index] as? [String:Any]
            print(item as Any)
            
            if (item!["prescription_image"] as! String) == "" {
                
            } else {
                
                frame.origin.x = cell.scrollView.frame.size.width * CGFloat(index)
                frame.size = cell.scrollView.frame.size
                
                let imageView = UIImageView()
                
                imageView.sd_setImage(with: URL(string: (item!["prescription_image"] as! String)), placeholderImage: UIImage(named: "1024"))
                
                imageView.frame = frame
                imageView.tag = index
                cell.scrollView.contentSize.width = cell.scrollView.frame.width * CGFloat(index + 1)
                cell.scrollView.addSubview(imageView)
                
            }
            
            
            
            /*let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(PatientPrescriptionDetails.cellTappedMethod2(_:)))
             imageView.isUserInteractionEnabled = true
             imageView.addGestureRecognizer(tapGestureRecognizer1)*/
            
        }
        
        /*cell.btnLeftScroll.tag = indexPath.row
        cell.btnLeftScroll.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        cell.btnRightScroll.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        
        cell.scrollView.contentSize = CGSize(width: cell.scrollView.frame.size.width * CGFloat(self.prescription_image_array.count), height: cell.scrollView.frame.size.height)
        cell.scrollView.delegate = self*/
        
        
        
        
        return cell
    }
    
    @objc func leftButtonTapped() {
        let indexPath = IndexPath.init(row: self.prescription_image_array.count, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! PharmacyPrescriptionListTableCell
        
         if cell.scrollView.contentOffset.x > 0 {
             cell.scrollView.contentOffset.x -=  cell.scrollView.bounds.width
         }
    }
    
    @objc func rightButtonTapped() {
        let indexPath = IndexPath.init(row: self.prescription_image_array.count, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! PharmacyPrescriptionListTableCell
        
        if cell.scrollView.contentOffset.x < cell.scrollView.bounds.width * CGFloat(self.prescription_image_array.count-1) {
            cell.scrollView.contentOffset.x +=  cell.scrollView.bounds.width
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return 260
    }
    
}
