//
//  ContentView.swift
//  Alripe
//
//  Created by Ethan Lim on 29/1/24.
//

import SwiftUI
import UIKit
import Vision
import CoreML

struct ContentView: View {
    
    @State var selectedImage: UIImage? = nil
    
    @State var isFinished = false
    @State var isPresenting = false
    @State var showIntroductionView = true
    @State var sourceType: UIImagePickerController.SourceType = .camera
    @State var tipSelected: String = "quicken"
    
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
                VStack {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(minWidth: 300, maxHeight: 250)
                            .padding()
                    }
                    ScrollView {
                        if isFinished {
                            if fruitDetector.fruitRipeness == .none {
                                Text("This is not a fruit.")
                                    .font(.title)
                                    .bold()
                                    .padding()
                                    .multilineTextAlignment(.leading)
                            } else if fruitDetector.fruitRipeness == .ripe {
                                Text(titleText)
                                    .font(.title)
                                    .bold()
                                    .padding()
                                Text("Enjoy your fruit!")
                            } else if fruitDetector.fruitRipeness == .overripe {
                                Text(titleText)
                                    .font(.title)
                                    .bold()
                                    .padding()
                                ForEach(fruitDetector.overripeRecipes, id: \.self) { tip in
                                    Text(tip ?? "Tip unavailable")
                                        .padding()
                                }
                            } else {
                                Text(titleText)
                                    .font(.title)
                                    .bold()
                                Picker("Tip Controller", selection: $tipSelected) {
                                    Text("Quicken").tag("quicken")
                                    Text("Slow down").tag("slow")
                                }
                                .pickerStyle(.segmented)
                                .padding()
                                if tipSelected == "quicken" {
                                    ForEach(fruitDetector.ripeningTip, id: \.self) { tip in
                                        Text(tip ?? "")
                                            .padding([.bottom, .leading, .trailing])
                                            .multilineTextAlignment(.leading)
                                    }
                                } else if tipSelected == "slow" {
                                    ForEach(fruitDetector.delayRipeningTip, id: \.self) { tip in
                                        Text(tip ?? "")
                                            .padding([.bottom, .leading, .trailing])
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                            }
                        } else {
                            Button {
                                fruitDetector.detect(uiImage: selectedImage!)
                                isFinished = true
                            } label: {
                                Text("Detect")
                            }
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
                        }
                        .buttonStyle(.borderedProminent)
                        Button {
                            self.sourceType = .photoLibrary
                            isPresenting = true
                        } label: {
                            HStack {
                                Image(systemName: "photo")
                                Text("Photo library")
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .fullScreenCover(isPresented: $isPresenting, onDismiss: didDismiss) {
                    ImagePicker(selectedImage: self.$selectedImage, isPresenting: $isPresenting, sourceType: self.$sourceType, isFinished: $isFinished)
                }
                .navigationBarTitle("Fruit Detector")
            }
        }
        .sheet(isPresented: $showIntroductionView) {
            IntroductionView(showIntroductionView: $showIntroductionView)
        }
    }
    func didDismiss() {
        if let selectedImage {
            fruitDetector.detect(uiImage: selectedImage)
            isFinished = true
        }
    }
}

#Preview {
    ContentView()
}
