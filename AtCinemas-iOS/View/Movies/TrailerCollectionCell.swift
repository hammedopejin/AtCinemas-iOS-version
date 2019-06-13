//
//  TrailerCollectionCell.swift
//  AtCinemas-iOS
//
//  Created by Hammed opejin on 6/11/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import UIKit

class TrailerCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var trailerImageView: UIImageView!
    
    static let identifier = "TrailerCollectionCell"
    
    func configure(with: Trailer) {
        
    downloadManager.download(MovieAPI.getTrailerThumbnailURL(with.key)) { [unowned self] dat in
            if let data = dat, let image = UIImage(data: data) {
                self.trailerImageView.image = image
            }
        }
    }
    
}
