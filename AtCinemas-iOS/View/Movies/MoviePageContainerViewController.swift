//
//  PhotoPageContainerViewController.swift
//  AtCinemas-iOS
//
//  Created by Hammed opejin on 6/14/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import UIKit

class MoviePageContainerViewController: UIViewController {
    
    var pageViewController: UIPageViewController {
        return self.children[0] as! UIPageViewController
    }
    
    var flag = false
    var movies: [Movie]!
    var currentIndex = 0
    var nextIndex: Int?
    var viewModel: MovieViewModel!
    var favoriteViewModel: FavoriteMoviesViewModel!
    
    var isFavorite: Bool {
        return viewModel == nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageViewController.delegate = self
        self.pageViewController.dataSource = self
        
        if isFavorite {
            viewModel = MovieViewModel()
        }
        
        let vc = UIStoryboard(name: "Movies", bundle: nil).instantiateViewController(withIdentifier: "\(MovieDetailViewController.self)") as! MovieDetailViewController
        vc.index = self.currentIndex
      
        vc.movie = self.movies[self.currentIndex]
        vc.viewModel = self.viewModel
        
        let viewControllers = [
            vc
        ]
        setBar()
        self.pageViewController.setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
        
    }
    
    func setBar() {
        
        flag = coreManager.isFavorite("\(self.movies[self.currentIndex].id)")
        
        let shareImage  = UIImage(named: "share")!
        let starButton = UIBarButtonItem(image: UIImage(), style: .plain, target: self, action: #selector(saveMovie))
        starButton.setBackgroundImage(resizeImage(image: flag ? #imageLiteral(resourceName: "stargold") : #imageLiteral(resourceName: "starplain"), targetSize: CGSize(width: 100.0, height: 40.0)), for: .normal, barMetrics: .default)
        let shareButton = UIBarButtonItem(image: shareImage,  style: .plain, target: self, action: #selector(shareMovieTrailer))
        
        navigationItem.rightBarButtonItems = [starButton, shareButton]
        
        viewModel.getReviews(id: "\(self.movies[self.currentIndex].id)")
        viewModel.getTrailers(id: "\(self.movies[self.currentIndex].id)")
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkAndRemoveShareBotton), name: Notification.Name.TrailerNotification, object: nil)
    }
    
    @objc func saveMovie() {
       
        flag ? coreManager.deleteMovie(self.movies[self.currentIndex]) : coreManager.saveMovie(self.movies[self.currentIndex])
        
        navigationItem.rightBarButtonItem?.setBackgroundImage(resizeImage(image: flag ? #imageLiteral(resourceName: "starplain") : #imageLiteral(resourceName: "stargold"), targetSize: CGSize(width: 100.0, height: 40.0)), for: .normal, barMetrics: .default)
        flag = flag ? false : true
    }
    
    @objc func checkAndRemoveShareBotton() {
        if self.viewModel.trailers.isEmpty{
            _ = navigationItem.rightBarButtonItems?.popLast()
        }
    }
    
    @objc func shareMovieTrailer() {
        
        let firstActivityItem = "Check this movie trailer out: "
        let secondActivityItem : NSURL = NSURL(string: MovieAPI.getTrailerVideoURL(self.viewModel.trailers[0].key))!
        
        let activityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem], applicationActivities: nil)
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = view
        activityViewController.popoverPresentationController?.permittedArrowDirections = []
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.airDrop
        ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}

extension MoviePageContainerViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if currentIndex == 0 {
            return nil
        }
        
        let vc = UIStoryboard(name: "Movies", bundle: nil).instantiateViewController(withIdentifier: "\(MovieDetailViewController.self)") as! MovieDetailViewController
       
        vc.movie = self.movies[self.currentIndex - 1]
        vc.viewModel = self.viewModel
        
        vc.index = currentIndex - 1
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if currentIndex == (self.movies.count - 1) {
            return nil
        }
        
        let vc = UIStoryboard(name: "Movies", bundle: nil).instantiateViewController(withIdentifier: "\(MovieDetailViewController.self)") as! MovieDetailViewController
    
        vc.movie = self.movies[self.currentIndex + 1]
        vc.viewModel = self.viewModel
    
        vc.index = currentIndex + 1
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        guard let nextVC = pendingViewControllers.first as? MovieDetailViewController else {
            return
        }
        self.nextIndex = nextVC.index

    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if (completed && self.nextIndex != nil) {
            self.currentIndex = self.nextIndex!
            setBar()
        }
        self.nextIndex = nil
    }
    
}
