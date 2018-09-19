//
//  IapDataDog.h
//  YCSDK
//
//  Created by sunn on 2018/7/16.
//

#import <Foundation/Foundation.h>

@interface IapDataDog : NSObject

//保存数据：某笔购买的参数
+(void)saveParameterDictionaryWithDictionary:(NSDictionary *)aDictionary;

//获取本地某笔购买的参数
+(NSDictionary *)getParameterDictionary;

//移除掉本地保存的某笔购买参数
+(void)removeIapData;

//保存掉单的数据，由于种种不可抗拒的因素，比如突然断网等
+ (void)saveLostReceiveDataWithDict:(NSDictionary *)dict;
//如果当比数据请求发货有响应了，在本地中去掉这个数据
+ (void)removeSuccessLostWithTransId:(NSString *)trs ;

@end
