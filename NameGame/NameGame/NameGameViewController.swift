//
//  ViewController.swift
//  NameGame
//
//  Created by Matt Kauper on 3/8/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import UIKit

class NameGameViewController: UIViewController {
    
    var members: TeamMembers = []
    var buttonMap: [UIButton: TeamMember] = [:]
    
    var selectedMember: TeamMember? {
        didSet {
            self.updateQuestionLabel()
        }
    }
    
    let nameGame = NameGame()

    @IBOutlet weak var outerStackView: UIStackView!
    @IBOutlet weak var innerStackView1: UIStackView!
    @IBOutlet weak var innerStackView2: UIStackView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var imageButtons: [FaceButton]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let orientation: UIDeviceOrientation = self.view.frame.size.height > self.view.frame.size.width ? .portrait : .landscapeLeft
        configureSubviews(orientation)
        
        nameGame.delegate = self
        
        self.loadGameData()
    }

    @IBAction func faceTapped(_ button: FaceButton) {
        guard let tappedMember = self.getMemberFromButtonMap(button),
              let selectedMember = self.selectedMember else { return }
        
        let isAnswerCorrect = self.checkAnswer(tappedMember: tappedMember, selectedMember: selectedMember)
        
        if isAnswerCorrect {
            AlertHelper.showAlert(withTitle: "Congratulations!", withMessage: "You know your coworkers name!", presentingViewController: self)
        } else {
            AlertHelper.showAlert(withTitle: "Oops!", withMessage: "You chose the wrong person. Try again!", presentingViewController: self)
        }
    }

    func configureSubviews(_ orientation: UIDeviceOrientation) {
        if orientation.isLandscape {
            outerStackView.axis = .vertical
            innerStackView1.axis = .horizontal
            innerStackView2.axis = .horizontal
        } else {
            outerStackView.axis = .horizontal
            innerStackView1.axis = .vertical
            innerStackView2.axis = .vertical
        }

        view.setNeedsLayout()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let orientation: UIDeviceOrientation = size.height > size.width ? .portrait : .landscapeLeft
        configureSubviews(orientation)
    }

    func loadGameData() {
        self.nameGame.loadGameData { [unowned self] members, error in
            
            if error != nil {
                // FIXME: Add error handling
            }
            
            if let members = members {
                self.members = members
                
                if let selectedMember = members.randomElement() {
                    self.selectedMember = selectedMember
                }
                
                self.createButtonMap()
            }
        }
    }
    
    func createButtonMap() {
        guard let imageButtons = self.imageButtons else { return }
        
        let imageButtonCollectionMaxIndex = (imageButtons.count - 1)
        var imageButtonIndex = 0
        
        for member in self.members {
            if imageButtonIndex > imageButtonCollectionMaxIndex { break }
            
            let imageButton = self.imageButtons[imageButtonIndex]
            self.buttonMap[imageButton] = member
            self.loadImage(forButton: imageButton, withMember: member)
            imageButtonIndex += 1
        }
    }
    
    func getMemberFromButtonMap(_ button: FaceButton) -> TeamMember? {
        return self.buttonMap[button]
    }
    
    func loadImage(forButton button: FaceButton, withMember member: TeamMember) {
        if ImageOperations.sharedInstance.downloadsInProgress[member.id] != nil {
            return
        }
        
        let downloader = ImageDownloader(member: member)
        
        downloader.completionBlock = { [weak button, weak member] in
            DispatchQueue.main.async {
                button?.setBackgroundImage(member?.headshot.image, for: UIControl.State.normal)
                UIView.animate(withDuration: 0.8, delay: 0.0, options: .curveEaseIn, animations: {
                    button?.tintView.alpha = 1.0
                })
            }
        }
        
        ImageOperations.sharedInstance.downloadsInProgress[member.id] = downloader
        ImageOperations.sharedInstance.downloadQueue.addOperation(downloader)
    }
    
    func updateQuestionLabel() {
        guard let firstName = self.selectedMember?.firstName,
              let lastName  = self.selectedMember?.lastName else { return }
        let questionLabelText = "Who is \(firstName) \(lastName)?"
        self.questionLabel.text = questionLabelText
    }
}

extension NameGameViewController: NameGameDelegate {
    func checkAnswer(tappedMember: TeamMember, selectedMember: TeamMember) -> Bool {
        if tappedMember.id == selectedMember.id {
            return true
        } else {
            return false
        }
    }
}
