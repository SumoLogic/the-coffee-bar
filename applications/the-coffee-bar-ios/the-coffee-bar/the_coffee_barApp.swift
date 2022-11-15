import SwiftUI
import SumoLogicRum

@main
struct the_coffee_barApp: App {
    init() {
        SumoLogicRum.initialize(
            collectionSourceUrl: "%IOS_APP_COLLECTION_SOURCE_URL%",
            applicationName: "%IOS_APP_APPLICATION_NAME%"
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(OrderState())
        }
    }
}
