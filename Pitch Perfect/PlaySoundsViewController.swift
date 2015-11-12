//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Timo Krall on 10/28/15.
//  Copyright © 2015 Timo Krall. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // general function by stopping the player; e.g., useful to invoke before the player is used consecutively
    func stopPlayer() {
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.currentTime = 0.0
        
    }
    
    // general function resued for fast and slow playing of recorded sound
    func playAudioWithVariableSpeed(rate: Float) {
    
        stopPlayer()
        audioPlayer.rate = rate
        audioPlayer.play()
        
    }
    
    // play recording quickly
    @IBAction func playFast(sender: UIButton) {
        
        playAudioWithVariableSpeed(1.5)
        print("fast")
        
    }

    // play recording slowly
    @IBAction func playSlow(sender: UIButton) {
        
        playAudioWithVariableSpeed(0.5)
        print("slowly")
        
    }

    
    // general function reused for chipmunk as well as for darth vader sound
    func playAudioWithVariablePitch(pitch: Float) {
    
        stopPlayer()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)

        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to:changePitchEffect, format:nil)
        audioEngine.connect(changePitchEffect, to:audioEngine.outputNode, format: nil)
    
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        try! audioEngine.start()
        
        audioPlayerNode.play()
        
    }
    
    // play recording in style of chipmunk pitch
    @IBAction func playChipmunkAudio(sender: UIButton) {
        
        playAudioWithVariablePitch(1000)
        print("chipmunk")
        
    }

    // play recording in style of Darth Vader pitch
    @IBAction func playDarthvaderAudio(sender: AnyObject) {
        
        playAudioWithVariablePitch(-1000)
        print("vader")
        
    }
    
    // stop playing the recording
    @IBAction func playStop(sender: UIButton) {
        
        stopPlayer()
        print("stopped")
        
    }
    
}
