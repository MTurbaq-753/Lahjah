//
//  MenuCell.swift
//  Dialect Arabia
//
//  Created by Mohammad Alturbaq on 11/01/2022.
//

import UIKit

class MenuCell: UITableViewCell {
    
    @IBOutlet weak var arLabel: UILabel!
    
    @IBOutlet weak var engLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    static func nib() -> UINib{
        return UINib(nibName: K.MenuCell, bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
