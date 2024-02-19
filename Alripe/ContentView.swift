//
//  ContentView.swift
//  Alripe
//
//  Created by Ethan Lim on 29/1/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var showIntroductionView = true
    
    var body: some View {
        NavigationStack {
            VStack {
                FruitIdentifierView()
            }
            .padding()
        }
        .sheet(isPresented: $showIntroductionView) {
            IntroductionView(showIntroductionView: $showIntroductionView)
        }
    }
}

#Preview {
    ContentView()
}
