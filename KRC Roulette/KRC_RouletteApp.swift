import Firebase
import SwiftUI
import FirebaseAuth

@main
struct KRC_RouletteApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var isLoggedIn = false

    var body: some Scene {
        WindowGroup {
            Group {
                if isLoggedIn {
                    ContentView()
                } else {
                    ContentView()
                }
            }
            .preferredColorScheme(.dark)
            .onAppear {
                checkIfUserIsLoggedIn()
            }
        }
    }

    func checkIfUserIsLoggedIn() {
        if let user = Auth.auth().currentUser {
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
    }
}
