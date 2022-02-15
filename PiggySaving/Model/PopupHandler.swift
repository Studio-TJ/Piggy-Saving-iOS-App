//
//  PopupHandler.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 15/02/2022.
//

import SwiftUI

class PopupHandler: ObservableObject {
    @Published var view: AnyView = AnyView(EmptyView())
    @Published var popuped: Bool = false
}
