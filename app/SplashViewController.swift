//
//  Semaphore - iOS
//  iOS application accompanying Semaphore
//  See https://shlchoi.github.io/semaphore/ for more information about Semaphore
//
//  SplashViewController.swift
//  Copyright © 2017 Samson H. Choi
//
//  See https://github.com/shlchoi/semaphore-ios/blob/master/LICENSE for license information
//

import UIKit
import FirebaseAuth

class SplashViewController: UIViewController {
    override func viewDidLoad() {
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            if FIRAuth.auth()?.currentUser != nil {
                self.performSegue(withIdentifier: "authenticatedSegue", sender: self)
            } else {
                self.performSegue(withIdentifier: "unauthenticatedSegue", sender: self)
            }
        }
    }
}
