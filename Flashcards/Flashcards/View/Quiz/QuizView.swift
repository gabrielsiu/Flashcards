//
//  QuizView.swift
//  Flashcards
//
//  Created by Gabriel Siu on 2023-05-22.
//

import SwiftUI

struct QuizView: View {
  @State private var showingSetSelectionView = false
  var body: some View {
    ScrollView {
      VStack {
        QuizTypeView(
          title: "Flashcards",
          description: "Classic flashcards to test your knowledge",
          imageName: "rectangle.portrait.on.rectangle.portrait.angled"
        )
        .onTapGesture {
          
        }
        Spacer()
      }
      .padding([.top, .leading, .trailing])
    }
    .sheet(isPresented: $showingSetSelectionView) {
      SettingsView()
    }
  }
}

struct QuizView_Previews: PreviewProvider {
  static var previews: some View {
    QuizView()
  }
}
