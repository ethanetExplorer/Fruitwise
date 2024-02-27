//
//  FruitDetailView.swift
//  Fruitwise
//
//  Created by Ethan Lim on 25/2/24.
//

import SwiftUI

struct FruitDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var investigatableFruitItem: FruitItem
    @Binding var fruitsArray: [FruitItem]
    
    var fruitItemExisting: Bool {
        if fruitsArray.contains(where: { $0 == investigatableFruitItem }) {
            return true
        } else {
            return false
        }
    }
    
    var daysToRipenessLowerLimit: Int? {
        if let lowerLimitDate = investigatableFruitItem.daysToRipeLowerLimit {
            let timeInterval: Double = lowerLimitDate.timeIntervalSince(Date())
            return Int(timeInterval / 86400)
        }
        return nil
    }
    
    var daysToRipenessUpperLimit: Int? {
        if let upperLimitDate = investigatableFruitItem.daysToRipeUpperLimit {
            let timeInterval: Double = upperLimitDate.timeIntervalSince(Date())
            return Int(timeInterval / 86400)
        }
        return nil
    }

    
    //Fruit text generator
    var fruitNameText: String {
        switch investigatableFruitItem.fruitName {
        case .avocado:
            return "avocado"
        case .banana:
            return "banana"
        case .tomato:
            return "tomato"
        default:
            return ""
        }
    }
    
    var ripenessText: String {
        switch investigatableFruitItem.fruitRipeness {
        case .halfRipe:
            return "half-ripe"
        case .overripe:
            return "overripe"
        case .ripe:
            return "ripe"
        case .unripe:
            return "unripe"
        default:
            return ""
        }
    }
    
    var titleText: String {
        if fruitNameText != "" && ripenessText != "" {
            return "Your \(fruitNameText) is \(ripenessText)"
        } else { return "This is not a fruit" }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if let image = investigatableFruitItem.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 24)
                }
                Text(titleText)
                    .font(.title)
                    .bold()
                    .padding(.horizontal, 24)
                if investigatableFruitItem.fruitRipeness == .none {
                    Button {
                        dismiss()
                    } label: {
                        Text("Dismiss")
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                } else if investigatableFruitItem.fruitRipeness == .ripe {
                    List {
                        Section(header: Text("Prolong fruit ripeness")) {
                            ForEach(Array(investigatableFruitItem.delayRipeningTips.keys), id: \.self) { key in    
                                if let value = investigatableFruitItem.delayRipeningTips[key] {
                                    VStack (alignment: .leading) {
                                        Text(key)
                                            .fontWeight(.medium)
                                        Text(value)
                                            .font(.caption)
                                    }
                                }
                            }
                        }
                    }
                    Button {
                        dismiss()
                    } label: {
                        Text("Dismiss")
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                } else if investigatableFruitItem.fruitRipeness == .overripe {
                    List {
                        Section(header: Text("Recipes with overripe fruits"), footer: Text("Don't throw your overripe fruit away, put it to good use with these recipes instead.")) {
                            ForEach(investigatableFruitItem.overripeRecipes, id: \.self) { recipe in
                                Text(recipe!)    
                            }
                        }
                    }
                    Button {
                        dismiss()
                    } label: {
                        Text("Dismiss")
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                } else {
                    Text("Your fruit will ripen in \(daysToRipenessLowerLimit ?? 0) to \(daysToRipenessUpperLimit ?? 0) days.")
                    List {
                        Section(header: Text("Quicken ripening")) {
                            ForEach(Array(investigatableFruitItem.ripeningTips.keys), id: \.self) { key in    
                                if let value = investigatableFruitItem.ripeningTips[key] {
                                    VStack (alignment: .leading) {
                                        Text(key)
                                            .fontWeight(.medium)
                                        Text(value)
                                            .font(.caption)
                                    }
                                }
                            }
                        }
                        Section(header: Text("Slow down ripening")) {
                            ForEach(Array(investigatableFruitItem.delayRipeningTips.keys), id: \.self) { key in    
                                if let value = investigatableFruitItem.delayRipeningTips[key] {
                                    VStack (alignment: .leading) {
                                        Text(key)
                                            .fontWeight(.medium)
                                        Text(value)
                                            .font(.caption)
                                    }
                                }
                            }
                        }
                    }
                    if !fruitsArray.contains(investigatableFruitItem) {
                        Button {
                            fruitsArray.append(investigatableFruitItem)
                            dismiss()
                        } label: {
                            Text("Save fruit")
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                    } else {
                        Button {
                            dismiss()
                        } label: {
                            Text("Dismiss")
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                    }
                }
                
            }
        }
    }
}
//#Preview {
//    FruitDetailView(investigatableFruitItem: .constant(FruitItem(detectionResult: "", image: nil)), fruitsArray: .constant([]), tips: .constant(FruitTips))
//}
