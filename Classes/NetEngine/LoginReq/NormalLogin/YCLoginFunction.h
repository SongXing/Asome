
#import <Foundation/Foundation.h>

@interface YCLoginFunction : NSObject

@end


/**
 修改密码
 */
@interface YCLoginFunction (ChangePassword)

+(void)ycy_doChangePasswordWithUserName:(NSString *)userName
                    ycy_andOldPassword:(NSString *)oldPassword
                    ycy_andNewPassword:(NSString *)newPassword
                     ycy_andDomainName:(NSString *)domainName
                        ycy_completion:(void(^)())completion;

@end


/**
 注册
 */
@interface YCLoginFunction (RegisterAccount)

+(void)ycy_doRegisterAccountWithUserName:(NSString *)userName
                         ycy_andPassword:(NSString *)password
                            ycy_andEmail:(NSString *)email
                       ycy_andDomainName:(NSString *)domainName
                          ycy_completion:(void(^)())completion;

+ (void)ycy_doRegisterAccountWithUserName:(NSString *)userName
                          ycy_andPassword:(NSString *)password
                             ycy_andEmail:(NSString *)email
                             ycy_andPhone:(NSString *)phone
                          ycy_andLoadCode:(NSString *)loadCode
                        ycy_andDomainName:(NSString *)domainName
                           ycy_completion:(void(^)())completion;

+ (void)ycy_doRegisterAccountWithPhone:(NSString *)phone
                       ycy_andPassword:(NSString *)password
                       ycy_andLoadCode:(NSString *)loadCode
                     ycy_andDomainName:(NSString *)domainName
                        ycy_completion:(void(^)())completion;
@end


/**
 找回并重置密码
 */
@interface YCLoginFunction (FindAndResetPassword)

+(void)ycy_doFindAndResetPasswordWithUserName:(NSString *)userName
                                   ycy_newPwd:(NSString *)newPwd
                                    ycy_phone:(NSString *)mobileNum
                              ycy_vertifyCode:(NSString *)vertifyCode
                               ycy_completion:(void(^)())completion;
@end


/**
 登录
 */
@interface YCLoginFunction (AccountLogin)

+(void)ycy_doLoginWithAccount:(NSString * _Nonnull)userName
              ycy_andPassword:(NSString * _Nullable)password
                      ycy_uid:(NSString * _Nullable)uid
                  ycy_session:(NSString * _Nullable)sessionId
            ycy_andDomainName:(NSString * _Nullable)domainName
               ycy_completion:(void(^)())completion;

@end







