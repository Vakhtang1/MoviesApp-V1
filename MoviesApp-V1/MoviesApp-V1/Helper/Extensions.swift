//
//  Extensions.swift
//  MoviesApp-V1
//
//  Created by Vakho on 10/9/20.
//

import Foundation
import UIKit

extension String {
    
    func downloadImage(completion: @escaping (UIImage?) -> ()) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500" + self) else {return}
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            guard let data = data else {return}
            completion(UIImage(data: data))
        }.resume()
    }
    
}
