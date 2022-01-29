//
//  CollectionViewCell.swift
//  Dialect Arabia
//
//  Created by Mohammad Alturbaq on 05/01/2022.
//

import UIKit

class WordsCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(_ label: String){
        self.label.text = label
    }
    
    static func nib() -> UINib{
        return UINib(nibName: K.WordsCell, bundle: nil)
    }

}
