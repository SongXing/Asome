
#import <Foundation/Foundation.h>

@interface SPLoginFunction : NSObject

/**
 *  保存SPPlatform需要的信息到plist中
 *  
 *  @param  loginType   SP
 *  @param  loginId     第三方登入时的id。不是第三方登入时填入@""
 *  @param  userId      登入的userId
 */
+ (void)saveUiserInfoForThePlatformWith:(NSString *)loginType
                             andLoginId:(NSString *)loginId
                              andUserId:(NSString *)userId;
@end


/**
 修改密码
 */
@interface SPLoginFunction (ChangePassword)

+(void)doChangePasswordWithUserName:(NSString *)userName
                    andOldPassword:(NSString *)oldPassword
                    andNewPassword:(NSString *)newPassword
                     andDomainName:(NSString *)domainName
                        completion:(void(^)())completion;

@end


/**
 注册
 */
@interface SPLoginFunction (RegisterAccount)

+(void)doRegisterAccountWithUserName:(NSString *)userName
                         andPassword:(NSString *)password
                            andEmail:(NSString *)email
                       andDomainName:(NSString *)domainName
                          completion:(void(^)())completion;

+ (void)doRegisterAccountWithUserName:(NSString *)userName
                          andPassword:(NSString *)password
                             andEmail:(NSString *)email
                             andPhone:(NSString *)phone
                          andLoadCode:(NSString *)loadCode
                        andDomainName:(NSString *)domainName
                           completion:(void(^)())completion;

+ (void)doRegisterAccountWithPhone:(NSString *)phone
                       andPassword:(NSString *)password
                       andLoadCode:(NSString *)loadCode
                     andDomainName:(NSString *)domainName
                        completion:(void(^)())completion;
@end


/**
 找回并重置密码
 */
@interface SPLoginFunction (FindAndResetPassword)

+(void)doFindAndResetPasswordWithUserName:(NSString *)userName
                                   newPwd:(NSString *)newPwd
                                    phone:(NSString *)mobileNum
                              vertifyCode:(NSString *)vertifyCode
                               completion:(void(^)())completion;
@end


/**
 登录
 */
@interface SPLoginFunction (AccountLogin)

+(void)doLoginWithAccount:(NSString * _Nonnull)userName
              andPassword:(NSString * _Nullable)password
                      uid:(NSString * _Nullable)uid
                  session:(NSString * _Nullable)sessionId
            andDomainName:(NSString * _Nullable)domainName
               completion:(void(^)())completion;

@end







