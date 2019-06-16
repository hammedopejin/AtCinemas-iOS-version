//
//  SettingsViewController.swift
//  AtCinemas-iOS
//
//  Created by Hammed opejin on 6/10/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var settingsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Utils.lockOrientation(.portrait, andRotateTo : .portrait)
        if let hash = UserDefaults.standard.value(forKey: Constants.Keys.hash.rawValue) as? String,
            let url = Utils.loadWithFileManager(hash),
            let image = UIImage(contentsOfFile: url.path) {
            userImageView.image = image
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Utils.lockOrientation(.all)
    }
    
    //MARK: Touches Began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        
        if touch?.view == view.viewWithTag(3) {
            
            let imageController = UIImagePickerController()
            imageController.sourceType = .photoLibrary
            imageController.delegate = self
            present(imageController, animated: true, completion: nil)
            
        } else if touch?.view == view.viewWithTag(2) {
            
        }
    }

    func setupSettings() {
        settingsTableView.tableFooterView = UIView(frame: .zero)
    }
    
    func showLogoutView(view: UIView){
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let popoverController = optionMenu.popoverPresentationController {
            popoverController.sourceView = view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        let logoutAction = UIAlertAction(title: "Log Out", style: .destructive){ (alert: UIAlertAction!) in
            self.logOut()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (alert: UIAlertAction!) in
    
        }
        
        optionMenu.addAction(logoutAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func logOut(){
        
        do {
            
            try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
            loginVC.dismissTab(tabBarController!)
            present(loginVC, animated: true, completion: nil)
            
        } catch {
            print("Couldn't sign out Firebase")
        }
    
    }
    
}

//MARK: TableView
extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Auth.auth().currentUser != nil ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 2 }
        if section == 1 { return 3 }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if Auth.auth().currentUser != nil {
            if indexPath.row == 0 && indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "emailCell", for: indexPath)
                cell.textLabel?.text = "Email"
                return cell
            }
            
            if indexPath.row == 1 && indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "passwordCell", for: indexPath)
                cell.textLabel?.text = "Password"
                return cell
            }
            
            if indexPath.row == 0 && indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "termsCell", for: indexPath)
                cell.textLabel?.text = "Terms and Conitions"
                return cell
            }
            if indexPath.row == 1 && indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "privacyCell", for: indexPath)
                cell.textLabel?.text = "Privacy Policy"
                return cell
            }
            
            if indexPath.row == 2 && indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "logoutCell", for: indexPath)
                
                return cell
            }
        } else {
            if indexPath.row == 0 && indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "termsCell", for: indexPath)
                cell.textLabel?.text = "Terms and Conitions"
                return cell
            }
            
            if indexPath.row == 1 && indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "privacyCell", for: indexPath)
                cell.textLabel?.text = "Privacy Policy"
                return cell
            }
        }
        
        return UITableViewCell()
    }
}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = tableView.backgroundColor
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == 0 && indexPath.row == 1 {
           
        }
        
        if indexPath.section == 0 && indexPath.row == 2 {
            
        }
        
        if indexPath.section == 1 && indexPath.row == 0 {

        }
        
        if indexPath.section == 1 && indexPath.row == 1 {

        }
        
        if indexPath.section == 1 && indexPath.row == 2 {
            showLogoutView(view: tableView.cellForRow(at: indexPath)!)
        }
    }
    
}

//MARK: UIPickerControllerDelegate
extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
            let data = image.pngData() else {
                return
        }
        
        Utils.saveWithFileManager(data)
        
        let hash = String("data.hashValue")
        UserDefaults.standard.set(hash, forKey: Constants.Keys.hash.rawValue)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}
