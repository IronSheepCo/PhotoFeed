//
//  FirebaseUtil.swift
//  PhotoFeed
//
//  Created by Mac on 02/11/2016.
//  Copyright © 2016 ironsheep.tech. All rights reserved.
//

import Foundation
import Firebase

class FirebaseUtil
{
    let ref:FIRDatabaseReference
    
    static let instance:FirebaseUtil = FirebaseUtil()
    
    fileprivate init()
    {
        FIRApp.configure()
        
        ref = FIRDatabase.database().reference()
    }
    
}
