//
//  HPPatientPrescriptionVC.swift
//  E health App
//
//  Created by Ranjan on 02/09/21.
//

import UIKit

class HPPatientPrescriptionVC: UIViewController {
    
    @IBOutlet weak var viewNavigationBar:UIView!
    @IBOutlet weak var btnNaviagtionBack:UIButton!
    @IBOutlet weak var lblNavigationBar:UILabel!{
        didSet {
            
            lblNavigationBar.text = "Patient Prescription"
        }
    }
    
    @IBOutlet weak var lblPatientName:UILabel!{
        didSet{
            lblPatientName.textColor = .white
        }
    }

    @IBOutlet weak var collectionview:UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.backgroundColor = .white
        self.view.backgroundColor = .white
        lblPatientName.text = "Prescription by: " + "Dr. John Smith"
        
        let alert = UIAlertController(title: "SORRY!", message: "You don't have permission to access the prescription", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Request to Access", style: .default, handler: { action in

            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HPDashboardVC") as? HPDashboardVC
            
            self.navigationController?.pushViewController(push!, animated: true)
            
        }))
        
        self.present(alert, animated: true)
        
    }

}

extension HPPatientPrescriptionVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:HPPatientPrescriptionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HPPatientPrescriptionCollectionViewCell
        cell.backgroundColor = .white
        cell.imgPrescription.image = UIImage(named: "prescription")
        cell.lblUploadedTimeNDate.text = "Jul 6th, 21"
        cell.designForCell()
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = (collectionview.frame.size.width - 20)/2
        return CGSize(width: size, height: size)
        
        }
}

extension UIView{
    func designForCell() {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
}
