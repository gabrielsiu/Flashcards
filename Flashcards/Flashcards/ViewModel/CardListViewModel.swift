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
    coreDataService.context.delete(card)
    coreDataService.save()
    getCards(from: setEntity)
  }
}
