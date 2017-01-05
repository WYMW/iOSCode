//
//  ViewController.m
//  Networking
//
//  Created by WangWei on 1/6/16.
//  Copyright © 2016年 BarryWang. All rights reserved.
//

#import "ViewController.h"
#import "WYNetworkingManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    pasteBoard.string = @"1234";
    
    [[WYNetworkingManager shareInstance] setBaseUrl:@"http://api.rfq.mobi"];
//    
    [[WYNetworkingManager shareInstance] POST:@"/gdg-api/comicsound/listcomic.json" parameters:@{@"start":@"0", @"size":@"100"} timeoutInterval:-1 loadCache:NO success:^(NSURLSessionDataTask *dataTask, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        
        NSLog(@"error");
    }];
    
    
//    [[WYNetworkingManager shareInstance] POST:@"/comicsound/listcomic.json" parameters:@{@"start":@"0", @"size":@"100"} success:^(NSURLSessionDataTask *dataTask, id responseObject) {
//        
//        NSLog(@"%@", responseObject);
//
//        
//    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
//        
//        NSLog(@"%@", error);
//
//    }];
//
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
