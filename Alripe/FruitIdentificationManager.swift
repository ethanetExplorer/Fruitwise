//
//  FruitIdentificationManager.swift
//  Alripe
//
//  Created by Ethan Lim on 14/2/24.
//

import Foundation
import CoreML
import Vision
import CoreImage
import UIKit

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
        
        if results.first!.confidence >= 0.90 {
            if let firstResult = results.first {
                print(firstResult.identifier)
                print(results.first!.confidence)
                self.results = firstResult.identifier
            }
        }
        else if results.first!.confidence < 0.90 {
            print("Failed in detection")
            print("\(results.first?.identifier) \nConfidence = \(results.first?.confidence)")
        }
    }
    
}

class DetectionResultProcessor: ObservableObject, Identifiable {
    
    @Published private var model = FruitIdentificationModel()
    
    var firstResult: String? {
        model.results
    }
    
    var separatedFirstResult: [Substring]? {
        firstResult?.split(separator: "-")
    }
    
    func detect(uiImage: UIImage) {
        guard let ciImage = CIImage (image: uiImage) else { return }
        model.detect(ciImage: ciImage)
        print("Detected")
    }
    
    var fruitName: FruitNames {
        switch firstResult {
        case let result where result!.contains("avocado"): return .avocado
        case let result where result!.contains("banana"): return .banana
        case let result where result!.contains("tomato"): return .tomato
        case let result where result! == "not-fruit": return .none
        default: return .none
        }
    }
    
    var fruitRipeness: RipenessStates {
        switch firstResult {
        case let result where result!.contains("unripe"): return .unripe
        case let result where result!.contains("halfripe"): return .halfRipe
        case let result where result!.contains("ripe"): return .ripe
        case let result where result!.contains("overripe"): return .overripe
        case let result where result! == "not-fruit": return .none
        default: return .none
        }
    }
    
    var ripeningTip: [String?] {
        switch fruitName {
        case .avocado: return ["Place avocados in a paper bag with a ripe banana or apple to speed up the process.",
                               "Store avocados in a warm area, such as on top of the refrigerator or near a sunny window.",
                               "Check avocados daily for ripeness and use them as soon as they are ready."]
        case .banana: return ["Place bananas in a paper bag with an apple or avocado to accelerate ripening.",
                              "Expose bananas to ethylene-producing fruits like apples or tomatoes to speed up the process.",
                              "Wrap the stems of bananas with plastic wrap to trap ethylene gas and ripen them faster."]
        case .tomato: return ["Store tomatoes in the refrigerator to slow down the ripening process.",
                              "Keep tomatoes away from ethylene-producing fruits like apples or bananas.",
                              "Store tomatoes in a cool, dark place with good air circulation to extend their shelf life."]
        default: return [""]
        }
    }
    var delayRipeningTip: [String?] {
        switch fruitName {
        case .avocado: return ["Store unripe avocados in the refrigerator to slow down the ripening process.",
                               "Wrap unripe avocados individually in paper towels to prevent them from ripening too quickly.",
                               "Avoid placing avocados near ethylene-producing fruits like bananas or apples."]
        case .banana: return ["Store bananas in a cool area away from direct sunlight to slow down ripening.",
                              "Wrap the stems of bananas with aluminum foil to reduce exposure to ethylene gas.",
                              "Separate ripe bananas from unripe ones to prevent them from ripening too quickly."]
        case .tomato: return ["Store tomatoes in a paper bag with a ripe apple or banana to slow down ripening.",
                              "Keep tomatoes in a cool, dry place away from heat sources to extend their shelf life.",
                              "Avoid storing tomatoes near ethylene-producing fruits like bananas or apples."]
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
