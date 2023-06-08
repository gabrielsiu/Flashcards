//
//  CardListView.swift
//  Flashcards
//
//  Created by Gabriel Siu on 2023-05-22.
//

import SwiftUI

private enum Constants {
  static let title: LocalizedStringKey = "cards"
  static let noCards: LocalizedStringKey = "noCards"
}

struct CardListView: View {
  @StateObject private var viewModel: CardListViewModel
  @State var showingCreateCardView = false
  
  private let coreDataService: CoreDataService
  private let setEntity: SetEntity
  
  init(viewModel: CardListViewModel, coreDataService: CoreDataService, setEntity: SetEntity) {
    _viewModel = StateObject(wrappedValue: viewModel)
    self.coreDataService = coreDataService
    self.setEntity = setEntity
  }
  
  var body: some View {
    NavigationStack {
      List {
        ForEach(viewModel.cards) { card in
          NavigationLink {
            QuizView()
          } label: {
            VStack(alignment: .leading) {
              Text(card.term ?? "")
                .font(.headline)
              Text(card.definition ?? "")
                .font(.caption)
            }
          }
        }
        .onDelete(perform: { indexSet in
          viewModel.deleteCard(indexSet, from: setEntity)
        })
      }
      .navigationTitle(Constants.title)
      .onAppear {
        viewModel.getCards(from: setEntity)
      }
      .toolbar {
        Button {
          showingCreateCardView = true
        } label: {
          Image(systemName: "plus")
        }
      }
      .sheet(isPresented: $showingCreateCardView, onDismiss: {
        viewModel.getCards(from: setEntity)
      }, content: {
        CreateCardView(
          isPresented: $showingCreateCardView,
          viewModel: CreateCardViewModel(
            coreDataService: coreDataService,
            setEntity: setEntity
          )
        )
      })
      .overlay(Group {
        if viewModel.cards.isEmpty {
          Text(Constants.noCards)
        }
      })
    }
  }
}

struct CardListView_Previews: PreviewProvider {
  static var previews: some View {
    CardListView(viewModel: CardListViewModel(coreDataService: CoreDataService()), coreDataService: CoreDataService(), setEntity: SetEntity())
  }
}
