import Foundation

@main
struct ShellAppearanceScaleTests {
    static func main() {
        let appearance = CodexShellAppearance.default

        precondition(
            appearance.contentScale == 1,
            "Shell should fill the window bounds without leaving an outer border."
        )
    }
}
