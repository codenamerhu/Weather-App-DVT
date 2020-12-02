//
//  ForecastDayTableViewCell.swift
//  Weather App-DVT
//
//  Created by Jerry Boyd PTY on 2020/12/02.
//  Copyright © 2020 codenamerhu. All rights reserved.
//

import UIKit

class ForecastDayTableViewCell: UITableViewCell {

    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var taperature: UILabel!
    
    static let identifier = "ForecastCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
