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
        
        locationManager.distanceFilter = 3
        
        locationManager.startUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let lastLocation = locations.last!
        
        let region = MKCoordinateRegionMake(lastLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01))
        
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func longPressOnMap(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state != UIGestureRecognizerState.began
        {
            return
        }
        
        let touchLocation = sender.location(in: mapView)
        let coordinates = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        
        let alert = UIAlertController(title: "Add feed", message: "Want to add a PhotoFeed at this location?", preferredStyle: .alert )
        
        let okAction = UIAlertAction(title: "OK", style: .default ){action in
            self.createPhotoFeed( coordinates )
        }
        
        let cancelAction = UIAlertAction(title:"Cancel", style: .cancel ){action in}
        
        alert.addAction( okAction )
        alert.addAction( cancelAction )
        
        present( alert, animated:true )
    }
    
    fileprivate func createPhotoFeed(_ coords: CLLocationCoordinate2D )
    {
        let data: [String:Any] = ["creator": UserSettings.ID!, "location":["lat":coords.latitude, "long":coords.longitude]]
        
        FirebaseUtil.instance.ref.child( "photofeeds" ).child( UUID().uuidString ).setValue(data)
    }
    
}
