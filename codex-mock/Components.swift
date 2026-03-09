import AppKit
import SwiftUI

enum CodexPalette {
    static let background = Color(hex: "#0A0A0B")
    static let canvas = Color(hex: "#0D0E10")
    static let chromeBar = Color(hex: "#17171A")
    static let chromeStroke = Color.white.opacity(0.05)
    static let sidebarTop = Color(hex: "#1B1A22")
    static let sidebarBottom = Color(hex: "#17171C")
    static let panel = Color(hex: "#18191D")
    static let panelElevated = Color(hex: "#1F2025")
    static let stroke = Color.white.opacity(0.09)
    static let mutedStroke = Color.white.opacity(0.05)
    static let textPrimary = Color.white.opacity(0.96)
    static let textSecondary = Color.white.opacity(0.56)
    static let textTertiary = Color.white.opacity(0.34)
    static let accentBlue = Color(hex: "#168BFF")
    static let accentPurple = Color(hex: "#845BFF")
    static let accentOrange = Color(hex: "#FF8B3D")
}

struct CodexShellBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [CodexPalette.background, CodexPalette.canvas],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            RadialGradient(
                colors: [Color(hex: "#2A1D27").opacity(0.38), .clear],
                center: .topLeading,
                startRadius: 30,
                endRadius: 680
            )

            RadialGradient(
                colors: [Color(hex: "#151C2B").opacity(0.26), .clear],
                center: .bottomTrailing,
                startRadius: 40,
                endRadius: 760
            )
        }
        .ignoresSafeArea()
    }
}

struct CodexSidebar: View {
    let data: CodexAppData
    let appearance: CodexShellAppearance
    let shellState: CodexShellState
    let onNewThread: () -> Void
    let onSelectProject: (CodexProject) -> Void
    let onSelectThread: (CodexProject, CodexThread) -> Void
    let onToggleProjectCollapse: (CodexProject) -> Void

    @State private var topBlockHeight: CGFloat = 0
    @State private var footerBlockHeight: CGFloat = 0
    @State private var listContentHeight: CGFloat = 0

    private let footerSpacingMin: CGFloat = 12

    private var threadRows: [SidebarThreadListRow] {
        SidebarThreadListRow.makeRows(
            from: data.projects,
            collapsedProjectIDs: shellState.collapsedProjectIDs
        )
    }

