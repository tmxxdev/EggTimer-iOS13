//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var progressBar: UIProgressView! {
        didSet {
            progressBar.progress = 0
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    
    var timer: Timer?
    var secondsPassed: Int = 0
    var totalSeconds: Int = 0
    let eggTimesMin = [
        "Soft": 5,
        "Medium": 7,
        "Hard": 12
    ]
    var player: AVAudioPlayer?
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        let hardness = sender.currentTitle!
        countdown(seconds: (eggTimesMin[hardness] ?? 0) * 60)
    }
    
    func countdown(seconds: Int) {
        guard timer == nil else {
            print("Timer is already scheduled")
            return
        }
        
        totalSeconds = seconds
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(updateCounter),
            userInfo: nil,
            repeats: true
        )
        updateCounter()
    }
    
    @objc func updateCounter() {
        guard let timer = self.timer else { return }
        
        progressBar.progress = Float(secondsPassed) / Float(totalSeconds)
        if secondsPassed < totalSeconds {
            titleLabel.text = "\(totalSeconds - secondsPassed) seconds to the end of the world"
            secondsPassed += 1
        } else {
            print("egg boiled")
            titleLabel.text = "DONE!"
            playAlarm()
            
            timer.invalidate()
            self.timer = nil
            secondsPassed = 0
            totalSeconds = 0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.18, execute: {
                self.titleLabel.text = "How do you like your eggs?"
                self.progressBar.progress = 0
            })
        }
    }
    
    func playAlarm() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }
        
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = self.player else { return }
            player.play()
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
}
