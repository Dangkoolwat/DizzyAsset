import AppKit
import SwiftUI

class QuickPeekPanel: NSPanel {
    init(contentRect: NSRect, view: NSView) {
        super.init(
            contentRect: contentRect,
            styleMask: [.nonactivatingPanel, .titled, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        
        self.isFloatingPanel = true
        self.level = .floating
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        self.titleVisibility = .hidden
        self.titlebarAppearsTransparent = true
        self.isMovableByWindowBackground = true
        self.hasShadow = true
        self.backgroundColor = .clear
        
        self.contentView = view
    }
    
    override var canBecomeKey: Bool {
        return true
    }
    
    override func cancelOperation(_ sender: Any?) {
        QuickPeekManager.shared.hide()
    }
}

@MainActor
class QuickPeekManager: ObservableObject {
    static let shared = QuickPeekManager()
    
    private var panel: QuickPeekPanel?
    
    private init() {}
    
    func toggle() {
        if let panel = panel, panel.isVisible {
            hide()
        } else {
            show()
        }
    }
    
    func show() {
        if panel == nil {
            let view = QuickPeekView()
            let hostingView = NSHostingView(rootView: view)
            hostingView.frame = NSRect(x: 0, y: 0, width: 700, height: 450)
            
            panel = QuickPeekPanel(
                contentRect: NSRect(x: 0, y: 0, width: 700, height: 450),
                view: hostingView
            )
            panel?.center()
        }
        
        panel?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func hide() {
        panel?.orderOut(nil)
    }
}
