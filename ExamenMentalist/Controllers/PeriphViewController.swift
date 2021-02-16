//
//  PeriphViewController.swift
//  ExamenMentalist
//
//  Created by Théo Champion on 15/02/2021.
//

import UIKit

class PeriphViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension PeriphViewController: UITabBarControllerDelegate {
    
}
