//
//  InitialTableViewCell.swift
//  demo_Food
//
//  Created by 4n4rk0z on 17/02/21.
//

import UIKit

class InitialTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imgFoodDish: UIImageView!
    @IBOutlet weak var lblDishName: UILabel!
    @IBOutlet weak var lblDishDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
