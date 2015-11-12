//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Timo Krall on 10/27/15.
//  Copyright © 2015 Timo Krall. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopAudioButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    // display recording button, hide stop button
    func recordingUIShown() {
    
        recordButton.enabled = true
        stopAudioButton.hidden = true
    
    }
    
    // hide recording button, show stop button
    func recordingUIHidden() {
    
        recordButton.enabled = false
        stopAudioButton.hidden = false
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        recordingUIShown()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // record user audio
    @IBAction func recordAudio(sender: UIButton) {
        
        recordingInProgress.text = "Recording..."
        recordingUIHidden()
        
        print("in recordAudio")
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
            
    }

    
    
    // finish the recording
    @IBAction func stopAudio(sender: UIButton) {
        
        recordingInProgress.text = "Tap to Record"
        recordingUIShown()
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    // go to next view only if recording finished
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {

        if(flag){
        
            // solved by looking up http://stackoverflow.com/questions/29688058/initializing-in-swift
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        
        }
        
        else {
        
            print("Recording was not successful")
            recordingUIShown()
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "stopRecording") {
            
            let playSoundVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            
            // code fixed after reading comment by nora_602197077871903 at discussions.udacity.com/t/not-able-to-record-the-audio/30888/5
            playSoundVC.receivedAudio = data
            
        }
        
    }
    
}