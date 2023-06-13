//
//  ReportsTableCell.swift
//  E health App
//
//  Created by apple on 07/02/22.
//

import UIKit

class ReportsTableCell: UITableViewCell {

    @IBOutlet weak var segment_controll:UISegmentedControl!
    
    @IBOutlet weak var lbl_cell_1:UILabel! {
        didSet {
            lbl_cell_1.textColor = . black
        }
    }
    
    @IBOutlet weak var lbl_cell_2:UILabel! {
        didSet {
            lbl_cell_2.textColor = . black
        }
    }
    
    @IBOutlet weak var lbl_cell_3:UILabel! {
        didSet {
            lbl_cell_3.textColor = . black
        }
    }
    
    @IBOutlet weak var lbl_cell_4:UILabel! {
        didSet {
            lbl_cell_4.textColor = . black
        }
    }
    
    @IBOutlet weak var lbl_cell_5:UILabel! {
        didSet {
            lbl_cell_5.textColor = . black
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

}
