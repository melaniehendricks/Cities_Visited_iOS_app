//
//  CityTableViewCell.swift
//  Lab5
//
//  Created by Melanie Hendricks on 3/20/20.
//  Copyright © 2020 Melanie Hendricks. All rights reserved.
//

import UIKit

class CityTableViewCell: UITableViewCell {

    // declare variables
    @IBOutlet weak var cityTitle: UILabel!
    @IBOutlet weak var cityImage: UIImageView!{
        didSet{
            cityImage.layer.cornerRadius = cityImage.bounds.width/4
            cityImage.clipsToBounds = true
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
