//
//  FeedAnnotation.swift
//  PhotoFeed
//
//  Created by Mac on 02/11/2016.
//  Copyright © 2016 ironsheep.tech. All rights reserved.
//

import Foundation
import MapKit

class FeedAnnotation: NSObject, MKAnnotation{
    
    var coordinate: CLLocationCoordinate2D
    var title:String?
    var firebaseKey:String
    
    init(_ loc: CLLocationCoordinate2D, firKey:String )
    {
        coordinate = loc
        title = firKey.substring(to: firKey.index( firKey.startIndex, offsetBy:8) )
        firebaseKey = firKey
    }
    
}
