 //
//  SwitchCell.swift
//  Yelp
//
//  Created by Tran Khanh Trung on 10/22/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit
 
@objc protocol SwitchCellDelegate {
    @objc optional func switchCell(switchCell: SwitchCell, didChangeValue value: Bool)
 }
 
class SwitchCell: UITableViewCell {

    weak var delegate: SwitchCellDelegate?
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        onSwitch.addTarget(self, action: #selector(SwitchCell.switchValueChanged), for: .valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated:  animated)

        // Configure the view for the selected state
    }
    
    func switchValueChanged(){
        //print("switchValueChanged")
        delegate?.switchCell?(switchCell: self, didChangeValue: onSwitch.isOn)
    }
}
