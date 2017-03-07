//
//  LoginViewController.swift
//  Semaphore
//
//  Created by Samson on 2017-02-17.
//  Copyright © 2017 Samson. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var credentialView: UIView!
    @IBOutlet weak var logoMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var spacerHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(LoginViewController.keyboardWillShow),
                                               name: Notification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(LoginViewController.keyboardWillHide),
                                               name: Notification.Name.UIKeyboardWillHide,
                                               object: nil)

        self.credentialView.layer.borderColor = UIColor.SemaphoreBlue.cgColor
        self.emailField.delegate = self
        self.passwordField.delegate = self
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailField {
            self.passwordField.becomeFirstResponder()
            return true
        } else if textField == self.passwordField {
            login()
            return true
        }
        return false
    }

    @IBAction func login() {
        guard let email = self.emailField.text else {
            self.emailField.layer.borderColor = UIColor.red.cgColor
            return
        }
        guard let password = self.passwordField.text else {
            self.passwordField.layer.borderColor = UIColor.red.cgColor
            return
        }

        self.passwordField.resignFirstResponder()

        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if user != nil {
                NSLog("User %@ signed in", user?.email ?? "Failed")

                self.performSegue(withIdentifier: "loginSegue", sender: self)
            }

            if error != nil {
                NSLog("Error: %@", error.debugDescription)
            }
        }
    }


    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.logoMarginConstraint.constant = 8
            self.spacerHeightConstraint.constant = keyboardSize.height
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        self.logoMarginConstraint.constant = 64
        self.spacerHeightConstraint.constant = 0
    }
}


