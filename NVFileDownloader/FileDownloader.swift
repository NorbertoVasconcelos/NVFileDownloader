//
//  FileDownloader.swift
//  NVFileDownloader
//
//  Created by Norberto Vasconcelos on 02/05/2017.
//  Copyright © 2017 Norberto Vasconcelos. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

public protocol FileDownloaderDelegate {
    func progressUpdate(progress: Progress)
    func downloadComplete(file: Data, fileUrl: String)
    func allDownloadsComplete()
}

public class FileDownloader: FileDownloaderProtocol {
    
    public static var delegate: FileDownloaderDelegate?
    private static var overallProgress: Progress = Progress()
    private static var downloadStack: Stack = Stack<FileProgress>()
    private static var executionLocked: Variable<Bool> = Variable(false)
    private static var disposeBag = DisposeBag()
    
    // Speed calculation variables
    private static var bytesAtStart: Double?
    private static var timeAtStart: Date?
    
    public static func syncDownload(urls: [URL]) {
        
        for url in urls {
            let fileProgress = FileProgress(url)
            downloadStack.push(fileProgress)
        }
        
        executionLocked
            .asObservable()
            .bind(onNext: {
                locked in
                print(locked)
            
                if !(locked as Bool) {
                    // Lock execution and download an item from the stack.
                    executionLocked.value = true
                    
                    if let fp = downloadStack.pop() {
                        overallProgress.addFile(fp)
                        downloadFileWithProgress(fileProgress: fp,
                                                 completed: {
                                                    data in
                                                    print("Downloaded a file.")
                                                    overallProgress.removeFile(fp)
                                                    executionLocked.value = false
                                                    self.delegate?.downloadComplete(file: data, fileUrl: fp.url.absoluteString)
                                                    if downloadStack.count == 0 {
                                                        self.delegate?.allDownloadsComplete()
                                                    }
                        })
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    public static func asyncDownload(urls: [URL]) {
//        let newProgress = Progress(urls: urls)
//        downloadQueue.append(newProgress)
//
//        for (index, _) in newProgress.files.enumerated() {
//            downloadFileWithProgress(progressIndex: downloadQueue.count - 1,
//                                     fileProgress: index,
//                                     completed: {
//                                        data in
//                                        print("Downloaded a file.")
//            })
//        }
    }
    
    // Cancel all downloads.
    public func cancel() {
        
    }
    
    // MARK: - Helper Methods
    private static func downloadFileWithProgress(fileProgress: FileProgress, completed: @escaping (Data) -> ()) {
        // Reset speed calculation variables
        timeAtStart = Date()
        bytesAtStart = 0.0
        
        Alamofire.request("http://\(fileProgress.url)")
            .downloadProgress(closure: { progress in
                
                let updatedFileProgress = FileProgress(fileProgress.url)
                updatedFileProgress.fileSize = Float(progress.totalUnitCount)
                updatedFileProgress.downloadedBytes = Float(progress.completedUnitCount)
                updatedFileProgress.downloadSpeed = calculateSpeed(bytesEnd: Double(progress.completedUnitCount))
                updatedFileProgress.percentage = Float(round(progress.fractionCompleted)*100)
                
                overallProgress.updateFile(updatedFileProgress)

                // Send progress to delegate.
                delegate?.progressUpdate(progress: overallProgress)
            })
            .responseData(completionHandler: {
                response in
                print(response)
                if let data = response.data {
                    completed(data)
                } else {
                    print("Failed to retrieve data.")
                }
                
            })
    }
    
    
    // Returns X per second.
    private static func calculateSpeed(bytesEnd: Double) -> Float {
        var bytesPerSecond = 0.0
        let timeAtEnd = Date()
        if let bat = bytesAtStart, let tat = timeAtStart {
            let deltaBytes = bytesEnd - bat
            let deltaTime = timeAtEnd.timeIntervalSince(tat)
            
            bytesPerSecond = deltaBytes/deltaTime
        }
        
        
        timeAtStart = timeAtEnd
        bytesAtStart = bytesEnd
        
        return Float(bytesPerSecond)
    }
    
    // Transforms given bytes into a more readable format:
    // GB/MB/KB or Bytes
    private static func transformBytes(_ bytes: Double) -> (Float, String) {
        let roundedBytes = Float(bytes)
        let gb = roundedBytes / 1073741824
        if gb >= 1 {
            return (gb, "GB")
        } else {
            let mb = roundedBytes / 1048576
            if mb >= 1 {
                return (mb, "MB")
            } else {
                let kb = roundedBytes / 1024
                if kb >= 1 {
                    return (kb, "KB")
                }
            }
        }
        
        return (roundedBytes, "Bytes")
    }
}
