//
//  SetSelectionViewModel.swift
//  Flashcards
//
//  Created by Gabriel Siu on 2023-06-11.
//

import Foundation
import CoreData

class SetSelectionViewModel: ObservableObject {
  @Published var sets: [SetEntity] = []
  
  private let coreDataService: CoreDataService
  
  init(coreDataService: CoreDataService) {
    self.coreDataService = coreDataService
    getSets()
  }
  
  func getSets() {
    let request = NSFetchRequest<SetEntity>(entityName: "SetEntity")
    
    do {
      sets = try coreDataService.context.fetch(request)
    } catch {
      print("Error getting data: \(error)")
    }
  }
}
