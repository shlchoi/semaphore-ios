//
//  SplashViewController.swift
//  Semaphore
//
//  Created by Samson on 2017-02-17.
//  Copyright © 2017 Samson. All rights reserved.
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
