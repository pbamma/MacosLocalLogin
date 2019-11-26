//
//  ViewController.swift
//  MacosLocalLogin
//
//  Created by Philip Starner on 11/24/19.
//  Copyright © 2019 Philip Starner. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    
    @IBOutlet var textView: NSTextView!
    private var isLoggedIn = false
    private var firstTimeUse:Bool {
        let defaults = UserDefaults.standard
        if let value = defaults.value(forKey: Constants.FirstTimeAppUse) as? Bool {
            return value
        }
        return true
    }
    
    @IBOutlet weak var loginButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.logout()
    }
    
    // MARK: button methods
    
    @IBAction func onLoginPressed(_ sender: Any) {
        if firstTimeUse {
            self.performSegue(withIdentifier: "CreatePasswordSegue", sender: nil)
        } else if !isLoggedIn {
            self.performSegue(withIdentifier: "LoginSegue", sender: nil)
        } else {
            self.logout()
        }
    }
    
    @IBAction func onResetAppPressed(_ sender: Any) {
        self.logout()
        //This will convince the app that it is first time use,
        //which will cause the create password view to appear
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: Constants.FirstTimeAppUse)
        
        do {
            try KeychainManager.shared.removeFromKeychain()
            print("Keychain removal success.")
        } catch {
            print("Problem removing from keychain")
        }
    }
    
    
    // MARK: segue method
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        weak var weakSelf =  self
        if segue.identifier == "CreatePasswordSegue"{
            let vc = segue.destinationController as! CreatePasswordViewController
            vc.parentVC = weakSelf
        } else if segue.identifier == "LoginSegue"{
            let vc = segue.destinationController as! LoginViewController
            vc.parentVC = weakSelf
        }
    }
    
    
    // MARK: parent sheet return update methods
    
    func newPasswordCreated() {
        self.loginSuccess()
    }
    
    func loginCompleted() {
        self.loginSuccess()
    }
    
    
    // MARK: login methods
    
    func loginSuccess() {
        self.loginButton.title = "Logout"
        self.isLoggedIn = true
        textView.isEditable = true
        textView.backgroundColor = NSColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
    }
    
    func logout() {
        self.loginButton.title = "Login"
        self.isLoggedIn = false
        textView.isEditable = false
        textView.backgroundColor = NSColor.init(red: 247/255.0, green: 216/255.0, blue: 216/255.0, alpha: 1)
    }
    
}



