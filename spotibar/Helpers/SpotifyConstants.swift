//
//  SpotifyConstants.swift
//  spotibar
//
//  Created by Kyle Milner on 08/09/2016.
//  Copyright © 2016 kyRobot. All rights reserved.
//

import Foundation

struct SpotifyConstants {
    struct NotificationKeys {
        static let State = "Player State"
        static let ID = "Track ID"
        static let Album = "Album"
        static let Name = "Name"
        static let Artist = "Album Artist"
    }

    enum PlayerState : String {
        case Playing, Paused, Stopped
    }
}
