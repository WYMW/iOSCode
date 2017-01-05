//
//  ViewController.swift
//  NSOperationDemo
//
//  Created by WangWei on 20/12/16.
//  Copyright © 2016年 WangWei. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let operation = ConOperation()
//
//        let queue = OperationQueue()
//        
//        queue.addOperation(operation)
        
        operation.start()        
        self.addObserver(self, forKeyPath: "isExecuting", options: NSKeyValueObservingOptions.new, context: nil)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        
        if keyPath == "isExecuting" {
            print(change?[NSKeyValueChangeKey.newKey] ?? 0)
            
        }
        
        print(change as Any)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

