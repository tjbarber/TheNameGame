//
//  FaceButton.swift
//  NameGame
//
//  Created by Intern on 3/11/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import Foundation
import UIKit

open class FaceButton: UIButton {

    var id: Int = 0
    var tintView: UIView = UIView(frame: CGRect.zero)
    var teamMember: TeamMember? {
        didSet {
            self.loadImage()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        setTitleColor(.white, for: .normal)
        titleLabel?.alpha = 0.0

        tintView.alpha = 0.0
        tintView.translatesAutoresizingMaskIntoConstraints = false
        tintView.isUserInteractionEnabled = false
        addSubview(tintView)

        tintView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tintView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        tintView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tintView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func loadImage() {
        guard let teamMember = self.teamMember else { return }
        
        if ImageOperations.sharedInstance.downloadsInProgress[teamMember.id] != nil {
            return
        }
        
        let downloader = ImageDownloader(member: teamMember)
        
        downloader.completionBlock = { [weak self] in
            DispatchQueue.main.async {
                self?.setBackgroundImage(self?.teamMember?.headshot.image, for: UIControl.State.normal)
                UIView.animate(withDuration: 0.8, delay: 0.0, options: .curveEaseIn, animations: {
                    self?.tintView.alpha = 1.0
                })
            }
        }
        
        ImageOperations.sharedInstance.downloadsInProgress[teamMember.id] = downloader
        ImageOperations.sharedInstance.downloadQueue.addOperation(downloader)
    }
}
