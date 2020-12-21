// Created 21/12/2020

import UIKit

class ViewModel: ObservableObject {
    @Published var images = ["a94", "ad9"].compactMap{ UIImage(named: $0) }
}
