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

    @IBOutlet weak var window: NSWindow!
    
    let menuItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        if let button = menuItem.button {
            button.image = NSImage(named: "Spotify@2x")
            button.action = #selector(AppDelegate.helloWorld(_:))
        }
    }
    
    func helloWorld(sender: AnyObject) {
        print("Hello, world")
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

