//
//  QuizTypeView.swift
//  Flashcards
//
//  Created by Gabriel Siu on 2023-06-11.
//

import SwiftUI

struct QuizTypeView: View {
  var title: String
  var description: String
  var imageName: String
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 10)
        .fill(Color.gray)
        .frame(height: 100)
      HStack(alignment: .top) {
        Image(systemName: imageName)
          .font(.system(size: 25))
        VStack(alignment: .leading) {
          Text(title)
            .font(.headline)
          Text(description)
        }
      }
    }
  }
}

struct QuizTypeView_Previews: PreviewProvider {
  static var previews: some View {
    QuizTypeView(
      title: "Flashcards",
      description: "Classic flashcards to test your knowledge",
      imageName: "rectangle.portrait.on.rectangle.portrait.angled"
    )
  }
}
