//
//  CardListView.swift
//  Flashcards
//
//  Created by Gabriel Siu on 2023-05-22.
//

import SwiftUI

struct CardListView: View {
  @StateObject private var viewModel = CardListViewModel()
  
  private let title: LocalizedStringKey = "cards"
  
//  init(_ viewModel: CardListViewModel) {
//    self.viewModel = viewModel
//  }
  
  var body: some View {
    NavigationView {
      List {
        Text("1")
        Text("2")
      }
    }
    .navigationTitle(title)
  }
}

struct CardListView_Previews: PreviewProvider {
  static var previews: some View {
    CardListView()
  }
}
