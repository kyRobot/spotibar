//
//  SpotibarViewController.swift
//  spotibar
//
//  Created by Kyle Milner on 06/09/2016.
//  Copyright © 2016 kyRobot. All rights reserved.
//

import Cocoa

class SpotibarViewController: NSViewController {

    @IBOutlet var trackNameLabel: NSTextField!
    @IBOutlet var artistLabel:  NSTextField!
    @IBOutlet var albumImg: NSImageView!

    var track: Track?
    var displayedTrack: String?
    var displayedAlbum: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        artistLabel.cell?.wraps = true
        artistLabel.cell?.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        trackNameLabel.cell?.wraps = true
        trackNameLabel.cell?.lineBreakMode = NSLineBreakMode.ByTruncatingTail
    }
    
    override func viewWillAppear() {
        refreshView()
    }

    func updateFromSpotify (track: Track) {
        self.track = track
        refreshView()
    }

    private func refreshView() {
        // no track, quick return
        guard let track = track,
                name = trackNameLabel,
                artist = artistLabel,
                art = albumImg
        else {
            return
        }

        // no track info, clean up
        if track.state == SpotifyConstants.PlayerState.Stopped ||
            track.state == SpotifyConstants.PlayerState.Paused{
            clear()
            return
        }

        // no change, do nothing
        if track.id == displayedTrack {
            return
        }

        // Do Updates

        if let newName = track.name {
            name.stringValue = newName
            name.toolTip = newName
        }

        if let newArtist = track.artist {
            artist.stringValue = newArtist
        }

        if let newAlbum = track.album {
            if newAlbum != displayedAlbum {
                let safe = newAlbum.stringByReplacingOccurrencesOfString(" ", withString: "+")
                art.image = NSURL(string: "https://placehold.it/250x250?text=\(safe)")
                    .flatMap { NSData(contentsOfURL: $0) }
                    .flatMap { NSImage(data: $0) }
            }
        }

        displayedTrack = track.id
        displayedAlbum = track.album


    }

    private func clear() {
        albumImg.image = nil
        artistLabel.stringValue = ""
        trackNameLabel.stringValue = ""
        trackNameLabel.toolTip = nil
        track = nil
        displayedAlbum = nil
        displayedTrack = nil
    }
    
}
