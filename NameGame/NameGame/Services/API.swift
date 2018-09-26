//
//  API.swift
//  NameGame
//
//  Created by TJ Barber on 9/24/18.
//  Copyright © 2018 WillowTree Apps. All rights reserved.
//

import Foundation

enum APIError: Error {
    case couldNotRetrieveData
    case couldNotDecodeJSON
}

class API {
    let endpoint = "https://willowtreeapps.com/api/v1.0/profiles/"
    let sessionConfiguration = URLSessionConfiguration.default
    
    func requestMembers(completion: @escaping (TeamMembers?, Error?) -> Void) {
        let session = URLSession(configuration: self.sessionConfiguration)
        guard let endpointURL = URL(string: endpoint) else { return }
        
        let dataTask = session.dataTask(with: endpointURL) { data, response, error in
            if error != nil {
                completion(nil, APIError.couldNotRetrieveData)
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let teamMembers = try decoder.decode(TeamMembers.self, from: data)
                    completion(teamMembers, nil)
                } catch (let e) {
                    completion(nil, APIError.couldNotDecodeJSON)
                    print(e.localizedDescription)
                }
            }
        }
        
        dataTask.resume()
    }
}
