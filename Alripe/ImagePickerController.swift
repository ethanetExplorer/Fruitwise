//
//  ImagePickerController.swift
//  Alripe
//
//  Created by Ethan Lim on 5/2/24.
//

import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    @Binding var isPresenting: Bool
    @Binding var sourceType: UIImagePickerController.SourceType
    @Binding var isFinished: Bool
    
    @State private var fruitDetector = DetectionResultProcessor()
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
    
    typealias UIViewControllerType = UIImagePickerController
        
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        let parent: ImagePicker
                
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            parent.selectedImage = info[.originalImage] as? UIImage
            parent.isPresenting = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresenting = false
        }
        
        init(_ imagePicker: ImagePicker) {
            self.parent = imagePicker
        }
    }
}
