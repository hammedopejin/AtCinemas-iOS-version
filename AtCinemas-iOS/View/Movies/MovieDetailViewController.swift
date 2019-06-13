//
//  MovieDetailViewController.swift
//  AtCinemas-iOS
//
//  Created by Hammed opejin on 6/11/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var trailerCollectionView: UICollectionView!
    @IBOutlet weak var reviewCollectionView: UICollectionView!
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieReleasedateLabel: UILabel!
    @IBOutlet weak var movieRatingsLabel: UILabel!
    @IBOutlet weak var movieOverviewTextView: UITextView!
    
    var viewModel: MovieViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        movieOverviewTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))
    }
    
    //MARK: Setup
    func setupViews() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateReviews), name: Notification.Name.ReviewNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTrailers), name: Notification.Name.TrailerNotification, object: nil)
        
        if let movie = viewModel.currentMovie {
            viewModel.getReviews(id: "\(movie.id)")
            viewModel.getTrailers(id: "\(movie.id)")
            
            movieTitleLabel.text = movie.title
            movieReleasedateLabel.text = movie.releaseDate
            movieRatingsLabel.text = "\(movie.rating)"
            movieOverviewTextView.text = "\(movie.overview)"
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

    //MARK: Selector
    @objc func updateReviews() {
        DispatchQueue.main.async {
            self.reviewCollectionView.reloadData()
        }
    }
    
    @objc func updateTrailers() {
        DispatchQueue.main.async {
            self.trailerCollectionView.reloadData()
        }
    }

}

//MARK: collection view
extension MovieDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == self.trailerCollectionView ? viewModel.trailers.count : viewModel.reviews.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.trailerCollectionView{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrailerCollectionCell.identifier, for: indexPath) as! TrailerCollectionCell
            
            let trailer = viewModel.trailers[indexPath.row]
            cell.configure(with: trailer)
            
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCollectionCell.identifier, for: indexPath) as! ReviewCollectionCell
            
            cell.backgroundColor = .clear
            
            let review = viewModel.reviews[indexPath.row]
            
            cell.configure(with: review)
            
            return cell
        }
    }
    
}

extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView == self.trailerCollectionView ? .init(width: 100, height: 120) : .init(width: UIScreen.main.bounds.size.width, height: 325)
    }
}
