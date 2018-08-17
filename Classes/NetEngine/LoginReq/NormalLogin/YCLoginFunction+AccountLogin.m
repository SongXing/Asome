

#import "YCLoginFunction.h"
#import "HelloHeader.h"


@implementation YCLoginFunction (AccountLogin)

+(void)doLoginWithAccount:(NSString * _Nonnull)userName
              andPassword:(NSString * _Nullable)password
                      uid:(NSString * _Nullable)uid
                  session:(NSString * _Nullable)sessionId
            andDomainName:(NSString * _Nullable)domainName
               completion:(void (^)())completion
{    
    NSDictionary *dict = nil;
    dict = @{            
             @"account"     :   userName,
             @"password"    :   password ? :@"",
             @"uid"         :   uid ? :@"",
             @"sessionid"   :   sessionId ? :@"",
             @"sid"         :   @"",
             @"aid"         :   [YCUser shareUser].aid,
             
             };
    
    NSString *mainDomain = [NSString stringWithFormat:beatifulgirl_NSSTRING(((char []) {143, 234, 133, 203, 218, 195, 133, 198, 197, 205, 195, 196, 0})),kPlatformDomain];
    
    [SPRequestor requestByParams:dict
                additionalParams:nil
                   requestDomain:mainDomain
             requestSecondDomain:mainDomain
      expectResponseDicKeysArray:nil
                      retryTimes:1
                  isReqestByPost:YES
               ComplitionHandler:^(NSURLResponse *response, NSDictionary *resultJsonDic, NSError *jsonParseErr, NSString *resultStr, NSData *resultRawData, NSError *error) {
                   
                   if (!error && !jsonParseErr)
                   {                       
                       //获取code参数
                       NSString * codeStr= [NSString stringWithFormat:@"%@",resultJsonDic[@"result"]];
                       
                       if ( 0 == codeStr.intValue )// 成功
                       {
                           completion?completion(resultJsonDic):nil;
                       }
                       else {
                           [HelloUtils spToastWithMsg:[resultJsonDic[@"data"] objectForKey:@"msg"]];
                           // 1110 认证过期
                           if (1110 == codeStr.intValue) {
                               completion?completion(@"SessionTimeIsOver"):nil;
                           } else {
                               completion?completion(nil):nil;
                           }
                       }
                   }
                   else // 请求出错
                   {
                       [HelloUtils spToastWithMsg:@"请求超时"];
                       completion?completion(error):nil;
                   }
                   
       }];
    
}

@end
