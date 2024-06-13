//
//  FlashcardsViewModel.swift
//  Flashcards
//
//  Created by Gabriel Siu on 2023-06-12.
//

import Foundation
import SwiftUI
import AVFoundation

class FlashcardsViewModel: NSObject, ObservableObject {
  private var sets: [SetEntity]
  private var cards = [Card]()
  private var numCards = 0
  
  private var audioPlayer : AVAudioPlayer?
  
  private var score = 0
  @Published var currentCard: Card?
  @Published var isPlaying = false
  
  init(sets: [SetEntity]) {
    self.sets = sets
    super.init()
    generateCards()
    currentCard = cards.removeFirst()
  }
  
  func generateCards() {
    var cardEntities = [CardEntity]()
    for set in sets {
      if let cards = set.cards as? Set<CardEntity> {
        cardEntities.append(contentsOf: Array(cards))
      }
    }
    cards = cardEntities.map {
      Card(
        term: $0.term ?? "",
        definition: $0.definition ?? "",
        audioPath: $0.audioPath ?? "",
        id: $0.id ?? UUID()
      )
    }
    cards.shuffle()
    numCards = cards.count
  }
  
  func moveToNextCard(correct: Bool) {
    if correct {
      score += 1
    }
    
    if cards.isEmpty {
      
    } else {
      currentCard = cards.removeFirst()
    }
  }
  
  func scoreText() -> String {
    "Score: \(score) / \(numCards)"
  }
  
  func cardNumText() -> String {
    "Card #\(numCards - cards.count) / \(numCards)"
  }
  
  // MARK: Playback
  
  func recordingExists() -> Bool {
    guard let cardID = currentCard?.id else { return false }
    guard let filePath = audioFilePath(cardID) else { return false }
    return FileManager.default.fileExists(atPath: filePath)
  }
  
  func startPlayback() {
    guard let cardID = currentCard?.id else { return }
    guard let audioFilePath = audioFilePath(cardID) else { return }
    guard FileManager.default.fileExists(atPath: audioFilePath) else { return }
    guard let data = FileManager.default.contents(atPath: audioFilePath) else { return }
    
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
  
  private func audioFilePath(_ id: UUID) -> String? {
    guard let cardID = currentCard?.id else { return nil }
    let folderName = "Flashcards_Audio_Recordings/"
    let fileName = folderName.appending(cardID.uuidString).appending(".m4a")
    guard let filePath = getDocumentsDirectory()?.appendingPathComponent(fileName).path() else { return nil }
    return filePath
  }
  
  private func getDocumentsDirectory() -> URL? {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
  }
}

// MARK: - Audio Player Delegate

extension FlashcardsViewModel: AVAudioRecorderDelegate, AVAudioPlayerDelegate {
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    stopPlayback()
  }
}
