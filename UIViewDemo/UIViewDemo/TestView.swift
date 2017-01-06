//
//  TestView.swift
//  UIViewDemo
//
//  Created by WangWei on 6/1/17.
//  Copyright © 2017年 WangWei. All rights reserved.
//

import UIKit

class TestView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let view =  super.hitTest(point, with: event)

        print("hitTest")
        print("point = \(point)")
        print("event = \(event)")
        return view;
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    
        print("pointInside")
        print("point = \(point)")
        print("event = \(event)")
        return super.point(inside: point, with: event)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("come here touchesBegan")
    }
    
    func tap(){
        print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    }

}
