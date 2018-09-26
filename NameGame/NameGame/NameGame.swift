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
    var members: [String: TeamMember] { get set }
    var selectedMember: TeamMember? { get set }
}

class NameGame {

    weak var delegate: NameGameDelegate?

    let numberPeople = 6

    // Load JSON data from API
    func loadGameData(completion: @escaping ([String: TeamMember]?, Error?) -> Void) {
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
    
    func loadMemberImages(completion: @escaping ([UIImage]?, Error?) -> Void) {
        
    }
    
    fileprivate func randomlySelect(_ members: TeamMembers) -> [String: TeamMember] {
        var selectedMembers = [String: TeamMember]()
        
        while selectedMembers.count > self.numberPeople {
            guard let member = getRandomMemberFrom(members) else {
                // The reason we set this to break if member is nil is because
                // randomElement() only returns nil if the collection is empty
                // If we don't break and continue, we'll find ourselves in an infinite loop
                break
            }
            
            if selectedMembers[member.id] == nil {
                selectedMembers[member.id] = member
            }
        }
        
        return selectedMembers
    }
    
    fileprivate func getRandomMemberFrom(_ members: TeamMembers) -> TeamMember? {
        return members.randomElement()
    }
    
}
