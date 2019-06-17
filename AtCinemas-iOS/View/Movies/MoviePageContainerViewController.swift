//
//  PhotoPageContainerViewController.swift
//  AtCinemas-iOS
//
//  Created by Hammed opejin on 6/14/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import UIKit
import Firebase

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
        
        let cartImage  = UIImage(named: "cart")!
        let starButton = UIBarButtonItem(image: UIImage(), style: .plain, target: self, action: #selector(saveMovie))
        starButton.setBackgroundImage(resizeImage(image: flag ? #imageLiteral(resourceName: "stargold") : #imageLiteral(resourceName: "starplain"), targetSize: CGSize(width: 100.0, height: 40.0)), for: .normal, barMetrics: .default)
        let cartButton = UIBarButtonItem(image: cartImage,  style: .plain, target: self, action: #selector(addToCart))
        
        if Auth.auth().currentUser != nil {
            navigationItem.rightBarButtonItems = [starButton, cartButton]
        } else {
            navigationItem.rightBarButtonItems = [starButton]
        }
        
        viewModel.getReviews(id: "\(self.movies[self.currentIndex].id)")
        viewModel.getTrailers(id: "\(self.movies[self.currentIndex].id)")
    }
    
    @objc func saveMovie() {
       
        flag ? coreManager.deleteMovie(self.movies[self.currentIndex]) : coreManager.saveMovie(self.movies[self.currentIndex])
        
        navigationItem.rightBarButtonItem?.setBackgroundImage(resizeImage(image: flag ? #imageLiteral(resourceName: "starplain") : #imageLiteral(resourceName: "stargold"), targetSize: CGSize(width: 100.0, height: 40.0)), for: .normal, barMetrics: .default)
        flag = flag ? false : true
    }
    
    @objc func addToCart() {
        if fireViewModel.cartID.contains("\(self.movies[self.currentIndex].id)") {
            fireService.remove(self.movies[self.currentIndex])
            fireViewModel.cartID.remove("\(self.movies[self.currentIndex].id)")
            showAlert(title: "", message: "\(self.movies[self.currentIndex].title) removed from cart")
        } else {
            fireService.add(self.movies[self.currentIndex])
            fireViewModel.cartID.insert("\(self.movies[self.currentIndex].id)")
            showAlert(title: "", message: "\(self.movies[self.currentIndex].title) added to cart")
        }
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
