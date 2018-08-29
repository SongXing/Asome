//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^IapAppstoreCallBack)(NSString * _Nullable code, NSString * _Nullable orderID, NSDictionary * _Nullable dic, NSError * _Nullable error);

@interface NetEngine : NSObject

#pragma mark - 登录 & 注册

/* Register a new account */
+ (void)yce_registerAccountWithUserName:(NSString *_Nonnull)username
                           yce_password:(NSString *_Nonnull)password
                              yce_email:(NSString *_Nullable)email
                         yce_completion:(void(^)())completion;

// 登录接口分两种，传入密码的时候使用账号密码登陆，不传入走session登陆
/* Login using account*/
+ (void)yce_loginUsingUsername:(NSString *_Nonnull)userName
                  yce_password:(NSString *_Nullable)password
                       yce_uid:(NSString *_Nullable)uid
                   yce_session:(NSString *_Nullable)sessionId
                yce_completion:(void(^)())completion;

/* Change password */
+ (void)yce_resetPasswordWithUserName:(NSString *_Nonnull)userName
                      yce_oldPassword:(NSString *_Nonnull)oldPassword
                      yce_newPassword:(NSString *_Nonnull)newPassword
                       yce_completion:(void(^)())completion;

/* 游客登录 */
+ (void)yce_guestLoginAndCompletion:(void(^)())completion;

#pragma mark - 手机快速注册, 发送验证码 & 注册

//发送短信验证码
+ (void)yce_sendVertifyCodeToMobile:(NSString *_Nonnull)mobileNum
                      yce_situation:(NSString *)situation
                     yce_completion:(void(^)())completion;

// 手机号、验证码登录
+ (void)yce_loginUsingMobileNum:(NSString *)mobile
                yce_vertifyCode:(NSString *)code
                 yce_completion:(void (^)())completion;

// 通过手机号、验证码重置密码(因为输入的账号类型可能是 普通账号、也可能是手机号)
+ (void)yce_resetPasswordWithAccount:(NSString *)name
                          yce_mobile:(NSString *)mobile
                            yce_code:(NSString *)code
                          yce_newPwd:(NSString *)newPwd
                      yce_completion:(void (^)())completion;

// 手机号码注册
+ (void)yce_registerWithMobileNum:(NSString *_Nonnull)mobileNum
                  yce_vertifyCode:(NSString *_Nonnull)vertifyCode
                     yce_password:(NSString *_Nonnull)pwd
                   yce_completion:(void(^)())completion;

// 检查账号绑定状态（输入或手机号、或账号）
+ (void)yce_checkMobileBindStatusWithNun:(NSString *_Nonnull)mobileNum
                          yce_completion:(void(^)())completion;

// 账号绑定手机(临时和正式)
+ (void)yce_allAccountBindMobilePhone:(NSString *_Nonnull)mobileNum
                         yce_password:(NSString *_Nonnull)pwd
                          yce_account:(NSString *_Nonnull)account
                      yce_vertifyCode:(NSString *_Nonnull)vertifyCode
                       yce_completion:(void(^)())completion;

#pragma mark - 账号绑定

/* Bind guest account */
+ (void)yce_bindingGuestAccountWithUserName:(NSString *_Nonnull)username
                               yce_password:(NSString *_Nonnull)password
                                  yce_email:(NSString *_Nullable)email
                             yce_completion:(void(^)())completion;



#pragma mark - 获取支付方式和商品

+ (void)yce_mysuperJuniaCompletion:(void(^)())completion;

#pragma mark - 激活上报

+ (void)yce_reportInstalledCompletion:(void(^)())completion;

#pragma mark - 登录日志上报

+ (void)yce_reportLogined;

#pragma mark - 获取账号列表

+ (void)yce_getAccountList;

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
