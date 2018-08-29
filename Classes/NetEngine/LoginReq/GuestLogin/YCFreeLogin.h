//
//

#import <Foundation/Foundation.h>

@interface YCFreeLogin : NSObject

/* 免注册登录 */
+ (void)ycy_loginWithoutRegisterAndcompletion:(void(^)())block;

/**
 *	@brief	免注册绑定接口
 *
 *	@param 	userName 	绑定的用户帐号
 *	@param 	password 	用户密码
 *	@param 	email 	用户Email
  *	@param 	loginId 	用户登录ID
  *	@param 	thirdPlate 	第三方标识
 */
+ (void)ycy_bindingFreeAccountWithUserName:(NSString *)userName
                          andPassword:(NSString *)password
                             andEmail:(NSString *)email
                           andLoginId:(NSString *)loginId
                        andThirdPlate:(NSString *)thirdPlate
                           completion:(void(^)())block;




@end
