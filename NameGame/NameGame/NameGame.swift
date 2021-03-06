//
//  NameGame.swift
//  NameGame
//
//  Created by Erik LaManna on 11/7/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import Foundation
import GameplayKit

enum NameGameError: Error {
    case couldNotRetrieveMembers
}

protocol NameGameDelegate: class {
    var members: [TeamMember] { get set }
    var selectedMember: TeamMember? { get set }
    var attemptsMade: Int { get set }
    var gameTimer: Timer? { get set }
    var hintTimer: Timer? { get set }
    var elapsedTime: Int { get set }
    var hintModeEnabled: Bool { get set }
    
    func checkAnswer(tappedMember: TeamMember, selectedMember: TeamMember) -> Bool
}

class NameGame {

    weak var delegate: NameGameDelegate?

    let numberPeople = 6

    // Load JSON data from API
    func loadGameData(completion: @escaping ([TeamMember]?, Error?) -> Void) {
        DataStore.sharedInstance.getMembers { [unowned self] members, error in
            if error != nil {
                completion(nil, error)
                return
            }
            
            guard let members = members else {
                completion(nil, NameGameError.couldNotRetrieveMembers)
                return
            }
            
            let selectedMembers = self.randomlySelect(members)
            
            completion(selectedMembers, nil)
        }
    }
    
    fileprivate func randomlySelect(_ members: TeamMembers) -> [TeamMember] {
        var selectedMembers = [TeamMember]()
        
        while selectedMembers.count < self.numberPeople {
            
            guard let member = getRandomMemberFrom(members) else {
                // The reason we set this to break if member is nil is because
                // randomElement() only returns nil if the collection is empty
                // If we don't break and continue, we'll find ourselves in an infinite loop
                break
            }
            
            // A member can only be added if it's not already added
            if selectedMembers.filter({ $0.id == member.id }).count == 0 {
                selectedMembers.append(member)
            }
        }
        
        return selectedMembers
    }
    
    fileprivate func getRandomMemberFrom(_ members: TeamMembers) -> TeamMember? {
        return members.randomElement()
    }
    
}
