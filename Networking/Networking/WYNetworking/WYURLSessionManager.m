//
//  WYURLSessionManager.m
//  Networking
//
//  Created by WangWei on 21/2/17.
//  Copyright © 2017年 BarryWang. All rights reserved.
//

#import "WYURLSessionManager.h"
#import "WYURLSessionManagerTaskDelegate.h"

typedef NSURLSessionResponseDisposition (^WYURLSessionDataTaskDidReceiveResponseBlock)(NSURLSession *session, NSURLSessionDataTask *dataTask, NSURLResponse *response);
typedef void (^WYURLSessionDataTaskDidReceiveDataBlock)(NSURLSession *session, NSURLSessionDataTask *dataTask, NSData *data);


static NSString * const WYURLSessionManagerLockName = @"com.alamofire.networking.session.manager.lock";

static dispatch_queue_t  url_session_manager_creation_queue() {
  
    static dispatch_queue_t wy_url_session_manager_creation_queue;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        wy_url_session_manager_creation_queue = dispatch_queue_create("com.alamofire.networking.session.manager.creation", DISPATCH_QUEUE_SERIAL);
    });
    
    return wy_url_session_manager_creation_queue;
}

static void url_session_manager_create_task_safely(dispatch_block_t block) {
    
    if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0 ) {
    
        dispatch_sync(url_session_manager_creation_queue(), block);
        
    } else {
      
        block();
    }
    
}

@interface WYURLSessionManager()
@property (readwrite, nonatomic, strong) NSMutableDictionary *mutableTaskDelegatesKeyedByTaskIdentifier;
@property (readonly, nonatomic, copy) NSString *taskDescriptionForSessionTasks;
@property (readwrite, nonatomic, strong) NSLock *lock;
@property (nonatomic, copy) WYURLSessionDataTaskDidReceiveResponseBlock dataTaskDidReceiveResponse;
@property (nonatomic, copy) WYURLSessionDataTaskDidReceiveDataBlock dataTaskDidReceiveData;
@end




@implementation WYURLSessionManager

- (instancetype)init{
    
    return [self initWithSessionConfig:nil];
}

- (instancetype)initWithSessionConfig:(NSURLSessionConfiguration *)config {
  
    if (self = [super init]) {
        
        if (!config) {
            config = [NSURLSessionConfiguration defaultSessionConfiguration];
        }
        self.config = config;
        
        self.delegateQueue = [[NSOperationQueue alloc] init];
        self.delegateQueue.maxConcurrentOperationCount = 1;
        self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:self.delegateQueue];
        self.mutableTaskDelegatesKeyedByTaskIdentifier = [[NSMutableDictionary alloc] initWithCapacity:0];
        self.lock = [[NSLock alloc] init];
        self.lock.name = WYURLSessionManagerLockName;
        
        [self.session getTasksWithCompletionHandler:^(NSArray<NSURLSessionDataTask *> * _Nonnull dataTasks, NSArray<NSURLSessionUploadTask *> * _Nonnull uploadTasks, NSArray<NSURLSessionDownloadTask *> * _Nonnull downloadTasks) {
            
            for (NSURLSessionDataTask *dataTask in dataTasks) {
                
                [self addWYDelegateForDataTask:dataTask uploadProgress:nil downloadProgress:nil completeHandler:nil];
            }
            
            for (NSURLSessionUploadTask *uploadTask in uploadTasks) {
                
                [self addWYDelegateForUploadDataTask:uploadTask uploadProgress:nil completeHandler:nil];
            }
            
            for (NSURLSessionDownloadTask *downloadTask in downloadTasks) {
                
                [self addWYDelegateForDownloadTask:downloadTask destination:nil downloadProgress:nil complete:nil];
            }
            
        }];
        
        
        
    }
    return self;
}

