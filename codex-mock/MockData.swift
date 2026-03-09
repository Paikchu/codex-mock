import Foundation

enum CodexMockData {
    static func makeAppData() -> CodexAppData {
        CodexAppData(
            projects: [
                CodexProject(title: "CodexMock", threads: []),
                CodexProject(title: "Sparking", threads: []),
                CodexProject(
                    title: "Vela",
                    threads: [
                        CodexThread(
                            title: "Recreate a Codex-style macOS chat app",
                            relativeTime: "3m",
                            conversationRows: [
                                CodexConversationRow(
                                    kind: .assistant,
                                    paragraphs: [
                                        CodexRichText(segments: [.text("Skills used: "), .code("using-superpowers"), .text(", "), .code("brainstorming"), .text(", "), .code("frontend-design"), .text(", "), .code("test-driven-development"), .text(".")]),
                                        CodexRichText(segments: [.text("I will first read the new project's structure and entry files, confirm the initialized "), .code("macOS"), .text(" stack, and then implement a high-fidelity recreation directly in the existing project.")])
                                    ]
                                ),
                                CodexConversationRow(
                                    kind: .assistantStatus,
                                    paragraphs: [CodexRichText(segments: [.text("Viewed 4 files, 1 list")])]
                                ),
                                CodexConversationRow(
                                    kind: .assistant,
                                    paragraphs: [
                                        CodexRichText(segments: [.text("I have confirmed this is a "), .code("SwiftUI"), .text(" macOS project, which is a good fit for a native recreation. I will read the entry point and current views first, then ask one scope question to avoid drifting from the intended direction.")])
                                    ]
                                ),
                                CodexConversationRow(
                                    kind: .assistantStatus,
                                    paragraphs: [CodexRichText(segments: [.text("Viewed 2 files")])]
                                ),
                                CodexConversationRow(
                                    kind: .assistant,
                                    paragraphs: [
                                        CodexRichText(segments: [.text("Terminal command completed: "), .code("git -C /Users/max/Developer/CodexMock/codex-mock status --short --branch")])
                                    ]
                                ),
                                CodexConversationRow(
                                    kind: .divider,
                                    paragraphs: [],
                                    trailingLabel: "Processed 31s"
                                ),
                                CodexConversationRow(
                                    kind: .assistant,
                                    paragraphs: [
                                        CodexRichText(segments: [.text("I will recreate this directly in the "), .code("SwiftUI"), .text(" macOS project and implement the empty-state home screen from the screenshot with high fidelity.")]),
                                        CodexRichText(segments: [.text("One scope question first: do you want only the \"new thread empty-state home\" from the screenshot, or should I also implement the \"chat screen after entering a conversation\"?")])
                                    ]
                                ),
                                CodexConversationRow(
                                    kind: .userBubble,
                                    paragraphs: [
                                        CodexRichText(segments: [.text("Also build the post-entry conversation UI. The conversation view should match the screenshot I just shared.")])
                                    ]
                                )
                            ]
                        ),
                        CodexThread(title: "Plan the Figma chat UI and module flow integration", relativeTime: "1d", subtitle: "+40 -15", badge: "1d", conversationRows: []),
                        CodexThread(title: "Add streaming output to the backend task pipeline} Actually must e...", relativeTime: "1d", conversationRows: []),
                        CodexThread(title: "Define the implementation plan for fundamental analysis} Wait must be 18...", relativeTime: "1d", conversationRows: []),
                        CodexThread(title: "I already added TAVILY_API_KEY in the project, ...", relativeTime: "3d", conversationRows: []),
                        CodexThread(title: "Please help me generate an OpenAPI spec for the interface docs, ...", relativeTime: "3d", conversationRows: []),
                        CodexThread(title: "Help me revise the wrappers under tools; the AI interface currently...", relativeTime: "3d", conversationRows: []),
                        CodexThread(title: "Create a new branch based on PRD, architecture, ...", relativeTime: "4d", conversationRows: []),
                        CodexThread(title: "https://chatgpt.com/share/69a84c37-699c...", relativeTime: "4d", conversationRows: [])
                    ]
                ),
                CodexProject(title: "valuecell", threads: []),
                CodexProject(title: "Vela IOS", workspace: "Vela", threads: [])
            ],
            suggestions: [
                CodexSuggestionCard(symbolName: "gamecontroller.fill", accentHex: "#BDB4FF", title: "Build a classic Snake game in this repo."),
                CodexSuggestionCard(symbolName: "doc.fill", accentHex: "#FF9588", title: "Create a one-page $pdf that summarizes this app."),
                CodexSuggestionCard(symbolName: "pencil.and.scribble", accentHex: "#FFC65C", title: "Create a plan to...")
            ],
            toolbarActions: []
        )
    }
}
