//
//  Track.swift
//  spotibar
//
//  Created by Kyle Milner on 08/09/2016.
//  Copyright © 2016 kyRobot. All rights reserved.
//

import Foundation

public class Track : NSObject {

    let state: SpotifyConstants.PlayerState

    var id, name, artist, album : String?

    init(state: SpotifyConstants.PlayerState) {
        self.state = state
    }
    
}
