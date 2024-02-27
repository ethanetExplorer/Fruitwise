import SwiftUI

struct InformationView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var showInfoView: Bool
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("Purpose of project")
                        .bold()
                        .font(.title)
                        .padding(.vertical)
                    Text("Fruitwise was built to address and spread the awareness of food waste. Every year, almost **1 billion tonnes** of food waste is produced. Food waste also contributes to a massive amount of greenhouse gas emissions. \nWith Fruitwise, I hope that it is able to cater to people who forget about ever buying a fruit and throwing it away.")
                }
                .padding(.vertical)
                VStack {
                    Text("How it works")
                        .bold()
                        .font(.title)
                        .padding(.vertical)
                    Text("Fruitwise uses a custom-trained CoreML model that is trained on over 300 images of avocados, bananas and tomatos of varying ripeness levels in order to identify the ripeness of fruits. Demonstrational images provided were not used to train the CoreML model.")
                }
                .padding(.vertical)
                HStack {
                    VStack {
                        Text("Future work")
                            .bold()
                            .font(.title)
                            .padding(.vertical)
                        HStack {
                            VStack (alignment: .leading) {
                                Text("Implementing of SwiftData")
                                    .font(.title3)
                                    .bold()
                                Text("This allows fruits to be saved to the storage of the device.")
                            }
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        HStack {
                            VStack (alignment: .leading) {
                                Text("Reminders functionality")
                                    .font(.title3)
                                    .bold()
                                Text("This will remind users when their fruit is about to ripen or overripe so that they take note to consume it quickly.")
                            }
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        HStack {
                        VStack (alignment: .leading) {
                            Text("Training on more varities of fruits")
                                .font(.title3)
                                .bold()
                            Text("This means training the CoreML model on more types of fruits such as apples, oranges, grapes, and strawberries, allowing Fruitwise to be much more useful and capable. Additionally, this also means training the CoreML model on different breeds of fruits and to be more accurate.")
                        }
                            Spacer()
                    }
                        .padding(.vertical, 8)
                    }
                }
                .padding(.vertical)
            }
            .padding(.top, 24)
            .padding(.horizontal, 48)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Dismiss") {
                        showInfoView = false
                        dismiss()
                    }
                    .padding()
                }
            }
        }
    }
}
