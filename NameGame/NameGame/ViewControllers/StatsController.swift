//
//  StatsController.swift
//  NameGame
//
//  Created by TJ Barber on 9/26/18.
//  Copyright © 2018 WillowTree Apps. All rights reserved.
//

import UIKit

class StatsController: UIViewController {
    
    let timeFormatter = TimeFormattingHelper()
    
    @IBOutlet weak var averageTimeLabel: UILabel!
    @IBOutlet weak var averageAttemptsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setAverageTimeLabel()
        self.setAttemptsLabel()
    }
    
    @IBAction func returnToMainMenu(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setAverageTimeLabel() {
        let averageTime = StatsStore.sharedInstance.averageTimePlayed()
        let averageTimeString = timeFormatter.timeStringFromInterval(averageTime)
        
        self.averageTimeLabel.text = averageTimeString
    }
    
    func setAttemptsLabel() {
        let averageAttempts = StatsStore.sharedInstance.averageAttempts()
        self.averageAttemptsLabel.text = String(averageAttempts)
    }
}
