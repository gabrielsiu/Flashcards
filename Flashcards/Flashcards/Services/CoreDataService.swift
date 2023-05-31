//
//  CoreDataService.swift
//  Flashcards
//
//  Created by Gabriel Siu on 2023-05-30.
//

import Foundation
import CoreData

class CoreDataService {
  let container: NSPersistentContainer
  let context: NSManagedObjectContext
  
  init() {
    container = NSPersistentContainer(name: "FlashcardsContainer")
    container.loadPersistentStores { description, error in
      if let error = error {
        print("Error loading Core Data: \(error)")
      }
    }
    context = container.viewContext
  }
  
  func save() {
    do {
      try context.save()
    } catch let error {
      print("Error saving Core Data: \(error.localizedDescription)")
    }
  }
}
