//
//  PPPatientPrescriptionVC.swift
//  E health App
//
//  Created by Ranjan on 27/08/21.
//

import UIKit

class PPPatientPrescriptionVC: UIViewController {
    
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
        lblPatientName.text = "Prescription by: " + "John Smith"

    }
  

}

extension PPPatientPrescriptionVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:PPPatientPrescriptionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PPPatientPrescriptionCollectionViewCell
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
