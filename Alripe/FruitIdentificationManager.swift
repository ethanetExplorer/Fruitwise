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
        
        if results.first!.confidence >= 0.97 {
            if let firstResult = results.first {
                print(firstResult.identifier)
                print(results.first!.confidence)
                self.results = firstResult.identifier
            }
        }
        else if results.first!.confidence < 0.97 {
            print("Failed in detection")
            print("\(results.first?.identifier) \nConfidence = \(results.first?.confidence)")
        }
    }
    
}

class DetectionResultProcessor: ObservableObject {
    
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
        default: return .none
        }
    }
    
    var fruitRipeness: RipenessStates {
        switch firstResult {
        case let result where result!.contains("unripe"): return .unripe
        case let result where result!.contains("halfripe"): return .halfRipe
        case let result where result!.contains("ripe"): return .ripe
        case let result where result!.contains("overripe"): return .overripe
        default: return .none
        }
    }
    
    var ripeningTip: [String?] {
        switch fruitName {
        case .avocado: return ["Place your avocado in a paper bag with an apple or a banana.", "Keep your avocado in a warm environment.", "Keep your avocado in an enclosed space such as a cupboard.", "Store your fruit with other ripe avocados."]
        case .banana: return ["Place your banana in a paper bag.", "Keep your banana in a warm environment.", "Make sure your bananas are near each other by keeping them in a bunch."]
        case .tomato: return ["Place your tomato in a paper bag with an apple or a banana.", "Keep your tomato in a warm environment", " "]
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
