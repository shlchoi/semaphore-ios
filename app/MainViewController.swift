//
//  MainViewController.swift
//  Semaphore
//
//  Created by Samson on 2017-02-15.
//  Copyright © 2017 Samson. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var letterView:UIView?;
    @IBOutlet weak var letterText:UILabel?;
    
    @IBOutlet weak var magazineView:UIView?;
    @IBOutlet weak var magazineText:UILabel?;
    
    @IBOutlet weak var newspaperView:UIView?;
    @IBOutlet weak var newspaperText:UILabel?;
    
    @IBOutlet weak var parcelView:UIView?;
    @IBOutlet weak var parcelText:UILabel?;
    
    @IBOutlet weak var tableView:UITableView?;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
