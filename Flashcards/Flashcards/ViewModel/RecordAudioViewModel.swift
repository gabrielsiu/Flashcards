//
//  RecordAudioViewModel.swift
//  Flashcards
//
//  Created by Gabriel Siu on 2023-05-31.
//

import Foundation
import AVFoundation
import SwiftUI

class RecordAudioViewModel: NSObject, ObservableObject {
  var audioRecorder: AVAudioRecorder?
  var audioPlayer : AVAudioPlayer?
  var recordingSession: AVAudioSession?
  
  let cardID: UUID
  let folderName = "Flashcards_Audio_Recordings"
  
  @Published var isRecording = false
  @Published var isPlaying = false
  @Published var recordingData: Data? = nil
  
  init(_ id: UUID) {
    cardID = id
    recordingSession = AVAudioSession.sharedInstance()
    super.init()
    getRecordingData()
    do {
      try recordingSession?.setCategory(.playAndRecord)
      try recordingSession?.setActive(true)
      recordingSession?.requestRecordPermission({ allowed in
        if allowed {
          
        } else {
          
        }
      })
    } catch {
      print(error) // TODO: Handle error
    }
  }
  
  // MARK: Setup
  
  func createFolderIfNeeded() {
    guard let path = getDocumentsDirectory()?.appendingPathComponent(folderName).path() else { return }
    if !FileManager.default.fileExists(atPath: path) {
      do {
        try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true)
        print("Success creating audio recordings folder")
      } catch {
        print("Error creating audio recordings folder: \(error)")
      }
    }
  }
  
  // MARK: Recording
  
  func getRecordingData() {
    let fileName = folderName.appending(cardID.uuidString).appending(".m4a")
    guard let filePath = getDocumentsDirectory()?.appendingPathComponent(fileName).path() else {
      print("Error getting file path")
      return
    }
    
    recordingData = FileManager.default.contents(atPath: filePath)
  }
  
  func startRecording() {
    let fileName = folderName.appending(cardID.uuidString).appending(".m4a")
    guard let filePath = getDocumentsDirectory()?.appendingPathComponent(fileName) else {
      print("Error getting file path")
      return
    }
    
    let settings = [
      AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
      AVSampleRateKey: 12000,
      AVNumberOfChannelsKey: 1,
      AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
    
    do {
      audioRecorder = try AVAudioRecorder(url: filePath, settings: settings)
      audioRecorder?.delegate = self
      audioRecorder?.record()
      isRecording = true
    } catch let error {
      print("Error starting the recording: \(error)")
    }
  }
  
  func finishRecording(_ success: Bool) {
    audioRecorder?.stop()
    audioRecorder = nil
    isRecording = false
    if success {
      getRecordingData()
    }
  }
  
  // MARK: Playback
  
  func startPlayback() {
    guard let data = recordingData else { return }
    
    do {
      audioPlayer = try AVAudioPlayer(data: data)
      audioPlayer?.delegate = self
      audioPlayer?.play()
      isPlaying = true
    } catch {
      print("Error playing the recording: \(error)")
    }
  }
  
  func stopPlayback() {
    audioPlayer?.stop()
    audioPlayer = nil
    isPlaying = false
  }
  
  // MARK: Deletion
  
  func deleteRecording() {
    let fileName = folderName.appending(cardID.uuidString).appending(".m4a")
    guard let filePath = getDocumentsDirectory()?.appendingPathComponent(fileName).path() else {
      print("Error getting file path")
      return
    }
    guard FileManager.default.fileExists(atPath: filePath) else {
      print("File doesn't exist")
      return
    }
    
    do {
      try FileManager.default.removeItem(atPath: filePath)
      recordingData = nil
    } catch {
      print("Error deleting the recording: \(error)")
    }
  }
  
  private func getDocumentsDirectory() -> URL? {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
  }
  
  func descriptionText() -> LocalizedStringKey {
    if isRecording {
      return "recording"
    }
    if recordingData == nil {
      return "noRecording"
    } else {
      return "recordingExists"
    }
  }
}

// MARK: - Audio Recorder & Player Delegate

extension RecordAudioViewModel: AVAudioRecorderDelegate, AVAudioPlayerDelegate {
  func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    if !flag {
      print("Audio recording interrupted")
      finishRecording(false)
    }
  }
  
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    stopPlayback()
  }
}
