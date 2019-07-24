//
//  FireViewModel.swift
//  AtCinemas-iOS
//
//  Created by Hammed opejin on 6/15/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import Foundation

let fireViewModel = FireViewModel.shared

class FireViewModel {
    
    static let shared = FireViewModel()
    private init() {}
    
    func getFire() {
        
        fireService.get { [unowned self] movies, err in
            
            if err != nil {
                NotificationCenter.default.post(name: Notification.Name.FireNotification, object: nil)
                print(err?.localizedDescription as Any)
                return
            }
           
            self.cartMovies = movies
            print("Fire Count: \(self.cartMovies.count)")
            
        }
    }
    
    private func setCartIDs() {
        cartMovies.forEach({cartID.insert("\($0.id)")})
    }
    
}
