//
//  ClickObserver.swift
//  spotibar
//
//  Created by Kyle Milner on 07/09/2016.
//  Copyright © 2016 kyRobot. All rights reserved.
//

import Foundation
import Cocoa

public class ClickObserver {
    private var monitor: AnyObject?
    private let mask: NSEventMask = [NSEventMask.LeftMouseDownMask, NSEventMask.RightMouseDownMask]
    private let action: NSEvent? -> ()
    
    public init(action: NSEvent? -> ()) {
        self.action = action
    }
    
    deinit {
        ignore()
    }
    
    public func observe() {
        monitor = NSEvent.addGlobalMonitorForEventsMatchingMask(mask, handler: action)
    }
    
    public func ignore() {
        if monitor != nil {
            NSEvent.removeMonitor(monitor!)
            monitor = nil
        }
    }
}
