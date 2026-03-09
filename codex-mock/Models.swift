import Foundation
import SwiftUI

enum CodexCanvas: Equatable {
    case emptyHome
    case conversation
}

enum CodexTextSegment: Equatable {
    case text(String)
    case code(String)
}

struct CodexRichText: Identifiable, Equatable {
    let id = UUID()
    let segments: [CodexTextSegment]
}

enum CodexConversationRowKind: Equatable {
    case assistant
    case assistantStatus
    case userBubble
    case divider
}

struct CodexConversationRow: Identifiable, Equatable {
    let id = UUID()
    let kind: CodexConversationRowKind
    let paragraphs: [CodexRichText]
    var trailingLabel: String? = nil
}

struct CodexThread: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let relativeTime: String
    var subtitle: String? = nil
    var badge: String? = nil
    var conversationRows: [CodexConversationRow]
}

struct CodexProject: Identifiable, Equatable {
    let id = UUID()
    let title: String
    var workspace: String? = nil
    let threads: [CodexThread]
}

struct CodexSuggestionCard: Identifiable, Equatable {
    let id = UUID()
    let symbolName: String
    let accentHex: String
    let title: String
}

struct CodexToolbarAction: Identifiable, Equatable {
    let id = UUID()
    let symbolName: String
}

struct CodexAppData: Equatable {
    let projects: [CodexProject]
    let suggestions: [CodexSuggestionCard]
    let toolbarActions: [CodexToolbarAction]
}

enum SidebarThreadListRowKind: Equatable {
    case project(CodexProject)
    case thread(project: CodexProject, thread: CodexThread)
    case empty(CodexProject)
}

struct SidebarThreadListRow: Identifiable, Equatable {
    let id: String
    let kind: SidebarThreadListRowKind

    static func makeRows(
        from projects: [CodexProject],
        collapsedProjectIDs: Set<CodexProject.ID> = []
    ) -> [SidebarThreadListRow] {
        var rows: [SidebarThreadListRow] = []

        for project in projects {
            rows.append(
                SidebarThreadListRow(
                    id: "project-\(project.id.uuidString)",
                    kind: .project(project)
                )
            )

            guard !collapsedProjectIDs.contains(project.id) else {
                continue
            }

            if project.threads.isEmpty {
                rows.append(
                    SidebarThreadListRow(
                        id: "empty-\(project.id.uuidString)",
                        kind: .empty(project)
                    )
                )
            } else {
                for thread in project.threads {
                    rows.append(
                        SidebarThreadListRow(
                            id: "thread-\(project.id.uuidString)-\(thread.id.uuidString)",
                            kind: .thread(project: project, thread: thread)
                        )
                    )
                }
            }
        }

        return rows
    }
}

enum SidebarThreadListLayout {
    static func availableHeight(
        sidebarHeight: CGFloat,
        topBlockHeight: CGFloat,
        footerBlockHeight: CGFloat,
        sectionTopPadding: CGFloat,
        footerSpacing: CGFloat,
        bottomPadding: CGFloat
    ) -> CGFloat {
        max(
            0,
            sidebarHeight
                - topBlockHeight
                - footerBlockHeight
                - sectionTopPadding
                - footerSpacing
                - bottomPadding
        )
    }

    static func resolvedHeight(contentHeight: CGFloat, availableHeight: CGFloat) -> CGFloat {
        guard contentHeight > 0 else {
            return max(0, availableHeight)
        }

        return max(0, min(contentHeight, availableHeight))
    }

    static func shouldScroll(contentHeight: CGFloat, availableHeight: CGFloat) -> Bool {
        contentHeight > availableHeight
    }
}

enum CodexWindowChromeButtonKind: Equatable {
    case close
    case minimize
    case zoom
}

struct CodexWindowChromeButton: Identifiable, Equatable {
    let id = UUID()
    let kind: CodexWindowChromeButtonKind
    let hexColor: String
}

struct CodexWindowChrome: Equatable {
    let height: CGFloat
    let buttonDiameter: CGFloat
    let buttonSpacing: CGFloat
    let leadingInset: CGFloat
    let dividerOpacity: Double
    let usesWindowActions: Bool
    let usesNativeTrafficLights: Bool
    let embedsTrafficLightsInSidebar: Bool
    let buttons: [CodexWindowChromeButton]

    static let `default` = CodexWindowChrome(
        height: 58,
        buttonDiameter: 14,
        buttonSpacing: 10,
        leadingInset: 18,
        dividerOpacity: 0.05,
        usesWindowActions: true,
        usesNativeTrafficLights: false,
        embedsTrafficLightsInSidebar: false,
        buttons: [
            CodexWindowChromeButton(kind: .close, hexColor: "#FF5F57"),
            CodexWindowChromeButton(kind: .minimize, hexColor: "#FEBC2E"),
            CodexWindowChromeButton(kind: .zoom, hexColor: "#28C840")
        ]
    )
}

