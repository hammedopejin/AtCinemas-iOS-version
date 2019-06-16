//
//  CartViewController.swift
//  AtCinemas-iOS
//
//  Created by Hammed opejin on 6/14/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {

    var collectionView: UICollectionView!
    
    
    override func loadView() {
        super.loadView()
        
        setupCollectionView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createCartObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fireViewModel.getFire()
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.setupToFill(superView: view)
        collectionView.register(UINib(nibName: MovieCollectionCell.identifier, bundle: nil), forCellWithReuseIdentifier: MovieCollectionCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        collectionView.addSubview(navBar)
        let navItem = UINavigationItem(title: "Cart")
        navBar.setItems([navItem], animated: false)
    }
    
    func createCartObserver() {
        NotificationCenter.default.addObserver(forName: Notification.Name.FireNotification, object: nil, queue: .main) {
            [unowned self] _ in
            self.collectionView.reloadData()
            if fireViewModel.cartMovies.isEmpty {
                self.showAlert(title: "Cart Empty!", message: "No Movie in the cart")
            }
        }
    }
    
}


extension CartViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fireViewModel.cartMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionCell.identifier, for: indexPath) as! MovieCollectionCell
        
        let movie = fireViewModel.cartMovies[indexPath.row]
        cell.configure(movie: movie)
        
        return cell
    }
    
}

extension CartViewController: UICollectionViewDelegateFlowLayout {
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
        
        if UIScreen.main.bounds.size.width > 500{
            return .init(top: 10, left: 30, bottom: 10, right: 30)
        }else{
            return .init(top: 10, left: 2, bottom: 10, right: 2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: UIScreen.main.bounds.size.width, height: 44)
    }
    
}

extension UIView {
    func setupToFill(superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        superView.addSubview(self)
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
    }
}