    var body: some View {
        GeometryReader { proxy in
            let availableThreadHeight = SidebarThreadListLayout.availableHeight(
                sidebarHeight: proxy.size.height,
                topBlockHeight: topBlockHeight,
                footerBlockHeight: footerBlockHeight,
                sectionTopPadding: 0,
                footerSpacing: footerSpacingMin,
                bottomPadding: appearance.sidebarListBottomPadding
            )
            let resolvedThreadHeight = SidebarThreadListLayout.resolvedHeight(
                contentHeight: listContentHeight,
                availableHeight: availableThreadHeight
            )
            let shouldScroll = SidebarThreadListLayout.shouldScroll(
                contentHeight: listContentHeight,
                availableHeight: availableThreadHeight
            )

            VStack(alignment: .leading, spacing: 0) {
                sidebarTopBlock
                    .captureHeight(using: SidebarTopBlockHeightPreferenceKey.self) { topBlockHeight = $0 }

                SidebarThreadList(
                    rows: threadRows,
                    appearance: appearance,
                    shellState: shellState,
                    resolvedHeight: resolvedThreadHeight,
                    shouldScroll: shouldScroll,
                    onSelectProject: onSelectProject,
                    onSelectThread: onSelectThread,
                    onToggleProjectCollapse: onToggleProjectCollapse
                ) { listContentHeight = $0 }
                .padding(.bottom, appearance.sidebarListBottomPadding)

                Spacer(minLength: footerSpacingMin)

                sidebarFooter
                    .captureHeight(using: SidebarFooterHeightPreferenceKey.self) { footerBlockHeight = $0 }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .frame(width: appearance.sidebarWidth)
        .background(
            ZStack {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .opacity(appearance.sidebarMaterialOpacity)

                LinearGradient(
                    colors: [
                        CodexPalette.sidebarTop.opacity(appearance.sidebarGradientTopOpacity),
                        CodexPalette.sidebarBottom.opacity(appearance.sidebarGradientBottomOpacity)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#3A2937").opacity(0.16), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .overlay(
                Rectangle()
                    .fill(Color.white.opacity(0.04))
                    .frame(width: 1),
                alignment: .trailing
            )
        )
    }

    private var sidebarTopBlock: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: appearance.sidebarActionSpacing) {
                SidebarActionButton(
                    symbol: "square.and.pencil",
                    title: "New thread",
                    appearance: appearance,
                    fillsWidth: true,
                    action: onNewThread
                )

                SidebarActionButton(
                    symbol: "clock",
                    title: "Automations",
                    appearance: appearance,
                    fillsWidth: true,
                    action: {}
                )

                SidebarActionButton(
                    symbol: "circle.grid.2x2",
                    title: "Skills",
                    appearance: appearance,
                    fillsWidth: true,
                    action: {}
                )
            }
            .padding(.horizontal, appearance.sidebarHorizontalPadding)
            .padding(.top, appearance.sidebarTopInset)

            SidebarThreadHeader(appearance: appearance)
                .padding(.horizontal, appearance.sidebarHorizontalPadding)
                .padding(.top, appearance.sidebarThreadSectionTopPadding)
        }
    }

    private var sidebarFooter: some View {
        HStack {
            SidebarActionButton(
                symbol: "gearshape",
                title: "Settings",
                appearance: appearance,
                fillsWidth: false,
                action: {}
            )
            Spacer()
            Button(action: onNewThread) {
                Text("Upgrade")
                    .font(.system(size: 16, weight: appearance.sidebarTextWeight))
                    .foregroundStyle(CodexPalette.textPrimary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(CodexPalette.panelElevated.opacity(0.8))
                            .overlay(Capsule().stroke(CodexPalette.stroke, lineWidth: 1))
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, appearance.sidebarHorizontalPadding)
        .padding(.vertical, appearance.sidebarFooterVerticalPadding)
    }

}

struct WindowConfigurator: NSViewRepresentable {
    let behavior: CodexWindowBehavior

    func makeNSView(context: Context) -> NSView {
        let view = NSView(frame: .zero)
        DispatchQueue.main.async {
            configureWindowIfNeeded(for: view)
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        DispatchQueue.main.async {
            configureWindowIfNeeded(for: nsView)
        }
    }

    private func configureWindowIfNeeded(for view: NSView) {
        guard let window = view.window else { return }

        if behavior.usesFullSizeContentView {
            window.styleMask.insert(.fullSizeContentView)
        } else {
            window.styleMask.remove(.fullSizeContentView)
        }

        window.titlebarAppearsTransparent = behavior.usesTransparentTitleBar
        window.titleVisibility = behavior.hidesWindowTitle ? .hidden : .visible
        window.isMovableByWindowBackground = behavior.isMovableByBackground
        window.isOpaque = false
        window.backgroundColor = .clear

        if behavior.hidesWindowTitle, !window.title.isEmpty {
            window.title = ""
        }
    }
}

struct SidebarActionButton: View {
    let symbol: String
    let title: String
    let appearance: CodexShellAppearance
    let fillsWidth: Bool
    let action: () -> Void

    @State private var isHovered = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: symbol)
                    .font(.system(size: 17, weight: .medium))
                    .frame(width: appearance.sidebarLeadingIconWidth, alignment: .leading)
                Text(title)
                    .font(.system(size: 17, weight: appearance.sidebarTextWeight))
            }
            .foregroundStyle(isHovered ? Color.white : CodexPalette.textPrimary)
            .frame(maxWidth: fillsWidth ? .infinity : nil, alignment: .leading)
            .padding(.horizontal, 10)
            .padding(.vertical, appearance.sidebarActionVerticalPadding)
            .background(sidebarRowBackground(isHovered: isHovered, isSelected: false, appearance: appearance))
            .contentShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(.easeOut(duration: 0.14)) {
                isHovered = hovering
            }
        }
    }
}

