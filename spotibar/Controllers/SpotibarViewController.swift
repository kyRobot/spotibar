//
//  SpotibarViewController.swift
//  spotibar
//
//  Created by Kyle Milner on 06/09/2016.
//  Copyright © 2016 kyRobot. All rights reserved.
//

import Cocoa

class SpotibarViewController: NSViewController, NSPopoverDelegate {

    @IBOutlet var trackNameLabel: NSTextField!
    @IBOutlet var artistLabel:  NSTextField!
    @IBOutlet var albumImg: NSImageView!

    var currentTrack: Track?
    var displayedAlbum: String?
    var getArt: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        artistLabel.cell?.wraps = true
//        artistLabel.cell?.lineBreakMode = NSLineBreakMode.ByTruncatingTail
//        trackNameLabel.cell?.wraps = true
//        trackNameLabel.cell?.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        albumImg.imageScaling = NSImageScaling.scaleProportionallyUpOrDown
    }

    func popoverWillShow(_ notification: Notification) {
        getArt = true
    }

    func popoverDidClose(_ notification: Notification) {
        getArt = false
    }

    override func viewWillAppear() {
        refreshView()
    }

    func updateFromSpotify (track: Track) {
        self.currentTrack = track
        refreshView()
    }

    fileprivate func refreshView() {
        // no track, or view not loaded yet. quick return
        guard let track = currentTrack,
                let name = trackNameLabel,
                let artist = artistLabel,
                let art = albumImg
        else {
            return
        }

        // no track info, clean up
        if track.state == SpotifyConstants.PlayerState.stopped ||
            track.state == SpotifyConstants.PlayerState.paused {
            reset()
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

        // art is external and 2 web calls, get it judiciously
        if let newAlbum = track.album {
            if newAlbum != displayedAlbum && getArt {
                art.image = track.art
                displayedAlbum = track.album
            }
        }
    }

    fileprivate func reset() {
        albumImg.image = nil
        artistLabel.stringValue = ""
        trackNameLabel.stringValue = ""
        trackNameLabel.toolTip = nil
        currentTrack = nil
        displayedAlbum = nil
    }
    
}
