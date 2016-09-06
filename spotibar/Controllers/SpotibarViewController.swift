//
//  SpotibarViewController.swift
//  spotibar
//
//  Created by Kyle Milner on 06/09/2016.
//  Copyright © 2016 kyRobot. All rights reserved.
//

import Cocoa

class SpotibarViewController: NSViewController {

    @IBOutlet var artistLabel:  NSTextField!
    @IBOutlet var albumImg: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        updateFromSpotify()
    }
    
    func updateFromSpotify () {
        artistLabel.stringValue = "Artist Name"
        albumImg.image = NSURL(string: "https://placehold.it/250x250")
            .flatMap { NSData(contentsOfURL: $0) }
            .flatMap { NSImage(data: $0) }
    }
    
}
