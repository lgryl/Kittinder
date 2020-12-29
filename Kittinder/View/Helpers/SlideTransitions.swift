// Created 20/12/2020

import SwiftUI

extension AnyTransition {
    static var slideTrailingBottom: AnyTransition {
        AnyTransition.asymmetric(insertion: .identity,
                                 removal: AnyTransition.move(edge: .trailing).combined(with: AnyTransition.move(edge: .bottom)))
    }

    static var slideLeadingBottom: AnyTransition {
        AnyTransition.asymmetric(insertion: .identity,
                                 removal: AnyTransition.move(edge: .leading).combined(with: AnyTransition.move(edge: .bottom)))
    }
}
