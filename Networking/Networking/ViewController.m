//
//  ViewController.m
//  Networking
//
//  Created by WangWei on 1/6/16.
//  Copyright © 2016年 BarryWang. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"
#import "WYNetwork.h"
#import "ThirdViewController.h"
#import "WYURLSessionManager.h"
#define url "http://api.rfq.mobi/gdg-api/task/getbanner.json"
#define url2 "http://api.rfq.mobi/gdg-api/comicsound/listcomic.json?start=0&size=100"

@interface ViewController ()<NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionTaskDelegate>
@property (weak, nonatomic) IBOutlet UIButton *click;
@property (nonatomic, strong) NSMutableData *data;
@end

@implementation ViewController

- (IBAction)push:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://mp.weixin.qq.com/mp/profile_ext?action=home&__biz=MzI0MzY0ODM3Nw==&scene=124#wechat_redirect"]];

    //[self.navigationController pushViewController:[[ThirdViewController alloc] init] animated:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSLog(@"%s======= %@",__FUNCTION__, [NSThread currentThread]);
    
//    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
//    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:@url]];
//    [dataTask resume];
    

    
    [[WYNetwork shareInstance] dataTaskWithUrl:@url2 successHandler:^(NSURLSessionTask *task, NSDictionary *dict) {
        
        NSLog(@"url2 = %@",dict);
        
    } failHandler:^(NSURLSessionTask *task, NSError *error) {
        
        NSLog(@"%@",error.localizedDescription);
    }];
//
//

//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@url]];
//    WYURLSessionManager *manager =  [[WYURLSessionManager alloc] init];
//    [manager dataTaskWithRequest:request completeHandler:^(NSURLResponse * _Nonnull response, id  _Nonnull responseObeject, NSError * _Nonnull error) {
//        
//        NSLog(@"%@",response);
//    }];
//    
//    [manager dataTaskWithRequest:request completeHandler:^(NSURLResponse * _Nonnull response, id  _Nonnull responseObeject, NSError * _Nonnull error) {
//        
//        NSLog(@"%@",response);
//    }];
    
 dispatch_async(dispatch_get_main_queue(), ^{
     
 });

}


- (void)viewWillAppear:(BOOL)animated {
      
    
}

- (void)getSuccess:(void(^)(void))success {
  
    success();
}
- (void)dealloc {

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
