//
//  WYNetwork.m
//  Networking
//
//  Created by WangWei on 21/2/17.
//  Copyright © 2017年 BarryWang. All rights reserved.
//

#import "WYNetwork.h"
@interface WYNetwork()<NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionTaskDelegate>
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSMutableDictionary *dataResult;
@property (nonatomic, strong) NSMutableDictionary *successResult;
@property (nonatomic, strong) NSMutableDictionary *failResult;
@end

@implementation WYNetwork
+ (instancetype)shareInstance {
  
    static dispatch_once_t onceToken;
    static WYNetwork *networking;
    dispatch_once(&onceToken, ^{
        networking = [[WYNetwork alloc] init];
    });
    
    return networking;
}


- (WYNetwork *)init {
   
    if (self = [super init]) {
        
        _dataResult = [[NSMutableDictionary alloc] initWithCapacity:0];
        _successResult = [[NSMutableDictionary alloc] initWithCapacity:0];
        _failResult = [[NSMutableDictionary alloc] initWithCapacity:0];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
        self.session = session;
    }
    
    return  self;
}

- (NSURLSessionDataTask *)dataTaskWithUrl:(NSString *)url successHandler:(success)successHandler failHandler:(fail)failHandler {
   
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:[NSURL URLWithString:url]];
    self.successResult[dataTask] = successHandler;
    self.failResult[dataTask] = failHandler;
    self.dataResult[dataTask] = [NSMutableData data];
    [dataTask resume];
    return  dataTask;
}



- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    NSLog(@"%s======= %@",__FUNCTION__, [NSThread currentThread]);
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    NSLog(@"%s======= %@",__FUNCTION__, [NSThread currentThread]);
    NSMutableData *resultData = self.dataResult[dataTask];
    [resultData appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    NSLog(@"%s======= %@",__FUNCTION__, [NSThread currentThread]);
    NSLog(@"error = %@",error);
    NSLog(@"下载完成");
    if (error) {
        
        fail failHandler = self.failResult[task];
        if (failHandler) {
            failHandler(task, error);
        }
    } else {
        NSMutableData *resultData = self.dataResult[task];

        success successHandler = self.successResult[task];
        if (successHandler) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            successHandler(task, dict);
        }
        [self.dataResult removeObjectForKey:task];
        [self.successResult removeObjectForKey:task];
    }
}


@end
