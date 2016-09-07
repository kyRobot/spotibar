//
//  AppDelegate.swift
//  spotibar
//
//  Created by Kyle Milner on 05/09/2016.
//  Copyright © 2016 kyRobot. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    let menuItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    let popover = NSPopover()
    private var clickObserver: ClickObserver?


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        if let button = menuItem.button {
            button.image = NSImage(named: "Spotify@2x")
            button.imagePosition = NSCellImagePosition.ImageLeft
            button.action = #selector(AppDelegate.togglePopover(_:))
            button.title = "Now Playing"
        }
        
        popover.contentViewController = SpotibarViewController(nibName: "SpotibarViewController", bundle: nil)
        
        clickObserver = ClickObserver() { [unowned self] event in
            print("click")
            if self.popover.shown {
                self.closePopover(event)
            }
        }
        clickObserver?.observe()
    }
    
    func togglePopover(sender: AnyObject?) {
        
        if popover.shown {
            self.closePopover(sender)
        } else {
            if let button = menuItem.button {
                popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSRectEdge.MinY)
            }
            clickObserver?.observe()
        }
    }
    
    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
        clickObserver?.ignore()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

