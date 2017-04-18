//
//  WYNetwork.h
//  Networking
//
//  Created by WangWei on 21/2/17.
//  Copyright © 2017年 BarryWang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^success)(NSURLSessionTask *task, NSDictionary *dict);
typedef void(^fail)(NSURLSessionTask *task, NSError *error);


@interface WYNetwork : NSObject
+ (instancetype)shareInstance;
- (NSURLSessionDataTask *)dataTaskWithUrl:(NSString *)url successHandler:(success)successHandler failHandler:(fail)failHandler;
@end
