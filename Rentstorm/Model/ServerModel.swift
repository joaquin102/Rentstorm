//
//  ServerModel.swift
//  Rentstorm
//
//  Created by Joaquin Pereira on 3/14/18.
//  Copyright © 2018 Joaquin Pereira. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class ServerModel: NSObject {

    static var RADIUS = 20 //Miles
    
    class func rates(location:CLLocation, startDate:Date, endDate:Date, block: @escaping (_ rates:[Rate]) -> Void) {
        
        //Format dates
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Apply required date format
        let startDateString: String = dateFormatter.string(from: startDate)
        let endDateString: String = dateFormatter.string(from: endDate)
        
        //let url = "https://api.sandbox.amadeus.com/v1.2/cars/search-circle?apikey=8ziGGBD5UYagqCGpPGKAk0tCg7BHpnhg&latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)&radius=42&pick_up=\(startDateString)&drop_off=2018-06-08"
        
        let url = "https://api.sandbox.amadeus.com/v1.2/cars/search-circle?apikey=8ziGGBD5UYagqCGpPGKAk0tCg7BHpnhg&latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)&radius=\(RADIUS)&pick_up=\(startDateString)&drop_off=\(endDateString)";
        
        //Make the call
        Alamofire.request(url).responseJSON { response in
            
            //Check for data
            if let json = response.data {
                
                //Applying swifty
                let data = try! JSON(data: json)
                
                //Get all rates as an array
                let rates = data["results"].array;
                let code = data["status"].int;
                
                //If there are rates, then:
                if let rates = rates {
                    
                    //Create rates objects
                    let ratesObjects = self.createRateObjects(serverData: rates, currentLocation: location, startDate: startDate, endDate: endDate)
                    
                    //Sort them by distance
                    let rateObjectsSorted = ratesObjects.sorted(by: {
                        
                        $0.distanceToBranch! < $1.distanceToBranch!
                        
                    })
                    
                    //Call block
                    block(rateObjectsSorted);
                
                }else{
                    
                    block([])
                }
                
            }
            
        }
        
        
    }
    
    
    class func rates(place:Place, startDate:Date, endDate:Date, block: @escaping (_ rates:[Rate]) -> Void) {
     
        //Get place coordinates
        place.placeLocation { (location) in
            
            LocationModel.sharedInstance.currentLocation(block: { (currentLocation, error) in
                
                if error == nil {
                    
                    //Format dates
                    let dateFormatter: DateFormatter = DateFormatter()
                    
                    // Set date format
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    
                    // Apply required date format
                    let startDateString: String = dateFormatter.string(from: startDate)
                    let endDateString: String = dateFormatter.string(from: endDate)
                    
                    //Make the call
                    Alamofire.request("https://api.sandbox.amadeus.com/v1.2/cars/search-circle?apikey=8ziGGBD5UYagqCGpPGKAk0tCg7BHpnhg&latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)&radius=\(RADIUS)&pick_up=\(startDateString)&drop_off=\(endDateString)").responseJSON { response in
                        
                        //Check for data
                        if let json = response.data {
                            
                            //Applying swifty
                            let data = try! JSON(data: json)
                            
                            //Get all rates as an array
                            let rates = data["results"].array;
                            let code = data["status"].int;
                            
                            //If there are rates, then:
                            if let rates = rates {
                                
                                //Create rates objects
                                let ratesObjects = self.createRateObjects(serverData: rates, currentLocation: currentLocation!, startDate: startDate, endDate: endDate)
                                
                                //Sort them by distance
                                let rateObjectsSorted = ratesObjects.sorted(by: {
                                    
                                    $0.distanceToBranch! < $1.distanceToBranch!
                                    
                                })
                                
                                //Call block
                                block(rateObjectsSorted);
                                
                            }else{
                                
                                block([])
                            }
                            
                        }
                        
                    }
                
                }else{
                    
                    print("LOCATION IS OFF");
                }
                

            })

        }
        
    }
    
    
    class func createRateObjects(serverData:[JSON], currentLocation:CLLocation, startDate:Date, endDate:Date) -> [Rate]{
        
        var rates = [Rate]();
        
        for objectInfo in serverData {
            
            let locationInfo = objectInfo["location"].dictionary;
            let location = CLLocation.init(latitude: (locationInfo!["latitude"]?.double)!, longitude: (locationInfo!["longitude"]?.double)!)
            let distanceToBranch = currentLocation.distance(from: location) * 0.000621371192; //miles
            
            let providerInfo = objectInfo["provider"].dictionary;
            let company = providerInfo!["company_name"]?.string;
            let addressInfo = objectInfo["address"].dictionary;
            //let country = addressInfo!["country"]?.string;
            let city = addressInfo!["city"]?.string;
//            let region = addressInfo!["region"]?.string;
//            let street = addressInfo!["line1"]?.string;
            
            var address = ""
            
            if let branchCity = city {
                
                address = branchCity
            }

            
            let cars = objectInfo["cars"].array;
            
            if let cars = cars {
                
                for carRateInfo in cars {
                    
                    let ratesList = carRateInfo["rates"].array;
                    let dailyRateInfo = ratesList?.first?.dictionary; //DAILY
                    
                    let rateType = Rate.rateType(rateName: (dailyRateInfo!["type"]?.string)!);
                    let priceInfo = dailyRateInfo!["price"]?.dictionary;
                    let rateCurrency = priceInfo!["currency"]?.string;
                    let ratePrice = priceInfo!["amount"]?.string;

                    let carInfo = carRateInfo["vehicle_info"].dictionary;
                    let transmission = Rate.transmissionType(transmission: (carInfo!["transmission"]?.string)!);
                    let carType = Rate.carType(carTypeName: (carInfo!["type"]?.string)!);
                    let carCategory = Rate.carCategory(category: (carInfo!["category"]?.string)!);
                    let ac = carInfo!["air_conditioning"]?.bool;
                    
                    let totalInfo = carRateInfo["estimated_total"].dictionary;
                    let totalAmount = totalInfo!["amount"]?.string;
                    
                    //Create rate
                    let rate = Rate.init(company: company!, companyLocation: location, branchAddress:address, distanceToBranch:distanceToBranch, rateType: rateType, currency: rateCurrency!, startDate:startDate, endDate:endDate, ratePrice: ratePrice!, transmission: transmission, ac: ac!, carType: carType, category: carCategory, total: totalAmount!);
                    
                    
                    //Add to array
                    rates.append(rate);
                }
            }
        }
        
        return rates;
        
    }
    
}



