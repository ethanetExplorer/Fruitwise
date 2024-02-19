//
//  IntroductionView.swift
//  Alripe
//
//  Created by Ethan Lim on 19/2/24.
//

import SwiftUI

struct IntroductionView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        TabView {
            VStack {
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
                        Text("Alripe uses a machine learning model to identify your fruit and its ripeness level.")
                            
                    }
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
                        Text("Alripe gives you suggestions on how you can speed up or slow down the ripening process of your fruit.")
                    }
                }
                .padding()
                HStack {
                    Image(systemName: "book")
                        .font(.title)
                        .foregroundStyle(.orange)
                        .padding(5)
                    VStack(alignment: .leading) {
                        Text("Recipes")
                            .bold()
                            .font(.subheadline)
                        Text("For overripe fruits, Alripe suggests ways you can use your overripe fruits so that they don't go to waste.")
                            
                    }
                }
                .padding()
            }
            
            VStack {
                Text("Demonstrational \nimages")
                    .bold()
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 40.0)
            }
            
            VStack {
                Text("Limitations")
                    .bold()
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 40.0)
                Text("At present time, Alripe's machine learning model has only been trained on three (3) fruits: Avocado, banana, tomato.")
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

#Preview {
    IntroductionView()
}
