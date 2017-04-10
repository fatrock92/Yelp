//
//  FiltersCell.swift
//  Yelp
//
//  Created by Fateh Singh on 4/6/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FilterCellDelegate {
    @objc optional func switchCell(switchCell: FiltersCell, didChangeValue value: Bool)
}

class FiltersCell: UITableViewCell {

    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var filterSwitch: UISwitch!
    
    weak var delegate: FilterCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onSwitchValueChanged(_ sender: Any) {
        delegate?.switchCell?(switchCell: self, didChangeValue: filterSwitch.isOn)
    }
}
