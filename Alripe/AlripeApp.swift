//
//  AlripeApp.swift
//  Alripe
//
//  Created by Ethan Lim on 29/1/24.
//

import Foundation
import Vision
import SwiftUI
import CoreML

@main
struct AlripeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

enum RipenessStates { case unripe, halfRipe, ripe, overripe, none }
enum FruitNames { case avocado, banana, tomato, none}

struct FruitItem {
    var fruitImage: UIImage?
    var fruitName: FruitNames
    var fruitRipeness: RipenessStates
    var daysTillRipe: Int
    
    var ripeningTip: [String?] {
        switch fruitName {
        case .avocado: return [""]
        case .banana: return [""]
        case .tomato: return [""]
        default: return [""]
        }
    }
    var delayRipeningTip: [String?] {
        switch fruitName {
        case .avocado: return [""]
        case .banana: return [""]
        case .tomato: return [""]
        default: return [""]
        }
    }
    
    var overripeRecipes: [String?] {
        switch fruitName {
        case .avocado: return [""]
        case .banana: return [""]
        case .tomato: return [""]
        default: return [""]
        }
    }
}

struct AvocadoTips {
    let ripeningTip = [
        "",
        "",
        ""
    ]
}
