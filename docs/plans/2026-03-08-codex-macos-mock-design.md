# Codex macOS Mock Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build a SwiftUI macOS app that closely recreates the provided Codex desktop screenshots, including the empty home state and the in-conversation chat state, using local mock data only.

**Architecture:** Keep the app as a single macOS SwiftUI target and introduce a small local presentation layer for mock projects, threads, suggestions, and chat messages. Split the UI into focused SwiftUI views for the sidebar, top toolbar, empty state canvas, chat transcript, and composer so both screenshots can be rendered from one shared shell with state-driven switching.

**Tech Stack:** SwiftUI, AppKit-backed macOS window styling where needed, local mock models, SF Symbols, `xcodebuild`

---

### Task 1: Plan the shell structure

**Files:**
- Modify: `codex-mock/codex_mockApp.swift`
- Modify: `codex-mock/ContentView.swift`
- Create: `codex-mock/Models.swift`
- Create: `codex-mock/MockData.swift`

**Step 1: Write the failing test**

Document the key view states to support:
- app shell with left navigation and main canvas
- empty home state
- active conversation state
- selected thread highlighting
- reusable composer and toolbar controls

**Step 2: Run test to verify it fails**

Run: `xcodebuild -project codex-mock.xcodeproj -scheme codex-mock -sdk macosx -configuration Debug build`
Expected: current app builds but does not provide the required UI states or mock data models.

**Step 3: Write minimal implementation**

Create lightweight models for projects, threads, quick actions, and chat messages. Update the app entry to host a resizable desktop-style shell and choose an initial selected thread from mock data.

**Step 4: Run test to verify it passes**

Run: `xcodebuild -project codex-mock.xcodeproj -scheme codex-mock -sdk macosx -configuration Debug build`
Expected: build succeeds with the new structure in place.

### Task 2: Build the shared desktop shell

**Files:**
- Modify: `codex-mock/ContentView.swift`
- Create: `codex-mock/Components.swift`

**Step 1: Write the failing test**

Define the shell contract:
- fixed-width translucent sidebar
- full-height primary canvas
- dark palette matching the screenshots
- toolbar row, content area, and bottom status strip

**Step 2: Run test to verify it fails**

Run: `xcodebuild -project codex-mock.xcodeproj -scheme codex-mock -sdk macosx -configuration Debug build`
Expected: existing `ContentView` cannot render the required desktop shell.

**Step 3: Write minimal implementation**

Implement reusable shell views and modifiers for background gradients, divider lines, rounded panels, and typography sizing. Keep layout constants centralized so visual tuning stays predictable.

**Step 4: Run test to verify it passes**

Run: `xcodebuild -project codex-mock.xcodeproj -scheme codex-mock -sdk macosx -configuration Debug build`
Expected: shell compiles and renders both sidebar and canvas layout.

### Task 3: Implement the empty state home screen

**Files:**
- Modify: `codex-mock/ContentView.swift`
- Modify: `codex-mock/Components.swift`
- Modify: `codex-mock/MockData.swift`

**Step 1: Write the failing test**

List empty state requirements:
- centered mark, title, and project selector
- top-left thread title and Plus chip
- recommendation cards aligned near the composer
- bottom composer with model and permission badges

**Step 2: Run test to verify it fails**

Run: `xcodebuild -project codex-mock.xcodeproj -scheme codex-mock -sdk macosx -configuration Debug build`
Expected: empty state visual structure is still missing.

**Step 3: Write minimal implementation**

Create the hero stack, recommendation cards, and desktop composer matching the screenshot spacing and hierarchy. Feed values from mock data so labels remain editable from one place.

**Step 4: Run test to verify it passes**

Run: `xcodebuild -project codex-mock.xcodeproj -scheme codex-mock -sdk macosx -configuration Debug build`
Expected: empty state compiles cleanly.

### Task 4: Implement the conversation screen

**Files:**
- Modify: `codex-mock/ContentView.swift`
- Modify: `codex-mock/Components.swift`
- Modify: `codex-mock/MockData.swift`

**Step 1: Write the failing test**

List chat state requirements:
- transcript with assistant paragraphs, inline code pills, separators, and timestamps
- right-aligned user bubble
- header title and window actions
- same composer reused below transcript

**Step 2: Run test to verify it fails**

Run: `xcodebuild -project codex-mock.xcodeproj -scheme codex-mock -sdk macosx -configuration Debug build`
Expected: active thread cannot yet render a conversation transcript.

**Step 3: Write minimal implementation**

Render rich mock transcript rows with separate styles for assistant status rows and user prompts. Wire thread selection so one thread opens the chat state while the empty project stays on the home canvas.

**Step 4: Run test to verify it passes**

Run: `xcodebuild -project codex-mock.xcodeproj -scheme codex-mock -sdk macosx -configuration Debug build`
Expected: conversation view compiles and swaps correctly.

### Task 5: Polish and verify

**Files:**
- Modify: `codex-mock/ContentView.swift`
- Modify: `codex-mock/Components.swift`
- Modify: `codex-mock/codex_mockApp.swift`

**Step 1: Write the failing test**

Review against screenshots:
- sidebar density and contrast
- spacing of toolbar buttons and composer controls
- rounded corners, strokes, shadows, and bottom status line
- window minimum size and title bar presentation

**Step 2: Run test to verify it fails**

Run: `xcodebuild -project codex-mock.xcodeproj -scheme codex-mock -sdk macosx -configuration Debug build`
Expected: visual polish items still need iteration.

**Step 3: Write minimal implementation**

Tune colors, dimensions, and macOS window modifiers. Keep mock interactions local and deterministic.

**Step 4: Run test to verify it passes**

Run: `xcodebuild -project codex-mock.xcodeproj -scheme codex-mock -sdk macosx -configuration Debug build`
Expected: final build succeeds and the app presents both screenshot states.
