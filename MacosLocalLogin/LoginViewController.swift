//
//  LoginViewController.swift
//  MacosLocalLogin
//
//  Created by Philip Starner on 11/25/19.
//  Copyright © 2019 Philip Starner. All rights reserved.
//

import Cocoa

class LoginViewController: BaseViewController {
    @IBOutlet weak var userNameText: NSTextField!
    @IBOutlet weak var passwordText: NSSecureTextField!
    @IBOutlet weak var instructionsText: NSTextField!
    @IBOutlet weak var progressSpinner: NSProgressIndicator!
    @IBOutlet weak var loginButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    func setupViews() {
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.init(red: 247/255.0, green: 245/255.0, blue: 216/255.0, alpha: 1).cgColor
        self.progressSpinner.isHidden = true
    }
    
    @IBAction func onLogin(_ sender: Any) {
        let isValid = validateForm()
        
        if isValid {
            //disable Login button
            self.loginButton.isEnabled = false
            //show spinner
            self.progressSpinner.isHidden = false
            self.progressSpinner.startAnimation(self)
            
            //attempt login
            do {
                try KeychainManager.shared.loginFromKeychain(userName: self.userNameText.stringValue, password: self.passwordText.stringValue)
                    
                self.instructionsText.stringValue = "Success!"
                //logged in!
                view.layer?.backgroundColor = NSColor.init(red: 216/255.0, green: 245/255.0, blue: 216/255.0, alpha: 1).cgColor
                //dismiss sheet
                self.performDismiss()
                    
            } catch {
                self.showIncorrectUserNameOrPassword()
            }
        }
        
    }
    
    // MARK: validation
    
    private func validateForm() -> Bool {
        var areFieldsValid = false
        
        if self.userNameText.stringValue.count < 2 ||
            self.passwordText.stringValue.count < 2 {
            self.instructionsText.stringValue = "All fields must have at least 2 characters."
            
            return areFieldsValid
        } else {
            //fall through
            areFieldsValid = true
            return areFieldsValid
        }
    }
    
    func showIncorrectUserNameOrPassword() {
        instructionsText.stringValue = "Username or Password is incorrect.  Try again."
        self.loginButton.isEnabled = true
        self.progressSpinner.isHidden = true
        self.progressSpinner.stopAnimation(self)
    }
    
}
