//
//  RecordingAudioVC.swift
//  voice-recoder
//
//  Created by Minaroid on 09/07/2021.
//

import UIKit
import AVFoundation

class RecordingAudioVC: UIViewController , AVAudioRecorderDelegate{

    @IBOutlet weak var recordingBtn: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordingBtn: UIButton!
    
    var audioRecorder : AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingBtn.isEnabled = false
    }

    @IBAction func stopRecord(_ sender: Any) {
        stopRecordingBtn.isEnabled = false
        recordingBtn.isEnabled = true
        recordingLabel.text = "Tap to record"
        
    
          audioRecorder.stop()
          let audioSession = AVAudioSession.sharedInstance()
          try! audioSession.setActive(false)

    }
    
    @IBAction func startRecord(_ sender: Any) {
        stopRecordingBtn.isEnabled = true
        recordingBtn.isEnabled = false
        recordingLabel.text = "Recording.."
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, options:AVAudioSession.CategoryOptions.defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else {
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playVC = segue.destination as! PlayAudioVC
            let recordUrl = sender as! URL
            playVC.recordedAudioURL = recordUrl
        }
    }
}

