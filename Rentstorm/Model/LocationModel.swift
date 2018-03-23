//
//  LocationModel.swift
//  Rentstorm
//
//  Created by Joaquin Pereira on 3/14/18.
//  Copyright © 2018 Joaquin Pereira. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocationModel: NSObject, CLLocationManagerDelegate, MKLocalSearchCompleterDelegate {

    //SINGLETON
    static let sharedInstance = LocationModel()
    
    //Location
    var locationManager:CLLocationManager!
    
    //Search
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    //Block
    var locationBlock: ((_ location:CLLocation?, _ error:NSError?) -> Void)?
    var searchResultsBlock: ((Array<Place>) -> Void)?
    
    override init() {
        
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        searchCompleter.delegate = self;
        
    }
    
    
    
    //MARK: - Public blocks
    
    func currentLocation(block: @escaping (_ currentLocation: CLLocation?, _ error:NSError?) -> Void) {
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.requestLocation()
        
        }else{
            
            print("LOCATION NOT ACTIVATED")
        }
        
        self.locationBlock = block;
        
    }
    
    func currentPlace(block: @escaping (_ place:Place) -> Void) {
        
        //Get current location
        currentLocation { (currentLocation, error) in
            
            if error == nil {
                
                CLGeocoder().reverseGeocodeLocation(currentLocation!) { (placemark, error) in
                    if error != nil {
                        
                        print("There was an error getting current place")
                        
                    } else {
                        
                        let currentPlace = placemark! as [CLPlacemark]
                        
                        if currentPlace.count > 0 {
                            let currentPlace = placemark![0]
                            
                            //                        print(currentPlace.country)
                            //                        print(currentPlace.locality)
                            //                        print(currentPlace.subLocality)
                            //                        print(currentPlace.thoroughfare)
                            //                        print(currentPlace.postalCode)
                            //                        print(currentPlace.subThoroughfare)
                            
                            let nameString = currentPlace.name;
                            var adressString = ""
                            
                            if currentPlace.subThoroughfare != nil {
                                adressString = adressString + currentPlace.subThoroughfare! + " "
                            }

                            if currentPlace.thoroughfare != nil {
                                adressString = adressString + currentPlace.thoroughfare! + ", "
                            }
                            if currentPlace.locality != nil {
                                adressString = adressString + currentPlace.locality! + ", "
                            }
                            if currentPlace.country != nil {
                                adressString = adressString + currentPlace.country! + ", "
                            }
                            if currentPlace.country != nil {
                                adressString = adressString + currentPlace.postalCode! + "."
                            }
                            
                            
                            
                            //Create Place object
                            if nameString != nil { //If the place has a name:
                                
                                let place = Place(name: nameString!, address: adressString, country: currentPlace.country!);
                                place.location = currentLocation;
                                
                                block(place);
                                
                            }else{
                                
                                let place = Place(name: adressString, address: adressString, country: currentPlace.country!);
                                place.location = currentLocation;
                                
                                block(place);
                            }
                            
                        }
                        
                    }
                }
                
            }else{
                
                
            }
  
        }
    }
    
    func autocompleteWithText(text:String, block: @escaping (Array<Place>) -> Void) {
        
        //Block
        searchResultsBlock = block;
        
        //Call
        searchCompleter.queryFragment = text
    }
    
    //MARK: - Geocoding -
    
    func getCoordinatesWithAddress(address:String) {
        
        
    }
    
    
    //MARK: - locations history -
    
    func addPlaceToHistory(place:Place) {
        
        //Get list
        var list = UserDefaults.standard.array(forKey: "searchList") as? [[String:String]]
        
        //Create dic
        let placeInfo = ["name": place.name, "address":place.address, "country":place.country];
        
        //Check for duplicated values
        
        //Insert value at the top
        if list != nil {
            
            list?.insert(placeInfo as! [String : String], at: 0);
        
        }else{
            
            list = [placeInfo as! Dictionary<String, String>];
        }
        
        
        //add
        UserDefaults.standard.setValue(list, forKeyPath: "searchList");
        
        //Save
        UserDefaults.standard.synchronize();
    }
    
    func retrieveSearchHistory() -> [Place] {
        
        let list = UserDefaults.standard.array(forKey: "searchList") as? [[String:String]]
        
        if let list = list {
            
            //Create Place objects
            var places = [Place]()
            
            for placeInfo in list {
                
                places.append(Place.init(name: placeInfo["name"]!, address: placeInfo["address"]!, country:placeInfo["country"]!));
            }
            
            
            return places;
        }
        
       return [];
    }
    
    
    //MARK: - location delegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                
                if CLLocationManager.isRangingAvailable() {
                    
                    
                }
            }
        }
        
        if status == .denied {
            
            
        }
        
        if status == .notDetermined {
            
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let currentLocation :CLLocation = locations[0] as CLLocation
        
        self.locationBlock!(currentLocation, nil);
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        let error = NSError(domain: "Your location is off. Turn it on to use RentStorm", code: 404, userInfo: nil);
        
        self.locationBlock!(nil, error);
        
        print("Error \(error)")
    }
    
    
    //MARK: - Search delegate -
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        
        //Array
        var places = [Place]()
        
        //Results
        searchResults = completer.results
        
        //Create place object
        for result in searchResults  {
            
            places.append(Place.init(searchObject: result));
        }
        
        //call
        searchResultsBlock!(places);
        
    }
}
