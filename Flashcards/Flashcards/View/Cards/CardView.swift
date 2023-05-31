//
//  CardView.swift
//  Flashcards
//
//  Created by Gabriel Siu on 2023-05-31.
//

import SwiftUI

private enum Constants {
  static let height: CGFloat = 250
  static let cornerRadius: CGFloat = 20
  static let lineLimit = 5
}

struct CardView: View {
  @Binding var term: String
  @Binding var definition: String
  @Binding var isCardFlipped: Bool
  
  var body: some View {
    ZStack {
      if !isCardFlipped {
        CardSideView(text: $term, placeholder: "Term")
      }
      if isCardFlipped {
        CardSideView(text: $definition, placeholder: "Definition")
          .rotation3DEffect(.degrees(isCardFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
      }
    }
  }
}

struct CardSideView: View {
  @Binding var text: String
  let placeholder: String
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: Constants.cornerRadius, style: .continuous)
        .fill(Color(UIColor.secondarySystemBackground))
        .frame(height: Constants.height)
      Text(text)
        .font(.title2)
        .fontWeight(.medium)
        .multilineTextAlignment(.center)
        .lineLimit(Constants.lineLimit)
        .padding()
      if text == "" {
        Text(placeholder)
          .font(.largeTitle)
          .fontWeight(.medium)
          .foregroundColor(Color.gray)
      }
    }
  }
}
