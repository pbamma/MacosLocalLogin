//
//  BaseViewController.swift
//  MacosLocalLogin
//
//  Created by Philip Starner on 11/26/19.
//  Copyright © 2019 Philip Starner. All rights reserved.
//

import Cocoa

class BaseViewController: NSViewController {
    var parentVC: MainViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func performDismiss() {
        //dismiss sheet
        if let parentVC = self.parentVC {
            parentVC.newPasswordCreated()
        }
        self.dismiss(self)
    }
    
}
