//
//  FileDownloaderProtocol.swift
//  NVFileDownloader
//
//  Created by Norberto Vasconcelos on 02/05/2017.
//  Copyright © 2017 Norberto Vasconcelos. All rights reserved.
//

import Foundation

protocol FileDownloaderProtocol {
    
    // Download a list of URLs synchronously.
    static func syncDownload(urls: [URL])
    
    // Download a list of URLs asynchronously.
    static func asyncDownload(urls: [URL])
    
    // Cancel all downloads.
    func cancel()
}
