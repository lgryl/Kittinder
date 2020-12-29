// Created 20/12/2020

import SwiftUI

@main
struct KittinderApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: ViewModel())
        }
    }
}