struct SidebarProjectButton: View {
    let project: CodexProject
    let workspace: String?
    let appearance: CodexShellAppearance
    let isCollapsed: Bool
    let onSelect: () -> Void
    let onToggleCollapse: () -> Void

    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggleCollapse) {
                Image(systemName: projectIconSymbol)
                    .font(.system(size: 16, weight: .medium))
                    .frame(width: appearance.sidebarLeadingIconWidth, alignment: .leading)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            Button(action: onSelect) {
                HStack(spacing: 10) {
                    Text(project.title)
                        .font(.system(size: 15.5, weight: appearance.sidebarTextWeight))
                    if let workspace {
                        Text(workspace)
                            .font(.system(size: 15, weight: appearance.sidebarTextWeight))
                            .foregroundStyle(isHovered ? Color.white.opacity(0.78) : CodexPalette.textSecondary)
                    }
                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .foregroundStyle(isHovered ? Color.white : CodexPalette.textPrimary)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(sidebarRowBackground(isHovered: isHovered, isSelected: false, appearance: appearance))
        .contentShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .onHover { hovering in
            withAnimation(.easeOut(duration: 0.14)) {
                isHovered = hovering
            }
        }
    }

    private var projectIconSymbol: String {
        guard isHovered else {
            return "folder"
        }

        return isCollapsed ? "chevron.right" : "chevron.down"
    }
}

struct SidebarThreadRow: View {
    let thread: CodexThread
    let appearance: CodexShellAppearance
    let isSelected: Bool

    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 10) {
            threadMarker
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .center, spacing: 10) {
                    Text(thread.title)
                        .font(.system(size: 14, weight: appearance.sidebarTextWeight))
                        .foregroundStyle(textTint)
                        .lineLimit(1)

                    if let subtitle = thread.subtitle {
                        Text(subtitle)
                            .font(.system(size: 13, weight: appearance.sidebarTextWeight))
                            .foregroundStyle(secondaryTextTint)
                            .lineLimit(1)
                    }

                    Spacer(minLength: 8)

                    Text(thread.relativeTime)
                        .font(.system(size: 13, weight: appearance.sidebarTextWeight))
                        .foregroundStyle(secondaryTextTint)
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .background(sidebarRowBackground(isHovered: isHovered, isSelected: isSelected, appearance: appearance))
        .contentShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .onHover { hovering in
            withAnimation(.easeOut(duration: 0.14)) {
                isHovered = hovering
            }
        }
    }

    @ViewBuilder
    private var threadMarker: some View {
        if thread.badge != nil {
            Image(systemName: "pin")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(iconTint)
        } else {
            Circle()
                .strokeBorder(iconTint.opacity(0.88), lineWidth: 1.5)
                .frame(width: 14, height: 14)
        }
    }

    private var textTint: Color {
        isHovered && !isSelected ? .white : CodexPalette.textPrimary
    }

    private var secondaryTextTint: Color {
        if isSelected {
            return Color.white.opacity(0.76)
        }
        return isHovered ? Color.white.opacity(0.7) : CodexPalette.textSecondary
    }

    private var iconTint: Color {
        isHovered ? Color.white.opacity(0.76) : CodexPalette.textSecondary
    }
}

@ViewBuilder
private func sidebarRowBackground(
    isHovered: Bool,
    isSelected: Bool,
    appearance: CodexShellAppearance
) -> some View {
    let fillOpacity = isSelected ? 0.12 : (isHovered ? appearance.sidebarHoverFillOpacity : 0)
    let strokeOpacity = isSelected ? 0.05 : (isHovered ? appearance.sidebarHoverStrokeOpacity : 0)

    RoundedRectangle(cornerRadius: 14, style: .continuous)
        .fill(Color.white.opacity(fillOpacity))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.white.opacity(strokeOpacity), lineWidth: 1)
        )
}

