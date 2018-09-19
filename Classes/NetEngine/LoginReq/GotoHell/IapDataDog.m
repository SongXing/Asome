//
//  IapDataDog.m
//  YCSDK
//
//  Created by sunn on 2018/7/16.
//

#import "IapDataDog.h"
#import "YCIapInfo.h"
#import "HelloHeader.h"


@implementation IapDataDog

#pragma mark - 保存数据：某笔购买的参数

+(void)saveParameterDictionaryWithDictionary:(NSDictionary *)aDictionary
{
    NSMutableDictionary * tempDic=[[NSMutableDictionary alloc]initWithCapacity:2];
    for (NSString * key in aDictionary.allKeys)
    {
        if ([key isEqualToString:@"transactionReciptData"])
        {
            NSData * value                  = [aDictionary objectForKey:key];
            NSString * encryptKey           = [IapDataDog _iapEncryptFromString:key];
            NSString * encryptValue         = [SPSecurity getEncodeStringFromData:value];
            NSDictionary * oneKeyValueDic   = [NSDictionary dictionaryWithObject:encryptValue
                                                                          forKey:encryptKey];
            [tempDic addEntriesFromDictionary:oneKeyValueDic];
            continue;
        }
        NSString * value                    = [aDictionary objectForKey:key];
        NSString * encryptKey               = [IapDataDog _iapEncryptFromString:key];
        NSString * encryptValue             = [IapDataDog _iapEncryptFromString:value];
        NSDictionary * oneKeyValueDic       = [NSDictionary dictionaryWithObject:encryptValue
                                                                  forKey:encryptKey];
        [tempDic addEntriesFromDictionary:oneKeyValueDic];
    }
    [[NSUserDefaults standardUserDefaults]  setObject:tempDic forKey:SP_ONE_PURCHASE_INFO_KEY];
    [[NSUserDefaults standardUserDefaults]  synchronize];
}

#pragma mark - 获取本地某笔购买的参数

+ (NSDictionary *)getParameterDictionary
{
    NSDictionary * encryptDic       = [[NSUserDefaults standardUserDefaults] objectForKey:SP_ONE_PURCHASE_INFO_KEY];
    if (!encryptDic) {
        return nil;
    }
    NSMutableDictionary * tempDic   = [[NSMutableDictionary alloc] initWithCapacity:2];
    for (NSString * encryptKey in encryptDic.allKeys)
    {
        if ([encryptKey isEqualToString:[IapDataDog _iapEncryptFromString:@"transactionReciptData"]])
        {
            NSString * encryptValue=[encryptDic objectForKey:encryptKey];
            NSString * key=[IapDataDog _iapDecodeFromString:encryptKey];
            NSData * value=[SPSecurity getEncodeDataFromString:encryptValue];
            NSDictionary * oneKeyValueDic=[NSDictionary dictionaryWithObject:value forKey:key];
            [tempDic addEntriesFromDictionary:oneKeyValueDic];
            continue;
        }
        
        NSString * encryptValue=[encryptDic objectForKey:encryptKey];
        NSString * key=[IapDataDog _iapDecodeFromString:encryptKey];
        NSString * value=[IapDataDog _iapDecodeFromString:encryptValue];
        NSDictionary * oneKeyValueDic=[NSDictionary dictionaryWithObject:value forKey:key];
        [tempDic addEntriesFromDictionary:oneKeyValueDic];
    }
    return (NSDictionary *)tempDic ;
}

#pragma mark - 移除掉本地保存的某笔购买参数

+ (void)removeIapData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SP_ONE_PURCHASE_INFO_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Encrypt \ Decode

+ (NSString *)_iapEncryptFromString:(NSString *)aString
{
    return [SPSecurity getEncryptStringFromString:aString WithKey:@"YC_IAP" iv:@"iap"];
}

+ (NSString *)_iapDecodeFromString:(NSString *)aString
{
    return [SPSecurity getDecryptStringFromString:aString withKey:@"YC_IAP" iv:@"iap"];
}

+ (void)saveLostReceiveDataWithDict:(NSDictionary *)dict {
    NSArray *localAngles = [HelloUtils ycu_userdefault_getObjforKey:kLostAngles];
    NSMutableArray *mArr = @[].mutableCopy;
    !localAngles?:[mArr addObjectsFromArray:localAngles];
    [mArr addObject:dict];
    [HelloUtils ycu_userdefault_setObj:mArr key:kLostAngles];
}

+ (void)removeSuccessLostWithTransId:(NSString *)trs {
    NSArray *localAngles = [HelloUtils ycu_userdefault_getObjforKey:kLostAngles];
    NSMutableArray *mArr = [[NSMutableArray alloc] initWithArray:localAngles];
    for (NSDictionary *dict in localAngles) {
        if ([dict[@"transactionId"] isEqualToString:trs]) {
            NSLog(@"正在清除tranid: %@",trs);
            [mArr removeObject:dict];
        }
    }
    [HelloUtils ycu_userdefault_setObj:mArr key:kLostAngles];
}

@end
