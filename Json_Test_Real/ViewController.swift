//
//  ViewController.swift
//  Json_Test_Real
//
//  Created by Michael Christie on 19/02/2019.
//  Copyright © 2019 Michael Christie. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate{
    
    
    var coordinates: [String] = []
    var names: [String] = []
    
    var search1:String = ""
    var lat :String = ""
    var long: String = ""
    var latLong: String!
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        
        //let WEATHER_URL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=54.258732699999996,-8.4587171&radius=1000&keyword=restaurant&key=AIzaSyDlMpFeJnAIjRNkIHwmE0y64Y2OldEgZvo"
        
        //let searchquery = "Sligo"
        
        
        
        
        
        let lat = 54.2785726
        let long = -8.4573234
        
        
        convertLatLongToAddress(latitude: lat, longitude: long)
        
        
        // print("x: "+search1)
        //search = street1+" "+city1+" "+country1
        
        
        // getWeatherData(url: WEATHER_URL)
    }
    
    
    func getWeatherData(searchQuery: String) {
        
        print("Search query: "+searchQuery)
        print()
        
        
        //the general site seeing based off of location
        //let WEATHER_URL = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=things+to+do+in+\(searchQuery)&language=en&key=AIzaSyDlMpFeJnAIjRNkIHwmE0y64Y2OldEgZvo"
        
        
        //keywords area based off of location
        //save for restaurants and pubs
        // let WEATHER_URL2 = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=historical+buildings+in\(searchQuery)&language=en&key=AIzaSyDlMpFeJnAIjRNkIHwmE0y64Y2OldEgZvo"
        
        //restauraunts + bars short
        // let WEATHER_URL2 = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=54.2785412,-8.4574523&radius=1500&keyword=restaurants+pubs&key=AIzaSyDlMpFeJnAIjRNkIHwmE0y64Y2OldEgZvo"
        
        
        //restauraunts + bars short
        let WEATHER_URL2 = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=54.2785412,-8.4574523&radius=5000&keyword=restaurants+pubs&key=AIzaSyDlMpFeJnAIjRNkIHwmE0y64Y2OldEgZvo"
        
        
        
        Alamofire.request(WEATHER_URL2).responseJSON {
            
            response in
            
            if response.result.isSuccess {
                
                let weatherJSON : JSON = JSON(response.result.value!)
                //print(weatherJSON)
                self.updateWeatherData(json: weatherJSON)
                
                
               
                
                
                
            }
            else {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    
    
    func updateWeatherData(json : JSON){
        
        var results: [String] = []
        
        var i = 0
        while i <= 4
        {
            var element:String
            let tempResult = json["results"][i]["name"]
            
            
            if tempResult != JSON.null{
                element = tempResult.string!
                results += [element]
                i = i + 1
            }
            else{
                break
            }
        }
        
        if i == 0
        {
            print("no results")
        }
        
        for t in results {
            //print(t)
            convertAddressToLatLong(placename:t)
            
        }
        
        
        
        
       
    }
    
    
    func convertLatLongToAddress(latitude:Double,longitude:Double){
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        var city1 = "",country1:String = ""
        var search:String = ""
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Street address
            if let street = placeMark.thoroughfare {
              //  print("Street: ",street)
            }
            
            // City
            if let city = placeMark.locality {
                //print("city: ",city)
                city1 = city
            }
            
            // Country
            if let country = placeMark.country {
                //print("Country: ",country)
                country1 = country
                
                
                search = city1+"+"+country1
                
                self.search1 = search
                
                
                self.getWeatherData(searchQuery: self.search1)
            }
        })
        
        //print("2: "+self.search1)
        
    }
    
    func convertAddressToLatLong(placename: String) {
        
        let newString = placename.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        
        //print(newString)
        
        Alamofire.request("https://maps.googleapis.com/maps/api/geocode/json?address=+\(newString)&key=AIzaSyDlMpFeJnAIjRNkIHwmE0y64Y2OldEgZvo").responseJSON {
            
            response in
            
            if response.result.isSuccess
            {
                let json : JSON = JSON(response.result.value!)
                
                let x = json["results"][0]["geometry"]["location"]["lat"].stringValue
                let y = json["results"][0]["geometry"]["location"]["lng"].stringValue
                
                
                
                
                self.doSomething(withlatLong: x+","+y, name: newString)
                
            }
                
            else
            {
                print("Error \(String(describing: response.result.error))")
            }
        }
        
       
        
    }
    
    private func doSomething(withlatLong latLong:String,name:String ) {
        //Do whatever you want with latLong
        
        
        coordinates += [latLong]
        names += [name]
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! MapsViewController
        
        vc.namesArray = self.names
        vc.coordinatesArray = self.coordinates
        
    }
}