- (NSString *)taskDescriptionForSessionTasks {
      
    return  [NSString stringWithFormat:@"%p", self];
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completeHandler:(void(^)(NSURLResponse *response, id responseObeject, NSError *error)) completeHandler {
  
    return  [self dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completeHandler:completeHandler];
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                               uploadProgress:(nullable void(^)(NSProgress *uploadProgress)) uploadProgressBlock
                             downloadProgress:(nullable void(^)(NSProgress *downloadProgress)) downloadProgressBlock
                              completeHandler:(nullable void(^)(NSURLResponse *response, id _Nullable responseObject, NSError * _Nullable error)) completeHandler {
  
    __block NSURLSessionDataTask *dataTask = nil;
    url_session_manager_create_task_safely(^{
        
        dataTask = [self.session dataTaskWithRequest:request];
        
    });
    [self addWYDelegateForDataTask:dataTask uploadProgress:uploadProgressBlock downloadProgress:downloadProgressBlock completeHandler:completeHandler];
    
    return dataTask;
    
}

- (WYURLSessionManagerTaskDelegate *)delegateForTask:(NSURLSessionTask *)task {
    NSParameterAssert(task);
    
    WYURLSessionManagerTaskDelegate *delegate = nil;
    [self.lock lock];
    delegate = self.mutableTaskDelegatesKeyedByTaskIdentifier[@(task.taskIdentifier)];
    [self.lock unlock];
    
    return delegate;
}

- (void)setUrlSessionDelegate:(WYURLSessionManagerTaskDelegate *)delegate forTask:(NSURLSessionTask *)task {
   
    NSParameterAssert(delegate);
    NSParameterAssert(task);
    [self.lock lock];
    self.mutableTaskDelegatesKeyedByTaskIdentifier[@(task.taskIdentifier)] = delegate;
    [self.lock unlock];
}

- (void)addWYDelegateForDataTask:(NSURLSessionDataTask *)dataTask
                  uploadProgress:(nullable void(^)(NSProgress *uploadProgress)) uploadProgressBlock
                downloadProgress:(nullable void(^)(NSProgress *downloadProgress)) downloadProgressBlock
                 completeHandler:(nullable void(^)(NSURLResponse *response, id _Nullable responseObject, NSError * _Nullable error)) completeHandler{
  
    WYURLSessionManagerTaskDelegate *delegate = [[WYURLSessionManagerTaskDelegate alloc] init];
    delegate.manager = self;
    delegate.completeHandler = completeHandler;
    
    delegate.uploadProgressBlock = uploadProgressBlock;
    delegate.downloadProgressBlock = downloadProgressBlock;
    dataTask.taskDescription = self.taskDescriptionForSessionTasks;
    
    
    NSLog(@"taskDescription ==== %@",self.taskDescriptionForSessionTasks);
    [self setUrlSessionDelegate:delegate forTask:dataTask];
}

- (void)addWYDelegateForUploadDataTask:(NSURLSessionUploadTask *)uploadTask
                        uploadProgress:(nullable void(^)(NSProgress *uploadProgress)) uploadProgressBlock
                       completeHandler:(nullable void(^)(NSURLResponse *response, id _Nullable responseObject, NSError * _Nullable error)) completeHandler{
    
    WYURLSessionManagerTaskDelegate *delegate = [[WYURLSessionManagerTaskDelegate alloc] init];
    delegate.manager = self;
    delegate.completeHandler = completeHandler;
    
    delegate.uploadProgressBlock = uploadProgressBlock;
    uploadTask.taskDescription = self.taskDescriptionForSessionTasks;
    
    NSLog(@"taskDescription ==== %@",self.taskDescriptionForSessionTasks);
    [self setUrlSessionDelegate:delegate forTask:uploadTask];
}

- (void)addWYDelegateForDownloadTask:(NSURLSessionDownloadTask *)downloadTask
                         destination:(NSURL * (^)(NSURL* targetPath, NSURLResponse *response))destination
                    downloadProgress:(nullable void(^)(NSProgress *downloadProgress)) downloadProgressBlock
                            complete:(void (^)(NSURLResponse *response, id  responseObject, NSError *error))completeHandler{
    
    WYURLSessionManagerTaskDelegate *delegate = [[WYURLSessionManagerTaskDelegate alloc] init];
    delegate.manager = self;
    delegate.completeHandler = completeHandler;
    if (destination) {
        
        delegate.downloadFinishedBlock = ^NSURL *(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, NSURL *location){
          
            return destination(location, downloadTask.response);
        };
    }
    
    delegate.downloadProgressBlock = downloadProgressBlock;
    [self setUrlSessionDelegate:delegate forTask:downloadTask];
}


- (NSArray *)taskForKeyPath:(NSString *)keyPath {
    
    __block NSArray *array = nil;
    [self.session getTasksWithCompletionHandler:^(NSArray<NSURLSessionDataTask *> * _Nonnull dataTasks, NSArray<NSURLSessionUploadTask *> * _Nonnull uploadTasks, NSArray<NSURLSessionDownloadTask *> * _Nonnull downloadTasks) {
        
        if ([keyPath isEqualToString:NSStringFromSelector(@selector(dataTasks))]) {
            
            array = dataTasks;
            
        } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(uploadTasks))]){
        
            array = uploadTasks;
            
        }else if ([keyPath isEqualToString:@"downloadTasks"]){
          
            array = downloadTasks;
            
        } else if ([keyPath isEqualToString:@"tasks"]){
          
            array = [@[dataTasks, uploadTasks, downloadTasks] valueForKeyPath:@"@unionOfArrays.self"];
            
        }
        
    }];
    
    return array;
}

//- (NSArray *)tasks {
//  
//    
//}



#pragma mark Set
- (void)setDataTaskDidReceiveResponseBlock:(NSURLSessionResponseDisposition (^)(NSURLSession * _Nonnull, NSURLSessionDataTask * _Nonnull, NSURLResponse * _Nonnull))block {
   
    self.dataTaskDidReceiveResponse = block;
}
- (void)setDataTaskDidReceiveDataBlock:(void (^)(NSURLSession *session, NSURLSessionDataTask *dataTask, NSData *data))block {
    
    self.dataTaskDidReceiveData = block;
}


#pragma mark --NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error {
    
    WYURLSessionManagerTaskDelegate *delegate = [self delegateForTask:task];
    
    // delegate may be nil when completing a task in the background
}

#pragma mark --NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
  
    NSURLSessionResponseDisposition position = NSURLSessionResponseAllow;
    if (self.dataTaskDidReceiveResponse) {
        position = self.dataTaskDidReceiveResponse(session, dataTask, response);
    }
    
    if(completionHandler) {
    
        completionHandler(position);
    }
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    
    WYURLSessionManagerTaskDelegate *delegate = [self delegateForTask:dataTask];
    if ([delegate respondsToSelector:@selector(URLSession:dataTask:didReceiveData:)]) {
        [delegate URLSession:session dataTask:dataTask didReceiveData:data];
    }
  
    if (self.dataTaskDidReceiveData) {
        self.dataTaskDidReceiveData(session, dataTask, data);
    }

}




@end
