//
//  PopularCell.swift
//  MoviesApp-V1
//
//  Created by Vakho on 10/9/20.
//

import UIKit

class PopularCell: UICollectionViewCell {
    @IBOutlet weak var popularImage: UIImageView! {
        didSet {
            popularImage.layer.cornerRadius = 20
        }
    }
    
}
