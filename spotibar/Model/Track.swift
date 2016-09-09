//
//  Track.swift
//  spotibar
//
//  Created by Kyle Milner on 08/09/2016.
//  Copyright © 2016 kyRobot. All rights reserved.
//

import Foundation
import Cocoa

public class Track : NSObject {

    let state: SpotifyConstants.PlayerState

    var id, name, artist, album : String?

    lazy var art: NSImage? = { () -> NSImage? in

        guard let trackID = self.id,
                  image = try? self.fetchAlbumArt(trackID) else {
            return NSImage(named: "no_art@2x")
        }

        return image
    }()

    init(state: SpotifyConstants.PlayerState) {
        self.state = state
    }

    private func fetchAlbumArt(trackID: String) throws -> NSImage? {
        return try SpotifyConstants.WebAPI.Tracks(track:trackID).asURL()
            .flatMap { NSData(contentsOfURL: $0) }
            .flatMap { try grabTrackInfoAsJSON(fromData: $0) }
            .flatMap { grabAlbumImageURL(fromJSON: $0) }
            .flatMap { NSURL(string: $0) }
            .flatMap { NSImage(contentsOfURL: $0)  }
    }

    private func grabTrackInfoAsJSON(fromData data: NSData) throws -> NSDictionary? {
        return try NSJSONSerialization
                        .JSONObjectWithData(data,
                                            options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
    }

    private func grabAlbumImageURL(fromJSON json: NSDictionary) -> String? {
        guard let album = json["album"] as! NSDictionary?,
            images = album["images"] as! [NSDictionary]?
            else {
                return nil
        }

        return images
            .flatMap { AlbumImage(fromJSON: $0) }
            .sort( { $0.height > $1.height})
            .first?
            .url
    }

    private struct AlbumImage {
        let height: Int?
        let width: Int?
        let url: String?

        init(fromJSON json: NSDictionary) {
            height = json["height"] as! Int?
            width = json["width"] as! Int?
            url = json["url"] as! String?
        }
    }

}
