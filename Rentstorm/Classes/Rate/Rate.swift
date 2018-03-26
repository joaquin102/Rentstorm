//
//  Car.swift
//  Rentstorm
//
//  Created by Joaquin Pereira on 3/14/18.
//  Copyright © 2018 Joaquin Pereira. All rights reserved.
//

import CoreLocation

enum CarType {
    
    case TwoFourDoor
    case Special
    case PickupRegular
    case SUV
    case PassengerVan
    case Other
}

enum CarCategory:String {
    
    case Mini = "Mini"
    case Compact = "Compact"
    case Economy = "Economy"
    case Standard = "Standard"
    case Premium = "Premium"
    case Intermediate = "Intermediate"
    case Special = "Special"
    case Fullsize = "Fullsize"
    case Other = "Other"
}

enum RateType:String {
    
    case Daily = "Daily"
    case Weekly = "Weekly"
    case Weekend = "Weekend"
    case Monthly = "Monthly"
    case Yearly = "Yearly"
    case Other = "Other"
}

enum Transmission:String {
    
    case Manual = "Manual"
    case Automatic = "Automatic"
    case Other = "Other"
}

import UIKit

class Rate: NSObject {
    
    var suggestedName:String!
    
    var branchLocation:CLLocation?
    var branchAddress:String?
    var distanceToBranch:Double?
    var company:String?
    
    var rateType:RateType?
    var currency:String?
    var ratePriceString:String?
    
    var startDate:Date?;
    var endDate:Date?;
    
    var category:CarCategory?
    
    var people:Int!
    var luggage:Int!
    var transmission:Transmission!
    var ac:Bool!
    
    var totalString:String?
    
    var ratePrice:Double?
    var total:Double?
    
    init(company:String, companyLocation:CLLocation, branchAddress:String, distanceToBranch:Double, rateType:RateType, currency:String, startDate:Date, endDate:Date, ratePrice:String, transmission:Transmission, ac:Bool, carType: CarType, category:CarCategory, total:String) {
        
        super.init();
        
        self.branchLocation = companyLocation;
        self.branchAddress = branchAddress;
        self.distanceToBranch = distanceToBranch;
        self.company = company;
        
        self.rateType = rateType;
        self.currency = currencySymbol(rateCurrency: currency);
        self.ratePriceString = ratePrice;
        
        self.startDate = startDate;
        self.endDate = endDate;
        
        self.category = category;
        
        self.transmission = transmission;
        self.people = maxPeople(carType: carType);
        self.luggage = maxLuggage(carType: carType);
        self.ac = ac;
        
        self.totalString = total;
        
        self.ratePrice = Double(self.ratePriceString!);
        self.total = Double(self.totalString!);
        
        //
        self.suggestedName = Rate.suggestedVehicleName(category: category);
        
        //Dates
        
        
    }
    
    
    
    
    
    //MARK: - Helpers -
    
    class func suggestedVehicleName(category:CarCategory) -> String{
        
        if category.rawValue == "Mini" {
            
            return "Mini Cooper";
        }
        
        if category.rawValue == "Compact" {
            
            return "Ford Focus";
        }
        
        if category.rawValue == "Economy" {
            
            return "Nissan Sentra";
        }
        
        if category.rawValue == "Standard" {
            
            return "Nissan Altima";
        }
        
        if category.rawValue == "Premium" {
            
            return "Mercedes C Class";
        }
        
        if category.rawValue == "Intermediate" {
            
            return "Chrysler";
        }
        
        if category.rawValue == "Special" {
            
            return "Jaguar F-TYPE";
        }
        
        if category.rawValue == "Fullsize" {
            
            return "Santa Fe";
        }
        
        return "Ford Focus";
    }
    
    func maxPeople(carType:CarType) -> Int {
        
        if carType == .TwoFourDoor {
            
            return 4;
        }
        
        if carType == .Special {
            
            return 2;
        }
        
        if carType == .PickupRegular {
            
            return 4;
        }
        
        if carType == .SUV {
            
            return 6;
        }
        
        if carType == .PassengerVan {
            
            return 8;
        }
        
        return 4; //Default
    }
    
    func maxLuggage(carType:CarType) -> Int {
        
        if carType == .TwoFourDoor {
            
            return 2;
        }
        
        if carType == .Special {
            
            return 1;
        }
        
        if carType == .PickupRegular {
            
            return 5;
        }
        
        if carType == .SUV {
            
            return 5;
        }
        
        if carType == .PassengerVan {
            
            return 4;
        }
        
        return 2; //Default
    }
    
    func currencySymbol(rateCurrency:String) -> String {
        
        if rateCurrency == "USD" {
            
            return "$"
        }
        
        if rateCurrency == "EURO" {
            
            return "€"
        }
        
        return "$" //Default
    }
    
    
    class func carType(carTypeName:String) -> CarType {
        
        
        if carTypeName == "2\\/4 Door" {
            
            return .TwoFourDoor;
        }
        
        if carTypeName == "Special" {
            
            return CarType.Special;
        }
        
        if carTypeName == "Pickup (regular cab)" {
            
            return .PickupRegular;
        }
        
        if carTypeName == "SUV" {
            
            return .SUV;
        }
        
        if carTypeName == "Passenger van" {
            
            return .PassengerVan;
        }
        
        return CarType.Other;
    }
    
    class func carCategory(category:String) -> CarCategory {
        
        if category == "Mini" {
            
            return .Mini;
        }
        
        if category == "Compact" {
            
            return .Compact;
        }
        
        if category == "Economy" {
            
            return .Economy;
        }
        
        if category == "Standard" {
            
            return .Standard;
        }
        
        if category == "Premium" {
            
            return .Premium;
        }
        
        if category == "Intermediate" {
            
            return .Intermediate;
        }
        
        if category == "Special" {
            
            return .Special;
        }
        
        if category == "Fullsize" {
            
            return .Fullsize;
        }
        
        return CarCategory.Other;
    }
    
    class func rateType(rateName:String) -> RateType {
        
        if rateName == "DAILY" {
            
            return .Daily;
        }
        
        if rateName == "WEEKLY" {
            
            return .Weekly;
        }
        
        if rateName == "WEEKEND" {
            
            return .Weekend;
        }
        
        if rateName == "MONTHLY" {
            
            return .Monthly;
        }
        
        if rateName == "YEARLY" {
            
            return .Yearly;
        }
        
        return RateType.Other;
    }
    
    class func transmissionType(transmission:String) -> Transmission {
        
        if transmission == "Automatic" {
            
            return .Automatic;
        }
        
        if transmission == "Manual" {
            
            return .Manual;
        }
        
        
        return .Other;
    }
    
    
}

//extension
extension String {
    func index(at offset: Int, from start: Index? = nil) -> Index? {
        return index(start ?? startIndex, offsetBy: offset, limitedBy: endIndex)
    }
}

extension Substring {
    var string: String { return String(self) }
}
