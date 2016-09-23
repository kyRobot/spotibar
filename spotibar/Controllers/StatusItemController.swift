//
//  StatusItemController.swift
//  spotibar
//
//  Created by Kyle Milner on 07/09/2016.
//  Copyright © 2016 kyRobot. All rights reserved.
//

import Cocoa

class StatusItemController: NSObject {
    
    let menuItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let popover = NSPopover()
    let popoverViewController = SpotibarViewController(nibName: "SpotibarUI2", bundle: nil)
    fileprivate var clickObserver: ClickObserver?
    
    override init() {
        super.init()
        setupButton()
        setupPopover()
    }

    func update(track: Track) {
        switch track.state {
        case .playing:
            newButtonTitle(title: track.name)
        default:
            newButtonTitle(title: nil)
        }
        popoverViewController?.updateFromSpotify(track: track)

    }

    fileprivate func setupButton() {
        if let button = menuItem.button {
            button.image = NSImage(named: "Spotify@2x")
            button.target = self
            button.imagePosition = NSCellImagePosition.imageRight
            button.action = #selector(StatusItemController.togglePopover(sender:))
        }
    }

    fileprivate func setupPopover() {
        popover.contentViewController = popoverViewController
        popover.delegate = popoverViewController
        clickObserver = ClickObserver() { [unowned self] event in
            if self.popover.isShown {
                self.closePopover(sender: event)
            }
        }
    }
    
    @objc fileprivate func togglePopover(sender: AnyObject?) {
        if popover.isShown {
            self.closePopover(sender: sender)
        } else {
            if let button = menuItem.button {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
            clickObserver?.observe()
        }
    }
    
    fileprivate func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
        clickObserver?.ignore()
    }

    fileprivate func newButtonTitle(title: String?) {
        if let button = menuItem.button {
            if let newTitle = title {
                button.title = newTitle
            } else {
                button.title = "";
            }
        }
    }


}
