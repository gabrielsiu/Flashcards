//
//  CreateCardViewModel.swift
//  Flashcards
//
//  Created by Gabriel Siu on 2023-05-31.
//

import Foundation

class CreateCardViewModel: ObservableObject {
  
  let folderName = "Flashcards_Audio_Recordings"
  
  // TODO: Refactor repeated logic
  func checkIfRecordingExists(_ cardID: UUID) -> Bool {
    let fileName = folderName.appending(cardID.uuidString).appending(".m4a")
    guard let filePath = getDocumentsDirectory()?.appendingPathComponent(fileName).path() else {
      return false
    }
    
    return FileManager.default.fileExists(atPath: filePath)
  }
  
  private func getDocumentsDirectory() -> URL? {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
  }
}
