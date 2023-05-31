//
//  ContentView.swift
//  Flashcards
//
//  Created by Gabriel Siu on 2023-05-22.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    let cardsTitle: LocalizedStringKey = "cards"
    let quizTitle: LocalizedStringKey = "quiz"
    let settingsTitle: LocalizedStringKey = "settings"
    
    TabView {
      CardSetsView(CardSetsViewModel(CoreDataService()))
        .tabItem {
          Label(cardsTitle, systemImage: "square.3.stack.3d")
        }
      QuizView()
        .tabItem {
          Label(quizTitle, systemImage: "questionmark")
        }
      SettingsView()
        .tabItem {
          Label(settingsTitle, systemImage: "gear")
        }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
