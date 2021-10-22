//
//  OrderItems.swift
//  E health App
//
//  Created by apple on 05/10/21.
//

import UIKit
import SDWebImage

class OrderItems: UIViewController {

    var dictGetAllDataOnlyForItems : NSDictionary!
    
    var arrListOfAllItems : NSMutableArray! = []
    
    @IBOutlet weak var viewNavigationBar:UIView!
    @IBOutlet weak var btnNavigationBack:UIButton! {
        didSet {
            btnNavigationBack.tintColor = .white
            btnNavigationBack.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        }
    }
    
    @IBOutlet weak var lblNavigationBar:UILabel!{
        didSet {
            
            lblNavigationBar.text = "ITEMS"
        }
    }

    @IBOutlet weak var tablView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tablView.backgroundColor = .white
        self.view.backgroundColor = .white
        self.tablView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        self.navigationController?.isNavigationBarHidden = true
        
        // print(self.dictGetAllDataOnlyForItems as Any)
        self.btnNavigationBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        var ar : NSArray!
        ar = (self.dictGetAllDataOnlyForItems["orderproducts"] as! Array<Any>) as NSArray
        
         // print(ar as Any)
        self.arrListOfAllItems.addObjects(from: ar as! [Any])
        
        self.tablView.delegate = self
        self.tablView.dataSource = self
        self.tablView.reloadData()
        
    }

    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension OrderItems: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrListOfAllItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:OrderItemsTableCell = tablView.dequeueReusableCell(withIdentifier: "orderItemsTableCell") as! OrderItemsTableCell
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.backgroundColor = .white
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        let item = self.arrListOfAllItems[indexPath.row] as? [String:Any]
        // print(item as Any)
        cell.lblMedicineName.text = (item!["name"] as! String)
        
        let x2 : Int = (item!["quantity"] as! Int)
        let myString2 = String(x2)
        
        if item!["price"] is String {
                          
            print("Yes, it's a String")
          
            cell.btnQuantity.setTitle("Quantity : "+myString2+"|| Price : "+(item!["price"] as! String), for: .normal)
            
        } else if item!["price"] is Int {
          
            print("It is Integer")
          
            let x : Int = (item!["price"] as! Int)
            let myString = String(x)
            cell.btnQuantity.setTitle("Quantity : "+myString2+"|| Price : "+myString, for: .normal)
            
        } else {
            
            let temp:NSNumber = item!["price"] as! NSNumber
            let tempString = temp.stringValue
            cell.btnQuantity.setTitle("Quantity : "+myString2+"|| Price : "+tempString, for: .normal)
        }
        
        cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.imgProfile.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "1024"))
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let item = self.arrListOfAllItems[indexPath.row] as? [String:Any]
        
        if (item!["name"] as! String).count > 80 {
            return UITableView.automaticDimension
        } else {
            return 110
            
        }
        
        
        
    }
    
}
