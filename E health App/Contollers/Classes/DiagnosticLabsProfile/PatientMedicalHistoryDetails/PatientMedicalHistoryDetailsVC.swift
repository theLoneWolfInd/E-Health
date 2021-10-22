//
//  PatientMedicalHistoryDetailsVC.swift
//  E health App
//
//  Created by Ranjan on 24/08/21.
//

import UIKit
import Alamofire
import Firebase
import SDWebImage

class PatientMedicalHistoryDetailsVC: UIViewController {
    
    var getPatientDetails:NSDictionary!
    var getPatientMedicalHistoryDetails:NSDictionary!
    
    @IBOutlet weak var viewNavigationBar:UIView!
    @IBOutlet weak var btnNavigationBack:UIButton!
    @IBOutlet weak var lblNavigationBar:UILabel!{
        didSet {
            
            lblNavigationBar.text = "MEDICAL HISTORY"
        }
    }
    
    @IBOutlet weak var tablView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tablView.delegate = self
        tablView.dataSource = self
        self.view.backgroundColor = .white
        tablView.backgroundColor =  .white
        self.navigationController?.isNavigationBarHidden = true
        
        self.btnNavigationBack.addTarget(self, action: #selector(btnNavigationBackClickMethod), for: .touchUpInside)
        print(self.getPatientMedicalHistoryDetails as Any)
    }

    @objc func btnNavigationBackClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension PatientMedicalHistoryDetailsVC: UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell:PatientMedicalHistoryDetailsTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell1") as! PatientMedicalHistoryDetailsTableViewCell
            
            cell.lblPatientName.text = (self.getPatientMedicalHistoryDetails["PatientfullName"] as! String)+" "+(self.getPatientMedicalHistoryDetails["PatientLastName"] as! String)
            
            cell.btnAddress.setTitle((self.getPatientMedicalHistoryDetails["PatientAddress"] as! String), for: .normal)
            
            cell.btnAddress.titleLabel?.lineBreakMode = .byWordWrapping
            cell.btnAddress.titleLabel?.textAlignment = .center
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            return cell
        }
        
        else if indexPath.row == 1 {
            
            let cell:PatientMedicalHistoryDetailsTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell2") as! PatientMedicalHistoryDetailsTableViewCell
            
            cell.lblPhone.text = (self.getPatientMedicalHistoryDetails["PatientNumber"] as! String)
            
            cell.lblEmail.text = (self.getPatientMedicalHistoryDetails["PatientEmail"] as! String)
            
            return cell
        }
        
        else if indexPath.row == 2 {
            
            let cell:PatientMedicalHistoryDetailsTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell3") as! PatientMedicalHistoryDetailsTableViewCell
            
            cell.lblDieases.text = (self.getPatientMedicalHistoryDetails["disease"] as! String)
            
            return cell
        }
        
        else if indexPath.row == 3 {
            
            let cell:PatientMedicalHistoryDetailsTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell4") as! PatientMedicalHistoryDetailsTableViewCell
            
            cell.lblGender.text = (self.getPatientMedicalHistoryDetails["gender"] as! String)
            
            return cell
        }
        
        else if indexPath.row == 4 {
            
            let cell:PatientMedicalHistoryDetailsTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell5") as! PatientMedicalHistoryDetailsTableViewCell
            
            cell.lblTakingMedciene.text = (self.getPatientMedicalHistoryDetails["medicine"] as! String)
            
            return cell
        }
        
        else if indexPath.row == 5 {
            
            let cell:PatientMedicalHistoryDetailsTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell6") as! PatientMedicalHistoryDetailsTableViewCell
            
            cell.lblMedicationAlergies.text =  (self.getPatientMedicalHistoryDetails["allergies"] as! String)
            
            return cell
        }
        
        else if indexPath.row == 6 {
            
            let cell:PatientMedicalHistoryDetailsTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell7") as! PatientMedicalHistoryDetailsTableViewCell
            
            cell.lblTobaccoAlcohol.text = (self.getPatientMedicalHistoryDetails["using_alcohol"] as! String)
            
            return cell
        }
        
        else {
            
            let cell:PatientMedicalHistoryDetailsTableViewCell = tablView.dequeueReusableCell(withIdentifier: "cell8") as! PatientMedicalHistoryDetailsTableViewCell
            
            cell.lblEmpty.text = "Waiting for server data"
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 1 {
            return 130
        } else if indexPath.row == 7 {
            return 0
        } else {
            return UITableView.automaticDimension
        }
    }
    
}
