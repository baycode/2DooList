//
//  ListTableViewCell.swift
//  TwoDoo
//
//  Created by Bayram Ayyildiz on 2022-11-26.
//

import UIKit

protocol ListTableViewCellDelegate: class {
    func checkBoxToggle(sender: ListTableViewCell)
}

class ListTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkBoxButton: UIButton!
    
    weak var delegate: ListTableViewCellDelegate?
    var twoDooItem: TwoDooItem! {
        didSet {
            nameLabel.text = twoDooItem.name
            checkBoxButton.isSelected = twoDooItem.completed
        }
    }
    
    @IBAction func checkToggled(_ sender: UIButton) {
        delegate?.checkBoxToggle(sender: self)
    }
    
}
