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
    
    init(_ loc: CLLocationCoordinate2D, title:String = "" )
    {
        coordinate = loc
        self.title = title
    }
    
}
