//
//  ContentView.swift
//  Pinch
//
//  Created by Bagus Kurnia on 13/07/22.
//

import SwiftUI

struct ContentView: View {
  @State private var isAnimating: Bool = false
  @State private var imageScale: CGFloat = 1
  @State private var imageOffset: CGSize = .zero
  
  func resetImage() {
    withAnimation(.spring()) {
      imageScale = 1
      imageOffset = .zero
    }
  }
  
  var body: some View {
    NavigationView {
      ZStack {
        Color.clear
        
        Image("magazine-front-cover")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .cornerRadius(10)
          .padding()
          .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
          .opacity(isAnimating ? 1 : 0)
          .offset(x: imageOffset.width, y: imageOffset.height)
          .animation(.linear(duration: 1), value: isAnimating)
          .scaleEffect(imageScale)
          // Tap Gesture
          .onTapGesture(count: 2, perform: {
            if imageScale == 1 {
              withAnimation(.spring()) {
                imageScale = 5
              }
            } else {
              resetImage()
            }
          })
          // Drag Gesture
          .gesture(
            DragGesture()
              .onChanged { value in
                withAnimation(.linear(duration: 1)) {
                  imageOffset = value.translation
                }
              }
              .onEnded { _ in
                if imageScale <= 1 {
                  resetImage()
                }
              }
          )
      }
      .navigationTitle("Pinch & Zoom")
      .navigationBarTitleDisplayMode(.inline)
      .onAppear(perform: {
        isAnimating = true
      })
      .overlay(
        InfoPanelView(scale: imageScale, offset: imageOffset)
          .padding(.horizontal)
          .padding(.top, 30)
        , alignment: .top
      )
    }
    .navigationViewStyle(.stack)
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView()
        .preferredColorScheme(.light)
    }
}
