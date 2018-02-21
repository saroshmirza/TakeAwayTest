//
//  RestaurantCell.swift
//  TakeAway
//
//  Created by Sarosh Salman on 18.02.18.
//  Copyright © 2018 saroshmirza. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    let redColor = UIColor(red: 104.0/255.0, green: 0.0/255.0, blue: 21.0/255.0, alpha: 1.0)
    let greenColor = UIColor(red: 76.0/255.0, green: 166.0/255.0, blue: 45.0/255.0, alpha: 1.0)
    let orangeColor = UIColor(red: 226.0/255.0, green: 147.0/255.0, blue: 61.0/255.0, alpha: 1.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(withData restaurant: Restaurant) -> Void{
        name.text = restaurant.name
        status.text = restaurant.status
        
        if(restaurant.status == "open"){            
            status.backgroundColor = self.greenColor
        }else if(restaurant.status == "closed"){
            status.backgroundColor = self.redColor
        }else{
            status.backgroundColor = self.orangeColor
        }
        
        favButton.isSelected = restaurant.favorite!
    }
    
}
