//
//  FruitIdentificationManager.swift
//  Alripe
//
//  Created by Ethan Lim on 14/2/24.
//

import Foundation
import CoreML
import Vision

@Observable
class FruitDetectionManager {
    guard let model = try? VNCoreMLModel(for: Fruit().model) else {
        fatalError("Failed to load Core ML model")
    }
}
