//
//  ViewController.swift
//  AtCinemas-iOS
//
//  Created by Hammed opejin on 6/8/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {

    @IBOutlet weak var movieCollectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    func setupCollectionView() {
        movieCollectionView.register(UINib(nibName: MovieCollectionCell.identifier, bundle: nil), forCellWithReuseIdentifier: MovieCollectionCell.identifier)
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
    }
}

extension MovieViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionCell.identifier, for: indexPath) as! MovieCollectionCell
        
        
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
        return .init(width: width, height: 128)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
