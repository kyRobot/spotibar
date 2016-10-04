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

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        DistributedNotificationCenter.default()
            .addObserver(self,
                         selector: #selector(self.spotifyPlaybackChanged(notification:)),
                         name: NSNotification.Name(rawValue: "com.spotify.client.PlaybackStateChanged"),
                         object: nil)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        DistributedNotificationCenter.default().removeObserver(self)
    }

    @objc fileprivate func spotifyPlaybackChanged(notification: Notification) {
        let payload = notification.userInfo!
        let playerState: SpotifyConstants.PlayerState? =
            SpotifyConstants.PlayerState(rawValue: payload[SpotifyConstants.NotificationKeys.State] as! String)

        guard let knownState = playerState else {
            return
            // Error State i.e Player State is Unknown. Notification Structure may have changed
        }

        let state = (knownState == .playing && adCheck(map: payload)) ? .advertising : knownState

        let track = Track(state: state)
        track.id = extract(key: SpotifyConstants.NotificationKeys.ID, map: payload)
        track.name = extract(key: SpotifyConstants.NotificationKeys.Name, map: payload)
        track.artist = extract(key: SpotifyConstants.NotificationKeys.Artist, map: payload)
        track.album = extract(key: SpotifyConstants.NotificationKeys.Album, map: payload)
        statusItem.update(track: track)

    }

    fileprivate func extract(key: String, map: [AnyHashable: Any]) -> String? {
        guard let value = map[key] else {
            return nil
        }
        return String(describing: value)
    }

    fileprivate func adCheck(map: [AnyHashable: Any]) -> Bool {
        guard let trackNum = extract(key: SpotifyConstants.NotificationKeys.TrackNumber, map: map) else {
            return false
        }

        return trackNum == "0"
    }


}

