//
//  FavoriteViewController.swift
//  AtCinemas-iOS
//
//  Created by Hammed opejin on 6/11/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    
    var favoriteViewModel: FavoriteMoviesViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        favoriteViewModel.get()
    }
    
    func setupViewModel() {
        favoriteViewModel = FavoriteMoviesViewModel()
        favoriteViewModel.delegate = self
    }
    
    func setupCollectionView() {
        favoriteCollectionView.register(UINib(nibName: MovieCollectionCell.identifier, bundle: Bundle.main), forCellWithReuseIdentifier: MovieCollectionCell.identifier)
        favoriteCollectionView.delegate = self
        favoriteCollectionView.dataSource = self
        definesPresentationContext = true
    }

}

extension FavoriteViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteViewModel.favoriteMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionCell.identifier, for: indexPath) as! MovieCollectionCell
        
        let movies = favoriteViewModel.favoriteMovies
        let movie = movies[indexPath.row]
        cell.configure(movie: movie)
        
        return cell
    }
    
}

extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfCell: CGFloat
        if UIScreen.main.bounds.size.width > 700{
            numberOfCell = 7.3
        }else if UIScreen.main.bounds.size.width > 500{
            numberOfCell = 5.3
        }else{
            numberOfCell = 3.3
        }
        let width = UIScreen.main.bounds.size.width / numberOfCell
        return .init(width: width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if UIScreen.main.bounds.size.width > 500 {
            return .init(top: 10, left: 30, bottom: 10, right: 30)
        }else{
            return .init(top: 10, left: 2, bottom: 10, right: 2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let movies = favoriteViewModel.favoriteMovies
        
        let detailVC = UIStoryboard(name: "Movies", bundle: Bundle.main).instantiateViewController(withIdentifier: "PhotoPageContainerViewController") as! PhotoPageContainerViewController
        
        detailVC.currentIndex = indexPath.row
        detailVC.movies = movies
        detailVC.favoriteViewModel = favoriteViewModel
        detailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
}

extension FavoriteViewController: FavoriteMoviesViewModelDelegate {
    
    func updateView() {
        
        DispatchQueue.main.async {
            self.favoriteCollectionView.reloadData()
        }
    }
    
    func showUpdateAlert() {
        if self.favoriteViewModel.favoriteMovies.isEmpty {
            self.showAlert(title: "",
                           message: "No Favorite Movie yet!")
        }
    }
}
