//
//  AccountCollectionViewCell.swift
//  Savings_AccountV2
//
//  Created by Oliver Reekie on 05/07/2021.
//

import UIKit

class AccountCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var nameCell: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountCell: UILabel!
    
    func setup(with movie: Movie){
        nameCell.text = movie.theName
        amountCell.text = movie.amount
    }
    
}
