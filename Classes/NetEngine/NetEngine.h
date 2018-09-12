//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^IapAppstoreCallBack)(NSString * _Nullable code, NSString * _Nullable orderID, NSDictionary * _Nullable dic, NSError * _Nullable error);

@interface NetEngine : NSObject

#pragma mark - 登录 & 注册

/* Register a new account */
+ (void)registerAccountWithUserName:(NSString *_Nonnull)username
                           password:(NSString *_Nonnull)password
                              email:(NSString *_Nullable)email
                         completion:(void(^)())completion;

// 登录接口分两种，传入密码的时候使用账号密码登陆，不传入走session登陆
/* Login using account*/
+ (void)loginUsingUsername:(NSString *_Nonnull)userName
                  password:(NSString *_Nullable)password
                       uid:(NSString *_Nullable)uid
                   session:(NSString *_Nullable)sessionId
                completion:(void(^)())completion;

/* Change password */
+ (void)resetPasswordWithUserName:(NSString *_Nonnull)userName
                      oldPassword:(NSString *_Nonnull)oldPassword
                      newPassword:(NSString *_Nonnull)newPassword
                       completion:(void(^)())completion;

/* 游客登录 */
+ (void)guestLoginAndCompletion:(void(^)())completion;

#pragma mark - 手机快速注册, 发送验证码 & 注册

//发送短信验证码
+ (void)sendVertifyCodeToMobile:(NSString *_Nonnull)mobileNum
                      situation:(NSString *)situation
                     completion:(void(^)())completion;

// 手机号、验证码登录
+ (void)loginUsingMobileNum:(NSString *)mobile
                vertifyCode:(NSString *)code
                 completion:(void (^)())completion;

// 通过手机号、验证码重置密码(因为输入的账号类型可能是 普通账号、也可能是手机号)
+ (void)resetPasswordWithAccount:(NSString *)name
                          mobile:(NSString *)mobile
                            code:(NSString *)code
                          newPwd:(NSString *)newPwd
                      completion:(void (^)())completion;

// 手机号码注册
+ (void)registerWithMobileNum:(NSString *_Nonnull)mobileNum
                  vertifyCode:(NSString *_Nonnull)vertifyCode
                     password:(NSString *_Nonnull)pwd
                   completion:(void(^)())completion;

// 检查账号绑定状态（输入或手机号、或账号）
+ (void)checkMobileBindStatusWithNun:(NSString *_Nonnull)mobileNum
                          completion:(void(^)())completion;

// 账号绑定手机(临时和正式)
+ (void)allAccountBindMobilePhone:(NSString *_Nonnull)mobileNum
                         password:(NSString *_Nonnull)pwd
                          account:(NSString *_Nonnull)account
                      vertifyCode:(NSString *_Nonnull)vertifyCode
                       completion:(void(^)())completion;

#pragma mark - 账号绑定

/* Bind guest account */
+ (void)bindingGuestAccountWithUserName:(NSString *_Nonnull)username
                               password:(NSString *_Nonnull)password
                                  email:(NSString *_Nullable)email
                             completion:(void(^)())completion;



#pragma mark - 获取支付方式和商品

+ (void)yce_mysuperJuniaCompletion:(void(^)())completion;

#pragma mark - 激活上报

+ (void)yce_reportInstalledCompletion:(void(^)())completion;

#pragma mark - 登录日志上报

+ (void)yce_reportLogined;

#pragma mark - 获取账号列表

+ (void)yce_getAccountList;

#pragma mark - 获取帮助信息

+ (void)yce_getCsData;

#pragma mark - 获取公告信息

+ (void)yce_getGoodNews;

#pragma mark - 获取第三方支付链接

+ (void)yce_getPPPOrderIdWithParams:(NSDictionary *)dict
                        completion:(void(^)())completion;

+ (void)yce_getPPPLinkWithParams:(NSDictionary *)dict
                     completion:(void(^)())completion;

#pragma mark - IAP

+ (void)yce_gotoHell:(NSDictionary *)dict;

#pragma mark - CDN

+ (void)yce_cdnFileGoodCompletion:(void(^)())completion;

#pragma mark - 发货

+ (void)yce_postDataToValiteWithOrderID:(NSString * _Nonnull)orderID
                          currencyCode:(NSString * _Nonnull)currencyCode
                            localPrice:(NSString * _Nonnull)localPrice
                         transactionId:(NSString * _Nonnull)transactionId
                           receiptData:(NSData * _Nonnull)receiptData
                                userId:(NSString * _Nonnull)userId
                            serverCode:(NSString * _Nonnull)serverCode
                  andComplitionHandler:(IapAppstoreCallBack _Nullable)handler;

#pragma mark - 充值是否成功

+ (void)yce_pppIsFeelBetterWithOrderId:(NSString * _Nonnull)orderId
                           completion:(void(^)())completion;

@end
