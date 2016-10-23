//
//  CheckCell.swift
//  Yelp
//
//  Created by Tran Khanh Trung on 10/23/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit

@objc protocol CheckCellDelegate {
    @objc optional func checkCell(checkCell: CheckCell, didChangeValue value: Bool)
}

class CheckCell: UITableViewCell {

    weak var delegate: CheckCellDelegate?
    @IBOutlet weak var checkLabel: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    var isChecked:Bool = false {
        didSet{
            if isChecked {
                checkImage.image = UIImage(named: "checked_checkbox")!
            } else {
                checkImage.image = UIImage(named: "unchecked_checkbox")!
            }
        }
    }
    var sectionName: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.isUserInteractionEnabled = true
        //now you need a tap gesture recognizer
        //note that target and action point to what happens when the action is recognized.
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(CheckCell.cellTapped))
        //Add the recognizer to your view.
        self.addGestureRecognizer(tapRecognizer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellTapped(){
        //print("cell check tapped")
        isChecked = !isChecked
        delegate?.checkCell?(checkCell: self, didChangeValue: isChecked)
    }
}
