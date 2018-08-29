//
//  IapDataDog.m
//  YCSDK
//
//  Created by sunn on 2018/7/16.
//

#import "IapDataDog.h"
#import "YCIapInfo.h"

@implementation IapDataDog

#pragma mark - 保存数据：某笔购买的参数

+(void)ycy_saveParameterDictionaryWithDictionary:(NSDictionary *)aDictionary
{
    NSMutableDictionary * tempDic=[[NSMutableDictionary alloc]initWithCapacity:2];
    for (NSString * key in aDictionary.allKeys)
    {
        if ([key isEqualToString:@"transactionReciptData"])
        {
            NSData * value                  = [aDictionary objectForKey:key];
            NSString * encryptKey           = [IapDataDog ycy_iapEncryptFromString:key];
            NSString * encryptValue         = [SPSecurity getEncodeStringFromData:value];
            NSDictionary * oneKeyValueDic   = [NSDictionary dictionaryWithObject:encryptValue
                                                                          forKey:encryptKey];
            [tempDic addEntriesFromDictionary:oneKeyValueDic];
            continue;
        }
        NSString * value                    = [aDictionary objectForKey:key];
        NSString * encryptKey               = [IapDataDog ycy_iapEncryptFromString:key];
        NSString * encryptValue             = [IapDataDog ycy_iapEncryptFromString:value];
        NSDictionary * oneKeyValueDic       = [NSDictionary dictionaryWithObject:encryptValue
                                                                  forKey:encryptKey];
        [tempDic addEntriesFromDictionary:oneKeyValueDic];
    }
    [[NSUserDefaults standardUserDefaults]  setObject:tempDic forKey:SP_ONE_PURCHASE_INFO_KEY];
    [[NSUserDefaults standardUserDefaults]  synchronize];
}

#pragma mark - 获取本地某笔购买的参数

+ (NSDictionary *)ycy_getParameterDictionary
{
    NSDictionary * encryptDic       = [[NSUserDefaults standardUserDefaults] objectForKey:SP_ONE_PURCHASE_INFO_KEY];
    if (!encryptDic) {
        return nil;
    }
    NSMutableDictionary * tempDic   = [[NSMutableDictionary alloc] initWithCapacity:2];
    for (NSString * encryptKey in encryptDic.allKeys)
    {
        if ([encryptKey isEqualToString:[IapDataDog ycy_iapEncryptFromString:@"transactionReciptData"]])
        {
            NSString * encryptValue=[encryptDic objectForKey:encryptKey];
            NSString * key=[IapDataDog ycy_iapDecodeFromString:encryptKey];
            NSData * value=[SPSecurity getEncodeDataFromString:encryptValue];
            NSDictionary * oneKeyValueDic=[NSDictionary dictionaryWithObject:value forKey:key];
            [tempDic addEntriesFromDictionary:oneKeyValueDic];
            continue;
        }
        
        NSString * encryptValue=[encryptDic objectForKey:encryptKey];
        NSString * key=[IapDataDog ycy_iapDecodeFromString:encryptKey];
        NSString * value=[IapDataDog ycy_iapDecodeFromString:encryptValue];
        NSDictionary * oneKeyValueDic=[NSDictionary dictionaryWithObject:value forKey:key];
        [tempDic addEntriesFromDictionary:oneKeyValueDic];
    }
    return (NSDictionary *)tempDic ;
}

#pragma mark - 移除掉本地保存的某笔购买参数

+ (void)ycy_removeIapData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SP_ONE_PURCHASE_INFO_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Encrypt \ Decode

+ (NSString *)ycy_iapEncryptFromString:(NSString *)aString
{
    return [SPSecurity getEncryptStringFromString:aString WithKey:@"YC_IAP" iv:@"iap"];
}

+ (NSString *)ycy_iapDecodeFromString:(NSString *)aString
{
    return [SPSecurity getDecryptStringFromString:aString withKey:@"YC_IAP" iv:@"iap"];
}

@end
