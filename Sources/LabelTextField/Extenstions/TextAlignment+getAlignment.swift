//
//  TextAlignment+getAlignment.swift
//
//
//  Created by Josh McBroom on 1/16/24.
//

import SwiftUI

@available(iOS 13.0, *)
extension TextAlignment {
    func getAlignment() -> Alignment {
        self == .leading ? Alignment.leading : self == .trailing ? Alignment.trailing : Alignment.center
    }
}
