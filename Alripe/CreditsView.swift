import SwiftUI

struct CreditsView: View { 
    
    @Binding var showCreditsView: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Demonstrational images")) {
                    Link("Unripe banana", destination: URL(string: "https://elements.envato.com/overripe-yellow-banana-isolated-on-white-backgroun-K84HKNM")!)
                    Link("Overripe banana image", destination: URL(string: "https://www.flickr.com/photos/30478819@N08/50361658836")!)
                    Link("Unripe avocado", destination: URL(string: "http://elements.envato.com/green-fresh-avocado-in-male-hand-over-black-backgr-qtjzfnk")!)
                    Link("Unripe tomato", destination: URL(string: "https://elements.envato.com/green-tomato-with-rope-on-marble-background-YX4BYBM")!)
                    Link("Half-ripe tomato \nPhoto by Quaritsch Photography on Unsplash", destination: URL(string: "https://unsplash.com/photos/gold-onion-bulb-cs35NMiGjRE")!)
                }
                Section(header: Text("Tips for ripening fruits faster")) {
                    Link("Avocado", destination: URL(string: "https://www.healthline.com/nutrition/how-to-ripen-avocados")!)
                    Link("Banana", destination: URL(string: "https://www.masterclass.com/articles/how-to-quickly-ripen-bananas")!)
                    Link("Tomato", destination: URL(string: "https://onbackyard.com/ripening-tomatoes-off-the-vine/")!)
                }
                Section(header: Text("Tips for slowing down fruit ripening")) {
                    Link("Avocado", destination: URL(string: "https://www.foodrepublic.com/1459022/how-to-slow-down-avocado-ripening/")!)
                    Link("Banana", destination: URL(string: "https://www.today.com/food/best-tips-keep-bananas-turning-brown-ripening-t150266")!)
                    Link("Tomato", destination: URL(string: "https://www.ehow.com/how_8623441_slow-down-ripening-tomatoes.html")!)
                }
                Section(header: Text("Recipes using overripe fruits")) {
                    Link("Overripe avocados", destination: URL(string: "https://www.allrecipes.com/gallery/ways-to-use-overripe-avocado/")!)
                    Link("Overripe bananas", destination:URL(string: "https://www.thekitchn.com/best-recipes-using-overrripe-bananas-223860")!)
                    Link("Overripe tomatoes", destination:URL(string: "https://happymuncher.com/what-to-do-with-overripe-tomatoes/")!)
                }
                Section(header: Text("Others")) {
                    Link("Food waste statistics", destination: URL(string: "https://www.statista.com/chart/24350/total-annual-household-waste-produced-in-selected-countries/")!)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Dismiss") {
                        showCreditsView = false
                        dismiss()
                    }
                    .padding()
                }
            }
        }
    }
}
