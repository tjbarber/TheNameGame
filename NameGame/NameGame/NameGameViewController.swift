//
//  ViewController.swift
//  NameGame
//
//  Created by Matt Kauper on 3/8/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import UIKit

class NameGameViewController: UIViewController {
    
    var members: TeamMembersDict = [:]
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
        if button.teamMember?.id == self.selectedMember?.id {
            print("yes")
        } else {
            print("no")
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
        self.nameGame.loadGameData { [unowned self] memberDict, error in
            if error != nil {
                // FIXME: Add error handling
            }
            
            if let memberDict = memberDict {
                self.members = memberDict
                
                if let selectedMember = memberDict.randomElement() {
                    // selectedMember is a dictionary of type [String: TeamMember]
                    // Getting the value and assigning it to self.selectedMember
                    self.selectedMember = selectedMember.value
                }
                
                self.setMembersOnImageButtons()
            }
        }
    }
    
    func setMembersOnImageButtons() {
        guard let imageButtons = self.imageButtons else { return }
        
        let imageButtonCollectionMaxIndex = (imageButtons.count - 1)
        var imageButtonIndex = 0
        
        for (_, member) in self.members {
            if imageButtonIndex > imageButtonCollectionMaxIndex { break }
            
            let imageButton = self.imageButtons[imageButtonIndex]
            imageButton.teamMember = member
            imageButtonIndex += 1
        }
    }
    
    func updateQuestionLabel() {
        guard let firstName = self.selectedMember?.firstName,
              let lastName  = self.selectedMember?.lastName else { return }
        let questionLabelText = "Who is \(firstName) \(lastName)?"
        self.questionLabel.text = questionLabelText
    }
}

extension NameGameViewController: NameGameDelegate {}
