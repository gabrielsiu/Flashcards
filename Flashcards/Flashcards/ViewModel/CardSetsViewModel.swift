//
//  CardSetsViewModel.swift
//  Flashcards
//
//  Created by Gabriel Siu on 2023-05-23.
//

import SwiftUI
import CoreData

class CardSetsViewModel: ObservableObject {
  @Published var sets: [SetEntity] = []
  @Published var showingAlert = false
  
  let coreDataService: CoreDataService
  
  init(coreDataService: CoreDataService) {
    self.coreDataService = coreDataService
    getSets()
  }
  
  func getSets() {
    let request = NSFetchRequest<SetEntity>(entityName: "SetEntity")
    
    do {
      sets = try coreDataService.context.fetch(request)
    } catch let error {
      print("Error getting sets: \(error)")
    }
  }
  
  func addSet(_ name: String) {
    let newSet = SetEntity(context: coreDataService.context)
    newSet.name = name
    newSet.createdDate = Date()
    newSet.id = UUID()
    save()
  }
  
  func deleteSet(_ indexSet: IndexSet) {
    guard let index = indexSet.first else { return }
    let set = sets[index]
    coreDataService.context.delete(set)
    save()
  }
  
  func save() {
    coreDataService.save()
    getSets()
  }
}
