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
  
  init(_ coreDataService: CoreDataService) {
    self.coreDataService = coreDataService
    getCards()
  }
  
  func getCards() {
    let request = NSFetchRequest<CardEntity>(entityName: "CardEntity")
    
    do {
      cards = try coreDataService.context.fetch(request)
    } catch let error {
      print("Error getting cards: \(error)")
    }
  }
  
  func addCard(_ name: String) {
    let newSet = SetEntity(context: coreDataService.context)
    newSet.name = name
    newSet.createdDate = Date()
    save()
  }
  
  func deleteCard(_ indexSet: IndexSet) {
    guard let index = indexSet.first else { return }
    let card = cards[index]
    coreDataService.context.delete(card)
    save()
  }
  
  func save() {
    coreDataService.save()
    getCards()
  }
}
