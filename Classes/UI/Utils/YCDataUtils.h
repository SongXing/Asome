//
//  YCDataUtils.h
//  YCSDK
//
//  Created by sunn on 2018/7/11.
//

#import <Foundation/Foundation.h>
@class YCPPPModel;

@interface YCDataUtils : NSObject

+ (void)ycc_saveUserInfo:(NSDictionary *)dic;

+ (NSArray *)ycc_getAllUserInfo;

+ (void)ycc_saveLatestUserInfo:(NSDictionary *)dic;

+ (NSDictionary *)ycc_getLatestUserInfo;

+ (void)ycc_removeUserWithKey:(NSString *)key;

+ (void)ycc_removeUserWithIndex:(NSUInteger)idx;

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

+ (NSDictionary *)ycy_getCDNGoods;


@end
