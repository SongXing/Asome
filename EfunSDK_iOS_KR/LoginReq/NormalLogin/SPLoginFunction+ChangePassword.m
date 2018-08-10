
#import "SPLoginFunction.h"
//#import "SPRequestor.h"
//#import "HelloUtils.h"
#import "HelloHeader.h"

@implementation SPLoginFunction (Password)

+(void)doChangePasswordWithUserName:(NSString *)userName
                    andOldPassword:(NSString *)oldPassword
                    andNewPassword:(NSString *)newPassword
                     andDomainName:(NSString *)domainName
                        completion:(void (^)())completion
{
    
//    void (^otherBlock)() = Block_copy(completion);
    
    NSDictionary *dict = nil;
    dict = @{
             @"account"             : userName,   // must
             @"password"            : oldPassword,// must
             @"new_password"        : newPassword,// must
             @"confirm_password"    : newPassword,// must
             };
    
    NSString *mainDomain = [NSString stringWithFormat:@"%@/api/modifypasswd",kPlatformDomain];
//    @"https://center.play800.cn/api/modifypasswd";
    
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
                           completion(resultJsonDic);
                       }
                       else {
                           [HelloUtils spToastWithMsg:[resultJsonDic[@"data"] objectForKey:@"msg"]];
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
