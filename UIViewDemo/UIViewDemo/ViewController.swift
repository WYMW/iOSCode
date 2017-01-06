//
//  ViewController.swift
//  UIViewDemo
//
//  Created by WangWei on 6/1/17.
//  Copyright © 2017年 WangWei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.\
    
        
        let view1 = TestView(frame:CGRect(x:20, y:20, width:100, height:100))
        view1.backgroundColor = UIColor.red
        self.view .addSubview(view1)
        
        let tapRecongnize = UITapGestureRecognizer(target:self, action:#selector(ViewController.tap))
        self.view.addGestureRecognizer(tapRecongnize)
        
    }
    
    func tap(){
        print("点解了")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

