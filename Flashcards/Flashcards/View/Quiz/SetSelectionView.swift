//
//  SetSelectionView.swift
//  Flashcards
//
//  Created by Gabriel Siu on 2023-06-11.
//

import SwiftUI

struct SetSelectionView: View {
  @StateObject private var viewModel: SetSelectionViewModel
  @State private var selectedSets = Set<SetEntity>()
  
  init(viewModel: SetSelectionViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    NavigationView {
      List(viewModel.sets, selection: $selectedSets) {
        Text($0.name ?? "")
      }
    }
    .navigationTitle("Sets")
  }
}

struct SetSelectionView_Previews: PreviewProvider {
  static var previews: some View {
    SetSelectionView(viewModel: SetSelectionViewModel(coreDataService: CoreDataService()))
  }
}
