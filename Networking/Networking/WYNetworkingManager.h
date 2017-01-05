//
//  RHLNetworkingManager.h
//  Networking
//
//  Created by WangWei on 1/6/16.
//  Copyright © 2016年 BarryWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

/**
 * NSURLSessionDataTask recive success response to do
 *
 *  @param dataTask       dataTask which to request the data
 *  @param responseObject the response data
 */
typedef void(^WYSuccess)(NSURLSessionDataTask *dataTask, id responseObject);

/**
 * NSURLSessionDataTask recive fail response to do
 *
 *  @param dataTask       dataTask which to request the data
 *  @param responseObject the response data
 */
typedef void(^WYFailure)(NSURLSessionDataTask *dataTask, NSError *error);

/**
 *  To do when cancel the NSURLSessionDataTask
 */
typedef void (^cancelBlock)();

@interface WYNetworkingManager : NSObject
@property (nonatomic, assign) AFNetworkReachabilityStatus reachabilityStatus;
@property (nonatomic, assign) NSTimeInterval timeOutInterval;

+(WYNetworkingManager *)shareInstance;


/**
 *  To set the ssl certification
 *
 *  @param cerName the certification name without suffix, should be in main bundle
 */
-(void)setSSLCer:(NSString *)cerName;


/**
 *  set the baseUrl should be a domain. if set, all the url only need path.
 *
 *  @param urlString The domain for the baseUrl
 */
-(void)setBaseUrl:(NSString *)urlString;

/**
 *  Get the cache capacity
 *
 *  @return the bytes of capacity
 */
-(long long)getDiskCacheCapacity;
-(void)cleanCache;
/**
 *  Cancel the task if it is running
 *
 *  @param task    the task which you want to cancel
 *  @param perform to do some thing when cancel a taskTask
 */
-(void)cancel:(NSURLSessionDataTask *)task perform:(cancelBlock)perform;


/**
 *  Use the NSURLSessionDataTask to retrive data form server with Post
 *
 *  @param URLString       the URL For the data if you had set baseUrl ,it should be a relative path or it should be a complete url
 *  @param parameters      The dictionary for all the parameters
 *  @param timeoutInterval set the timeout inteval for the request
 *  @param locaCache       wheteher load reponse form  the cache
 *  @param success         when receive the success response  to do
 *  @param failure         when receive the fail response to do
 *
 *  @return return the dataTask which to retrive data from server
 */

-(NSURLSessionDataTask *)POST:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
              timeoutInterval:(NSTimeInterval)timeoutInterval
                    loadCache:(BOOL)locaCache
                      success:(WYSuccess) success
                      failure:(WYFailure)failure;

-(NSURLSessionDataTask *)POST:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      success:(WYSuccess) success
                      failure:(WYFailure)failure;

-(NSURLSessionDataTask *)POST:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
              timeoutInterval:(NSTimeInterval)timeoutInterval
                      success:(WYSuccess) success
                      failure:(WYFailure)failure;


/**
 *  Use the NSURLSessionDataTask to retrive data form server with GET, and the cache will be load automatically
 *
 *  @param URLString       the URL For the data if you had set baseUrl ,it should be a relative path or it should be a complete url
 *  @param parameters      The dictionary for all the parameters
 *  @param timeoutInterval set the timeout inteval for the request
 *  @param success         when receive the success response  to do
 *  @param failure         when receive the fail response to do
 *
 *  @return return the dataTask which to retrive data from server
 */

-(NSURLSessionDataTask *)GET:(NSString *)URLString
                  parameters:(NSDictionary *)parameters
               timeoutInteva:(NSTimeInterval)timeoutInterval
                     success:(WYSuccess)success
                     failure:(WYFailure)failure;


-(NSURLSessionDataTask *)GET:(NSString *)URLString
                  parameters:(NSDictionary *)parameters
                     success:(WYSuccess)success
                     failure:(WYFailure)failure;




@end
