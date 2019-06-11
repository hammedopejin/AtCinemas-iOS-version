//
//  MovieCollectionCell.swift
//  AtCinemas-iOS
//
//  Created by Hammed opejin on 6/10/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import UIKit

class MovieCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieLabel: UILabel!
    
    
    static let identifier = "MovieCollectionCell"
    
    func configure(movie: Movie) {
        
        movieLabel.text = movie.title
        downloadManager.download(MovieAPI.getThumbnailUrl(movie.imageUrl)) { [unowned self] dat in
            
            guard let data = dat else {
                DispatchQueue.main.async {
                    self.movieImageView.image = #imageLiteral(resourceName: "movie")
                }
                return
            }
            
            let img = UIImage(data: data)
            self.movieImageView.image = img
            
        }
        
    }
    
}
