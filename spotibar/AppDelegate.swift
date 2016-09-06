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


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        if let button = menuItem.button {
            button.image = NSImage(named: "Spotify@2x")
            button.imagePosition = NSCellImagePosition.ImageLeft
            button.action = #selector(AppDelegate.togglePopover(_:))
            button.title = "Now Playing"
        }
        
        popover.contentViewController = SpotibarViewController(nibName: "SpotibarViewController", bundle: nil)
        popover.behavior = NSPopoverBehavior.Transient
    }
    
    func togglePopover(sender: AnyObject?) {
        
        if popover.shown {
            popover.performClose(sender)
        } else {
            if let button = menuItem.button {
                popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSRectEdge.MinY)
            }
        }
        
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

