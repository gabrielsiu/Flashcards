//
//  RecordAudioView.swift
//  Flashcards
//
//  Created by Gabriel Siu on 2023-05-31.
//

import SwiftUI

struct RecordAudioView: View {
  @Binding var isPresented: Bool
  @StateObject var viewModel: RecordAudioViewModel
  
  var body: some View {
    NavigationStack {
      VStack {
        VStack(alignment: .leading, spacing: 10) {
          Text("Audio Recording")
            .font(.title)
          Text(viewModel.descriptionText())
            .font(.subheadline)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        
        if viewModel.recordPermissionGranted {
          Spacer()
          HStack(spacing: 20) {
            // Record Audio
            Button {
              if viewModel.audioRecorder == nil {
                viewModel.deleteRecording()
                viewModel.startRecording()
              } else {
                viewModel.finishRecording(true)
              }
            } label: {
              Image(systemName: viewModel.isRecording ? "stop.circle.fill" : "mic.circle.fill")
                .foregroundColor(.red)
                .font(.system(size: 60))
            }
            
            if viewModel.recordingData != nil {
              // Start / Stop Playback
              Button {
                if viewModel.isPlaying {
                  viewModel.stopPlayback()
                } else {
                  viewModel.startPlayback()
                }
              } label: {
                Image(systemName: viewModel.isPlaying ? "stop.circle.fill" : "play.circle.fill")
                  .foregroundColor(.blue)
                  .font(.system(size: 60))
              }
              
              // Delete Recording
              Button {
                viewModel.deleteRecording()
              } label: {
                Image(systemName: "trash.circle.fill")
                  .foregroundColor(.gray)
                  .font(.system(size: 60))
              }
            }
          }
        }
      }
      .padding([.leading, .trailing])
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Done") {
            isPresented = false
          }
          .disabled(viewModel.isRecording)
        }
      }
      .interactiveDismissDisabled(viewModel.isRecording)
    }
  }
}

struct RecordAudioView_Previews: PreviewProvider {
  @State static var value = true
  static var previews: some View {
    RecordAudioView(isPresented: $value, viewModel: RecordAudioViewModel(UUID()))
  }
}
