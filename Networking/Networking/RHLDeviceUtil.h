//
//  RHLDeviceUtil
//  Rehulu
//
//  Created by ZhangJie on 14-4-14.
//  Copyright (c) 2014年 ZhangJie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RHLAppInfo : NSObject
@property (nonatomic, copy) NSString* appDSID;
@property (nonatomic, copy) NSString* storeMeta;
@property (nonatomic, assign) BOOL isFirstInstalled;
@end

@interface RHLDeviceUtil : NSObject

+ (NSString *)getAPNS;
+ (void)setAPNS:(NSString *)apns;

+ (NSString *)getUUID;
+ (NSString *)getDeviceModel;
+ (NSString *)getDeviceSysVer;
+ (NSString *)getCurVersionStr;
+ (NSString *)getCurVersionNum;
+ (NSString *)getDeviceIDFA;
+ (NSString *)getDeviceMac;
+ (NSInteger)getUserId;
+ (BOOL) isAdvertisingTrackingEnabled;
+ (void)setUserId:(NSInteger) userId;
+ (BOOL) isApplicationInstalled:(NSString*) bId;
+ (BOOL) openApplicationByBundleId:(NSString*) bId;
+ (NSArray*) allApplications;
+ (RHLAppInfo*) getAppInfoByBundleId:(NSString *) bId;
+ (void) sendLocalNotification:(NSString  *)alertBody ActionText:(NSString *)actionText UserInfo:(NSDictionary*) userInfo FireDate:(NSDate*) date;
@end
