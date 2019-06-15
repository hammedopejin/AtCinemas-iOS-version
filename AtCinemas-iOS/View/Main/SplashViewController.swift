//
//  SplashViewController.swift
//  AtCinemas-iOS
//
//  Created by Hammed opejin on 6/14/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import UIKit
import Firebase

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        if Auth.auth().currentUser != nil {
            
            let tab = goToHome()
            appDelegate.window?.rootViewController = tab
            
        } else {
            
            let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            appDelegate.window?.rootViewController = loginVC
            
        }
    }
    
    //MARK: Helper
    func dismissTab(_ tabController: UITabBarController) {
        tabController.dismiss(animated: true, completion: nil)
        print("Dismissed TabBarController")
    }
    

}
