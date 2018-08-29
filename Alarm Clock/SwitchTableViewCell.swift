//
//  SwitchTableViewCell.swift
//  Alarm Clock
//
//  Created by Markus Varner on 8/28/18.
//  Copyright © 2018 Markus Varner. All rights reserved.
//

import UIKit

protocol SwitchTableViewCellDelegate: class {
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell)
}
class SwitchTableViewCell: UITableViewCell {

    //Properties
    //this will act similar to a Landing Pad with a didSet observer
    weak var delegate: SwitchTableViewCellDelegate?
    var alarm: Alarm? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Outlets
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var alarmSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK: - Custom Methods
    func updateViews() {
        
        //update time label, name label, and enabled switch with alarm data
        nameLabel.text = alarm?.name
        timeLabel.text = alarm?.fireTimeAsString
        guard let alarmEnabled = alarm?.enabled else {return}
        alarmSwitch.isOn = alarmEnabled
        
    }

    //MARK: - Actions
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        
        delegate?.switchCellSwitchValueChanged(cell: self)
    }
    
}
