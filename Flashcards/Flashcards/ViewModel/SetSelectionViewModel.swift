//
//  SetSelectionViewModel.swift
//  Flashcards
//
//  Created by Gabriel Siu on 2023-06-11.
//

import Foundation
import CoreData

class SetSelectionViewModel: ObservableObject {
  private var setEntities: [SetEntity] = []
  @Published var sets: [CardSet] = []
  
  private let coreDataService: CoreDataService
  
  init(coreDataService: CoreDataService) {
    self.coreDataService = coreDataService
    getSets()
  }
  
  func getSets() {
    let request = NSFetchRequest<SetEntity>(entityName: "SetEntity")
    request.predicate = NSPredicate(format: "cards.@count != 0")
    
    do {
      setEntities = try coreDataService.context.fetch(request)
      convertSetEntities()
    } catch {
      print("Error getting data: \(error)")
    }
  }
  
  func getSelectedSets(_ ids: Set<UUID>) -> [SetEntity] {
    var selectedSets = [SetEntity]()
    for id in ids {
      for setEntity in setEntities {
        if let setIdString = setEntity.id?.uuidString, setIdString == id.uuidString {
          selectedSets.append(setEntity)
        }
      }
    }
    return selectedSets
  }
  
  private func convertSetEntities() {
    sets = setEntities.map { CardSet(name: $0.name ?? "", id: $0.id ?? UUID()) }
  }
}
