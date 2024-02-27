//
//  FruitwiseBackend.swift
//  Fruitwise
//
//  Created by Ethan Lim on 25/2/24.
//

import Foundation
import UIKit
import Vision
import CoreML

enum FruitNames: Codable {
    case avocado, banana, tomato, none
}

enum FruitRipenessStates: Codable {
    case unripe, halfRipe, ripe, overripe, none
}

struct FruitItem: Identifiable, Equatable {
    let id = UUID()
    var detectionResult: String
    var image: UIImage?
    var fruitName: FruitNames {
        switch detectionResult {
            case let result where result.contains("avocado"): return .avocado
            case let result where result.contains("banana"): return .banana
            case let result where result.contains("tomato"): return .tomato
            case let result where result == "not-fruit": return .none
            default: return .none
        }
    }
    
    var fruitRipeness: FruitRipenessStates {
        switch detectionResult {
            case let result where result.contains("unripe"): return .unripe
            case let result where result.contains("halfripe"): return .halfRipe
            case let result where result.contains("overripe"): return .overripe
            case let result where result.contains("ripe"): return .ripe
            case let result where result == "not-fruit": return .none
            default: return .none
        }
    }
    
    var daysToRipeUpperLimit: Date? {
        switch fruitName {
        case .avocado:
            switch fruitRipeness {
            case .unripe:
                return Date.now.addingTimeInterval(5*24*60*60)
            case .halfRipe:
                return Date.now.addingTimeInterval(2*24*60*60)
            default: return Date.now
            }
        case .banana:
            switch fruitRipeness {
            case .unripe:
                return Date.now.addingTimeInterval(5*24*60*60)
            case .halfRipe:
                return Date.now.addingTimeInterval(2*24*60*60)
            default: return Date.now
            }
        case .tomato:
            switch fruitRipeness {
            case .unripe:
                return Date.now.addingTimeInterval(5*24*60*60)
            case .halfRipe:
                return Date.now.addingTimeInterval(2*24*60*60)
            default: return Date.now
            }
        case .none:
            return nil
        }
    }
    
    var daysToRipeLowerLimit: Date? {
        switch fruitName {
        case .avocado:
            switch fruitRipeness {
            case .unripe:
                return Date.now.addingTimeInterval(2*24*60*60)
            case .halfRipe:
                return Date.now.addingTimeInterval(1*24*60*60)
            default: return Date.now
            }
        case .banana:
            switch fruitRipeness {
            case .unripe:
                return Date.now.addingTimeInterval(3*24*60*60)
            case .halfRipe:
                return Date.now.addingTimeInterval(1*24*60*60)
            default: return Date.now
            }
        case .tomato:
            switch fruitRipeness {
            case .unripe:
                return Date.now.addingTimeInterval(3*24*60*60)
            case .halfRipe:
                return Date.now.addingTimeInterval(1*24*60*60)
            default: return Date.now
            }
        case .none:
            return nil
        }
    }
    
    var ripeningTips: [String: String] {
        switch fruitName {
        case .avocado:
            return ["Place avocado in a paper bag": "Ethylene gas causes fruits to ripen. Trapping the ethylene gas produced by the avocado speeds up ripening. More effective if placed with other fruits such as apples and bananas.",
                    "Store avocado in warm area": "A warm area increases rate of chemical reactions within the avocado that causes it to ripen more quickly."]
        case .banana:
            return ["Place banana in a paper bag": "Ethylene gas causes fruits to ripen. Trapping the ethylene gas produced by the avocado speeds up ripening.",
                    "Place bananas together in a bunch": "Ethylene gas produced by bananas causes fruits to ripen. Placing banans together in a bunch results in more ethylene gas that causes each banana to ripen more quickly.",
                    "Microwave your banana": "Poke small holes in the skin of the banana with a fork or knife. Microwave the banana for 30 seconds and then check. Continue microwaving until banana becomes ripe."]
        case .tomato:
            return ["Place tomato in a paper bag": "Ethylene gas causes fruits to ripen. Trapping the ethylene gas produced by the tomato speeds up ripening. More effective if placed with other fruits such as apples and bananas",
                    "Store tomato in warm area": "A warm area increases rate of chemical reactions within the tomato that causes it to ripen more quickly."]
        case .none:
            return [:]
        default: return [:]
        }
    }
    
    var delayRipeningTips: [String: String] {
        switch fruitName {
        case .avocado:
            return ["Keep avocado in refrigerator": "A cool, dark area like a refrigerator slows down the activity of enzymes that ripen the avocado and the production of ethylene gas.",
                    "Keep avocado away from apples and bananas": "Ethylene gas produced by apples and bananas causes fruits to ripen more quickly. Keeping the avocado away from these fruits prolongs the ripening process of the avocado."
            ]
        case .banana:
            return ["Keep banana in refrigerator": "A cool, dark area like a refrigerator slows down the activity of enzymes that ripen the banana and the production of ethylene gas. Place the banana in the freeze to keep it for even longer.",
                    "Wrap stem of banana": "Wrapping the stem of the traps ethylene gas produced from the stem of the banana and slows down the ripening process of the banana.",
                    "Separate bananas from each other": "The stem produces the most ethylene gas. By separating bananas from each other, each banana is exposed to less ethylene gas and ripens more slowly."
            ]
        case .tomato:
            return ["Keep tomato in refrigerator": "A cooler area like a refrigerator reduces the rate of chemical reactions within the tomato that causes it to ripen more quickly.",
                    "Keep tomato away from apples or bananas": "Keeping the tomato away from these fruits prolongs the ripening process of the tomato."
            ]
        case .none:
            return [:]
        default: return [:]
        }
    }
    
    var overripeRecipes: [String?] {
        switch fruitName {
        case .avocado:
            return ["Avocado dressing", "Avocado brownies", "Avocado smoothie", "Chocolate avocado pudding", "Avocado cream sauce"]
        case .banana:
            return ["Banana bread", "Banana smoothie", "Banana pancakes", "Banana coffee cake", "Banana bars", "Chocolate banana crumb cake"]
        case .tomato:
            return ["Tomato ketchup", "Tomato puree", "Pasta sauce", "Tomato soup"]
        default: return [""]
        }
    }
}

struct FruitIdentificationModel {
    
    private(set) var results: String?
    
    mutating func detect(ciImage: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: FruitIdentifier(configuration: MLModelConfiguration()).model)
        else {
            return
        }
        
        let request = VNCoreMLRequest(model: model)
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        try? handler.perform([request])
        guard let results = request.results as? [VNClassificationObservation] else {
            return
        }
        
        if results.first!.confidence >= 0.80 {
            if let firstResult = results.first {
                print(firstResult.identifier)
                print(results.first!.confidence)
                self.results = firstResult.identifier
            }
        }
        else if results.first!.confidence < 0.80 {
            print("Failed in detection")
            print("From FruitIdentificationModel: \(results.first?.identifier) \nConfidence = \(results.first?.confidence)")
        }
    }
}

class DetectionResultProcessor: ObservableObject {
    
    @Published private var model = FruitIdentificationModel()
    
    var newFruitItem: FruitItem?    
    
    func detect(uiImage: UIImage) {
        guard let ciImage = CIImage (image: uiImage) else { return }
        model.detect(ciImage: ciImage)
        print("From detection result processor: \(model.results ?? "")")
        
        newFruitItem = FruitItem(detectionResult: model.results!, image: uiImage)
    }
}
