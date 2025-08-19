import SwiftUI

struct FlowLayout<Content: View>: View {
    let alignment: HorizontalAlignment
    let spacing: CGFloat
    @ViewBuilder var content: Content

    init(alignment: HorizontalAlignment = .leading, spacing: CGFloat = 8,
         @ViewBuilder content: () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
    }

    var body: some View {
        GeometryReader { geo in
            _Flow(content: content, spacing: spacing, availableWidth: geo.size.width)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

private struct _Flow<Content: View>: View {
    let content: Content
    let spacing: CGFloat
    let availableWidth: CGFloat

    var body: some View {
        var x: CGFloat = 0
        var y: CGFloat = 0
        return ZStack(alignment: .topLeading) {
            content
                .fixedSize()
                .alignmentGuide(.leading) { d in
                    if x + d.width > availableWidth {
                        x = 0
                        y -= d.height + spacing
                    }
                    let result = x
                    x += d.width + spacing
                    return -result
                }
                .alignmentGuide(.top) { _ in y }
        }
    }
}
