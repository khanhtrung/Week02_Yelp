 //
 //  BusinessCell.swift
 //  Yelp
 //
 //  Created by Tran Khanh Trung on 10/21/16.
 //  Copyright © 2016 CoderSchool. All rights reserved.
 //
 
 import UIKit
 
 class BusinessCell: UITableViewCell {
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewCountsLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var bussines: Business!{
        didSet{
            if let imageURL = bussines.imageURL {
                thumbImageView.setImageWith(imageURL)
            }
            
            if let name = bussines.name {
                nameLabel.text = name
            }
            
            if let ratingImageURL = bussines.ratingImageURL{
                ratingImageView.setImageWith(ratingImageURL)
            }
            
            if let reviewCount = bussines.reviewCount {
                reviewCountsLabel.text = "\(reviewCount) Reviews"
            }
            
            if let address = bussines.address {
                addressLabel.text = address
            }
            
            if let categories = bussines.categories {
                categoriesLabel.text = categories
            }
            
            if let distance = bussines.distance {
                distanceLabel.text = distance
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if thumbImageView != nil{
            thumbImageView.layer.cornerRadius = 5
            thumbImageView.clipsToBounds = true
        }
        
        if nameLabel != nil{
            nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if nameLabel != nil{
            nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
 }
