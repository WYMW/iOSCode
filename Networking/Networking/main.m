//
//  main.m
//  Networking
//
//  Created by WangWei on 1/6/16.
//  Copyright © 2016年 BarryWang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    

    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}

void testSync()
{
    NSObject* obj = [NSObject new];
    @synchronized (obj) {
        
    }
}
