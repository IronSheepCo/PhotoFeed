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
import Toast_Swift
import GeoFire

class SpotsTabController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    fileprivate let locationManager = CLLocationManager()
    fileprivate var query: GFRegionQuery!
    
    fileprivate let feedSegue = "go_to_feed"
    
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
        
        //geo fire query update for feeds
        if let query = query
        {
            query.region = region
        }
        else
        {
            query = FirebaseUtil.instance.geofire.query(with: region )
            query.observe( .keyEntered, with:photoFeed )
        }
    }
    
    fileprivate func photoFeed( id:String?, loc: CLLocation? )
    {
        mapView.addAnnotation(FeedAnnotation(loc!.coordinate, firKey:id!))
    }
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation is MKUserLocation
        {
            return nil
        }
        
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: "customMKAnnotationViewId")
        
        if view == nil
        {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "customMKAnnotationViewId")
            
            let rightButton = UIButton(type: .detailDisclosure )
            view?.rightCalloutAccessoryView = rightButton
            view?.canShowCallout = true
        }
        
        return view
    }
    
    public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        guard let annon = view.annotation as? FeedAnnotation else{
            return
        }
        
        performSegue(withIdentifier: feedSegue, sender: annon)
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
        let data: [String:Any] = ["creator": UserSettings.ID!, "no":0]
        let feedId = UUID().uuidString
        let location:CLLocation = CLLocation( latitude:coords.latitude, longitude:coords.longitude )
        
        FirebaseUtil.instance.ref.child( "photofeeds" ).child( feedId ).setValue(data)
        FirebaseUtil.instance.geofire.setLocation(location, forKey: feedId){
            error in
            
            if error != nil
            {
                self.view.makeToast("An error occured. Feed not created", duration:2, position: .center)
            }
            else
            {
                self.view.makeToast("Photo feed created", duration:2, position:.center)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == feedSegue
        {
            guard let destination = segue.destination as? FeedViewController else
            {
                return
            }
            
            guard let realSender = sender as? FeedAnnotation else
            {
                return
            }
            
            destination.firKey = realSender.firebaseKey
        }
        
    }
    
}
