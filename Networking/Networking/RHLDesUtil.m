//
//  RHLDesUtil.m
//  Rehulu
//
//  Created by ZhangJie on 15/2/2.
//  Copyright (c) 2015年 Rehulu. All rights reserved.
//

#import "RHLDesUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Base64/MF_Base64Additions.h>

static NSString* sEncryKey = nil;
static const char _confuseTable[40] = {
    'r'^0x00,'a','X','Z',10,
    'H'^0x01,19,22,13,22,
    '!'^0x02,33,34,35,36,
    'I'^0x03,12,32,19,32,
    '@'^0x04,'a','*','C',80,
    's'^0x05,'L',':',';',80,
    '&'^0x06,'%',12,80,80,
    '^'^0x07,'7','/','~',80};

@interface RHLDesUtil()
+ (NSString *)doCipher:(NSString *)sTextIn key:(NSString *)sKey context:(CCOperation)encryptOrDecrypt;
@end

@implementation RHLDesUtil

+ (NSString *) getEncryKey:(NSString *)str
{
    if(sEncryKey){
        return sEncryKey;
    }
    
    //这些代码就是用来混淆常量
    if (!str){
        return nil;
    }
    
    NSUInteger length = [str length];
    if (length >= [@"" length]){
        length = 8;
    }
    
    NSMutableString *key = [[NSMutableString alloc] init];
    for (int i=0;i<length;i++) {
        [key appendFormat:@"%c",_confuseTable[i*5]^i];
    }
    sEncryKey = key;
    return sEncryKey;
}

+ (NSString *) encode:(NSString *)str key:(NSString *)key
{
    NSMutableString* encode = [NSMutableString stringWithString:[RHLDesUtil doCipher:str  key:key context:kCCEncrypt]];
    return encode;
}

+ (NSString *) decode:(NSString *)str key:(NSString *)key
{
    NSMutableString *str1 = [NSMutableString stringWithString:str];
    NSString *rt = [RHLDesUtil doCipher:str1 key:key context:kCCDecrypt];
    return rt;
}

+ (NSString *)doCipher:(NSString *)sTextIn key:(NSString *)sKey
               context:(CCOperation)encryptOrDecrypt {
    NSStringEncoding EnC = NSUTF8StringEncoding;
    
    NSMutableData *dTextIn;
    if (encryptOrDecrypt == kCCDecrypt) {
        dTextIn = [[NSData dataWithBase64String:sTextIn] mutableCopy];
    }
    else{
        dTextIn = [[sTextIn dataUsingEncoding: EnC] mutableCopy];
    }
    NSMutableData * dKey = [[sKey dataUsingEncoding:EnC] mutableCopy];
    [dKey setLength:kCCBlockSizeDES];
    uint8_t *bufferPtr1 = NULL;
    size_t bufferPtrSize1 = 0;
    size_t movedBytes1 = 0;
    bufferPtrSize1 = ([sTextIn length] + kCCKeySizeDES) & ~(kCCKeySizeDES -1);
    bufferPtr1 = malloc(bufferPtrSize1 * sizeof(uint8_t));
    memset((void *)bufferPtr1, 0x00, bufferPtrSize1);
    
    CCCrypt(encryptOrDecrypt, // CCOperation op
            kCCAlgorithmDES, // CCAlgorithm alg
            kCCOptionPKCS7Padding, // CCOptions options
            [dKey bytes], // const void *key
            [dKey length], // size_t keyLength //
            [dKey bytes], // const void *iv
            [dTextIn bytes], // const void *dataIn
            [dTextIn length],  // size_t dataInLength
            (void *)bufferPtr1, // void *dataOut
            bufferPtrSize1,     // size_t dataOutAvailable
            &movedBytes1);
    
    //[dTextIn release];
    //[dKey release];T
    
    NSString * sResult;
    if (encryptOrDecrypt == kCCDecrypt){
        sResult = [[NSString alloc] initWithData:[NSData dataWithBytes:bufferPtr1 length:movedBytes1] encoding:EnC];
        free(bufferPtr1);
    }
    else {
        NSData *dResult = [NSData dataWithBytes:bufferPtr1 length:movedBytes1];
        free(bufferPtr1);
        sResult = [dResult base64Encoding];
    }
    return sResult;
}
@end
