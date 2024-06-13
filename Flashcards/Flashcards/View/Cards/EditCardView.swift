//
//  EditCardView.swift
//  Flashcards
//
//  Created by Gabriel Siu on 2023-06-11.
//

import SwiftUI

private enum Constants {
  static let padding: CGFloat = 20
  static let textFieldHeight: CGFloat = 55
  static let textFieldCornerRadius: CGFloat = 10
}

struct EditCardView: View {
  @StateObject private var viewModel: EditCardViewModel
  @State var showingRecordAudioView = false
  @State var recordingExists = false
  @State private var term: String
  @State private var definition: String
  
  @State var isCardFlipped = false
  
  init(viewModel: EditCardViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
    term = viewModel.existingCardTerm
    definition = viewModel.existingCardDefinition
  }
  
  var body: some View {
    NavigationStack {
      VStack {
        CardView(term: $term, definition: $definition, isCardFlipped: $isCardFlipped)
          .padding([.top, .bottom], Constants.padding)
          .rotation3DEffect(.degrees(isCardFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
          .onTapGesture {
            withAnimation {
              isCardFlipped.toggle()
            }
          }
        TextField("Term", text: $term)
          .font(.headline)
          .padding(.leading)
          .frame(height: Constants.textFieldHeight)
          .background(Color(UIColor.secondarySystemBackground))
          .cornerRadius(Constants.textFieldCornerRadius)
        TextField("Definition", text: $definition)
          .font(.headline)
          .padding(.leading)
          .frame(height: Constants.textFieldHeight)
          .background(Color(UIColor.secondarySystemBackground))
          .cornerRadius(Constants.textFieldCornerRadius)
        Button {
          showingRecordAudioView = true
        } label: {
          HStack {
            Image(systemName: recordingExists ? "waveform.and.mic" : "mic.fill.badge.plus")
            Text(recordingExists ? "View/Edit Audio Recording" : "Add Audio Recording")
          }
        }
        .frame(height: Constants.textFieldHeight)
        Spacer()
      }
      .padding([.leading, .trailing])
      .onAppear {
        recordingExists = viewModel.checkIfRecordingExists()
      }
      .sheet(isPresented: $showingRecordAudioView, onDismiss: {
        recordingExists = viewModel.checkIfRecordingExists()
      }, content: {
        RecordAudioView(isPresented: $showingRecordAudioView, viewModel: RecordAudioViewModel(viewModel.cardID))
      })
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Save") {
            let card = Card(
              term: term,
              definition: definition,
              audioPath: viewModel.audioFilePath(),
              id: UUID() // Shouldn't be used
            )
            viewModel.updateCard(card: card)
          }
          .disabled(term == "" || definition == "")
        }
      }
    }
  }
}
