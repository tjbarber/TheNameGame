//
//  TimeDisplayHelper.swift
//  NameGame
//
//  Created by TJ Barber on 9/26/18.
//  Copyright © 2018 WillowTree Apps. All rights reserved.
//

import Foundation

class TimeFormattingHelper {
    let formatter = DateComponentsFormatter()
    
    init() {
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
    }
    
    func timeStringFromInterval(_ interval: Int) -> String {
        guard let timeInterval = TimeInterval(exactly: interval),
              let formattedString = formatter.string(from: timeInterval) else {
            return "0:00"
        }
        
        return formattedString
    }
    
    func timeStringFromInterval(_ interval: Float) -> String {
        guard let timeInterval = TimeInterval(exactly: interval),
            let formattedString = formatter.string(from: timeInterval) else {
                return "0:00"
        }
        
        return formattedString
    }
}
