//
//  ReviewCollectionViewCell.swift
//  AtCinemas-iOS
//
//  Created by Hammed opejin on 6/12/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import UIKit

class ReviewCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var reviewTextView: UITextView!
    
    static let identifier = "ReviewCollectionCell"
    
    func configure(with: Review) {
        reviewTextView.text = """
        ***By: @\(with.author)***
        
        \(with.content)
        """
        reviewTextView.setContentOffset(.zero, animated: true)
        reviewTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))
        
    }
    
}
