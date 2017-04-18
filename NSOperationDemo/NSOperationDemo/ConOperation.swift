//
//  ConOperation.swift
//  NSOperationDemo
//
//  Created by WangWei on 20/12/16.
//  Copyright © 2016年 WangWei. All rights reserved.
//

import UIKit
import Foundation

enum OperationStatusError:Error {
  
    case isAlreadyExecuting
    case isAlreadyFinished
}


class ConOperation: Operation, URLSessionDelegate, URLSessionDownloadDelegate {
    
    var execut = false
    var finish = false
    var readystatus = true
    var downloadFolderPath:String?
    var downloadUrl:String
    
    init(downloadUrl:String) {
        
        self.downloadUrl = downloadUrl
        super.init()
    }
    
    override func start() {
     
        if (self.isCancelled) {
          
            self.willChangeValue(forKey: "isFinished")
            finish = true
            self.didChangeValue(forKey: "isFinished")
        }
        
        if (self.isExecuting) {
            
            print("The Operation is executing, can't start again");
            return;
        }
        
        if self.isFinished {
            
            print("The Operation had finished, can't start again");
            return;
        }
        

        Thread.detachNewThreadSelector(#selector(ConOperation.main), toTarget: self, with: nil)
        readystatus = false

        
        
    }
    
    override func main() {
        
        self.willChangeValue(forKey: "isExecuting")
        execut = true
        self.didChangeValue(forKey: "isExecuting")
       // self.downloadUrl = "https://rhl-ota.b0.upaiyun.com/app/rhl/ios/20161207/HotomatoChest.ipa"
        self.downLoadPicture(url:self.downloadUrl)
        self.complete()
        
    }
    

    
    override var isConcurrent: Bool {
      
        get {
          
            return true
        }
    }
    
    override var isExecuting: Bool {
      
        get {
          
            return execut
        }
    }
    
    override var isFinished: Bool {
      
        get {
          
            return finish
        }
    }
    
    override var isAsynchronous: Bool {
      
        get {
         
            return true
        }
    }
    
    func complete() {
        
        self.willChangeValue(forKey:"isExecuting")
        self.execut = false;
        self.didChangeValue(forKey: "isExecuting")
        
        self.willChangeValue(forKey: "isFinished")
        self.finish = true;
        self.didChangeValue(forKey: "isFinished")
        
    }
    
    
    
    func downLoadPicture(url:String) {
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: self,  delegateQueue: nil)
        let fileName = url.components(separatedBy: "/").last
        print("url = \(url)");
        let finalUrl = URL(string:url)
        let sessionDownloadTask = session.downloadTask(with: finalUrl!)
        
        sessionDownloadTask.resume()
    }
    
    //Download Delegate
     func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if self.downloadFolderPath == nil {
            self.downloadFolderPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
        }
        let fileManager = FileManager.default;
        let finalFilePath = self.downloadFolderPath!.appending("/\(self.downloadUrl!.components(separatedBy: "/").last!)")
        do {
        
            try fileManager.moveItem(at: location, to: URL(fileURLWithPath:finalFilePath))
            
        }catch {
        
        }
        
        
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64){
    
        print("bytesWritten = \(bytesWritten)");
        print("totalBytesWritten = \(totalBytesWritten)");
        print("totalBytesExpectedToWrite = \(totalBytesExpectedToWrite)");
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        print("error = \(error)");
    }
    
    
}
