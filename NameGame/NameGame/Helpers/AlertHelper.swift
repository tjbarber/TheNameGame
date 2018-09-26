//
//  AlertHelper.swift
//  NameGame
//
//  Created by TJ Barber on 9/26/18.
//  Copyright © 2018 WillowTree Apps. All rights reserved.
//

import UIKit

class AlertHelper {
    static func showAlert(withTitle title: String, withMessage message: String, presentingViewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        presentingViewController.present(alertController, animated: true, completion: nil)
    }
    
    static func showAlert(withTitle title: String, withMessage message: String, presentingViewController: UIViewController, completionHandler: @escaping (UIAlertAction) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: completionHandler)
        alertController.addAction(okAction)
        presentingViewController.present(alertController, animated: true, completion: nil)
    }
}
