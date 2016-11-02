//
//  FeedViewController.swift
//  PhotoFeed
//
//  Created by Mac on 02/11/2016.
//  Copyright © 2016 ironsheep.tech. All rights reserved.
//

import Foundation
import UIKit

class FeedViewController:UIViewController
{
    var firKey:String!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = firKey.substring(to: firKey.index(firKey.startIndex, offsetBy:8))
    }
    
}
