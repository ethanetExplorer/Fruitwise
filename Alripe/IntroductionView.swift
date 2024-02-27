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
    @State var imagesArray = [
        ImageItem(imageName: "demo-banana-unripe", description: "Unripe banana", isSaved: false),
        ImageItem(imageName: "demo-banana-overripe", description: "Overripe banana", isSaved: false),
        ImageItem(imageName: "demo-avocado-unripe", description: "Unripe avocado", isSaved: false),
        ImageItem(imageName: "demo-tomato-unripe", description: "Unripe tomato", isSaved: false),
        ImageItem(imageName: "demo-tomato-halfripe", description: "Half-ripe tomato", isSaved: false)
    ]
    
    var body: some View {
        TabView {
            NavigationStack {
                VStack {
                    Image(uiImage: UIImage(named: "AppIcon") ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .frame(maxWidth: 128)
                        .padding(.horizontal, 150)
                    Text("Welcome to\nFruitwise")
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
                            Text("Fruitwise uses a machine learning model to identify your fruit and its ripeness level, and also tells you how many days it takes for your fruit to fully ripen.")
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 18.0)
                    .padding(.vertical, 8)
                    HStack {
                        Image(systemName: "clock")
                            .font(.title)
                            .foregroundStyle(.green)
                            .padding(5)
                        VStack(alignment: .leading) {
                            Text("Ripening suggestions")
                                .bold()
                                .font(.subheadline)
                            Text("Fruitwise gives you suggestions on how you can speed up or slow down the ripening process of your fruit.")
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 18.0)
                    .padding(.vertical, 8)
                    HStack {
                        Image(systemName: "book")
                            .font(.title)
                            .foregroundStyle(.orange)
                            .padding(5)
                        VStack(alignment: .leading) {
                            Text("Recipes")
                                .bold()
                                .font(.subheadline)
                            Text("For overripe fruits, Fruitwise suggests ways you can use your overripe fruits so that they don't go to waste.")
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 18.0)
                    .padding(.vertical, 8)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Dismiss") {
                            showIntroductionView = false
                            dismiss()
                        }
                        .padding()
                    }
                }
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
                        LazyVGrid(columns: [GridItem(), GridItem()], spacing: 0) {
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
                    }
                }
            }
            VStack {
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .padding(8)
                    Text("Limitations")
                        .bold()
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 40.0)
                }
                .padding(.top, 40.0)
                .font(.largeTitle)
                VStack {
                    HStack {
                        Image(systemName: "3.circle")
                            .padding()
                            .font(.title2)
                        Text("At present time, Fruitwise's machine learning model has only been trained on three (3) fruits: Avocado, banana, tomato.")
                        Spacer()
                    }
                    .padding(.vertical)
                    HStack {
                        Image(systemName: "carrot")
                            .padding()
                            .font(.title2)
                        Text("Avocados and tomatoes have been trained with images of single fruits. Bananas have been trained with images of bunches.")
                        Spacer()
                    }
                    .padding(.vertical)
                    HStack {
                        Image(systemName: "clock")
                            .font(.title2)
                            .padding()
                        Text("Fruitwise is less accurate with overripe fruits due to insufficient training data available.")
                        Spacer()
                    }
                    .padding(.vertical)
                }
                .padding(.horizontal)
                Spacer()
                Button {
                    dismiss()
                    showIntroductionView = false
                } label: {
                    Text("Continue")
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom, 64)
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
