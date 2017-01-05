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
        self.downLoadPicture(url: "http://img.mp.itc.cn/upload/20161228/50deee6d98604dae83d2aa066c4e0705_th.jpg")
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
    
    override var isReady: Bool {
      
        get {
         
            return false
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
        let url = URL(string:url)
        let sessionDownloadTask = session.downloadTask(with: url!)
        
        sessionDownloadTask.resume()
    }
    
    //Download Delegate
     func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        print("URL = \(location)")
        
        
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