struct SidebarThreadHeader: View {
    let appearance: CodexShellAppearance

    var body: some View {
        HStack {
            Text("Threads")
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(CodexPalette.textSecondary)
                .padding(.leading, appearance.sidebarSectionLabelLeadingInset)

            Spacer()

            HStack(spacing: 16) {
                Image(systemName: "folder.badge.plus")
                Image(systemName: "line.3.horizontal.decrease")
            }
            .font(.system(size: 16, weight: .medium))
            .foregroundStyle(CodexPalette.textSecondary)
        }
    }
}

struct SidebarThreadList: View {
    let rows: [SidebarThreadListRow]
    let appearance: CodexShellAppearance
    let shellState: CodexShellState
    let resolvedHeight: CGFloat
    let shouldScroll: Bool
    let onSelectProject: (CodexProject) -> Void
    let onSelectThread: (CodexProject, CodexThread) -> Void
    let onToggleProjectCollapse: (CodexProject) -> Void
    let onMeasuredContentHeight: (CGFloat) -> Void

    var body: some View {
        List {
            listRows
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .environment(\.defaultMinListRowHeight, 1)
        .scrollDisabled(!shouldScroll)
        .frame(height: max(0, resolvedHeight))
        .overlay(alignment: .topLeading) {
            VStack(alignment: .leading, spacing: 0) {
                listRows
            }
            .captureHeight(using: SidebarThreadContentHeightPreferenceKey.self) { onMeasuredContentHeight($0) }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .opacity(0.001)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
        }
    }

    @ViewBuilder
    private var listRows: some View {
        ForEach(rows) { row in
            SidebarThreadListRowView(
                row: row,
                appearance: appearance,
                shellState: shellState,
                onSelectProject: onSelectProject,
                onSelectThread: onSelectThread,
                onToggleProjectCollapse: onToggleProjectCollapse
            )
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
        }
    }
}

struct SidebarThreadListRowView: View {
    let row: SidebarThreadListRow
    let appearance: CodexShellAppearance
    let shellState: CodexShellState
    let onSelectProject: (CodexProject) -> Void
    let onSelectThread: (CodexProject, CodexThread) -> Void
    let onToggleProjectCollapse: (CodexProject) -> Void

    var body: some View {
        switch row.kind {
        case .project(let project):
            SidebarProjectButton(
                project: project,
                workspace: project.workspace,
                appearance: appearance,
                isCollapsed: shellState.isProjectCollapsed(project),
                onSelect: { onSelectProject(project) },
                onToggleCollapse: { onToggleProjectCollapse(project) }
            )
            .frame(maxWidth: .infinity, alignment: .leading)

        case .thread(let project, let thread):
            Button {
                onSelectThread(project, thread)
            } label: {
                SidebarThreadRow(
                    thread: thread,
                    appearance: appearance,
                    isSelected: shellState.selectedThread?.id == thread.id
                )
                .padding(.leading, 6)
            }
            .buttonStyle(.plain)

        case .empty:
            Text("No threads")
                .font(.system(size: 16, weight: appearance.sidebarTextWeight))
                .foregroundStyle(CodexPalette.textTertiary)
                .padding(.leading, 34)
                .padding(.top, 2)
                .padding(.bottom, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

private struct SidebarTopBlockHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

private struct SidebarFooterHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

private struct SidebarThreadContentHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

private struct CaptureHeightModifier<Key: PreferenceKey>: ViewModifier where Key.Value == CGFloat {
    let onChange: (CGFloat) -> Void

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear.preference(key: Key.self, value: proxy.size.height)
                }
            )
            .onPreferenceChange(Key.self, perform: onChange)
    }
}

private extension View {
    func captureHeight<Key: PreferenceKey>(
        using key: Key.Type,
        onChange: @escaping (CGFloat) -> Void
    ) -> some View where Key.Value == CGFloat {
        modifier(CaptureHeightModifier<Key>(onChange: onChange))
    }
}

struct CodexCanvasChrome<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        VStack(spacing: 0) {
            content
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CodexPalette.canvas)
    }
}

