//
//  PatientVC.swift
//  E health App
//
//  Created by Ranjan on 25/08/21.
//

import UIKit

class PatientVC: UIViewController, UISearchBarDelegate {
    
    var nameArray = ["Dishant Rajput","Deepak Kumar","Pankaj Sharma","Steve Richomnd","Natile Shawn Johnson","Dishant Rajput","Deepak Kumar","Pankaj Sharma","Steve Richomnd","Natile Shawn Johnson"]
    
    var amountArray = ["$245.73","$1297.034", "$09.2",
                       "$123456.987","$245.73","$1297.034", "$09.2",
                       "$123456.987","$245.73","$1297.034"]
    var phoneArray = ["888-124-1434","745-343-4233","638-343-3243","888-124-1434","745-343-4233","638-343-3243","888-124-1434","745-343-4233","638-343-3243","638-343-3243"]

    @IBOutlet weak var btnAddNewPatient: UIButton!
    @IBOutlet weak var viewNavigationBar:UIView!
    @IBOutlet weak var btnNaviagtionMenu:UIButton!
    @IBOutlet weak var lblNavigationBar:UILabel!{
        didSet {
            
            lblNavigationBar.text = "PATIENT"
        }
    }
    @IBOutlet weak var tablView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
     var filtered:[String] = []
    
    
    
    var searchActive : Bool =  false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        searchBar.backgroundColor = .white
        searchBar.barTintColor = .white
        tablView.backgroundColor = .white
        tablView.delegate = self
        tablView.dataSource = self
        searchBar.delegate = self
        self.tablView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        self.navigationController?.isNavigationBarHidden = true
        btnAddNewPatient.addTarget(self, action: #selector(btnAddNewPatientPress), for: .touchUpInside)
    }
    
    @objc func btnAddNewPatientPress(){
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddNewPatientVC") as? AddNewPatientVC
        
        self.navigationController?.pushViewController(push!, animated: true)
    }

}

extension PatientVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchActive {
            
            return filtered.count
        }
        
        else {
        
        return  nameArray.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:PatientTableViewCell  =  tablView.dequeueReusableCell(withIdentifier: "cell") as! PatientTableViewCell
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.backgroundColor = .white
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        cell.imgPatientProfile.image = UIImage(named: "daze")
        cell.btnPhoneNumber.setTitle(phoneArray[indexPath.row], for: .normal)
        cell.lblPaidAmount.text = amountArray[indexPath.row]
        
        if searchActive{
            
            
            cell.lblPatientName.text =  filtered[indexPath.row]
        }
        
        else {
        
        cell.lblPatientName.text =  nameArray[indexPath.row]
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 98

    }
    
    
    //Searchbar Delegate
     
     func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            searchActive = true;
        }
     
     
     func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            searchActive = false;
        }
     
     
     
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

            filtered = nameArray.filter({ (text) -> Bool in
             let tmp: NSString = text as NSString
             let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return range.location != NSNotFound
            })
         
            if(filtered.count == 0){
                searchActive = false;
            } else {
                searchActive = true;
            }
            self.tablView.reloadData()
        }

    
}
