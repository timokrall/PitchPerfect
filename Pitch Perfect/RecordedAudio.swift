//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Timo Krall on 10/28/15.
//  Copyright © 2015 Timo Krall. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{

    var filePathUrl: NSURL!
    var title: String!
    
    // solved by looking up http://stackoverflow.com/questions/29688058/initializing-in-swift
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }

}