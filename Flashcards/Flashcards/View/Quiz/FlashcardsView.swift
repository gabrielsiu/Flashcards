//
//  FlashcardsView.swift
//  Flashcards
//
//  Created by Gabriel Siu on 2023-06-12.
//

import SwiftUI

struct FlashcardsView: View {
  @StateObject private var viewModel: FlashcardsViewModel
  @State var isCardFlipped = false
  
  @State var term = ""
  @State var definition = ""
  
  init(viewModel: FlashcardsViewModel) {
    self._viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    VStack {
      Text(viewModel.cardNumText())
      Text(viewModel.scoreText())
      
      Spacer()
      
      CardView(
        term: $term,
        definition: $definition,
        isCardFlipped: $isCardFlipped
      )
      .rotation3DEffect(.degrees(isCardFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
      .onTapGesture {
        withAnimation {
          isCardFlipped.toggle()
        }
      }
      
      Spacer()
      
      HStack {
        Button {
          isCardFlipped = false
          viewModel.moveToNextCard(correct: false)
          updateCard()
        } label: {
          Image(systemName: "x.circle.fill")
            .foregroundColor(.red)
            .font(.system(size: 60))
        }
        
        if isCardFlipped, viewModel.recordingExists() {
          Spacer()
          
          Button {
            if viewModel.isPlaying {
              viewModel.stopPlayback()
            } else {
              viewModel.startPlayback()
            }
          } label: {
            Image(systemName: viewModel.isPlaying ? "stop.circle.fill" : "play.circle.fill")
              .foregroundColor(.blue)
              .font(.system(size: 60))
          }
          
          Spacer()
        } else {
          Spacer()
        }
        
        Button {
          isCardFlipped = false
          viewModel.moveToNextCard(correct: true)
          updateCard()
        } label: {
          Image(systemName: "checkmark.circle.fill")
            .foregroundColor(.green)
            .font(.system(size: 60))
        }
      }
    }
    .onAppear {
      updateCard()
    }
  }
  
  private func updateCard() {
    term = viewModel.currentCard?.term ?? ""
    definition = viewModel.currentCard?.definition ?? ""
  }
}

struct FlashcardsView_Previews: PreviewProvider {
  static var previews: some View {
    FlashcardsView(viewModel: FlashcardsViewModel(sets: []))
  }
}
