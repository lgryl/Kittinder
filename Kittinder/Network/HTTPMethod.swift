// Created 29/12/2020

import Foundation

enum HTTPMethod {
    case get
    case post

    func toString() -> String {
        String(describing: self).uppercased()
    }
}
