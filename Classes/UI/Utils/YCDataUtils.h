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

+ (void)ycd_handleGoodNews:(NSDictionary *)dict;

+ (NSDictionary *)ycd_getGoodNews;

+ (void)ycd_handleReqUserList:(NSDictionary *)dict;

+ (NSArray *)ycd_unarchUserList;

+ (void)ycd_handleGuestLoginData:(NSDictionary *)dict;

+ (NSArray *)ycd_unarchGuest;

+ (void)ycd_handelNormalUser:(NSDictionary *)dict;

+ (NSArray *)ycd_unarchNormalUser;

+ (void)ycd_removeNormalUserWithIndex:(NSUInteger)idx;

#pragma mark - 处理请求返回的pay数据

+ (void)ycd_handlePPP:(NSDictionary *)dict;

+ (YCPPPModel *)ycd_getPPP;

#pragma mark - 处理 CDN 信息

+ (void)ycd_handleCDNGoods:(NSDictionary *)dict;

+ (NSDictionary *)yc_getCDNGoods;

#pragma mark - 处理 CS 信息

+ (void)ycd_handleCsData:(NSDictionary *)dict;
+ (NSString *)ycd_getCsQq;
+ (NSString *)ycd_getCsTel;

@end
