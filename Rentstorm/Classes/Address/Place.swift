//
//  Place.swift
//  Rentstorm
//
//  Created by Joaquin Pereira on 3/15/18.
//  Copyright © 2018 Joaquin Pereira. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class Place: NSObject {

    //Properties
    var name:String?
    var address:String?
    var country:String?
    
    var location:CLLocation?
    
    
    init(searchObject:MKLocalSearchCompletion) {
        
        super.init()
        
        self.name = searchObject.title;
        self.address = searchObject.subtitle;
        self.country = "";
        
    }
    
    init(name:String, address:String, country:String) {
        
        super.init()
        
        self.name = name;
        self.address = address;
        self.country = country;
    }
    
    func placeLocation(block: @escaping (_ location:CLLocation) -> Void) {
        
        if address?.count == 0 {
            
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(self.name!) { (placemarks, error) in
                
                if let array = placemarks {
                    
                    let location = array.first?.location
                    
                    block(location!);
                    
                }else{
                    
                    //Return current location
                    
                }
                
            }
        
        }else{
            
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(self.address!) { (placemarks, error) in
                
                if let array = placemarks {
                    
                    let location = array.first?.location
                    
                    block(location!);
                    
                }else{
                    
                    //Return current location
                    
                }
                
            }
        }
    }

    
}
