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

class SpotsTabController: UIViewController, CLLocationManagerDelegate{
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    fileprivate let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let lastLocation = locations.last!
        
        let region = MKCoordinateRegionMake(lastLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01))
        
        mapView.setRegion(region, animated: true)
    }
    
}
