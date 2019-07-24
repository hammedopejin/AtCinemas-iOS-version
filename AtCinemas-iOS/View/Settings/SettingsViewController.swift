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
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Utils.lockOrientation(.portrait, andRotateTo : .portrait)
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Utils.lockOrientation(.all)
    }

    func setupSettings() {
        settingsTableView.tableFooterView = UIView(frame: .zero)
    }
    
}

//MARK: TableView
extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
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
        
        
        return UITableViewCell()
    }
}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
        
    }
    
}
