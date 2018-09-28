//
//  ViewController.swift
//  NameGame
//
//  Created by Matt Kauper on 3/8/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import UIKit

class NameGameViewController: UIViewController {
    
    @IBOutlet weak var outerStackView: UIStackView!
    @IBOutlet weak var innerStackView1: UIStackView!
    @IBOutlet weak var innerStackView2: UIStackView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var imageButtons: [FaceButton]!
    @IBOutlet weak var attemptsLabel: UILabel!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    
    let nameGame = NameGame()
    let timeFormatter = TimeFormattingHelper()
    var members: TeamMembers = []
    var buttonMap: [UIButton: TeamMember] = [:]
    var removedButtonMap: [UIButton: TeamMember] = [:]
    var memberImages: [String: HeadshotImage] = [:]
    var selectedMember: TeamMember? {
        didSet {
            self.updateQuestionLabel()
        }
    }
    
    // Stats properties
    var gameTimer: Timer?
    
    var elapsedTime: Int = 0 {
        didSet {
            self.updateElapsedTimeLabel()
        }
    }
    
    var attemptsMade: Int = 0 {
        didSet {
            self.updateAttemptsLabel()
        }
    }
    
    // Hint mode properties
    var hintTimer: Timer?
    var hintModeEnabled = false
    var maxHints = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let orientation: UIDeviceOrientation = self.view.frame.size.height > self.view.frame.size.width ? .portrait : .landscapeLeft
        configureSubviews(orientation)
        nameGame.delegate = self
        self.loadGameData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.questionLabel.alpha = 0.0
        self.attemptsLabel.alpha = 0.0
        self.elapsedTimeLabel.alpha = 0.0
        self.outerStackView.alpha = 0.0
        
        for imageButton in self.imageButtons {
            imageButton.alpha = 1.0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseIn, animations: { [unowned self] in
            self.questionLabel.alpha = 1.0
        })
        
        UIView.animate(withDuration: 0.5, delay: 1.0, options: .curveEaseIn, animations: { [unowned self] in
            self.attemptsLabel.alpha = 1.0
            self.elapsedTimeLabel.alpha = 1.0
        })
        
        UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseIn, animations: { [weak self] in
            self?.outerStackView.alpha = 1.0
        })
        
        self.startTimer()
        
        if self.hintModeEnabled {
            self.startHintModeTimer()
            self.setMaxHints()
        }
    }

    @IBAction func faceTapped(_ button: FaceButton) {
        self.attemptsMade += 1
        
        guard let tappedMember = self.getMemberFromButtonMap(button),
              let selectedMember = self.selectedMember else { return }
        
        let isAnswerCorrect = self.checkAnswer(tappedMember: tappedMember, selectedMember: selectedMember)
        
        if isAnswerCorrect {
            StatsStore.sharedInstance.addStats(elapsedTime: self.elapsedTime, attemptsMade: self.attemptsMade)
            self.invalidateTimers()
            self.performSegue(withIdentifier: "congratulationsSegue", sender: self)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewController = segue.destination as? CongratulationsController else { return }
        viewController.member = selectedMember
        
        if let selectedMember = selectedMember,
           let memberImage = memberImages[selectedMember.id] {
            viewController.memberImage = memberImage
        }
    }

    func loadGameData() {
        self.nameGame.loadGameData { [unowned self] members, error in
            if error != nil {
                AlertHelper.showAlert(withTitle: "An error occurred", withMessage: "Unable to download game data.", presentingViewController: self) { _ in
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
            if let unwrappedMembers = members {
                self.members = unwrappedMembers
                
                if let selectedMember = unwrappedMembers.randomElement() {
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
        
        let headshotImage = HeadshotImage(imageURLString: member.headshot.url)
        let downloader = ImageDownloader(headshotImage: headshotImage)
        
        downloader.completionBlock = { [weak button, weak member] in
            DispatchQueue.main.async {
                guard let member = member else { return }
                ImageOperations.sharedInstance.downloadsInProgress.removeValue(forKey: member.id)
                self.memberImages[member.id] = headshotImage
                button?.setBackgroundImage(headshotImage.image, for: UIControl.State.normal)
                
                // This code sets the contentMode on the backgroundImageView. It was originally being scaled to fit the imageView
                button?.setNeedsLayout()
                button?.subviews.first?.contentMode = .scaleAspectFill
                
                UIView.animate(withDuration: 0.8, delay: 0.0, options: .curveEaseIn, animations: {
                    button?.tintView.alpha = 0.0
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
    
    func invalidateTimers() {
        if let gameTimer = self.gameTimer {
            gameTimer.invalidate()
        }
        
        if let hintTimer = self.hintTimer {
            hintTimer.invalidate()
        }
    }
}

// MARK: NameGameDelegate
extension NameGameViewController: NameGameDelegate {
    func checkAnswer(tappedMember: TeamMember, selectedMember: TeamMember) -> Bool {
        if tappedMember.id == selectedMember.id {
            return true
        } else {
            return false
        }
    }
}

// MARK: Hint Mode Methods
extension NameGameViewController {
    func startHintModeTimer() {
        self.hintTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            self?.removeRandomMemberFromSelection()
        }
    }
    
    func setMaxHints() {
        // We can only give so many hints. If we have infinite hints we'll remove the correct answer
        self.maxHints = self.nameGame.numberPeople - 1
    }
    
    @objc func removeRandomMemberFromSelection() {
        guard let randomMember = self.buttonMap.randomElement() else { return }
        
        // The branch happens when there is only one more person which is the selected person
        // and if we've reaching the max number of hints
        if randomMember.value.id == self.selectedMember?.id && self.removedButtonMap.count == self.maxHints {
            self.hintTimer?.invalidate()
            return
        }
        
        if self.removedButtonMap[randomMember.key] != nil || randomMember.value.id == self.selectedMember?.id {
            self.removeRandomMemberFromSelection()
            return
        } else {
            let button = randomMember.key
            self.removedButtonMap[randomMember.key] = randomMember.value
            
            button.isUserInteractionEnabled = false
            UIView.animate(withDuration: 1.0) { [unowned button] in
                button.alpha = 0.0
            }
        }
    }
}

// MARK: Stats tracking
extension NameGameViewController {
    func startTimer() {
        self.gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateElapsedTime()
        }
    }
    
    func updateAttemptsLabel() {
        self.attemptsLabel.text = "Attempts made: \(self.attemptsMade)"
    }
    
    func updateElapsedTime() {
        self.elapsedTime += 1
    }
    
    func updateElapsedTimeLabel() {
        let elapsedTimeString = timeFormatter.timeStringFromInterval(self.elapsedTime)
        self.elapsedTimeLabel.text = "Time: \(elapsedTimeString)"
    }
}
