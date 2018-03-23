//
//  DatesModel.swift
//  Rentstorm
//
//  Created by Joaquin Pereira on 3/18/18.
//  Copyright © 2018 Joaquin Pereira. All rights reserved.
//

import UIKit

class DatesModel: NSObject {

    
    class func dayString(date:Date) -> String {
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "EEEE"
        
        // Apply date format
        let string: String = dateFormatter.string(from: date)
        
        return string;
    }
    
    class func dayNumberMonthYearString(date:Date) -> String {
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "dd MMM yy"
        
        // Apply date format
        let string: String = dateFormatter.string(from: date)
        
        return string;
    }
    
}
