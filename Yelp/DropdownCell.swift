//
//  DropdownCell.swift
//  Yelp
//
//  Created by Tran Khanh Trung on 10/23/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit

@objc protocol DropdownCellDelegate {
    @objc optional func dropdownCell(dropdownCell: DropdownCell, didChangeValue value: Bool)
}

class DropdownCell: UITableViewCell {

    weak var delegate: DropdownCellDelegate?
    @IBOutlet weak var dropdownLabel: UILabel!
    @IBOutlet weak var dropdownImage: UIImageView!
    var isChecked = false
    var sectionName: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.isUserInteractionEnabled = true
        //now you need a tap gesture recognizer
        //note that target and action point to what happens when the action is recognized.
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(DropdownCell.cellTapped))
        //Add the recognizer to your view.
        self.addGestureRecognizer(tapRecognizer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellTapped(){
        //print("dropdown tapped")
        isChecked = !isChecked
        
        delegate?.dropdownCell?(dropdownCell: self, didChangeValue: isChecked)
    }

}