struct CodexShellAppearance: Equatable {
    let contentScale: CGFloat
    let sidebarMaterialOpacity: Double
    let sidebarGradientTopOpacity: Double
    let sidebarGradientBottomOpacity: Double
    let sidebarWidth: CGFloat
    let sidebarHorizontalPadding: CGFloat
    let sidebarTopInset: CGFloat
    let sidebarActionSpacing: CGFloat
    let sidebarActionVerticalPadding: CGFloat
    let sidebarLeadingIconWidth: CGFloat
    let sidebarSectionLabelLeadingInset: CGFloat
    let sidebarTextWeight: Font.Weight
    let sidebarHoverFillOpacity: Double
    let sidebarHoverStrokeOpacity: Double
    let sidebarThreadSectionTopPadding: CGFloat
    let sidebarListBottomPadding: CGFloat
    let sidebarFooterVerticalPadding: CGFloat
    let canvasTopPadding: CGFloat
    let composerEditorHeight: CGFloat
    let composerMaxWidth: CGFloat
    let bodyTextSize: CGFloat
    let bodyLineSpacing: CGFloat

    static let `default` = CodexShellAppearance(
        contentScale: 1,
        sidebarMaterialOpacity: 0.52,
        sidebarGradientTopOpacity: 0.62,
        sidebarGradientBottomOpacity: 0.52,
        sidebarWidth: 304,
        sidebarHorizontalPadding: 12,
        sidebarTopInset: 28,
        sidebarActionSpacing: 6,
        sidebarActionVerticalPadding: 8,
        sidebarLeadingIconWidth: 22,
        sidebarSectionLabelLeadingInset: 44,
        sidebarTextWeight: .regular,
        sidebarHoverFillOpacity: 0.14,
        sidebarHoverStrokeOpacity: 0.06,
        sidebarThreadSectionTopPadding: 10,
        sidebarListBottomPadding: 8,
        sidebarFooterVerticalPadding: 20,
        canvasTopPadding: 12,
        composerEditorHeight: 74,
        composerMaxWidth: 1040,
        bodyTextSize: 16,
        bodyLineSpacing: 7
    )
}

struct CodexWindowBehavior: Equatable {
    let usesHiddenTitleBarStyle: Bool
    let usesTransparentTitleBar: Bool
    let usesFullSizeContentView: Bool
    let hidesWindowTitle: Bool
    let isMovableByBackground: Bool

    static let `default` = CodexWindowBehavior(
        usesHiddenTitleBarStyle: true,
        usesTransparentTitleBar: true,
        usesFullSizeContentView: true,
        hidesWindowTitle: true,
        isMovableByBackground: true
    )
}

struct CodexShellState: Equatable {
    let selectedProject: CodexProject
    let selectedThread: CodexThread?
    let canvas: CodexCanvas
    let collapsedProjectIDs: Set<CodexProject.ID>

    init(
        selectedProject: CodexProject,
        selectedThread: CodexThread?,
        canvas: CodexCanvas,
        collapsedProjectIDs: Set<CodexProject.ID> = []
    ) {
        self.selectedProject = selectedProject
        self.selectedThread = selectedThread
        self.canvas = canvas
        self.collapsedProjectIDs = collapsedProjectIDs
    }

    static func initialState(from data: CodexAppData) -> CodexShellState {
        if let conversationProject = data.projects.first(where: { !$0.threads.isEmpty }),
           let firstThread = conversationProject.threads.first {
            return CodexShellState(
                selectedProject: conversationProject,
                selectedThread: firstThread,
                canvas: .conversation
            )
        }

        let fallbackProject = data.projects.first ?? CodexProject(title: "CodexMock", threads: [])
        return CodexShellState(
            selectedProject: fallbackProject,
            selectedThread: nil,
            canvas: .emptyHome
        )
    }

    func selectingProject(_ project: CodexProject) -> CodexShellState {
        guard let firstThread = project.threads.first else {
            return CodexShellState(
                selectedProject: project,
                selectedThread: nil,
                canvas: .emptyHome,
                collapsedProjectIDs: collapsedProjectIDs
            )
        }

        return CodexShellState(
            selectedProject: project,
            selectedThread: firstThread,
            canvas: .conversation,
            collapsedProjectIDs: collapsedProjectIDs
        )
    }

    func selectingThread(_ thread: CodexThread) -> CodexShellState {
        CodexShellState(
            selectedProject: selectedProject,
            selectedThread: thread,
            canvas: .conversation,
            collapsedProjectIDs: collapsedProjectIDs
        )
    }

    func presentingHome() -> CodexShellState {
        CodexShellState(
            selectedProject: selectedProject,
            selectedThread: nil,
            canvas: .emptyHome,
            collapsedProjectIDs: collapsedProjectIDs
        )
    }

    func isProjectCollapsed(_ project: CodexProject) -> Bool {
        collapsedProjectIDs.contains(project.id)
    }

    func toggleProjectCollapse(_ project: CodexProject) -> CodexShellState {
        var collapsedProjectIDs = collapsedProjectIDs
        if collapsedProjectIDs.contains(project.id) {
            collapsedProjectIDs.remove(project.id)
        } else {
            collapsedProjectIDs.insert(project.id)
        }

        return CodexShellState(
            selectedProject: selectedProject,
            selectedThread: selectedThread,
            canvas: canvas,
            collapsedProjectIDs: collapsedProjectIDs
        )
    }
}
