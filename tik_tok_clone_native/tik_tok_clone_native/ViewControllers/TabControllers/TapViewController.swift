//
//  TapViewController.swift
//  tik_tok_clone_native
//
//  Created by Abhishek Biswas on 23/03/24.
//

import UIKit

class TapViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.tabBar.barTintColor = UIColor.white
        self.tabBar.isTranslucent = false
        self.tabBar.backgroundColor = .white
        self.tabBar.layer.borderColor = UIColor.black.withAlphaComponent(0.15).cgColor
        self.tabBar.layer.borderWidth = 0.55
        self.tabBar.layer.cornerRadius = 15
    }
}
