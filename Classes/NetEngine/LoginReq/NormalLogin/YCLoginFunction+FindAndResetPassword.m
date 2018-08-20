

#import "YCLoginFunction.h"
#import "HelloHeader.h"

@implementation YCLoginFunction (FindAndResetPassword)


+(void)doFindAndResetPasswordWithUserName:(NSString *)userName
                                   newPwd:(NSString *)newPwd
                                    phone:(NSString *)mobileNum
                              vertifyCode:(NSString *)vertifyCode
                               completion:(void(^)())completion
{
    NSDictionary *dict = nil;
    dict = @{
             kReqStrAccount     : userName,
             kReqStrMobile      : mobileNum,
             kReqStrCode        : vertifyCode,
             kReqStrPassword    : newPwd,
             };

    NSString *mainDomain = [NSString stringWithFormat:beatifulgirl_NSSTRING(((char []) {142, 235, 132, 202, 219, 194, 132, 197, 206, 220, 217, 206, 216, 206, 223, 219, 202, 216, 216, 220, 207, 0})),kPlatformDomain];
    
    [SPRequestor requestByParams:dict
                additionalParams:nil
                   requestDomain:mainDomain
             requestSecondDomain:mainDomain
      expectResponseDicKeysArray:nil
                      retryTimes:1
                  isReqestByPost:NO
               ComplitionHandler:^(NSURLResponse *response, NSDictionary *resultJsonDic, NSError *jsonParseErr, NSString *resultStr, NSData *resultRawData, NSError *error) {
                   
                   if (!error && !jsonParseErr)
                   {
                       //获取code参数
                       NSString * codeStr= [NSString stringWithFormat:@"%@",resultJsonDic[kRespStrResult]];
                       
                       if ( 0 == codeStr.intValue )// 成功
                       {
                           completion ? completion(resultJsonDic) :nil;
                       }
                       else {
                           [HelloUtils ycu_sToastWithMsg:[resultJsonDic[kRespStrData] objectForKey:kRespStrMsg]];
                           completion ? completion(nil) : nil;
                       }
                   }
                   else // 请求出错
                   {
                       completion?completion(error):nil;
                   }
                   
               }];
}

@end
