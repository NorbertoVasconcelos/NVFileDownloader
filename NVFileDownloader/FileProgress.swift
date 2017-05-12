//
//  FileProgress.swift
//  NVFileDownloader
//
//  Created by Norberto Vasconcelos on 02/05/2017.
//  Copyright © 2017 Norberto Vasconcelos. All rights reserved.
//

import Foundation

public class FileProgress {
    public var url: URL
    public var downloadedBytes: Float
    public var downloadSpeed: Float
    public var fileSize: Float
    public var percentage: Float
    
    public init(_ url: URL) {
        self.url = url
        self.fileSize = 0.0
        self.downloadedBytes = 0.0
        self.downloadSpeed = 0.0
        self.percentage = 0.0
    }
    
    public init(url: URL, downloadedBytes: Float, downloadSpeed: Float, fileSize: Float, percentage: Float) {
        self.url = url
        self.fileSize = fileSize
        self.downloadedBytes = downloadedBytes
        self.downloadSpeed = downloadSpeed
        self.percentage = percentage
    }
}
