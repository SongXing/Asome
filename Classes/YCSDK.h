//
//  YCSDK.h
//  YCSDK
//
//  Created by sunn on 2017/3/7.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define YC_SDK_VERSION @"5.3.4"

// 通知回调类常量
extern NSString *const YC_LOGIN_SUCCUESS;

extern NSString *const YC_PAY_SUCCUESS;
extern NSString *const YC_PAY_PUCHESSING;
extern NSString *const YC_PAY_FAIL;

// 参数类常量
extern NSString *const YC_PRM_ROLE_ID;          // 游戏角色 ID
extern NSString *const YC_PRM_ROLE_NAME;        // 游戏角色名
extern NSString *const YC_PRM_ROLE_LEVEL;       // 游戏角色等级
extern NSString *const YC_PRM_ROLE_SERVER_ID;   // 游戏角色所在服务器
extern NSString *const YC_PRM_ROLE_SERVER_NAME; // 游戏角色所在服务器名称

extern NSString *const YC_PRM_PAY_PRODUCT_ID;     // 充值时的商品 ID
extern NSString *const YC_PRM_PAY_PRODUCT_PRICE;  // 充值时的商品价格
extern NSString *const YC_PRM_PAY_PRODUCT_NAME;   // 充值时的商品名称
extern NSString *const YC_PRM_PAY_CP_ORDER_ID;    // 充值时厂商生产的订单号
extern NSString *const YC_PRM_PAY_EXTRA;          // 充值时厂商生产的订单号



@interface YCSDK : NSObject
    
/**
 单例
 
 @return Satrpy 单例对象
 */
+ (instancetype)shareYC;

/**
 登录
 */
- (void)yc_login;


/**
 登录并指定方向

 @param orientation 屏幕方向
 */
- (void)yc_loginWithGameOrientation:(UIInterfaceOrientation)orientation;

/**
 快速登录入口
 注销、切换账号后调用
 */
- (void)yc_logout;

/**
 充值
 
 @param payParms 充值参数集合
 */
- (void)yc_pay:(NSDictionary *)payParms;

/**
 保存角色信息
 
 */
- (void)yc_setGameRoleInfo:(NSDictionary *)params;


/**
 公告信息
 */
- (void)yc_iHaveGoodNews;


@end
