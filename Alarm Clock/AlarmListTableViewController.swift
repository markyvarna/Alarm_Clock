//
//  AlarmListTableViewController.swift
//  Alarm Clock
//
//  Created by Markus Varner on 8/28/18.
//  Copyright © 2018 Markus Varner. All rights reserved.
//

import UIKit

class AlarmListTableViewController: UITableViewController, SwitchTableViewCellDelegate, AlarmScheduler {
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
    }

    // MARK: - Table View Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmController.shared.alarms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as? SwitchTableViewCell
        
            let alarm = AlarmController.shared.alarms[indexPath.row]
        cell?.timeLabel.text = alarm.fireTimeAsString
        cell?.nameLabel.text = alarm.name
        cell?.alarmSwitch.isEnabled = alarm.enabled
        
        cell?.delegate = self
        
        //if unable to use SwitchCell init and return new uitableviewcell
        return cell ?? UITableViewCell()
    }
    
    //MARK: - TableView Swipe to Delete Method
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            //get alarm object out of [alarms] via shared instance and the tblViews indexPath
             let alarm = AlarmController.shared.alarms[indexPath.row]
            AlarmController.shared.delete(alarm: alarm)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //Protocol Method
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell) {
        //get the current alarms indexPath
        guard let indexPath = tableView.indexPathForSelectedRow?.row else {return}
        //get the alarm obj
        let alarm = AlarmController.shared.alarms[indexPath]
        //toggle its enabled property with toggleEnabled() shared method
        AlarmController.shared.toggleEnabled(for: alarm)
        
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToUpdate" {
            let destinationvc = segue.destination as? AlarmDetailTableViewController
            guard let indexPath = tableView.indexPathForSelectedRow?.row else {return}
            destinationvc?.alarm = AlarmController.shared.alarms[indexPath]
        }
    }
    

}
