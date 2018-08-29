//
//  AlarmDetailTableViewController.swift
//  Alarm Clock
//
//  Created by Markus Varner on 8/28/18.
//  Copyright © 2018 Markus Varner. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {
    
    //Properties
    //this will help with displaying an existing alarm or returning nil if there isnt one
    var alarm: Alarm? {
        didSet {
            loadViewIfNeeded()
            self.updateViews()
        }
    }
    var alarmIsOn: Bool = true

    //MARK: - Outlets
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var enabledButtonOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    //MARK: - Private Method
    private func updateViews() {
        
        //populate the datePicker and titleTextField with current alarms date and title
        guard let alarm = alarm else {return}
        alarmIsOn = alarm.enabled
        datePicker.date = alarm.fireDate
        titleTextField.text = alarm.name
        
        //set enabledButtoOutlet property to alarms enabled property
        if alarmIsOn {
            enabledButtonOutlet.backgroundColor = .green
            enabledButtonOutlet.setTitle("On", for: .normal)
            enabledButtonOutlet.titleLabel?.textColor = .white
        } else {
            enabledButtonOutlet.backgroundColor = .red
            enabledButtonOutlet.setTitle("Off", for: .normal)
            enabledButtonOutlet.titleLabel?.textColor = .white
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    //MARK: - Actions
    @IBAction func enabledButtonTapped(_ sender: UIButton) {
        guard let alarm = alarm else {return}
        AlarmController.shared.toggleEnabled(for: alarm)
        alarmIsOn = alarm.enabled
        
        if alarmIsOn {
            enabledButtonOutlet.backgroundColor = .green
            enabledButtonOutlet.setTitle("On", for: .normal)
            enabledButtonOutlet.titleLabel?.textColor = .white
        } else {
            enabledButtonOutlet.backgroundColor = .red
            enabledButtonOutlet.setTitle("Off", for: .normal)
            enabledButtonOutlet.titleLabel?.textColor = .white
        }
    }
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let titleText = titleTextField.text else {return}
        guard titleText != "" else {return}
        
        if let alarm = alarm {
            AlarmController.shared.update(alarm: alarm, fireDate: datePicker.date, name: titleText, enabled: alarmIsOn)
        } else {
            AlarmController.shared.addAlarm(fireDate: datePicker.date, name: titleText, enabled: alarmIsOn, uuid: titleText)
        }
        self.navigationController?.popViewController(animated: true)
    }
   
}
