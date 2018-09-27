//
//  StatsStore.swift
//  NameGame
//
//  Created by TJ Barber on 9/26/18.
//  Copyright © 2018 WillowTree Apps. All rights reserved.
//

import Foundation

class StatsStore {
    static let sharedInstance = StatsStore()
    private var gamesPlayed = 0
    private var overallTimePlayed = 0
    private var overallAttempts = 0
    
    func addStats(elapsedTime: Int, attemptsMade: Int) {
        self.gamesPlayed += 1
        self.overallAttempts += attemptsMade
        self.overallTimePlayed += elapsedTime
    }
    
    func averageAttempts() -> Int {
        if self.overallAttempts == 0 || self.gamesPlayed == 0 {
            return 0
        }
        return self.overallAttempts / self.gamesPlayed
    }
    
    func averageTimePlayed() -> Int {
        if self.overallTimePlayed == 0 || self.gamesPlayed == 0 {
            return 0
        }
        return self.overallTimePlayed / self.gamesPlayed
    }
}
