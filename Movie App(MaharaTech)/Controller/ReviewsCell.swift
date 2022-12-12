//
//  ReviewsCell.swift
//  Movie App(MaharaTech)
//
//  Created by Ahmed on 10/12/2022.
//

import UIKit

class ReviewsCell: UITableViewCell {

    @IBOutlet weak var autherContent: UILabel!
    @IBOutlet weak var autherName: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
