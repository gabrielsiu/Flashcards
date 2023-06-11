//
//  EditCardViewModel.swift
//  Flashcards
//
//  Created by Gabriel Siu on 2023-06-11.
//

import Foundation

class EditCardViewModel: ObservableObject {
  private let folderName = "Flashcards_Audio_Recordings/"
  private let coreDataService: CoreDataService
  private var existingCard: CardEntity
  
  var existingCardTerm: String {
    existingCard.term ?? ""
  }
  
  var existingCardDefinition: String {
    existingCard.definition ?? ""
  }
  
  var cardID: UUID {
    existingCard.id ?? UUID()
  }
  
  init(existingCard: CardEntity, coreDataService: CoreDataService) {
    self.existingCard = existingCard
    self.coreDataService = coreDataService
  }
  
  // TODO: Refactor repeated logic
  func checkIfRecordingExists() -> Bool {
    guard let filePath = audioFilePath() else { return false }
    return FileManager.default.fileExists(atPath: filePath)
  }
  
  func audioFilePath() -> String? {
    let fileName = folderName.appending(cardID.uuidString).appending(".m4a")
    guard let filePath = getDocumentsDirectory()?.appendingPathComponent(fileName).path() else { return nil }
    return filePath
  }
  
  private func getDocumentsDirectory() -> URL? {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
  }
  
  func moveCard(cardEntity: CardEntity, to setEntity: SetEntity) {
    
  }
  
  func updateCard(card: Card) {
    existingCard.audioPath = checkIfRecordingExists() ? card.audioPath : nil
    existingCard.definition = card.definition
    existingCard.term = card.term
    coreDataService.save()
  }
}
