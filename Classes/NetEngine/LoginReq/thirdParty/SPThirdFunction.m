

#import "SPThirdFunction.h"
#import "HelloHeader.h"

@implementation SPThirdFunction

#pragma mark -第三方账号登录（新接口）
+(void)doThirdLoginWithThirdId:(NSString *)thirdId
                 andThirdPlate:(NSString *)thirdPlate
                 andDomainName:(NSString *)domainName
                 andOtherBlock:(void(^)())block
{
    NSDictionary *dict = nil;
    dict = @{
             @"mac"            : [SPFunction getMacaddress],
             @"adid"           : [SPFunction getSpUUID],
             @"sid"            : [YCUser shareUser].serverId?:@"",
             @"aid"            : [YCUser shareUser].aid?:@"",
             @"openudid"       : @"",
             
             };
  
    NSString *mainDomain = [NSString stringWithFormat:@"%@/api/defaultaccount",kPlatformDomain];;//@"https://center.play800.cn/api/defaultaccount?";
    
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
                           block(resultJsonDic);
                       }
                       else {
                           [NSClassFromString(@"HelloUtils") spToastWithMsg:[resultJsonDic[@"data"] objectForKey:@"msg"]];
                           block(nil);
                       }
                   }
                   else // 请求出错
                   {
                       [HelloUtils spToastWithMsg:@"请求超时"];
                       block(nil);
                   }
                   
               }];
    
}


#pragma mark - 绑定账号
+(void)doAccountBindingWithUserName:(NSString *)userName
                            andPassword:(NSString *)password
                               andEmail:(NSString *)email
                             andLoginId:(NSString *)loginId
                          andThirdPlate:(NSString *)thirdPlate
                          andDomainName:(NSString *)domainName
                          andOtherBlock:(void(^)())block
{       
    NSDictionary *dict = nil;
    dict = @{
             
             };
    
    
    NSString *mainDomain = [NSString stringWithFormat:@"%@/api/defaultaccount",kPlatformDomain];;//@"https://center.play800.cn/api/defaultaccount?";
    
    [SPRequestor requestByParams:dict
                additionalParams:nil
                   requestDomain:mainDomain
             requestSecondDomain:mainDomain
      expectResponseDicKeysArray:nil
                      retryTimes:1
                  isReqestByPost:YES
               ComplitionHandler:^(NSURLResponse *response, NSDictionary *resultJsonDic, NSError *jsonParseErr, NSString *resultStr, NSData *resultRawData, NSError *error) {
                   
                   //TOOD
               }];
         
    
}


@end
