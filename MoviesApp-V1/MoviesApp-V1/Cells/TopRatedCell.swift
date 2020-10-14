//
//  TopRatedCell.swift
//  MoviesApp-V1
//
//  Created by Vakho on 10/9/20.
//

import UIKit

class TopRatedCell: UICollectionViewCell {
    
    @IBOutlet weak var ratedImage: UIImageView! {
        didSet {
            ratedImage.layer.cornerRadius = 20
        }
    }
}
