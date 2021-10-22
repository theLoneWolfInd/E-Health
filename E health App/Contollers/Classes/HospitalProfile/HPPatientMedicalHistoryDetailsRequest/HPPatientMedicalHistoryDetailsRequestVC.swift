//
//  HPPatientMedicalHistoryDetailsRequestVC.swift
//  E health App
//
//  Created by Ranjan on 01/09/21.
//

import UIKit

class HPPatientMedicalHistoryDetailsRequestVC: UIViewController {
    
    @IBOutlet weak var viewNavigationBar:UIView!
    @IBOutlet weak var btnNaviagtionBack:UIButton!
    @IBOutlet weak var lblNavigationBar:UILabel!{
        didSet {
            
            lblNavigationBar.text = "ADD MEDICAL HISTORY"
        }
    }

    @IBOutlet weak var tablViw:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        tablViw.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        tablViw.delegate = self
        tablViw.dataSource = self
        btnNaviagtionBack.addTarget(self, action: #selector(btnNavigationBackPress), for: .touchUpInside)
        
        let alert = UIAlertController(title: "SORRY!", message: "You don't have permission to access the medical history", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Request to Access", style: .default, handler: { action in

            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HPDashboardVC") as? HPDashboardVC
            
            self.navigationController?.pushViewController(push!, animated: true)
            
        }))
        
        self.present(alert, animated: true)
        
    }
    
    @objc func btnNavigationBackPress(){
        navigationController?.popViewController(animated: true)
    }

}

extension HPPatientMedicalHistoryDetailsRequestVC: UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let cell:HPPatientMedicalHistoryDetailsRequestTableViewCell = tablViw.dequeueReusableCell(withIdentifier: "cell1") as! HPPatientMedicalHistoryDetailsRequestTableViewCell
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            cell.backgroundColor = .white
            
            cell.lblPatientName.text = "Michel Jordan"
            cell.btnAddress.setTitle("Lorem Ipsum is simply dummy text of the printing and typesetting industry", for: .normal)
            cell.btnAddress.titleLabel?.lineBreakMode = .byWordWrapping
            cell.btnAddress.titleLabel?.textAlignment = .center
            return cell
        }
        
        else if indexPath.row == 1{
            
            let cell:HPPatientMedicalHistoryDetailsRequestTableViewCell = tablViw.dequeueReusableCell(withIdentifier: "cell2") as! HPPatientMedicalHistoryDetailsRequestTableViewCell
            
            cell.backgroundColor = .white
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.lblPhone.text = "1800-124-5678"
            cell.lblEmail.text = "test@mailyahoogmail.com"
            return cell
        }
        
        else if indexPath.row == 2{
            
            let cell:HPPatientMedicalHistoryDetailsRequestTableViewCell = tablViw.dequeueReusableCell(withIdentifier: "cell3") as! HPPatientMedicalHistoryDetailsRequestTableViewCell
            cell.backgroundColor = .white
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.lblDieases.text = "It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum"
            
            return cell
        }
        
        else if indexPath.row == 3{
            
            let cell:HPPatientMedicalHistoryDetailsRequestTableViewCell = tablViw.dequeueReusableCell(withIdentifier: "cell4") as! HPPatientMedicalHistoryDetailsRequestTableViewCell
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            cell.backgroundColor = .white
            
            cell.lblGender.text = "Male"
            
            return cell
        }
        
        else if indexPath.row == 4{
            
            let cell:HPPatientMedicalHistoryDetailsRequestTableViewCell = tablViw.dequeueReusableCell(withIdentifier: "cell5") as! HPPatientMedicalHistoryDetailsRequestTableViewCell
            cell.lblTakingMedciene.text = "Decongestants, such as pseudoephedrine and phenylephrine"
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            cell.backgroundColor = .white
            
            return cell
        }
        
        else if indexPath.row == 5{
            
            let cell:HPPatientMedicalHistoryDetailsRequestTableViewCell = tablViw.dequeueReusableCell(withIdentifier: "cell6") as! HPPatientMedicalHistoryDetailsRequestTableViewCell
            cell.lblMedicationAlergies.text =  "Yes, by paracetamol"
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            cell.backgroundColor = .white
            
            return cell
        }
        
        else if indexPath.row == 6{
            
            let cell:HPPatientMedicalHistoryDetailsRequestTableViewCell = tablViw.dequeueReusableCell(withIdentifier: "cell7") as! HPPatientMedicalHistoryDetailsRequestTableViewCell
            cell.lblTobaccoAlcohol.text = "Yes"
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            cell.backgroundColor = .white
            
            return cell
        }
        
        else {
            
            let cell:HPPatientMedicalHistoryDetailsRequestTableViewCell = tablViw.dequeueReusableCell(withIdentifier: "cell8") as! HPPatientMedicalHistoryDetailsRequestTableViewCell
            cell.lblEmpty.text = "Waiting for server data"
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            cell.backgroundColor = .white
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0{
            
            return UITableView.automaticDimension
        }
        
        else if indexPath.row == 1{
            
            return 130
        }
        
        else if indexPath.row == 2{
            
            return UITableView.automaticDimension
        }
        else if indexPath.row == 3{
            
            return UITableView.automaticDimension
        }
        else if indexPath.row == 4{
            
            return UITableView.automaticDimension
        }
        else if indexPath.row == 5{
            
            return UITableView.automaticDimension
        }
        else if indexPath.row == 6{
            
            return UITableView.automaticDimension
        }
        else if indexPath.row == 7{
            
            return UITableView.automaticDimension
        }
        
        else{
            
            return 80
        }
    }
    
}

