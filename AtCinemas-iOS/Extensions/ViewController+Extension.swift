//
//  ViewController+Extension.swift
//  AtCinemas-iOS
//
//  Created by Hammed opejin on 6/14/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import UIKit

extension UIViewController{

    func goToHome() -> UITabBarController  {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: "MainTabController") as! UITabBarController
    }

    func showError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        present(alert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
}
