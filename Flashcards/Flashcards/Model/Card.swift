//
//  Card.swift
//  Flashcards
//
//  Created by Gabriel Siu on 2023-05-31.
//

import Foundation

struct Card {
  let term: String
  let definition: String
  let audioPath: String?
  let id = UUID()
  let createdDate = Date()
}
