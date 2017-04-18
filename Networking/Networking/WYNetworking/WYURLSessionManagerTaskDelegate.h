//
//  WYURLSessionManagerTaskDelegate.h
//  Networking
//
//  Created by WangWei on 21/2/17.
//  Copyright © 2017年 BarryWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYURLSessionManager.h"
#import "Constant.h"


@interface WYURLSessionManagerTaskDelegate : NSObject

@property (nonatomic, weak)   WYURLSessionManager *manager;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSProgress *uploadProgress;
@property (nonatomic, strong) NSProgress *downloadProgress;
@property (nonatomic, copy)   WYURLSessionTaskCompletionHandler completeHandler;
@property (nonatomic, copy)   WYURLSessionTaskProgressBlock uploadProgressBlock;
@property (nonatomic, copy)   WYURLSessionTaskProgressBlock downloadProgressBlock;
@property (nonatomic, copy)   WYURLSessionDownloadTaskDidFinishDownloadingBlock downloadFinishedBlock;
- (void)setupProgressForTask:(NSURLSessionTask *)task;
- (void)URLSession:(__unused NSURLSession *)session
          dataTask:(__unused NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data;
@end
