import SwiftUI
import UIKit

struct ContentView: View {
    
    //IntroductionView
    @State var showIntroductionView = true
    
    //ContentView, General
    @State var investigatableFruitItem = FruitItem(detectionResult: "", image: nil)
    @ObservedObject var fruitDetector = DetectionResultProcessor()    
    @State var fruitsArray: [FruitItem] = []
    var columns: [GridItem] {
        return Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)
    }
    @State var showDeleteAlert = false
    
    //ImagePicker
    @State var selectedImage: UIImage? = nil
    @State var presentImagePicker = false
    @State var sourceType: UIImagePickerController.SourceType = .camera
    
    //FruitDetailView
    @State var showFruitDetailView = false
    
    //Credits and future work
    @State var showCreditsView = false
    @State var showInfoView = false
    
    var body: some View {
        NavigationStack {
            if !fruitsArray.isEmpty {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 0) {
                        ForEach(fruitsArray) { fruit in
                            Button {
                                self.investigatableFruitItem = fruit
                                showFruitDetailView = true
                            } label: {
                                VStack(alignment: .leading) {
                                    Image(uiImage: fruit.image!)
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                    switch fruit.fruitName {
                                    case .avocado: Text("Avocado")
                                            .font(.caption)
                                    case .banana: Text("Banana")
                                            .font(.caption)
                                    case .tomato: Text("Tomato")
                                            .font(.caption)
                                    default: Text("Unidentified")
                                            .font(.caption)
                                    }
                                }
                                .padding(12)
                            }
                        }
                    }
                }
                .navigationTitle("Fruitwise")
                .toolbar {
                    Menu {
                        Button {
                            sourceType = .camera
                            presentImagePicker = true
                        } label: {
                            HStack {
                                Image(systemName: "camera")
                                Text("Camera")
                            }
                        }
                        Button {
                            sourceType = .photoLibrary
                            presentImagePicker = true
                        } label: {
                            HStack {
                                Image(systemName: "photo.stack")
                                Text("Photos library")
                            }
                        }
                    } label: {
                        Image(systemName: "camera.viewfinder")
                    }
                    Menu {
                        Button {
                            showIntroductionView = true
                        } label: {
                            Text("Show introduction")
                        }
                        Button {
                            showCreditsView = true
                        } label: {
                            Text("Credits")
                        }
                        Button {
                            showInfoView = true
                        } label: {
                            Text("Information")
                        }
                    } label: {
                        Image(systemName: "info.circle")
                    }
                        .alert(isPresented: $showDeleteAlert) {
                            Alert(title: Text("Delete Everything"), message: Text("Are you sure you want to delete everything?"), primaryButton: .destructive(Text("Delete")) {
                                fruitsArray.removeAll()
                            }, secondaryButton: .cancel(Text("Cancel")){
                                showDeleteAlert = false
                            })
                        }
                    Button(role: .destructive) {
                        showDeleteAlert = true
                    } label: {
                        Image(systemName: "trash")
                            .foregroundStyle(.red)
                    }
                }
            } else {
                Text("Start adding fruits by tapping \(Image(systemName: "camera.viewfinder")) in the top-right corner")
                    .padding(.horizontal, 36)
                    .navigationTitle("Fruitwise")
                    .toolbar {
                        Menu {
                            Button {
                                sourceType = .camera
                                presentImagePicker = true
                            } label: {
                                HStack {
                                    Image(systemName: "camera")
                                    Text("Camera")
                                }
                            }
                            Button {
                                sourceType = .photoLibrary
                                presentImagePicker = true
                            } label: {
                                HStack {
                                    Image(systemName: "photo.stack")
                                    Text("Photos library")
                                }
                            }
                        } label: {
                            Image(systemName: "camera.viewfinder")
                        }
                        Menu {
                            Button {
                                showIntroductionView = true
                            } label: {
                                HStack {
                                    Image(systemName: "figure.wave")
                                    Text("Show introduction")
                                }
                            }
                            Button {
                                showCreditsView = true
                            } label: {
                                HStack {
                                    Image(systemName: "c.circle")
                                    Text("Credits")
                                }
                            }
                            Button {
                                showInfoView = true
                            } label: {
                                HStack {
                                    Image(systemName: "calendar")
                                    Text("Information")
                                }
                            }
                        } label: {
                            Image(systemName: "info.circle")
                        }
                    }
            }
        }
        .fullScreenCover(isPresented: $presentImagePicker, onDismiss: didDismiss) {
            ImagePicker(selectedImage: $selectedImage, presentImagePicker: $presentImagePicker, sourceType: $sourceType)
        }
        .sheet(isPresented: $showFruitDetailView) {
            FruitDetailView(investigatableFruitItem: $investigatableFruitItem, fruitsArray: $fruitsArray)
        }
        .sheet(isPresented: $showIntroductionView) {
            IntroductionView(showIntroductionView: $showIntroductionView)
        }
        .sheet(isPresented: $showCreditsView) {
            CreditsView(showCreditsView: $showCreditsView)
        }
        .sheet(isPresented: $showInfoView) {
            InformationView(showInfoView: $showInfoView)
        }
    }
    func didDismiss() {
        fruitDetector.detect(uiImage: selectedImage!)
        investigatableFruitItem = fruitDetector.newFruitItem!
        showFruitDetailView = true
    }
}
