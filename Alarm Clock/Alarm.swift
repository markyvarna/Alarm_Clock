//
//  Alarm.swift
//  Alarm Clock
//
//  Created by Markus Varner on 8/28/18.
//  Copyright © 2018 Markus Varner. All rights reserved.
//

import Foundation

class Alarm: Equatable, Codable {
    //note we only need to compare the uuid because no alarm will hve same uuid
    static func == (lhs: Alarm, rhs: Alarm) -> Bool {
        if lhs.uuid != rhs.uuid {return false}
        return true
    }
    
    var fireDate: Date
    var name: String
    var enabled: Bool
    /*a UUID is a universally unique identifier, and will be used to schedule
     and cancel local notifications*/
    var uuid: String
    
    init(name: String, fireDate: Date, enabled: Bool = false, uuid: String) {
        self.name = name
        self.fireDate = fireDate
        self.enabled = enabled
        self.uuid = uuid
    }
   
    /*fireTimeAsString is a computed property that will return a string
    representaiton of the alarms time*/
    var fireTimeAsString: String {
        
        //instanciate a DateFormatter
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        //time style to short, we only want the Time, not the month, week or day
        formatter.timeStyle = .short
        //convert the fireDatw to a string and return it
        return formatter.string(from: fireDate)
        
    }
    
    
}
