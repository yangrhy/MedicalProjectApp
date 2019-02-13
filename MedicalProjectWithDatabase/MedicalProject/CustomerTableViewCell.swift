//
//  CustomerTableViewCell.swift
//  MedicalProject
//
//  Created by Ricky Yang on 2/9/19.
//

import UIKit

class CustomerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblCustName: UILabel!
    @IBOutlet weak var lblCustAddress: UILabel!
    @IBOutlet weak var lblDelivDate: UILabel!
    @IBOutlet weak var lblDelivTime: UILabel!
    @IBOutlet weak var lblDelivStatus: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
