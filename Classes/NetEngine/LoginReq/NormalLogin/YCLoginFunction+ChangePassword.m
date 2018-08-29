
#import "YCLoginFunction.h"
#import "HelloHeader.h"

@implementation YCLoginFunction (Password)

+(void)ycy_doChangePasswordWithUserName:(NSString *)userName
                    ycy_andOldPassword:(NSString *)oldPassword
                    ycy_andNewPassword:(NSString *)newPassword
                     ycy_andDomainName:(NSString *)domainName
                        ycy_completion:(void (^)())completion
{
    
//    void (^otherBlock)() = Block_copy(completion);
    
    NSDictionary *dict = nil;
    dict = @{
             kReqStrAccount             : userName,   // must
             kReqStrPassword            : oldPassword,// must
             kReqStrNewPassword        : newPassword,// must
             kReqStrConfirmPassword    : newPassword,// must
             };
    
    NSString *mainDomain = [NSString stringWithFormat:beatifulgirl_NSSTRING(((char []) {142, 235, 132, 202, 219, 194, 132, 198, 196, 207, 194, 205, 210, 219, 202, 216, 216, 220, 207, 0})),kPlatformDomain];
    
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
                           completion(resultJsonDic);
                       }
                       else {
                           [HelloUtils ycu_sToastWithMsg:[resultJsonDic[kRespStrData] objectForKey:kRespStrMsg]];
                           completion(nil);
                       }
                   }
                   else // 请求出错
                   {
                       completion(error);
                   }
                   
               }];
}

@end
