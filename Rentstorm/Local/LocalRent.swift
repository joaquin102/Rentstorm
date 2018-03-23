//
//  LocalRent.swift
//  Rentstorm
//
//  Created by Joaquin Pereira on 3/19/18.
//  Copyright © 2018 Joaquin Pereira. All rights reserved.
//

import UIKit
import RealmSwift

class LocalRent: Object {

    @objc dynamic var company:String?
    @objc dynamic var branchLocationLatitude = 0.0
    @objc dynamic var branchLocationLongitude = 0.0
    @objc dynamic var branchAddress:String?;
    
    @objc dynamic var distanceToBranch = 0.0
    
    @objc dynamic var suggestedCarName:String?
    
    @objc dynamic var currency:String?
    
    @objc dynamic var startDateString:String?;
    @objc dynamic var endDateString:String?;
    
    @objc dynamic var people = 0
    @objc dynamic var luggage = 0
    @objc dynamic var transmission = ""
    @objc dynamic var ac = true
    
    var total = 0.0
    
    func create(company:String, branchLocationLatitude:Double, branchLocationLongitude:Double, branchAddress:String, distanceToBranch:Double, suggestedCarName:String, currency:String, startDateString:String, endDateString:String, people:Int, luggage:Int, transmission:String, ac:Bool, total:Double) {
        
        let localRent = LocalRent();
        localRent.company = company;
        localRent.branchLocationLatitude = branchLocationLatitude;
        localRent.branchLocationLongitude = branchLocationLongitude;
        localRent.branchAddress = branchAddress;
        localRent.distanceToBranch = distanceToBranch;
        localRent.suggestedCarName = suggestedCarName;
        localRent.currency = currency;
        localRent.startDateString = startDateString;
        localRent.endDateString = endDateString;
        localRent.people = people;
        localRent.luggage = luggage;
        localRent.transmission = transmission;
        localRent.ac = ac;
        localRent.total = total;
        
        let realm = try! Realm()
        
        try! realm.write {
            
            realm.add(self);
        }

    }

    func save() {
        
        //Get realm access
        let realm = try! Realm();
        
        //Save
        try! realm.write {
            
            realm.add(self);
        }
        
    }
    
    func delete() {
        
        //Get realm access
        let realm = try! Realm();
        
        //Delete post
        try! realm.write {
            
            realm.delete(self);
        }
    }
    
    func myReservations() -> Array<LocalRent> {
        
        let reservations = try! Array(Realm().objects(LocalRent.self))
        
        if reservations.count > 0 {
            
            return reservations;
        }
        
        return [];
    }
}
