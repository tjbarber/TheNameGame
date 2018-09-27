//
//  CongratulationsController.swift
//  NameGame
//
//  Created by TJ Barber on 9/26/18.
//  Copyright © 2018 WillowTree Apps. All rights reserved.
//

import UIKit

class CongratulationsController: UIViewController {
    
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var memberJobTitleLabel: UILabel!
    @IBOutlet weak var memberBioLabel: UILabel!
    @IBOutlet weak var memberImageView: UIImageView!
    
    var member: TeamMember?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let member = self.member {
            self.memberNameLabel.text = "\(member.firstName) \(member.lastName)"
            self.memberJobTitleLabel.text = member.jobTitle
            self.memberBioLabel.text = member.bio
            
            self.memberImageView.image = member.headshot.image
        }
    }
}
