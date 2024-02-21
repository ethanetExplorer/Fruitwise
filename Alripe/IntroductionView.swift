//
//  IntroductionView.swift
//  Alripe
//
//  Created by Ethan Lim on 19/2/24.
//

import SwiftUI
import Photos

struct IntroductionView: View {
    
    struct ImageItem: Identifiable, Hashable {
        let id = UUID()
        var imageName: String
        var description: String
        var isSaved: Bool
    }
    
    @Environment(\.dismiss) var dismiss
    @Binding var showIntroductionView: Bool
    @State var showImageCredits = false
    @State var columnSpacing = [
        GridItem(.adaptive(minimum: 160))
    ]
    @State var imagesArray = [
        ImageItem(imageName: "demo-banana-unripe", description: "Unripe banana", isSaved: false),
        ImageItem(imageName: "demo-banana-overripe", description: "Overripe banana", isSaved: false),
        ImageItem(imageName: "demo-avocado-unripe", description: "Unripe avocado", isSaved: false),
        ImageItem(imageName: "demo-tomato-unripe", description: "Unripe tomato", isSaved: false),
        ImageItem(imageName: "demo-tomato-halfripe", description: "Half-ripe tomato", isSaved: false)
    ]
    
    var body: some View {
        TabView {
            VStack {
                Image(uiImage: UIImage(named: "AppIcon") ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 150)
                Text("Welcome to\nAlripe")
                    .bold()
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 40.0)
                HStack {
                    Image(systemName: "camera.viewfinder")
                        .font(.title)
                        .foregroundStyle(.blue)
                        .padding(5)
                    VStack(alignment: .leading) {
                        Text("Fruit detection")
                            .bold()
                            .font(.subheadline)
                        Text("Alripe uses a machine learning model to identify your fruit and its ripeness level, and also tells you how many days it takes for your fruit to fully ripen.")
                            
                    }
                }
                .padding(.horizontal, 18.0)
                .padding(.vertical, 8)
                HStack {
                    Image(systemName: "clock")
                        .font(.title)
                        .foregroundStyle(.green)
                        .padding(5)
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Ripening suggestions")
                            .bold()
                            .font(.subheadline)
                        Text("Alripe gives you suggestions on how you can speed up or slow down the ripening process of your fruit.")
                    }
                }
                .padding()
                HStack {
                    Image(systemName: "book")
                        .font(.title)
                        .foregroundStyle(.orange)
                        .padding(5)
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Recipes")
                            .bold()
                            .font(.subheadline)
                        Text("For overripe fruits, Alripe suggests ways you can use your overripe fruits so that they don't go to waste.")
                            
                    }
                }
                .padding()
            }
            
            NavigationStack {
                ScrollView {
                    VStack {
                        Text("Demonstrational \nimages")
                            .bold()
                            .font(.largeTitle)
                            .multilineTextAlignment(.center)
                            .padding(.top, 32.0)
                        Text("These images have been provided for you to test out the app if you do not have any fruits on hand. Tap on an image to save it to your photos library.")
                            .padding()
                        LazyVGrid(columns: columnSpacing, spacing: 0) {
                            ForEach($imagesArray) { $image in
                                Button {
                                    saveImage(image)
                                    print("\(image.imageName) saved")
                                    image.isSaved = true
                                } label: {
                                    VStack (alignment: .leading){
                                        if image.isSaved {
                                            Image(image.imageName)
                                                .resizable()
                                                .scaledToFit()
                                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                                .saturation(0.0)
                                            Text("\(image.description) saved")
                                                .font(.caption)
                                            
                                        } else {
                                            Image(image.imageName)
                                                .resizable()
                                                .scaledToFit()
                                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                            Text(image.description)
                                                .font(.caption)
                                                .bold()
                                        }
                                    }
                                    .padding()
                                }
                                .disabled(image.isSaved)
                            }
                        }
                        .padding(.vertical)
                        Button { showImageCredits = true } label: {
                            HStack {
                                Image(systemName: "c.circle")
                                Text("Image credits")
                            }
                        }
                        .padding(.bottom, 36)
                        .buttonStyle(.bordered)
                    }
                }
            }
            .sheet(isPresented: $showImageCredits) {
                VStack {
                    Text("Image credits")
                        .bold()
                        .font(.largeTitle)
                        .padding(.top, 12)
                    List {
                        Link("Unripe banana", destination: URL(string: "https://elements.envato.com/overripe-yellow-banana-isolated-on-white-backgroun-K84HKNM")!)
                        Link("Overripe banana image", destination: URL(string: "https://elements.envato.com/overripe-yellow-banana-isolated-on-white-backgroun-K84HKNM")!)
                        Link("Unripe avocado", destination: URL(string: "http://elements.envato.com/green-fresh-avocado-in-male-hand-over-black-backgr-qtjzfnk")!)
                        Link("Unripe tomato", destination: URL(string: "https://elements.envato.com/green-tomato-with-rope-on-marble-background-YX4BYBM")!)
                        Link("Half-ripe tomato \nPhoto by Quaritsch Photography on Unsplash", destination: URL(string: "https://unsplash.com/photos/gold-onion-bulb-cs35NMiGjRE")!)
                    }
                }
                .presentationDetents([.fraction(0.5)])
//                .toolbar {
//                    ToolbarItem(placement: .topBarTrailing) {
//                        Button {
//                            showImageCredits = true
//                        } label: { Image(systemName: "c.circle")}
//                    }
//                }
            }
            VStack {
                Text("Limitations")
                    .bold()
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 40.0)
                VStack {
                    HStack {
                        Image(systemName: "3.circle")
                        Text("At present time, Alripe's machine learning model has only been trained on three (3) fruits: Avocado, banana, tomato.")
                    }
                    HStack {
                        Image(systemName: "carrot")
                        Text("Avocados and tomatoes have been trained with images of single fruits. Bananas have been trained with images of bunches.")
                    }
                }
                Spacer()
                Button {
                    dismiss()
                    showIntroductionView = false
                } label: {
                    Text("Continue")
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom, 40)
            }
            .padding(.horizontal, 10)
        }
        .tabViewStyle(.page)
        
    }
    func saveImage(_ image: ImageItem) {
        guard let image = UIImage(named: image.imageName) else {
            print("Image not found")
            return
        }
        
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                print("Image saved to photo library")
            } else {
                print("Permission denied")
            }
        }
    }
}

#Preview {
    IntroductionView(showIntroductionView: .constant(false))
}