struct CodexMarkView: View {
    var body: some View {
        ZStack {
            BlobShape()
                .stroke(Color.white.opacity(0.95), style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                .frame(width: 64, height: 64)

            Text(">_")
                .font(.system(size: 24, weight: .heavy, design: .default))
                .foregroundStyle(Color.white.opacity(0.96))
        }
    }
}

struct EmptyHomeView: View {
    let data: CodexAppData
    let shellState: CodexShellState
    @Binding var composerText: String
    let onSelectSuggestion: (CodexSuggestionCard) -> Void
    private let appearance = CodexShellAppearance.default

    var body: some View {
        CodexCanvasChrome {
            VStack(spacing: 0) {
                topRow
                Spacer(minLength: 10)
                centerHero
                Spacer(minLength: 100)
                suggestionRow
                composerSection(placeholder: "Ask Codex anything, @ to add files, / for commands")
            }
            .padding(.horizontal, 30)
            .padding(.top, appearance.canvasTopPadding)
            .padding(.bottom, 16)
        }
    }

    private var topRow: some View {
        HStack(alignment: .top) {
            HStack(spacing: 14) {
                Text("New thread")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(CodexPalette.textPrimary)

                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 12, weight: .black))
                    Text("Get Plus")
                        .font(.system(size: 15, weight: .bold))
                }
                .foregroundStyle(Color(hex: "#C58DFF"))
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(Color(hex: "#2A203C"))
                )
            }

            Spacer()
        }
    }

    private var centerHero: some View {
        VStack(spacing: 18) {
            CodexMarkView()
            Text("Start building")
                .font(.system(size: 60, weight: .bold))
                .foregroundStyle(CodexPalette.textPrimary)
            HStack(spacing: 8) {
                Text(shellState.selectedProject.title)
                    .font(.system(size: 44, weight: .medium))
                    .foregroundStyle(CodexPalette.textSecondary)
                Image(systemName: "chevron.down")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(CodexPalette.textSecondary)
            }
        }
        .padding(.top, 24)
    }

    private var suggestionRow: some View {
        VStack(spacing: 14) {
            HStack {
                Spacer()
                Text("Explore more")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(CodexPalette.textSecondary)
                Rectangle()
                    .fill(CodexPalette.stroke)
                    .frame(width: 1, height: 22)
                Button {} label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(CodexPalette.textSecondary)
                }
                .buttonStyle(.plain)
            }

            HStack(spacing: 18) {
                ForEach(data.suggestions) { card in
                    Button {
                        onSelectSuggestion(card)
                    } label: {
                        SuggestionCard(card: card)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .frame(maxWidth: 1160)
    }

    @ViewBuilder
    private func composerSection(placeholder: String) -> some View {
        CodexComposer(text: $composerText, placeholder: placeholder)
            .frame(maxWidth: appearance.composerMaxWidth)
            .padding(.top, 26)
    }

}

struct SuggestionCard: View {
    let card: CodexSuggestionCard

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Circle()
                .fill(Color(hex: card.accentHex))
                .frame(width: 34, height: 34)
                .overlay(
                    Image(systemName: card.symbolName)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.white)
                )

            Text(card.title)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(CodexPalette.textPrimary)
                .multilineTextAlignment(.leading)

            Spacer(minLength: 0)
        }
        .padding(24)
        .frame(maxWidth: .infinity, minHeight: 150, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color.white.opacity(0.03))
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(CodexPalette.stroke, lineWidth: 1)
                )
        )
    }
}

struct ConversationView: View {
    let data: CodexAppData
    let shellState: CodexShellState
    @Binding var composerText: String
    private let appearance = CodexShellAppearance.default

