//
//  CongratulationsController.swift
//  NameGame
//
//  Created by TJ Barber on 9/26/18.
//  Copyright © 2018 WillowTree Apps. All rights reserved.
//

import UIKit
import SafariServices

class CongratulationsController: UIViewController {
    
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var memberJobTitleLabel: UILabel!
    @IBOutlet weak var socialMediaHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var socialMediaStackView: UIStackView!
    @IBOutlet weak var memberBioLabel: UILabel!
    @IBOutlet weak var memberImageView: UIImageView!
    
    var member: TeamMember?
    var memberImage: HeadshotImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let member = self.member {
            self.memberNameLabel.text = "\(member.firstName) \(member.lastName)"
            self.memberJobTitleLabel.text = member.jobTitle
            
            // Sometimes the bio and the job title are the same, if so we'll set the bio title text to nil
            if member.jobTitle != member.bio {
                self.memberBioLabel.text = member.bio
            } else {
                self.memberBioLabel.text = nil
            }
            
            self.memberImageView.image = memberImage?.image
            
            if member.socialLinks.isEmpty {
                self.socialMediaHeightConstraint.constant = 0
            } else {
                self.layoutSocialIcons()
            }
        }
    }
    
    func layoutSocialIcons() {
        // This code is built with the intention that there may be more than one social link.
        // The socialLinks node in the JSON payload is an array and not a single dictionary,
        // so assuming that we may eventually have more than one socialLink is entirely possible.
        guard let member = self.member else { return }
        for socialLink in member.socialLinks {
            let socialButtonContainer = UIView(frame: CGRect.zero)
            let button = SocialButton(type: .custom)
            
            socialButtonContainer.translatesAutoresizingMaskIntoConstraints = false
            button.translatesAutoresizingMaskIntoConstraints = false
            
            socialButtonContainer.addSubview(button)
            
            NSLayoutConstraint.activate([
                NSLayoutConstraint.init(item: socialButtonContainer, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44.0),
                NSLayoutConstraint.init(item: button, attribute: .centerX, relatedBy: .equal, toItem: socialButtonContainer, attribute: .centerX, multiplier: 1.0, constant: 0),
                NSLayoutConstraint.init(item: button, attribute: .centerY, relatedBy: .equal, toItem: socialButtonContainer, attribute: .centerY, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint.init(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44.0),
                NSLayoutConstraint.init(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44.0)
                ])
            
            let socialName = socialLink.type.rawValue
            if let socialIcon = UIImage(named: socialName) {
                button.setBackgroundImage(socialIcon, for: .normal)
                button.socialUrl = socialLink.url
                button.addTarget(self, action: #selector(openSocialLink(sender:)), for: UIControl.Event.touchUpInside)
                self.socialMediaStackView.addArrangedSubview(socialButtonContainer)
            }
            
        }
    }
    
    @objc func openSocialLink(sender: SocialButton) {
        if let socialUrlString = sender.socialUrl,
           let socialUrl = URL(string: socialUrlString) {
            let safariController = SFSafariViewController(url: socialUrl)
            self.present(safariController, animated: true)
        }
    }
}
