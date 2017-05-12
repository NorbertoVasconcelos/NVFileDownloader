//
//  Progress.swift
//  NVFileDownloader
//
//  Created by Norberto Vasconcelos on 02/05/2017.
//  Copyright © 2017 Norberto Vasconcelos. All rights reserved.
//

import Foundation

public class Progress {
    public var files: Dictionary<String, FileProgress>
    private var totalDownloadSize: Float = 0.0
    
    public init() {
        files = Dictionary<String, FileProgress>()
    }
    
    public func numberOfFiles() -> Int {
        return files.count
    }
    
    public func downloadSpeed() -> Float {
        var combinedDownloadSpeed: Float = 0.0
        for key in files.keys {
            let fp = files[key]
            combinedDownloadSpeed += fp?.downloadSpeed ?? 0
        }
        return combinedDownloadSpeed
    }
    
    public func downloadedBytes() -> Float {
        var combinedDownloaded: Float = 0.0
        for key in files.keys {
            let fp = files[key]
            combinedDownloaded += fp?.downloadedBytes ?? 0
        }
        return combinedDownloaded
    }
    
    // File functions
    public func addFile(_ file: FileProgress) {
        let urlString = String(describing: file.url)
        files[urlString] = file
    }
    
    public func removeFile(_ file: FileProgress) {
        let urlString = String(describing: file.url)
        files.removeValue(forKey: urlString)
    }
    
    public func updateFile(_ file: FileProgress) {
        let urlString = String(describing: file.url)
        let currentFile = files[urlString]
        if let cf = currentFile, cf.fileSize == 0 {
            totalDownloadSize += file.fileSize
        }
        files[urlString] = file
    }
    
    // Progress details
    public func details() -> String {
        return "Total Download Size: \(totalDownloadSize) \n Downloaded Bytes: \(downloadedBytes()) \n Download Speed: \(downloadSpeed())"
    }
}
