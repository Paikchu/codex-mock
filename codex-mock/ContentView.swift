//
//  ContentView.swift
//  codex-mock
//
//  Created by max on 2026/3/8.
//

import SwiftUI

struct ContentView: View {
    private let data: CodexAppData
    private let appearance = CodexShellAppearance.default
    private let windowBehavior = CodexWindowBehavior.default

    @State private var shellState: CodexShellState
    @State private var composerText: String

    init(data: CodexAppData = CodexMockData.makeAppData()) {
        self.data = data
        let initialState = CodexShellState.initialState(from: data)
        _shellState = State(initialValue: initialState)
        _composerText = State(initialValue: "Request follow-up changes")
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            CodexShellBackground()

            HStack(spacing: 0) {
                CodexSidebar(
                    data: data,
                    appearance: appearance,
                    shellState: shellState,
                    onNewThread: showEmptyHome,
                    onSelectProject: selectProject(_:),
                    onSelectThread: selectThread(project:thread:),
                    onToggleProjectCollapse: toggleProjectCollapse(_:)
                )

                Group {
                    switch shellState.canvas {
                    case .emptyHome:
                        EmptyHomeView(
                            data: data,
                            shellState: shellState,
                            composerText: $composerText,
                            onSelectSuggestion: { composerText = $0.title }
                        )

                    case .conversation:
                        ConversationView(
                            data: data,
                            shellState: shellState,
                            composerText: $composerText
                        )
                    }
                }
            }
            .scaleEffect(appearance.contentScale, anchor: .topLeading)
        }
        .ignoresSafeArea(.container, edges: .top)
        .background(WindowConfigurator(behavior: windowBehavior))
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    private func showEmptyHome() {
        if let emptyProject = data.projects.first(where: { $0.title == "CodexMock" }) {
            withAnimation(.easeOut(duration: 0.18)) {
                shellState = shellState.selectingProject(emptyProject)
                composerText = ""
            }
        }
    }

    private func selectProject(_ project: CodexProject) {
        withAnimation(.easeOut(duration: 0.18)) {
            shellState = shellState.selectingProject(project)
            composerText = project.threads.isEmpty ? "" : "Request follow-up changes"
        }
    }

    private func selectThread(project: CodexProject, thread: CodexThread) {
        withAnimation(.easeOut(duration: 0.18)) {
            shellState = shellState.selectingProject(project).selectingThread(thread)
            composerText = "Request follow-up changes"
        }
    }

    private func toggleProjectCollapse(_ project: CodexProject) {
        withAnimation(.easeOut(duration: 0.18)) {
            shellState = shellState.toggleProjectCollapse(project)
        }
    }
}

#Preview {
    ContentView()
        .frame(width: 1512, height: 982)
}
