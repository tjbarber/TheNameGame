//
//  DataStore.swift
//  NameGame
//
//  Created by TJ Barber on 9/24/18.
//  Copyright © 2018 WillowTree Apps. All rights reserved.
//

import Foundation

enum DataStoreError: Error {
    case membersReturnedNil
}

class DataStore {
    static let sharedInstance = DataStore()
    private var members = TeamMembers()
    
    private init() {}
    
    func getMembers(completion: @escaping (TeamMembers?, Error?) -> Void) {
        if self.members.isEmpty {
            self.getData { [unowned self] members, error in
                if error != nil {
                    completion(nil, error)
                    return
                }
                
                guard let members = members else {
                    completion(nil, DataStoreError.membersReturnedNil)
                    return
                }
                
                self.members = members
                completion(self.members, nil)
            }
        } else {
            completion(self.members, nil)
        }
    }
    
    private func getData(completion: @escaping (TeamMembers?, Error?) -> Void) {
        let api = API()
        api.requestMembers { (members, error) in
            completion(members, error)
        }
    }
}
