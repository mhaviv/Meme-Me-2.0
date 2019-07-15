//
//  MemeTableViewController.swift
//  Meme Me 2.0
//
//  Created by Michael Haviv on 7/8/19.
//  Copyright © 2019 Michael Haviv. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController  {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
}
