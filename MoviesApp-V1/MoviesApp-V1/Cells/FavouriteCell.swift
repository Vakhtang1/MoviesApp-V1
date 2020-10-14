//
//  FavouriteCell.swift
//  MoviesApp-V1
//
//  Created by Vakho on 10/13/20.
//

import UIKit

class FavouriteCell: UITableViewCell {

    @IBOutlet weak var favouriteImgView: UIImageView!
    @IBOutlet weak var favouriteTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
