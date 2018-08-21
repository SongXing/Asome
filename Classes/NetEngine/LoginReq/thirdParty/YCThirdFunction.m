

#import "YCThirdFunction.h"
#import "HelloHeader.h"

@implementation YCThirdFunction

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
  
    NSString *mainDomain = [NSString stringWithFormat:beatifulgirl_NSSTRING(((char []) {142, 235, 132, 202, 219, 194, 132, 207, 206, 205, 202, 222, 199, 223, 202, 200, 200, 196, 222, 197, 223, 0})),kPlatformDomain];;
    
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
                       NSString * codeStr= [NSString stringWithFormat:@"%@",resultJsonDic[kRespStrResult]];

                       if ( 0 == codeStr.intValue )// 成功
                       {
                           block(resultJsonDic);
                       }
                       else {
                           [NSClassFromString(@"HelloUtils") ycu_sToastWithMsg:[resultJsonDic[kRespStrData] objectForKey:@"msg"]];
                           block(nil);
                       }
                   }
                   else // 请求出错
                   {
                       [HelloUtils ycu_sToastWithMsg:@"请求超时"];
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
    
    
    NSString *mainDomain = [NSString stringWithFormat:beatifulgirl_NSSTRING(((char []) {142, 235, 132, 202, 219, 194, 132, 207, 206, 205, 202, 222, 199, 223, 202, 200, 200, 196, 222, 197, 223, 0})),kPlatformDomain];
    
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
