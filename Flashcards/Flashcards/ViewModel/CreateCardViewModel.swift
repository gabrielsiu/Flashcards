//
//  CreateCardViewModel.swift
//  Flashcards
//
//  Created by Gabriel Siu on 2023-05-31.
//

import Foundation

class CreateCardViewModel: ObservableObject {
  private let folderName = "Flashcards_Audio_Recordings"
  private let coreDataService: CoreDataService
  private let setEntity: SetEntity
  private var existingCard: CardEntity?
  let cardID: UUID
  
  var existingCardTerm: String {
    existingCard?.term ?? ""
  }
  
  var existingCardDefinition: String {
    existingCard?.definition ?? ""
  }
  
  init(coreDataService: CoreDataService, setEntity: SetEntity, existingCard: CardEntity? = nil) {
    self.coreDataService = coreDataService
    self.setEntity = setEntity
    cardID = existingCard?.id ?? UUID()
  }
  
  // TODO: Refactor repeated logic
  func checkIfRecordingExists(_ cardID: UUID) -> Bool {
    guard let filePath = audioFilePath(cardID) else { return false }
    return FileManager.default.fileExists(atPath: filePath)
  }
  
  func audioFilePath(_ cardID: UUID) -> String? {
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
    newCard.id = card.id
    newCard.term = card.term
    newCard.set = setEntity
    coreDataService.save()
  }
}
