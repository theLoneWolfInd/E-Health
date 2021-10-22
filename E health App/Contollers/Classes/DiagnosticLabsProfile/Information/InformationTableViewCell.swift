//
//  InformationTableViewCell.swift
//  E health App
//
//  Created by Ranjan on 24/08/21.
//

import UIKit

class InformationTableViewCell: UITableViewCell,UITextViewDelegate{
    
    @IBOutlet weak var txtDeliveryAddress:UITextField!{
        didSet {
            
            Utils.txtUitextField(textField: txtDeliveryAddress, placeholderName: "Delivery Address", setLeftPadding: 20)
            txtDeliveryAddress.isSecureTextEntry = false
            }
        }
    @IBOutlet weak var txtContactPersonName:UITextField!{
        didSet {
            
            Utils.txtUitextField(textField: txtContactPersonName, placeholderName: "Name of contact person", setLeftPadding: 20)
            txtContactPersonName.isSecureTextEntry = false
            }
        }
    
    @IBOutlet weak var txtMobileNumber:UITextField!{
        didSet {
            
            Utils.txtUitextField(textField: txtMobileNumber, placeholderName: "Mobile Number", setLeftPadding: 20)
            txtMobileNumber.isSecureTextEntry = false
            }
        }
    
    @IBOutlet weak var btnDeliveryDate:UIButton!
    
    @IBOutlet weak var txtDeliveryDate:UITextField!{
        didSet {
            
            Utils.txtUitextField(textField: txtDeliveryDate, placeholderName: "Delivery Date", setLeftPadding: 20)
            txtDeliveryDate.isSecureTextEntry = false
            }
        }
    @IBOutlet weak var txtViewNote:UITextView!{
        didSet{
            txtViewNote.layer.cornerRadius = 20.0
            txtViewNote.clipsToBounds = true
            txtViewNote.backgroundColor = .white
            txtViewNote.layer.borderColor = UIColor.lightGray.cgColor
            txtViewNote.layer.borderWidth = 1
            txtViewNote.text = "Special Notes"
            txtViewNote.delegate = self
        }
    }
    
    @IBOutlet weak var btnSubmit:UIButton!{
        didSet{
            btnSubmit.layer.cornerRadius = 27.5
            btnSubmit.clipsToBounds = true
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtViewNote.textColor == UIColor.darkGray {
            txtViewNote.text = nil
            txtViewNote.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if txtViewNote.text.isEmpty {
            txtViewNote.text = "Special Notes"
            txtViewNote.textColor = UIColor.darkGray
        }
    }
    

}
