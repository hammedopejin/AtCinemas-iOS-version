//
//  LoginViewController.swift
//  AtCinemas-iOS
//
//  Created by Hammed opejin on 6/14/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var googleButton: GIDSignInButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var guestLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLogin()
    }
   
    @IBAction func googleButtonTapped(_ sender: UIButton) {
        
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func emailButtonTapped(_ sender: UIButton) {
        
        let alert = UIAlertController(title: nil, message: "Enter email and password", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let login = UIAlertAction(title: "Login", style: .default) { _ in
            guard let fields = alert.textFields, let emailField = fields.first, let passwordField = fields.last else {
                return
            }
            emailField.placeholder = "Enter Email"
            passwordField.placeholder = "Enter Password"
            passwordField.isSecureTextEntry = true
            
            if emailField.text == "" || passwordField.text == "" {
                print("All text fields must be entered properly!")
                return
            }
            
            if let email = emailField.text, let password = passwordField.text {
                Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                    if error == nil {
                        if let user = user {
                            
                            print("Successful SignIn: \(user.user.uid)")
                            let tab = self.goToHome()
                            self.present(tab, animated: true, completion: nil)
                        }
                    } else {
                        
                        Auth.auth().createUser(withEmail: email, password: password, completion: { [unowned self] (user, error) in
                            
                            if error != nil {
                                print("Registration failed, invalid credentials")
                                self.showError(title: "Error", message: error!.localizedDescription)
                                
                            } else {
                                print("Successfully authenticated with Firebase")
                                if let user = user {
                                    print("Successful SignIn: \(user.user.uid)")
                                    let tab = self.goToHome()
                                    self.present(tab, animated: true, completion: nil)
                                }
                            }
                            
                        })
                        
                    }
                })
                
            }
        }
        
        alert.addTextField(configurationHandler: nil)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(login)
        alert.addAction(cancel)
        present(alert, animated: true)
        
    }
    
    @IBAction func guestButtonTapped(_ sender: UITapGestureRecognizer) {
        let tab = self.goToHome()
        self.present(tab, animated: true, completion: nil)
    }
    
    func setupLogin() {
        
        googleButton.layer.cornerRadius = googleButton.layer.frame.height / 3
        emailButton.layer.cornerRadius = emailButton.layer.frame.height / 3
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        
    }
    
}

//MARK: GoogleDelegate
extension LoginViewController: GIDSignInUIDelegate, GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        //First check if user signs in Google successfully
        if let err = error {
            print("Error Signing in: \(err.localizedDescription)")
            return
        }
        
        guard let authentication = user.authentication else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        //If so, sign user in with credential from Google to Firebase
        Auth.auth().signInAndRetrieveData(with: credential) { [unowned self] (result, error) in
            if let err = error {
                print("Error Signing in: \(err.localizedDescription)")
                return
            }
            
            if let auth = result {
                print("Successful SignIn: \(auth.user.uid)")
                let tab = self.goToHome()
                self.present(tab, animated: true, completion: nil)
            }
        }
    
    }
    
}
