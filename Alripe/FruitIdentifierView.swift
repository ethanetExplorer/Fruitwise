//
//  FruitIdentifierView.swift
//  Alripe
//
//  Created by Ethan Lim on 29/1/24.
//

import SwiftUI

struct FruitIdentifierView: View {
    var body: some View {
        NavigationView {
            VStack {
                Button("Open Camera") {
                    showCamera = true
                }
                .padding()
                .background(.white)
                .sheet(isPresented: $showCamera) {
                    ImagePicker(showCamera: $showCamera, uiImage: $investigatablePhoto)
                }
                
                if let photo = investigatablePhoto {
                    Image(uiImage: photo)
                        .resizable()
                        .scaledToFit()
                        .padding()
                }
            }
        }
    }
}

#Preview {
    FruitIdentifierView()
}
