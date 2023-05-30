//
//  CardSetsView.swift
//  Flashcards
//
//  Created by Gabriel Siu on 2023-05-22.
//

import SwiftUI

private enum Constants {
  static let title: LocalizedStringKey = "sets"
  static let noSets: LocalizedStringKey = "noSets"
}

struct CardSetsView: View {
  
  var body: some View {
    NavigationView {
      List {
        Text("1")
        Text("2")
      }
      .navigationTitle(Constants.title)
      .toolbar {
        Button {
          print("Add button pressed")
        } label: {
          Image(systemName: "plus")
        }

      }
      .overlay(Group {
        Text(Constants.noSets)
      })
    }
  }
}

struct CardSetsView_Previews: PreviewProvider {
  static var previews: some View {
    CardSetsView()
  }
}
