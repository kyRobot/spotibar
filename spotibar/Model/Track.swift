//
//  Track.swift
//  spotibar
//
//  Created by Kyle Milner on 08/09/2016.
//  Copyright © 2016 kyRobot. All rights reserved.
//

import Foundation
import Cocoa

open class Track : NSObject {

    let state: SpotifyConstants.PlayerState

    var id, name, artist, album : String?

    lazy var art: NSImage? = { () -> NSImage? in

        guard let trackID = self.id,
                  let image = try? self.fetchAlbumArt(trackID: trackID) else {
            return NSImage(named: "no_art@2x")
        }

        return image
    }()

    init(state: SpotifyConstants.PlayerState) {
        self.state = state
    }

    fileprivate func fetchAlbumArt(trackID: String) throws -> NSImage? {
        return try SpotifyConstants.WebAPI.Tracks(track:trackID).asURL()
            .flatMap { try Data(contentsOf: $0 as URL) }
            .flatMap { try grabTrackInfoAsJSON(fromData: $0) }
            .flatMap { grabAlbumImageURL(fromJSON: $0) }
            .flatMap { URL(string: $0) }
            .flatMap { NSImage(contentsOf: $0)  }
    }

    fileprivate func grabTrackInfoAsJSON(fromData data: Data) throws -> NSDictionary? {
        return try JSONSerialization
                        .jsonObject(with: data,
                                            options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
    }

    fileprivate func grabAlbumImageURL(fromJSON json: NSDictionary) -> String? {
        guard let album = json["album"] as! NSDictionary?,
            let images = album["images"] as! [NSDictionary]?
            else {
                return nil
        }

        return images
            .flatMap { AlbumImage(fromJSON: $0) }
            .sorted( by: { $0.height! > $1.height!})
            .first?
            .url
    }

    fileprivate struct AlbumImage {
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
