//
//  CreateCardViewModel.swift
//  Flashcards
//
//  Created by Gabriel Siu on 2023-05-31.
//

import Foundation

class CreateCardViewModel: ObservableObject {
  private let folderName = "Flashcards_Audio_Recordings/"
  private let coreDataService: CoreDataService
  private let setEntity: SetEntity
  let cardID: UUID
  
  init(coreDataService: CoreDataService, setEntity: SetEntity) {
    self.coreDataService = coreDataService
    self.setEntity = setEntity
    cardID = UUID()
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
  
  func addCard(_ card: Card) {
    let newCard = CardEntity(context: coreDataService.context)
    newCard.audioPath = card.audioPath
    newCard.createdDate = card.createdDate
    newCard.definition = card.definition
    newCard.id = cardID
    newCard.term = card.term
    newCard.set = setEntity
    coreDataService.save()
  }
}
