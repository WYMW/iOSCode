//
//  WYNetworkingManager.m
//  Networking
//
//  Created by WangWei on 1/6/16.
//  Copyright © 2016年 BarryWang. All rights reserved.
//

#import "WYNetworkingManager.h"


#ifdef DEBUG
#define WYLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define WYLog( s, ... )
#endif

static NSString *identifier = @"WYNetworkingCache";

@interface WYNetworkingManager()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) NSURLSessionConfiguration *sessonConfig;
@property (nonatomic, strong) NSURL *basetUrl;
@end

@implementation WYNetworkingManager


+(WYNetworkingManager *)shareInstance {
    
    static WYNetworkingManager *shareInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareInstance = [[WYNetworkingManager alloc] init];
    });
    
    return shareInstance;
}

-(instancetype)init {
  
    if (self = [super init]) {
        
        NSString *cachePath = @"/WYNetworkingCache";
        
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *documentPath    = [documentPaths  objectAtIndex:0];
        
        NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
        
        NSString *fullCachePath = [documentPath stringByAppendingPathComponent:bundleIdentifier];
        WYLog(@"cachePath = %@", fullCachePath);

        
        NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:2 * 1024 * 1024
                                                                diskCapacity:100 * 1024 * 1024
                                                                    diskPath:cachePath];
        [NSURLCache setSharedURLCache:sharedCache];
        
        self.timeOutInterval = 60;
        
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.sessonConfig = configuration;
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
        self.sessionManager = manager;
        self.reachabilityStatus = 2;
        [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            
            self.reachabilityStatus = status;
            WYLog(@"The network status = %d", status);
            
        }];
        
        [manager.reachabilityManager startMonitoring];
        
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanCache) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    
    return  self;
}

-(void)setSSLCer:(NSString *)cerName {
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"cer"];
    if (cerPath) {
        
        NSData *certData = [NSData dataWithContentsOfFile:cerPath];
        [securityPolicy setAllowInvalidCertificates:NO];
        [securityPolicy setPinnedCertificates:[NSSet setWithObjects:certData, nil]];
        self.sessionManager.securityPolicy = securityPolicy;
        
    } else {
      
        WYLog(@"The certifiacation is not exits");
    }
    
    
}

-(void)setBaseUrl:(NSString *)urlString {
   
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    if ([[baseUrl path] length] > 0 && ![[baseUrl absoluteString] hasSuffix:@"/"]) {
        baseUrl = [baseUrl URLByAppendingPathComponent:@""];
    }
    
    self.basetUrl = baseUrl;

    
}

-(NSURLSessionDataTask *)POST:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      success:(WYSuccess) success
                      failure:(WYFailure)failure {
    
    return [self loadDataWithMethod:@"POST" urlString:URLString parameters:parameters timeOut:-1 loadCache:NO success:success failure:failure];
}

-(NSURLSessionDataTask *)POST:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
              timeoutInterval:(NSTimeInterval)timeoutInterval
                      success:(WYSuccess) success
                      failure:(WYFailure)failure {
    
   return [self loadDataWithMethod:@"POST" urlString:URLString parameters:parameters timeOut:timeoutInterval loadCache:NO success:success failure:failure];
    
}

-(NSURLSessionDataTask *)POST:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
              timeoutInterval:(NSTimeInterval)timeoutInterval
                    loadCache:(BOOL)locaCache
                      success:(WYSuccess) success
                      failure:(WYFailure)failure {
    
    return [self loadDataWithMethod:@"POST" urlString:URLString parameters:parameters timeOut:timeoutInterval loadCache:locaCache success:success failure:failure];
}


-(NSURLSessionDataTask *)GET:(NSString *)URLString
                  parameters:(NSDictionary *)parameters
                     success:(WYSuccess)success
                     failure:(WYFailure)failure {
    
    return [self loadDataWithMethod:@"GET" urlString:URLString parameters:parameters timeOut:- 1 loadCache:YES success:success failure:failure];
}

-(NSURLSessionDataTask *)GET:(NSString *)URLString
                  parameters:(NSDictionary *)parameters
               timeoutInteva:(NSTimeInterval)timeoutInterval
                     success:(WYSuccess)success
                     failure:(WYFailure)failure {
    
    return   [self loadDataWithMethod:@"GET" urlString:URLString parameters:parameters timeOut:timeoutInterval loadCache:YES success:success failure:failure];
}



-(NSURLSessionDataTask *)loadDataWithMethod:(NSString *)method
                                  urlString:(NSString *)URLString
                                 parameters:(NSDictionary *)parameters
                                    timeOut:(NSTimeInterval)timeOut
                                  loadCache:(BOOL)loadCache
                                    success:(WYSuccess)success
                                    failure:(WYFailure)failure {
    
    NSError *serializationError = nil;
    
    NSMutableURLRequest *request = [self.sessionManager.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.basetUrl] absoluteString] parameters:parameters error:&serializationError];
    
    if (timeOut == -1) {
        
        timeOut = self.timeOutInterval;
    }
    request.timeoutInterval = timeOut == 0 ? 1 : timeOut;
    
    if (serializationError) {
        
        failure(nil, serializationError);
    }
    
    if (self.reachabilityStatus == AFNetworkReachabilityStatusNotReachable && loadCache == YES) {
        
        
        request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
        
        
    } else {
        
        request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        
    }
    __block NSURLSessionDataTask *dataTask = nil;
    
    dataTask = [self.sessionManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        
        if (error) {
            
            if (failure) {
                
                failure(dataTask, error);
                
            }
        } else {
            
            if (success) {
                
                success(dataTask, responseObject);
            }
            
        }
        
    }];
    
    if (self.reachabilityStatus == AFNetworkReachabilityStatusNotReachable && loadCache == NO) {
        
        NSError *error = [NSError errorWithDomain:identifier code:-404 userInfo:@{NSLocalizedDescriptionKey:@"AFNetworkReachabilityStatusNotReachable"}];
        failure(dataTask, error);
        return dataTask;
    }
    
    [dataTask resume];
    
    return dataTask;
}


-(long long)getDiskCacheCapacity {
  
    
    return [NSURLCache sharedURLCache].diskCapacity;
}

-(void)cleanCache {
  
    return [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
}

-(void)cancel:(NSURLSessionDataTask *)task perform:(cancelBlock)perform {
  
    if (task.state == NSURLSessionTaskStateRunning ) {
        [task cancel];
        perform();
    }
}



@end
