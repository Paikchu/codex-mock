import Foundation

@main
struct ShellStateTests {
    static func main() {
        let data = CodexMockData.makeAppData()
        let initialState = CodexShellState.initialState(from: data)

        precondition(
            initialState.selectedProject.title == "Vela",
            "Initial state should select the first project with threads."
        )
        precondition(
            initialState.selectedThread?.title == "Recreate a Codex-style macOS chat app",
            "Initial state should select the first available thread in the active project."
        )
        precondition(
            initialState.canvas == .conversation,
            "Initial state should show the conversation canvas when a thread exists."
        )
        precondition(
            data.toolbarActions.isEmpty,
            "Top toolbar actions should be removed from the mock shell."
        )

        let emptyProject = data.projects.first { $0.title == "CodexMock" }!
        let emptyState = initialState.selectingProject(emptyProject)

        precondition(
            emptyState.selectedProject.title == "CodexMock",
            "Selecting a different project should update the selected project."
        )
        precondition(
            emptyState.selectedThread == nil,
            "Selecting a project without threads should clear the active thread."
        )
        precondition(
            emptyState.canvas == .emptyHome,
            "Selecting a project without threads should show the empty home canvas."
        )

        let threadedProject = data.projects.first { $0.title == "Vela" }!
        precondition(
            !initialState.isProjectCollapsed(threadedProject),
            "Projects should default to expanded so child threads stay visible."
        )

        let collapsedState = initialState.toggleProjectCollapse(threadedProject)
        precondition(
            collapsedState.isProjectCollapsed(threadedProject),
            "Toggling a project once should mark it as collapsed."
        )
        precondition(
            collapsedState.selectedProject == initialState.selectedProject,
            "Collapsing a project should not change the currently selected project."
        )
        precondition(
            collapsedState.selectedThread == initialState.selectedThread,
            "Collapsing a project should not clear the current thread selection."
        )

        let reopenedState = collapsedState.toggleProjectCollapse(threadedProject)
        precondition(
            !reopenedState.isProjectCollapsed(threadedProject),
            "Toggling a collapsed project again should expand it."
        )

        let otherProject = data.projects.first { $0.title == "CodexMock" }!
        let mixedCollapseState = collapsedState.toggleProjectCollapse(otherProject)
        precondition(
            mixedCollapseState.isProjectCollapsed(threadedProject),
            "Collapsing a second project should preserve the first project's collapsed state."
        )
        precondition(
            mixedCollapseState.isProjectCollapsed(otherProject),
            "Each project should track collapse state independently."
        )

        let chrome = CodexWindowChrome.default
        precondition(
            chrome.height == 58,
            "Window chrome height should match the desktop mock header."
        )
        precondition(
            chrome.buttonDiameter == 14,
            "Window chrome buttons should keep the macOS traffic light diameter."
        )
        precondition(
            chrome.leadingInset == 18,
            "Window chrome buttons should align with the left inset from the screenshot."
        )
        precondition(
            chrome.buttons.map(\.kind) == [.close, .minimize, .zoom],
            "Window chrome should expose the standard macOS traffic light order."
        )
        precondition(
            chrome.usesWindowActions,
            "Window chrome buttons should dispatch native window actions."
        )
        precondition(
            !chrome.usesNativeTrafficLights,
            "Pure SwiftUI mode should not manage native traffic lights inside the view hierarchy."
        )
        precondition(
            !chrome.embedsTrafficLightsInSidebar,
            "System window controls should stay in the default macOS title bar."
        )

        let appearance = CodexShellAppearance.default
        precondition(
            appearance.contentScale == 1,
            "Shell should fill the window bounds without leaving an outer black border."
        )
        precondition(
            appearance.sidebarMaterialOpacity == 0.64,
            "Sidebar should read more opaque so the navigation feels denser."
        )
        precondition(
            appearance.sidebarGradientTopOpacity == 0.72,
            "Sidebar top gradient should feel more solid while keeping the tint."
        )
        precondition(
            appearance.sidebarGradientBottomOpacity == 0.62,
            "Sidebar bottom gradient should also gain opacity while staying softer than the top."
        )
        precondition(
            appearance.sidebarWidth == 304,
            "Sidebar should use the narrower width from the Codex reference."
        )
        precondition(
            appearance.sidebarHorizontalPadding == 12,
            "Sidebar content should sit closer to the edges for a denser, more modern layout."
        )
        precondition(
            appearance.sidebarTopInset == 40,
            "Sidebar should leave more breathing room above the New thread button."
        )
        precondition(
            appearance.sidebarActionSpacing == 6,
            "Sidebar actions should use tighter spacing between the top entries."
        )
        precondition(
            appearance.sidebarActionVerticalPadding == 8,
            "Sidebar action buttons should compress their vertical padding."
        )
        precondition(
            appearance.sidebarTextWeight == .regular,
            "Sidebar text should use regular weight throughout the left rail."
        )
        precondition(
            appearance.sidebarLeadingIconWidth == 22,
            "Sidebar icons should reserve a fixed width so labels align vertically."
        )
        precondition(
            appearance.sidebarSectionLabelLeadingInset == 44,
            "Threads label should align with button text, not with the left icon edge."
        )
        precondition(
            appearance.sidebarHoverFillOpacity == 0.14,
            "Sidebar hover state should brighten toward a gray-white fill."
        )
        precondition(
            appearance.sidebarHoverStrokeOpacity == 0.06,
            "Sidebar hover state should add a soft light edge."
        )
        precondition(
            appearance.sidebarThreadSectionTopPadding == 10,
            "Threads header should keep a compact but visible gap below the action buttons."
        )
        precondition(
            appearance.sidebarListBottomPadding == 8,
            "Thread list should reserve a small bottom inset before the footer spacer."
        )
        precondition(
            appearance.sidebarFooterVerticalPadding == 20,
            "Sidebar footer should preserve its breathing room while staying docked to the bottom."
        )
        precondition(
            appearance.canvasTopPadding == 12,
            "Canvas content should start closer to the title bar."
        )
        precondition(
            appearance.composerEditorHeight == 74,
            "Composer should use the tighter input height."
        )
        precondition(
            appearance.composerMaxWidth == 1040,
            "Composer should use a narrower width cap so the input box does not stretch too wide."
        )
        precondition(
            appearance.conversationComposerTopPadding == 24,
            "Conversation composer should leave more space above the input field."
        )
        precondition(
            appearance.composerTextHorizontalPadding == 20,
            "Composer text should keep extra horizontal inset from the border."
        )
        precondition(
            appearance.composerTextTopPadding == 16,
            "Composer text should keep extra top inset from the border."
        )
        precondition(
            appearance.composerTextWeight == .regular,
            "Composer input text should use regular weight instead of a bold style."
        )
        precondition(
            appearance.bodyTextSize == 16,
            "Conversation body copy should use the smaller reference text size."
        )
        precondition(
            appearance.bodyLineSpacing == 7,
            "Conversation body copy should use tighter line spacing."
        )

        let windowBehavior = CodexWindowBehavior.default
        precondition(
            windowBehavior.usesTransparentTitleBar,
            "Window should use a transparent title bar so controls visually blend into the shell."
        )
        precondition(
            windowBehavior.usesHiddenTitleBarStyle,
            "Window should opt into the hidden title bar style at creation time to avoid the white system bar on reopen."
        )
        precondition(
            windowBehavior.usesFullSizeContentView,
            "Window should extend content into the title bar region."
        )
        precondition(
            windowBehavior.hidesWindowTitle,
            "Window should hide the default title text for the Codex-style shell."
        )
        precondition(
            windowBehavior.isMovableByBackground,
            "Window should remain draggable after title bar fusion."
        )
    }
}