    var body: some View {
        CodexCanvasChrome {
            VStack(spacing: 0) {
                topRow
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 22) {
                        if let thread = shellState.selectedThread {
                            ForEach(thread.conversationRows) { row in
                                ConversationRowView(row: row, appearance: .default)
                            }
                        }
                    }
                    .frame(maxWidth: 980)
                    .padding(.top, 22)
                    .padding(.bottom, 54)
                    .padding(.horizontal, 10)
                }
                .frame(maxWidth: .infinity)

                CodexComposer(text: $composerText, placeholder: "Request follow-up changes")
                    .frame(maxWidth: appearance.composerMaxWidth)
                    .padding(.top, appearance.conversationComposerTopPadding)
            }
            .padding(.horizontal, 30)
            .padding(.top, appearance.canvasTopPadding)
            .padding(.bottom, 18)
        }
    }

    private var topRow: some View {
        HStack(alignment: .center) {
            HStack(spacing: 14) {
                Text(shellState.selectedThread?.title ?? "New thread")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(CodexPalette.textPrimary)
                    .lineLimit(1)

                Text(shellState.selectedProject.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(CodexPalette.textSecondary)

                Image(systemName: "ellipsis")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(CodexPalette.textSecondary)
            }

            Spacer()
        }
    }
}

struct ConversationRowView: View {
    let row: CodexConversationRow
    let appearance: CodexShellAppearance

