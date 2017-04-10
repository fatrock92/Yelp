//
//  BusinessCell.swift
//  Yelp
//
//  Created by Fateh Singh on 4/4/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingsImageView: UIImageView!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var business: Business! {
        didSet {
            nameLabel.text = business.name
            if business.imageURL != nil {
                thumbImageView.setImageWith(business.imageURL!)
            }
            ratingsImageView.setImageWith(business.ratingImageURL!)
            reviewsCountLabel.text = String(Int(business.reviewCount ?? 0)) + " Reviews"
            addressLabel.text = business.address
            categoriesLabel.text = business.categories
            distanceLabel.text = business.distance
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbImageView.layer.cornerRadius = 5
        thumbImageView.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
