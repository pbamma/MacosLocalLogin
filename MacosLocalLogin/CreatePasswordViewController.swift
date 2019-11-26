//
//  CreatePasswordViewController.swift
//  MacosLocalLogin
//
//  Created by Philip Starner on 11/25/19.
//  Copyright © 2019 Philip Starner. All rights reserved.
//

import Cocoa



class CreatePasswordViewController: BaseViewController {
    @IBOutlet weak var userNameText: NSTextField!
    @IBOutlet weak var passwordText: NSSecureTextField!
    @IBOutlet weak var reEnterPasswordText: NSSecureTextField!
    
    @IBOutlet weak var instructionsText: NSTextField!
    @IBOutlet weak var saveButton: NSButton!
    
    @IBOutlet weak var progressSpinner: NSProgressIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    func setupViews() {
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.init(red: 168/255.0, green: 245/255.0, blue: 247/255.0, alpha: 1).cgColor
        self.progressSpinner.isHidden = true
    }
    
    
    @IBAction func onSave(_ sender: Any) {
        let isValid = validateForm()
        
        if isValid {
            //disable Save button
            self.saveButton.isEnabled = false
            //show spinner
            self.progressSpinner.isHidden = false
            self.progressSpinner.startAnimation(self)
            
            
            do {
                try KeychainManager.shared.saveToKeychain(userName: self.userNameText.stringValue, password: self.passwordText.stringValue)

                instructionsText.stringValue = "Success!"
                
                //stop spinner
                self.progressSpinner.isHidden = true
                self.progressSpinner.stopAnimation(self)
                
                //set user defaults
                let defaults = UserDefaults.standard
                defaults.set(false, forKey: Constants.FirstTimeAppUse)
                
                self.performDismiss()
            } catch {
                self.instructionsText.stringValue = "Problem saving to keychain.  Please contact developer"
            }
            
            
        }
    }
    
    // MARK: validation
    
    private func validateForm() -> Bool {
        var areFieldsValid = false
        
        if self.userNameText.stringValue.count < 2 ||
            self.passwordText.stringValue.count < 2 ||
            self.reEnterPasswordText.stringValue.count < 2 {
            self.instructionsText.stringValue = "All fields must have at least 2 characters."
            return areFieldsValid
        } else if self.passwordText.stringValue != self.reEnterPasswordText.stringValue {
            self.instructionsText.stringValue = "Password fields must match."
            return areFieldsValid
        } else {
            //fall through
            areFieldsValid = true
            return areFieldsValid
        }
    }

}
