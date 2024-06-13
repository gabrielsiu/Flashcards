//
//  CardListViewModel.swift
//  Flashcards
//
//  Created by Gabriel Siu on 2023-05-23.
//

import Foundation
import CoreData

class CardListViewModel: ObservableObject {
  @Published var cards: [CardEntity] = []
  
  let coreDataService: CoreDataService
  
  init(coreDataService: CoreDataService) {
    self.coreDataService = coreDataService
  }
  
  func getCards(from setEntity: SetEntity) {
    let request = NSFetchRequest<CardEntity>(entityName: "CardEntity")
    request.predicate = NSPredicate(format: "set == %@", setEntity)
    
    do {
      cards = try coreDataService.context.fetch(request)
    } catch let error {
      print("Error getting cards: \(error)")
    }
  }
  
  func deleteCard(_ indexSet: IndexSet, from setEntity: SetEntity) {
    guard let index = indexSet.first else { return }
    let card = cards[index]
    deleteRecording(card.id ?? UUID())
    coreDataService.context.delete(card)
    coreDataService.save()
    getCards(from: setEntity)
  }
  
  private func deleteRecording(_ cardID: UUID) {
    let folderName = "Flashcards_Audio_Recordings/"
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
    } catch {
      print("Error deleting the recording: \(error)")
    }
  }
  
  private func getDocumentsDirectory() -> URL? {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
  }
}
