//
//  Filter.swift
//  Rentstorm
//
//  Created by Joaquin Pereira on 3/23/18.
//  Copyright © 2018 Joaquin Pereira. All rights reserved.
//

import UIKit

class Filter: NSObject {

    //Filters
    var rates = [String]();
    var sizes = [String]();
    var transmission = [String]();

    override init() {
        
        super.init();
    }
    
    init(rateTypes:[String], sizes:[String], transmission:[String]) {
    
        super.init()
        
        self.rates = rateTypes;
        self.sizes = sizes;
        self.transmission = transmission;
        
    }
    
    //
    
    func removeFilters() {
        
        rates.removeAll();
        sizes.removeAll();
        transmission.removeAll();
    }
    
    func numberOfFiltersApplied() -> Int {
        
        return rates.count + sizes.count + transmission.count;
    }
}
