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
    private var clickObserver: ClickObserver?
    
    override init() {
        super.init()
        setupButton()
        setupPopover()
    }

    func update(state: String) {
        if state == SpotifyConstants.PlayerStates.Playing {
            newButtonTitle(state)
        }
        else {
            newButtonTitle(nil)
        }
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
        popover.contentViewController = SpotibarViewController(nibName: "SpotibarViewController", bundle: nil)
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
            if let t = title {
                button.title = t
            } else {
                button.title = "";
            }
        }
    }


}
