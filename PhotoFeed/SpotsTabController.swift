//
//  SpotsTabController.swift
//  PhotoFeed
//
//  Created by Mac on 01/11/2016.
//  Copyright © 2016 ironsheep.tech. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class SpotsTabController: UIViewController{
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake(45, 90), MKCoordinateSpanMake(0.1, 0.1)), animated: true)
    }
    
}
