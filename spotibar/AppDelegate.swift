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
    
    let statusItem = StatusItemController()

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        NSDistributedNotificationCenter.defaultCenter()
            .addObserver(self,
                         selector: #selector(self.spotifyPlaybackChange(_:)),
                         name: "com.spotify.client.PlaybackStateChanged",
                         object: nil)
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        NSDistributedNotificationCenter.defaultCenter().removeObserver(self)
    }

    @objc private func spotifyPlaybackChange(notification: NSNotification) {
        let payload = notification.userInfo!
        let playerState: String = payload[SpotifyConstants.NotificationKeys.State] as! String
        statusItem.update(playerState)

    }


}

