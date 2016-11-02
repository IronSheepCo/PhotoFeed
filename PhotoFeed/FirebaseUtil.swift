//
//  FirebaseUtil.swift
//  PhotoFeed
//
//  Created by Mac on 02/11/2016.
//  Copyright © 2016 ironsheep.tech. All rights reserved.
//

import Foundation
import Firebase
import GeoFire

class FirebaseUtil
{
    let ref:FIRDatabaseReference
    let geofire:GeoFire
    
    static let instance:FirebaseUtil = FirebaseUtil()
    
    fileprivate init()
    {
        FIRApp.configure()
        
        ref = FIRDatabase.database().reference()
        geofire = GeoFire(firebaseRef: ref.child("locations"))
    }
    
}
