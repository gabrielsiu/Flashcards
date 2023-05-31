//
//  CreateCardView.swift
//  Flashcards
//
//  Created by Gabriel Siu on 2023-05-31.
//

import SwiftUI

private enum Constants {
  static let padding: CGFloat = 20
  static let textFieldHeight: CGFloat = 55
  static let textFieldCornerRadius: CGFloat = 10
}

struct CreateCardView: View {
  @Binding var isPresented: Bool
  @State private var term = ""
  @State private var definition = ""
  
  @State var isCardFlipped = false
  
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
        Spacer()
      }
      .padding([.leading, .trailing])
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button("Cancel", role: .cancel) {
            isPresented = false
          }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Done") {
            print("done")
          }
          .disabled(term == "" || definition == "")
        }
      }
    }
  }
}
