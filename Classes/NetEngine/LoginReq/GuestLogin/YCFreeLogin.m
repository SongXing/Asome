//
//

#import "YCFreeLogin.h"
#import "SPCentreInfo.h"
#import "YCThirdFunction.h"
#import "HelloHeader.h"

@implementation YCFreeLogin

#pragma mark - 免注册登陆
+ (void)loginWithoutRegisterAndcompletion:(void (^)())block
{
    NSString *loginId = [YCOpenUDID ycu_getYcUdidValue];
    [YCThirdFunction doThirdLoginWithThirdId:loginId
                               andThirdPlate:@"mac"
                               andDomainName:SP_GET_INFO(@"thirdLoginProName")
                               andOtherBlock:block];
}

#pragma mark - 绑定免注册账号（added）
+(void)bindingFreeAccountWithUserName:(NSString *)userName
                          andPassword:(NSString *)password
                             andEmail:(NSString *)email
                           andLoginId:(NSString *)loginId
                        andThirdPlate:(NSString *)thirdPlate
                           completion:(void (^)())block
{
    [YCThirdFunction doAccountBindingWithUserName:userName
                                      andPassword:password
                                         andEmail:email
                                       andLoginId:loginId
                                    andThirdPlate:thirdPlate
                                    andDomainName:SP_GET_INFO(@"thirdLoginProName")
                                    andOtherBlock:block];
}

@end
