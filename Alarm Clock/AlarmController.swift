//
//  AlarmController.swift
//  Alarm Clock
//
//  Created by Markus Varner on 8/28/18.
//  Copyright © 2018 Markus Varner. All rights reserved.
//

import Foundation
import UserNotifications

class AlarmController: AlarmScheduler {
    
    //Shared Instance
    static let shared = AlarmController()
    //Source of Truth
    var alarms: [Alarm] = []
    //Mock Data
//    var mockAlarms: [Alarm] {
//        let mockalarms = [Alarm(name: "Alarm1", fireDate: Date(), enabled: false, uuid: "alarm1"), Alarm(name: "Alarm2", fireDate: Date(), enabled: false, uuid: "alarm2"), Alarm(name: "Alarm3", fireDate: Date(), enabled: false, uuid: "alarm3"), Alarm(name: "Alarm4", fireDate: Date(), enabled: false, uuid: "alarm4")]
//        return mockalarms
//    }
    
    //Add
    func addAlarm(fireDate: Date, name: String, enabled: Bool, uuid: String) -> Alarm {
        
        let alarm = Alarm(name: name, fireDate: fireDate, enabled: enabled, uuid: uuid)
        alarms.append(alarm)
        scheduleUserNotifications(for: alarm)
        
        saveToPersistenceStorage()
        return alarm
    }
    //Update
    func update(alarm: Alarm, fireDate: Date, name: String, enabled: Bool) {
        alarm.fireDate = fireDate
        alarm.name = name
        alarm.enabled = enabled
        scheduleUserNotifications(for: alarm)
        saveToPersistenceStorage()
    }
    //Delete
    func delete(alarm: Alarm) {
        
        guard let index = alarms.index(of: alarm) else {return}
        self.cancelUserNotifications(for: alarm)
        alarms.remove(at: index)
        
        saveToPersistenceStorage()
    }
    
    func toggleEnabled(for alarm: Alarm) {
        //set the cells enabled to the opposite of what it is
        alarm.enabled = !alarm.enabled
        if alarm.enabled {
            scheduleUserNotifications(for: alarm)
        } else {
            cancelUserNotifications(for: alarm)
        }
        
    }
    
    //MARK: - Data  Persistence
    
    //get URL
    func fileURL() -> URL {
        
        let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = filePath[0]
        let fileName = "alarm.json"
        let fullPath = documentDirectory.appendingPathComponent(fileName)
        
        return fullPath
    }
    //Encode & Save
    func saveToPersistenceStorage() {
        
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(alarms)
            try data.write(to: fileURL())
        } catch {
            print("🤬 COULDNT ENCODE DATA🤬")
        }
    }
    //Decode & Load
    func loadFromPersistenceStorage() -> [Alarm] {
        
        let decoder = JSONDecoder()
        
        do {
            let data = try Data(contentsOf: fileURL())
            let alarms = try decoder.decode([Alarm].self, from: data)
            return alarms
        } catch {
            print("🤬 COULDNT DECODE DATA🤬")
        }
        return []
    }
}
protocol AlarmScheduler: class {
    func scheduleUserNotifications(for alarm: Alarm)
    func cancelUserNotifications(for alarm: Alarm)
}
extension AlarmScheduler {
    func scheduleUserNotifications(for alarm: Alarm) {
        let content = UNMutableNotificationContent()
        content.title = "Wake Up!!"
        content.body = "Your Nap has Ended."
        content.sound = UNNotificationSound.default
        
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: alarm.fireDate)
        let trigger =  UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: alarm.uuid, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("🤬Error scheduling local notifications \(error)🤬")
            }
        }
    }
    func cancelUserNotifications(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
}
