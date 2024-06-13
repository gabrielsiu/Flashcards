//
//  QuizTypesView.swift
//  Flashcards
//
//  Created by Gabriel Siu on 2023-06-12.
//

import SwiftUI

struct QuizTypesView: View {
  @State private var showingSetSelectionView = false
  
  private let coreDataService: CoreDataService
  
  init(coreDataService: CoreDataService) {
    self.coreDataService = coreDataService
  }
  
  var body: some View {
    NavigationStack {
      ScrollView {
        VStack {
          QuizTypeView(
            title: "Flashcards",
            description: "Classic flashcards to test your knowledge",
            imageName: "rectangle.portrait.on.rectangle.portrait.angled"
          )
          .onTapGesture {
            showingSetSelectionView = true
          }
          Spacer()
        }
        .padding([.top, .leading, .trailing])
      }
      .navigationTitle("Quiz")
    }
    .sheet(isPresented: $showingSetSelectionView, onDismiss: {
//      viewModel.getCards(from: setEntity)
    }, content: {
      SetSelectionView(
        viewModel: SetSelectionViewModel(coreDataService: coreDataService),
        isPresented: $showingSetSelectionView
      )
    })
  }
}

struct QuizTypesView_Previews: PreviewProvider {
  static var previews: some View {
    QuizTypesView(coreDataService: CoreDataService())
  }
}
