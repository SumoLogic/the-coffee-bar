import SwiftUI

@main
struct the_coffee_barApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(OrderState())
        }
    }
}
