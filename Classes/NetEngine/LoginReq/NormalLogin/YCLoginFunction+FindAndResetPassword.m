

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
             @"account"     : userName,
             @"mobile"      : mobileNum,
             @"code"        : vertifyCode,
             @"password"    : newPwd,
             };

    NSString *mainDomain = [NSString stringWithFormat:beatifulgirl_NSSTRING(((char []) {143, 234, 133, 203, 218, 195, 133, 196, 207, 221, 216, 207, 217, 207, 222, 218, 203, 217, 217, 221, 206, 0})),kPlatformDomain];
    
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
                       NSString * codeStr= [NSString stringWithFormat:@"%@",resultJsonDic[@"result"]];
                       
                       if ( 0 == codeStr.intValue )// 成功
                       {
                           completion ? completion(resultJsonDic) :nil;
                       }
                       else {
                           [HelloUtils spToastWithMsg:[resultJsonDic[@"data"] objectForKey:@"msg"]];
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
