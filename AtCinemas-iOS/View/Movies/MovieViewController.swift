//
//  ViewController.swift
//  AtCinemas-iOS
//
//  Created by Hammed opejin on 6/8/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import UIKit
import Firebase

class MovieViewController: UIViewController {

    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    let movieViewModel = MovieViewModel()
    let searchController = UISearchController(searchResultsController: nil)
    var by = Constants.Keys.nowPlaying.rawValue
    
    override func loadView() {
        super.loadView()
        
        if Auth.auth().currentUser != nil {
            if var controllers = tabBarController?.viewControllers {
                let tabItem = UITabBarItem(title: "Cart", image: nil, selectedImage: nil)
                let cartVC = CartViewController()
                cartVC.tabBarItem = tabItem
                controllers.append(cartVC)
                tabBarController?.setViewControllers(controllers, animated: true)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        createSearch()
        movieViewModel.requestMoreData(by: by, flag: true)
   
    }
    
    @IBAction func toggleSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            by = Constants.Keys.nowPlaying.rawValue
            movieViewModel.requestMoreData(by: by, flag: true)
        case 1:
            by = Constants.Keys.popular.rawValue
            movieViewModel.requestMoreData(by: by, flag: true)
        default:
            by = Constants.Keys.topRated.rawValue
            movieViewModel.requestMoreData(by: by, flag: true)
        }
    }
    
    func setupCollectionView() {
        movieCollectionView.register(UINib(nibName: MovieCollectionCell.identifier, bundle: Bundle.main), forCellWithReuseIdentifier: MovieCollectionCell.identifier)
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        movieViewModel.delegate = self
        definesPresentationContext = true
    }
    
    func createSearch() {
        
        searchController.dimsBackgroundDuringPresentation =  false
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.placeholder = "Search for Movie..."
    }
    
    //MARK: Helper func
    func isFiltering() -> Bool {
        
        let isEmpty = searchController.searchBar.text!.isEmpty
        return !isEmpty && searchController.isActive
    }
    
    func filterMovies(by search: String) {
        
        movieViewModel.filteredMovies = movieViewModel.movies.filter({$0.title.lowercased().contains(search.lowercased())})
        
        movieCollectionView.reloadData()
    }
    
}

//MARK: collection view
extension MovieViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isFiltering() ? movieViewModel.filteredMovies.count : movieViewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionCell.identifier, for: indexPath) as! MovieCollectionCell
        
        let movies = isFiltering() ? movieViewModel.filteredMovies : movieViewModel.movies
        let movie = movies[indexPath.row]
        cell.configure(movie: movie)
        
        if indexPath.row > (movies.count - 5) {
            movieViewModel.requestMoreData(by: by, flag: false)
        }
        
        return cell
    }
    
    
}

extension MovieViewController: UICollectionViewDelegateFlowLayout {
    
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
        
        let movies = isFiltering() ? movieViewModel.filteredMovies : movieViewModel.movies
        let movie = movies[indexPath.row]
        movieViewModel.currentMovie = movie
        
        let detailVC = UIStoryboard(name: "Movies", bundle: Bundle.main).instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        
        detailVC.viewModel = movieViewModel
        detailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailVC, animated: true)
       
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if (kind == UICollectionView.elementKindSectionHeader) {
            let headerView: UICollectionReusableView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MovieCollectionViewHeader", for: indexPath)
            
            return headerView
        }
        
        return UICollectionReusableView()
        
    }
}

extension MovieViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let search = searchController.searchBar.text else {
            return
        }
        
        filterMovies(by: search)
    }
}

extension MovieViewController: MovieViewModelDelegate {
    
    func updateView() {
        
        DispatchQueue.main.async {
            self.movieCollectionView.reloadData()
        }
    }
}
