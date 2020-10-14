//
//  SearchCell.swift
//  MoviesApp-V1
//
//  Created by Vakho on 10/12/20.
//

import UIKit

class SearchCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView! {
        didSet {
            imgView.layer.cornerRadius = 20
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()

        imgView.image = nil
    }
}
