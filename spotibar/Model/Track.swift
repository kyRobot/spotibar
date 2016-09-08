//
//  Track.swift
//  spotibar
//
//  Created by Kyle Milner on 08/09/2016.
//  Copyright © 2016 kyRobot. All rights reserved.
//

import Cocoa

public class Track : NSObject {

    let state: SpotifyConstants.PlayerState

    var id, name, artist, album : String?

    lazy var art: NSImage? = { () -> NSImage? in

        guard let trackID = self.id else {
            return NSImage(named: "no_art@2x")
        }

        return NSURL(string: "https://placehold.it/250x250?text=\(trackID)")
            .flatMap { NSData(contentsOfURL: $0) }
            //            .flatMap { print($0); return $0} // Peek
            .flatMap { NSImage(data: $0) }

    }()

    init(state: SpotifyConstants.PlayerState) {
        self.state = state
    }
    
}
