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

        let playerState: SpotifyConstants.PlayerState? =
            SpotifyConstants.PlayerState(rawValue: payload[SpotifyConstants.NotificationKeys.State] as! String)

        guard let state = playerState else {
            return
            // Error State i.e Player Error is Unknown. Notifications may have changed
        }

        let track = Track(state: state)
        track.id = extract(SpotifyConstants.NotificationKeys.ID, map: payload)
        track.name = extract(SpotifyConstants.NotificationKeys.Name, map: payload)
        track.artist = extract(SpotifyConstants.NotificationKeys.Artist, map: payload)
        statusItem.update(track)
    }

    private func extract(key: String, map: [NSObject: AnyObject]) -> String? {
        return map[key] as! String?
    }


}

