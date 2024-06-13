//
//  ContentView.swift
//  Flashcards
//
//  Created by Gabriel Siu on 2023-05-22.
//

import SwiftUI

struct ContentView: View {
  private let coreDataService = CoreDataService()
  var body: some View {
    let cardsTitle: LocalizedStringKey = "cards"
    let quizTitle: LocalizedStringKey = "quiz"
    let settingsTitle: LocalizedStringKey = "settings"
    
    TabView {
      CardSetsView(
        viewModel: CardSetsViewModel(coreDataService: coreDataService),
        coreDataService: coreDataService
      )
        .tabItem {
          Label(cardsTitle, systemImage: "rectangle.portrait.on.rectangle.portrait")
        }
      QuizTypesView(coreDataService: coreDataService)
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