    var body: some View {
        switch row.kind {
        case .assistant:
            VStack(alignment: .leading, spacing: 14) {
                ForEach(row.paragraphs) { paragraph in
                    Text(paragraph.attributed)
                        .font(.system(size: appearance.bodyTextSize, weight: .medium))
                        .foregroundStyle(CodexPalette.textPrimary)
                        .lineSpacing(appearance.bodyLineSpacing)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

        case .assistantStatus:
            VStack(alignment: .leading, spacing: 8) {
                ForEach(row.paragraphs) { paragraph in
                    Text(paragraph.attributed)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(CodexPalette.textSecondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 8)

        case .userBubble:
            HStack {
                Spacer(minLength: 100)
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(row.paragraphs) { paragraph in
                        Text(paragraph.attributed)
                            .font(.system(size: appearance.bodyTextSize, weight: .semibold))
                            .foregroundStyle(CodexPalette.textPrimary)
                            .lineSpacing(appearance.bodyLineSpacing)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(.horizontal, 22)
                .padding(.vertical, 18)
                .background(
                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                        .fill(Color.white.opacity(0.09))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                        .stroke(CodexPalette.stroke, lineWidth: 1)
                )
                .frame(maxWidth: 640, alignment: .trailing)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)

        case .divider:
            HStack(spacing: 14) {
                Rectangle()
                    .fill(CodexPalette.stroke)
                    .frame(height: 1)
                Text(row.trailingLabel ?? "")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(CodexPalette.textSecondary)
                    .fixedSize()
                Rectangle()
                    .fill(CodexPalette.stroke)
                    .frame(height: 1)
            }
            .padding(.vertical, 10)
        }
    }
}

struct CodexComposer: View {
    @Binding var text: String
    let placeholder: String
    private let appearance = CodexShellAppearance.default

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            ZStack(alignment: .topLeading) {
                TextEditor(text: $text)
                    .font(.system(size: 17, weight: appearance.composerTextWeight))
                    .foregroundStyle(CodexPalette.textPrimary)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: appearance.composerEditorHeight, maxHeight: appearance.composerEditorHeight)
                    .padding(.horizontal, appearance.composerTextHorizontalPadding)
                    .padding(.top, appearance.composerTextTopPadding)

                if text.isEmpty {
                Text(placeholder)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(CodexPalette.textTertiary)
                        .padding(.horizontal, 20)
                        .padding(.top, 18)
                        .allowsHitTesting(false)
                }
            }

            HStack {
                HStack(spacing: 18) {
                    Image(systemName: "plus")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(CodexPalette.textSecondary)

                    composerMenu(title: "GPT-5.4")
                    composerMenu(title: "High")
                }

                Spacer()

                HStack(spacing: 18) {
                    Image(systemName: "mic")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(CodexPalette.textSecondary)

                    Circle()
                        .fill(Color.white.opacity(0.78))
                        .frame(width: 42, height: 42)
                        .overlay(
                            Image(systemName: "arrow.up")
                                .font(.system(size: 19, weight: .bold))
                                .foregroundStyle(CodexPalette.canvas)
                        )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(Color.white.opacity(0.024))
                .overlay(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(CodexPalette.stroke, lineWidth: 1)
                )
        )
    }

    private func composerMenu(title: String) -> some View {
        HStack(spacing: 8) {
            Text(title)
                .font(.system(size: 17, weight: .medium))
            Image(systemName: "chevron.down")
                .font(.system(size: 13, weight: .bold))
        }
        .foregroundStyle(CodexPalette.textSecondary)
    }
}

private struct BlobShape: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height

        var path = Path()
        path.move(to: CGPoint(x: w * 0.23, y: h * 0.12))
        path.addCurve(to: CGPoint(x: w * 0.76, y: h * 0.12), control1: CGPoint(x: w * 0.36, y: h * 0.01), control2: CGPoint(x: w * 0.64, y: h * 0.02))
        path.addCurve(to: CGPoint(x: w * 0.92, y: h * 0.42), control1: CGPoint(x: w * 0.89, y: h * 0.15), control2: CGPoint(x: w * 0.97, y: h * 0.29))
        path.addCurve(to: CGPoint(x: w * 0.78, y: h * 0.83), control1: CGPoint(x: w * 0.9, y: h * 0.58), control2: CGPoint(x: w * 0.9, y: h * 0.74))
        path.addCurve(to: CGPoint(x: w * 0.49, y: h * 0.88), control1: CGPoint(x: w * 0.67, y: h * 0.9), control2: CGPoint(x: w * 0.58, y: h * 0.91))
        path.addCurve(to: CGPoint(x: w * 0.17, y: h * 0.78), control1: CGPoint(x: w * 0.36, y: h * 0.97), control2: CGPoint(x: w * 0.22, y: h * 0.93))
        path.addCurve(to: CGPoint(x: w * 0.1, y: h * 0.48), control1: CGPoint(x: w * 0.04, y: h * 0.69), control2: CGPoint(x: w * 0.02, y: h * 0.55))
        path.addCurve(to: CGPoint(x: w * 0.23, y: h * 0.12), control1: CGPoint(x: w * 0.16, y: h * 0.31), control2: CGPoint(x: w * 0.12, y: h * 0.18))
        path.closeSubpath()
        return path
    }
}

private extension CodexRichText {
    var attributed: AttributedString {
        let appearance = CodexShellAppearance.default
        var result = AttributedString()

        for segment in segments {
            switch segment {
            case let .text(value):
                var chunk = AttributedString(value)
                chunk.foregroundColor = CodexPalette.textPrimary
                chunk.font = .system(size: appearance.bodyTextSize, weight: .medium)
                result.append(chunk)

            case let .code(value):
                var chunk = AttributedString(value)
                chunk.foregroundColor = Color.white.opacity(0.94)
                chunk.backgroundColor = Color.white.opacity(0.1)
                chunk.font = .system(size: 15, weight: .semibold, design: .monospaced)
                result.append(chunk)

                var spacer = AttributedString(" ")
                spacer.font = .system(size: appearance.bodyTextSize, weight: .medium)
                result.append(spacer)
            }
        }

        return result
    }
}

extension Color {
    init(hex: String) {
        let cleanHex = hex.replacingOccurrences(of: "#", with: "")
        var int: UInt64 = 0
        Scanner(string: cleanHex).scanHexInt64(&int)

        let a, r, g, b: UInt64
        switch cleanHex.count {
        case 8:
            (a, r, g, b) = ((int >> 24) & 255, (int >> 16) & 255, (int >> 8) & 255, int & 255)
        default:
            (a, r, g, b) = (255, (int >> 16) & 255, (int >> 8) & 255, int & 255)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
