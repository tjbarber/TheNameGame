//
//  HomeController.swift
//  NameGame
//
//  Created by TJ Barber on 9/26/18.
//  Copyright © 2018 WillowTree Apps. All rights reserved.
//

import UIKit

enum segueIdentifiers: String {
    case playGame
    case playHintMode
    case viewStats
}

class HomeController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case segueIdentifiers.playGame.rawValue:
            if let viewController = segue.destination as? NameGameViewController {
                viewController.hintModeEnabled = false
            }
        case segueIdentifiers.playHintMode.rawValue:
            if let viewController = segue.destination as? NameGameViewController {
                viewController.hintModeEnabled = true
            }
        default:
            break
        }
        
    }
    
    @IBAction func prepareForUnwind(_ segue: UIStoryboardSegue) {}
}
