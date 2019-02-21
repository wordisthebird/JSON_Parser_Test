//
//  MapsViewController.swift
//  Json_Test_Real
//
//  Created by Michael Christie on 19/02/2019.
//  Copyright © 2019 Michael Christie. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON
import MapKit

class MapsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    var long2: Double = 0.0
    var lat2: Double = 0.0
    var namesArray: [String] = []
    var coordinatesArray: [String] = []
    
    @IBOutlet weak var MapView: GMSMapView!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        
        drawPath()
        
    }
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        
        
        long2 = location.coordinate.longitude
        lat2 = location.coordinate.latitude
        
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
        if MapView.isHidden {
            MapView.isHidden = false
            MapView.camera = camera
        } else {
            MapView.animate(to: camera)
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            MapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    func drawPath()
    {
        //let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=Bicycling&key=AIzaSyAPnrmjCzY2Dd2j28Kmuq7v3XLvFrIavt0"
        print(namesArray[0])
        print(namesArray[1])
        print(namesArray[2])
        print(namesArray[3])
        print()
        
        
        
        
        // working leave it alone
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=54.258803297329756,-8.458667755611835&destination=\(namesArray[0]),Sligo&waypoints=\(namesArray[1]),+Sligo&mode=bicycling&waypoints=(coordinatesArray[1]%7C(coordinatesArray[2]%7C54.258803297329756,-8.458667755611835&key=AIzaSyDO5Jpi7CRDRkmuERJLIGk-wRc3b-vW4y8"
        
        
        //let url = "https://maps.googleapis.com/maps/api/directions/json?origin=54.258803297329756,-8.458667755611835&destination=\(coordinatesArray[0])&mode=bicycling&waypoints=(coordinatesArray[1]%7C(coordinatesArray[2]%7C54.258803297329756,-8.458667755611835&key=AIzaSyDO5Jpi7CRDRkmuERJLIGk-wRc3b-vW4y8"
        
        
        print("URL:"+url)
        print()
        Alamofire.request(url).responseJSON { response in
            //   print(response.request!)  // original URL request
            //   print(response.response!) // HTTP URL response
            //   print(response.data!)     // server data
            //   print(response.result)   // result of response serialization
            
            do {
                let json = try JSON(data: response.data!)
                let routes = json["routes"].arrayValue
                
                for route in routes
                {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.map = self.MapView
                    polyline.strokeWidth = 4
                    
                    
                    let position = CLLocationCoordinate2D(latitude: 54.2736593, longitude: -8.4766331)
                    let marker = GMSMarker(position: position)
                    marker.map = self.MapView
                    
                    let position2 = CLLocationCoordinate2D(latitude: 54.2716825, longitude: -8.4805958)
                    let marker2 = GMSMarker(position: position2)
                    marker2.map = self.MapView
                }
            }
            catch {
                print("nope")
            }
            
            
            
        }
        
        
        
    }
    
}
