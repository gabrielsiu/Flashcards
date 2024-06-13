//
//  SetSelectionView.swift
//  Flashcards
//
//  Created by Gabriel Siu on 2023-06-11.
//

import SwiftUI

struct SetSelectionView: View {
  @StateObject private var viewModel: SetSelectionViewModel
  @Binding var isPresented: Bool
  @State var showingQuizView = false
  @State private var selectedSets = Set<UUID>()
  
  init(viewModel: SetSelectionViewModel, isPresented: Binding<Bool>) {
    _viewModel = StateObject(wrappedValue: viewModel)
    self._isPresented = isPresented
  }
  
  var body: some View {
    NavigationView {
      List(viewModel.sets, selection: $selectedSets) {
        Text($0.name)
      }
      .navigationTitle("Sets")
      .sheet(isPresented: $showingQuizView, onDismiss: {
        // quiz view dismissed
      }, content: {
        FlashcardsView(
          viewModel: FlashcardsViewModel(sets: viewModel.getSelectedSets(selectedSets))
        )
      })
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button("Cancel", role: .cancel) {
            isPresented = false
          }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Start") {
             showingQuizView = true
          }
          .disabled(selectedSets.isEmpty)
        }
      }
      .environment(\.editMode, .constant(EditMode.active))
    }
  }
}

#Preview {
  SetSelectionView(
    viewModel: SetSelectionViewModel(coreDataService: CoreDataService()),
    isPresented: .constant(true)
  )
}
