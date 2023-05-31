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
  
  init(_ viewModel: CardListViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    NavigationStack {
      List {
        ForEach(viewModel.cards) { card in
//          VStack(alignment: .leading) {
//            Text(setEntity.name ?? "")
//              .font(.headline)
//            Text("\(setEntity.cards?.count ?? 0) cards")
//              .font(.caption)
//          }
        }
      }
      .navigationTitle(Constants.title)
      .toolbar {
        Button {
          showingCreateCardView = true
        } label: {
          Image(systemName: "plus")
        }
      }
      .sheet(isPresented: $showingCreateCardView) {
        CreateCardView(isPresented: $showingCreateCardView)
      }
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
    CardListView(CardListViewModel(CoreDataService()))
  }
}
