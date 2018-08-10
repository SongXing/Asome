//
//  YCDataUtils.h
//  YCSDK
//
//  Created by sunn on 2018/7/11.
//

#import <Foundation/Foundation.h>
@class YCPPPModel;

@interface YCDataUtils : NSObject

+ (void)cn_saveUserInfo:(NSDictionary *)dic;

+ (NSArray *)cn_getAllUserInfo;

+ (void)cn_saveLatestUserInfo:(NSDictionary *)dic;

+ (NSDictionary *)cn_getLatestUserInfo;

+ (void)cn_removeUserWithKey:(NSString *)key;

+ (void)cn_removeUserWithIndex:(NSUInteger)idx;

#pragma mark - 处理请求返回的用户列表

+ (void)yc_handleGoodNews:(NSDictionary *)dict;

+ (NSDictionary *)yc_getGoodNews;

+ (void)yc_handleReqUserList:(NSDictionary *)dict;

+ (NSArray *)yc_unarchUserList;

+ (void)yc_handleGuestLoginData:(NSDictionary *)dict;

+ (NSArray *)yc_unarchGuest;

+ (void)yc_handelNormalUser:(NSDictionary *)dict;

+ (NSArray *)yc_unarchNormalUser;

+ (void)yc_removeNormalUserWithIndex:(NSUInteger)idx;

#pragma mark - 处理请求返回的pay数据

+ (void)yc_handlePPP:(NSDictionary *)dict;

+ (YCPPPModel *)yc_getPPP;

#pragma mark - 处理 CDN 信息

+ (void)yc_handleCDNGoods:(NSDictionary *)dict;

+ (NSDictionary *)yc_getCDNGoods;


@end
