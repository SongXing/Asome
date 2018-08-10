

#import "SPLoginFunction.h"


@implementation SPLoginFunction

+ (void)saveUiserInfoForThePlatformWith:(NSString *)loginType
                             andLoginId:(NSString *)loginId
                              andUserId:(NSString *)userId
{
    //for the platform
    NSString *LoginSuccessfulWithUserIDandUIDAndLoginType = [NSString stringWithFormat:@"%@,%@,%@",
                                                             loginType,loginId,userId];
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:LoginSuccessfulWithUserIDandUIDAndLoginType forKey:@"SP_LOGIN_INFO_FOR_PLATFORM"];
    [userdefaults synchronize];
}

@end
