//
//  WYURLSessionManagerTaskDelegate.m
//  Networking
//
//  Created by WangWei on 21/2/17.
//  Copyright © 2017年 BarryWang. All rights reserved.
//
#include <notify.h>

#import "WYURLSessionManagerTaskDelegate.h"

@interface WYURLSessionManagerTaskDelegate()


@end

@implementation WYURLSessionManagerTaskDelegate

- (instancetype)init {
  
    if (self = [super init]) {
        
        self.data = [NSMutableData data];
        
        self.uploadProgress = [[NSProgress alloc] initWithParent:nil userInfo:nil];
        self.uploadProgress.totalUnitCount = NSURLSessionTransferSizeUnknown;
        
        self.downloadProgress = [[NSProgress alloc] initWithParent:nil userInfo:nil];
        self.downloadProgress.totalUnitCount = NSURLSessionTransferSizeUnknown;
        
        notify_post("1234");
    }
    
    return  self;
}

#pragma mark - NSProgress Tracking

- (void)setupProgressForTask:(NSURLSessionTask *)task {
  
    __weak typeof(task) weakTask = task;
    
    self.uploadProgress.totalUnitCount = task.countOfBytesExpectedToSend;
    self.downloadProgress.totalUnitCount = task.countOfBytesExpectedToReceive;
    [self.uploadProgress setCancellable:YES];
    [self.uploadProgress setCancellationHandler:^{
        
        typeof(task) strongTask = weakTask;
        [strongTask cancel];
    }];
    [self.uploadProgress setPausable:YES];
    [self.uploadProgress setPausingHandler:^{
        __typeof__(weakTask) strongTask = weakTask;
        [strongTask suspend];
    }];
    if ([self.uploadProgress respondsToSelector:@selector(setResumingHandler:)]) {
        [self.uploadProgress setResumingHandler:^{
            __typeof__(weakTask) strongTask = weakTask;
            [strongTask resume];
        }];
    }
    
    [self.downloadProgress setCancellable:YES];
    [self.downloadProgress setCancellationHandler:^{
        __typeof__(weakTask) strongTask = weakTask;
        [strongTask cancel];
    }];
    [self.downloadProgress setPausable:YES];
    [self.downloadProgress setPausingHandler:^{
        __typeof__(weakTask) strongTask = weakTask;
        [strongTask suspend];
    }];
    
    if ([self.downloadProgress respondsToSelector:@selector(setResumingHandler:)]) {
        [self.downloadProgress setResumingHandler:^{
            __typeof__(weakTask) strongTask = weakTask;
            [strongTask resume];
        }];
    }
    
    [task addObserver:self
           forKeyPath:NSStringFromSelector(@selector(countOfBytesReceived))
              options:NSKeyValueObservingOptionNew
              context:NULL];
    
    [task addObserver:self
           forKeyPath:NSStringFromSelector(@selector(countOfBytesExpectedToReceive))
              options:NSKeyValueObservingOptionNew
              context:NULL];
    
    [task addObserver:self
           forKeyPath:NSStringFromSelector(@selector(countOfBytesSent))
              options:NSKeyValueObservingOptionNew
              context:NULL];
    [task addObserver:self
           forKeyPath:NSStringFromSelector(@selector(countOfBytesExpectedToSend))
              options:NSKeyValueObservingOptionNew
              context:NULL];
    
    [self.downloadProgress addObserver:self
                            forKeyPath:NSStringFromSelector(@selector(fractionCompleted))
                               options:NSKeyValueObservingOptionNew
                               context:NULL];
    [self.uploadProgress addObserver:self
                          forKeyPath:NSStringFromSelector(@selector(fractionCompleted))
                             options:NSKeyValueObservingOptionNew
                             context:NULL];
    
}

#pragma mark --NSURLSessionDataTaskDelegate

- (void)URLSession:(__unused NSURLSession *)session
          dataTask:(__unused NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    
    [self.data appendData:data];
}


- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionTask *)dataTask
didCompleteWithError:(NSError *)error {

    if(self.completeHandler) {
      
    }
}



@end
