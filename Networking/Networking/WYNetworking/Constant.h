//
//  Constant.h
//  Networking
//
//  Created by WangWei on 22/2/17.
//  Copyright © 2017年 BarryWang. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

typedef void (^WYURLSessionTaskCompletionHandler)(NSURLResponse *response, id responseObject, NSError *error);
typedef void (^WYURLSessionTaskProgressBlock)(NSProgress *progress);
typedef NSURL* (^WYURLSessionDownloadTaskDidFinishDownloadingBlock)(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, NSURL *location);
#endif /* Constant_h */
