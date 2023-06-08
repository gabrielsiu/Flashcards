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
  
  static let alertTitle: LocalizedStringKey = "alertTitle"
  static let alertMessage: LocalizedStringKey = "alertMessage"
  static let cancel: LocalizedStringKey = "cancel"
}

struct CardSetsView: View {
  @StateObject private var viewModel: CardSetsViewModel
  @State var newSetName = ""
  
  private let coreDataService: CoreDataService
  
  init(viewModel: CardSetsViewModel, coreDataService: CoreDataService) {
    _viewModel = StateObject(wrappedValue: viewModel)
    self.coreDataService = coreDataService
  }
  
  var body: some View {
    NavigationStack {
      List {
        ForEach(viewModel.sets) { setEntity in
          NavigationLink {
            CardListView(
              viewModel: CardListViewModel(coreDataService: coreDataService),
              coreDataService: coreDataService,
              setEntity: setEntity
            ) // TODO: consolodate service
          } label: {
            VStack(alignment: .leading) {
              Text(setEntity.name ?? "")
                .font(.headline)
              Text("\(setEntity.cards?.count ?? 0) cards")
                .font(.caption)
            }
          }
        }
        .onDelete(perform: viewModel.deleteSet)
      }
      .navigationTitle(Constants.title)
      .onAppear {
        viewModel.getSets()
      }
      .toolbar {
        Button {
          viewModel.showingAlert = true
        } label: {
          Image(systemName: "plus")
        }

      }
      .alert(Constants.alertTitle, isPresented: $viewModel.showingAlert, actions: {
        TextField("Name", text: $newSetName)
        Button(Constants.alertTitle) {
          viewModel.addSet(newSetName)
          newSetName = ""
        }
        Button(Constants.cancel, role: .cancel, action: {})
      }, message: {
        Text(Constants.alertMessage)
      })
      .overlay(Group {
        if viewModel.sets.isEmpty {
          Text(Constants.noSets)
        }
      })
    }
  }
}

struct CardSetsView_Previews: PreviewProvider {
  static var previews: some View {
    CardSetsView(viewModel: CardSetsViewModel(coreDataService: CoreDataService()), coreDataService: CoreDataService())
  }
}
