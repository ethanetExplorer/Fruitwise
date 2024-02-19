//
//  FruitIdentifierView.swift
//  Alripe
//
//  Created by Ethan Lim on 29/1/24.
//

import SwiftUI
import UIKit
import Vision
import CoreML

struct FruitIdentifierView: View {
    
    @State var selectedImage: UIImage? = nil
    @State var isFinished = false
    @State var isPresenting = false
    @State var sourceType: UIImagePickerController.SourceType = .camera
    @State var tipSelected: String = ""
    @State private var fruitDetector = DetectionResultProcessor()
    
    var titleText: String {
        let fruitNameText: String
        let ripenessText: String
        
        switch fruitDetector.fruitName {
        case .avocado:
            fruitNameText = "avocado"
        case .banana:
            fruitNameText = "banana"
        case .tomato:
            fruitNameText = "tomato"
        default:
            return ""
        }
        
        switch fruitDetector.fruitRipeness {
        case .halfRipe:
            ripenessText = "half-ripe"
        case .overripe:
            ripenessText = "overripe"
        case .ripe:
            ripenessText = "ripe"
        case .unripe:
            ripenessText = "unripe"
        default:
            return ""
        }
        
        return "Your \(fruitNameText) is \(ripenessText)"
    }
    
    var body: some View {
        NavigationStack {
            if selectedImage != nil {
                VStack (alignment: .leading) {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .padding()
                            .aspectRatio(contentMode: .fit)
                    }
                    if isFinished {
                        Text(titleText)
                            .bold()
                            .font(.title)
                        Picker("Tip Controller", selection: $tipSelected) {
                            Text("Quicken").tag("quicken")
                            Text("Slow down").tag("slow")
                            if fruitDetector.fruitRipeness == .overripe {
                                Text("Recipes").tag("recipes")
                            }
                        }
                        .pickerStyle(.segmented)
                        if tipSelected == "quicken" {
                            Text("Quicken ripening process")
                        } else if tipSelected == "slow" {
                            Text("Slow down ripening process")
                        } else if tipSelected == "recipes" {
                            Text("Recipes")
                        }
                    } else {
                        Button {
                            fruitDetector.detect(uiImage: selectedImage!)
                            isFinished = true
                        } label: {
                            Text("Detect")
                        }
                    }
                    Spacer()
                    Button {
                        selectedImage = nil
                        isFinished = false
                    } label: {
                        Text("Revert")
                    }
                }
            } else {
                VStack {
                    HStack {
                        Button {
                            self.sourceType = .camera
                            isPresenting = true
                        } label: {
                            HStack {
                                Image(systemName: "camera")
                                Text("Camera")
                            }
                            .padding()
                        }
                        Button {
                            self.sourceType = .photoLibrary
                            isPresenting = true
                        } label: {
                            HStack {
                                Image(systemName: "photo")
                                Text("Photo library")
                            }
                            .padding()
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $isPresenting, onDismiss: didDismiss) {
            ImagePicker(selectedImage: self.$selectedImage, isPresenting: $isPresenting, sourceType: self.$sourceType, isFinished: $isFinished)
        }
        .navigationBarTitle("Fruit Detector")
        
    }
    func didDismiss() {
        if let selectedImage {
            fruitDetector.detect(uiImage: selectedImage)
            isFinished = true
        }
    }
}



//#Preview {
//    FruitIdentifierView()
//}
