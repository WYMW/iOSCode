//
//  main.m
//  SYNC
//
//  Created by WangWei on 5/4/17.
//  Copyright © 2017年 rehulu. All rights reserved.
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
