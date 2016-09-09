//
//  StatusItemController.swift
//  spotibar
//
//  Created by Kyle Milner on 07/09/2016.
//  Copyright © 2016 kyRobot. All rights reserved.
//

import Cocoa

class StatusItemController: NSObject {
    
    let menuItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    let popover = NSPopover()
    let popoverViewController = SpotibarViewController(nibName: "SpotibarViewController", bundle: nil)
    private var clickObserver: ClickObserver?
    
    override init() {
        super.init()
        setupButton()
        setupPopover()
    }

    func update(track: Track) {
        switch track.state {
        case .Playing:
            newButtonTitle(track.name)
        default:
            newButtonTitle(nil)
        }
        popoverViewController?.updateFromSpotify(track)

    }

    private func setupButton() {
        if let button = menuItem.button {
            button.image = NSImage(named: "Spotify@2x")
            button.target = self
            button.imagePosition = NSCellImagePosition.ImageLeft
            button.action = #selector(StatusItemController.togglePopover(_:))
        }
    }

    private func setupPopover() {
        popover.contentViewController = popoverViewController
        popover.delegate = popoverViewController
        clickObserver = ClickObserver() { [unowned self] event in
            if self.popover.shown {
                self.closePopover(event)
            }
        }
    }
    
    @objc private func togglePopover(sender: AnyObject?) {
        if popover.shown {
            self.closePopover(sender)
        } else {
            if let button = menuItem.button {
                popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSRectEdge.MinY)
            }
            clickObserver?.observe()
        }
    }
    
    private func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
        clickObserver?.ignore()
    }

    private func newButtonTitle(title: String?) {
        if let button = menuItem.button {
            if let newTitle = title {
                button.title = newTitle
            } else {
                button.title = "";
            }
        }
    }


}
