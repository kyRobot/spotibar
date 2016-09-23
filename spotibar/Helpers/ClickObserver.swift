//
//  ClickObserver.swift
//  spotibar
//
//  Created by Kyle Milner on 07/09/2016.
//  Copyright © 2016 kyRobot. All rights reserved.
//

import Foundation
import Cocoa

open class ClickObserver {
    fileprivate var monitor: AnyObject?
    fileprivate let mask: NSEventMask = [NSEventMask.leftMouseDown, NSEventMask.rightMouseDown]
    fileprivate let action: (NSEvent?) -> ()
    
    public init(action: @escaping (NSEvent?) -> ()) {
        self.action = action
    }
    
    deinit {
        ignore()
    }
    
    open func observe() {
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: action) as AnyObject?
    }
    
    open func ignore() {
        if monitor != nil {
            NSEvent.removeMonitor(monitor!)
            monitor = nil
        }
    }
}
