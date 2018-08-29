//
//  IapDataDog.h
//  YCSDK
//
//  Created by sunn on 2018/7/16.
//

#import <Foundation/Foundation.h>

@interface IapDataDog : NSObject

//保存数据：某笔购买的参数
+(void)ycy_saveParameterDictionaryWithDictionary:(NSDictionary *)aDictionary;

//获取本地某笔购买的参数
+(NSDictionary *)ycy_getParameterDictionary;

//移除掉本地保存的某笔购买参数
+(void)ycy_removeIapData;

@end
