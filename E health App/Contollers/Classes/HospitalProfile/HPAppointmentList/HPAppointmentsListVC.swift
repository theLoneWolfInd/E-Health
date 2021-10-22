//
//  HPAppointmentsListVC.swift
//  E health App
//
//  Created by Ranjan on 01/09/21.
//

import UIKit

class HPAppointmentsListVC: UIViewController {

    var arr = ["Arthur", "Ford", "Trillian", "Zaphod", "Marvin"]

    @IBOutlet weak var viewNavigationBar:UIView!
    @IBOutlet weak var btnDashboardMenu:UIButton!
    @IBOutlet weak var lblNavigationBar:UILabel!{
        didSet {
            
            lblNavigationBar.text = "Appointment Date"
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
     var filtered:[String] = []
    
    
    
    var searchActive : Bool =  false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        searchBar.backgroundColor = .white
        searchBar.barTintColor = .white
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        self.tableView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        self.navigationController?.isNavigationBarHidden = true
    }
    
}

extension HPAppointmentsListVC:UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchActive {
            
            return filtered.count
        }
        
        else {
        
        return  arr.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:HPAppointmentsListTableViewCell  =  tableView.dequeueReusableCell(withIdentifier: "cell") as! HPAppointmentsListTableViewCell
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        cell.backgroundColor = .white
        
        cell.imgProfile.image = UIImage(named: "david")
        cell.lblDoctorName.text = "Dr. Anothny - Surgical"
        cell.lblDate.text = "Date: " + "Sep 01st, 2021"
        
        if searchActive{
            
            
            cell.lblPatientName.text =  filtered[indexPath.row]
        }
        
        else {
        
        cell.lblPatientName.text =  arr[indexPath.row]
            
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

            filtered = arr.filter({ (text) -> Bool in
             let tmp: NSString = text as NSString
             let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return range.location != NSNotFound
            })
         
            if(filtered.count == 0){
                searchActive = false;
            } else {
                searchActive = true;
            }
            self.tableView.reloadData()
        }

}
