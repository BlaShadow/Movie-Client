//
//  Date+Helper.swift
//  Movie-Api-Client
//
//  Created by Blashadow on 7/18/18.
//  Copyright © 2018 Blashadow. All rights reserved.
//

import UIKit

extension Date {
    
    /// Parse string to date with format 2018-03-12
    ///
    /// - Parameter value: string value
    /// - Returns: date
    static func dateWithString(value:String) -> Date {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        
        return dateFormat.date(from: value)!
    }
    
    /// Format date with format Jun 02, 2018
    func formatDateAsString() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MMM dd, yyyy"
        
        return dateFormat.string(from: self);
    }
}

