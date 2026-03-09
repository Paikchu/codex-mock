import Foundation

@main
struct SidebarThreadListTests {
    static func main() {
        let data = CodexMockData.makeAppData()
        let rows = SidebarThreadListRow.makeRows(from: data.projects, collapsedProjectIDs: [])

        precondition(
            rows.count == 18,
            "Flattened sidebar rows should include every project plus each thread or empty-state row."
        )

        precondition(
            rows[0].kind == .project(data.projects[0]),
            "Each project should start with its own project row."
        )
        precondition(
            rows[1].kind == .empty(data.projects[0]),
            "Projects without threads should emit an empty-state row immediately after the project row."
        )
        precondition(
            rows[4].kind == .project(data.projects[2]),
            "The next threaded project should appear in source order."
        )
        precondition(
            rows[5].kind == .thread(project: data.projects[2], thread: data.projects[2].threads[0]),
            "Thread rows should follow their owning project row."
        )
        precondition(
            rows[14].kind == .project(data.projects[3]),
            "Trailing projects should still emit their project row."
        )
        precondition(
            rows[15].kind == .empty(data.projects[3]),
            "Trailing empty projects should still emit their empty-state row."
        )
        precondition(
            rows[16].kind == .project(data.projects[4]),
            "The final project should still appear after earlier empty projects."
        )
        precondition(
            rows[17].kind == .empty(data.projects[4]),
            "Trailing empty projects should still emit their empty-state row."
        )

        let collapsedRows = SidebarThreadListRow.makeRows(
            from: data.projects,
            collapsedProjectIDs: [data.projects[0].id, data.projects[2].id]
        )
        precondition(
            collapsedRows.count == 8,
            "Collapsed projects should emit only their project row and hide all child thread or empty rows."
        )
        precondition(
            collapsedRows[0].kind == .project(data.projects[0]),
            "Collapsed empty projects should still keep their project row visible."
        )
        precondition(
            collapsedRows[1].kind == .project(data.projects[1]),
            "Projects that remain expanded should still keep their original order."
        )
        precondition(
            collapsedRows[2].kind == .empty(data.projects[1]),
            "Expanded empty projects should continue to show their empty-state row."
        )
        precondition(
            collapsedRows[3].kind == .project(data.projects[2]),
            "Collapsed threaded projects should still keep their parent project row."
        )
        precondition(
            !collapsedRows.contains(where: {
                if case .thread(let project, _) = $0.kind {
                    return project.id == data.projects[2].id
                }
                if case .empty(let project) = $0.kind {
                    return project.id == data.projects[2].id
                }
                return false
            }),
            "Collapsed projects should remove both thread rows and empty-state rows from the visible list."
        )

        let tightHeight = SidebarThreadListLayout.availableHeight(
            sidebarHeight: 420,
            topBlockHeight: 128,
            footerBlockHeight: 74,
            sectionTopPadding: 10,
            footerSpacing: 12,
            bottomPadding: 8
        )
        precondition(
            tightHeight == 188,
            "Available list height should subtract the measured header, footer, and fixed spacing."
        )
        precondition(
            SidebarThreadListLayout.resolvedHeight(contentHeight: 0, availableHeight: tightHeight) == tightHeight,
            "An unmeasured thread list should temporarily use the available height so rows can render and be measured."
        )
        precondition(
            !SidebarThreadListLayout.shouldScroll(contentHeight: 0, availableHeight: tightHeight),
            "An unmeasured thread list should not force scrolling before content height is known."
        )
        precondition(
            SidebarThreadListLayout.resolvedHeight(contentHeight: 120, availableHeight: tightHeight) == 120,
            "Short thread lists should shrink to fit their content height."
        )
        precondition(
            !SidebarThreadListLayout.shouldScroll(contentHeight: 120, availableHeight: tightHeight),
            "Short thread lists should not enable scrolling."
        )
        precondition(
            SidebarThreadListLayout.resolvedHeight(contentHeight: 320, availableHeight: tightHeight) == tightHeight,
            "Long thread lists should clamp to the available height."
        )
        precondition(
            SidebarThreadListLayout.shouldScroll(contentHeight: 320, availableHeight: tightHeight),
            "Long thread lists should enable scrolling once the content exceeds the height cap."
        )
    }
}
