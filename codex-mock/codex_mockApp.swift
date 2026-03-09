//
//  codex_mockApp.swift
//  codex-mock
//
//  Created by max on 2026/3/8.
//

import SwiftUI

@main
struct codex_mockApp: App {
    private let windowBehavior = CodexWindowBehavior.default

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .defaultSize(width: 1512, height: 982)
        .windowResizability(.contentMinSize)
        .windowStyle(.hiddenTitleBar)
    }
}
