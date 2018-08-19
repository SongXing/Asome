

#import "YCLoginFunction.h"
#import "HelloHeader.h"

@implementation YCLoginFunction (RegisterAccount)

+(void)doRegisterAccountWithUserName:(NSString *)userName
                             andPassword:(NSString *)password
                                andEmail:(NSString *)email
                           andDomainName:(NSString *)domainName
                              completion:(void(^)())completion
{
    [self doRegisterAccountWithUserName:userName
                            andPassword:password
                               andEmail:email
                               andPhone:nil
                            andLoadCode:nil
                          andDomainName:domainName
                             completion:completion];
}

//手机注册

+ (void)doRegisterAccountWithPhone:(NSString *)phone
                       andPassword:(NSString *)password
                       andLoadCode:(NSString *)loadCode
                     andDomainName:(NSString *)domainName
                        completion:(void(^)())completion
{
    [self doRegisterAccountWithUserName:nil
                            andPassword:password
                               andEmail:nil
                               andPhone:phone
                            andLoadCode:loadCode
                          andDomainName:domainName
                             completion:completion];
}

+ (void)doRegisterAccountWithUserName:(NSString *)userName
                          andPassword:(NSString *)password
                             andEmail:(NSString *)email
                             andPhone:(NSString *)phone
                          andLoadCode:(NSString *)loadCode
                        andDomainName:(NSString *)domainName
                           completion:(void(^)())completion
{    
    NSDictionary *dict = nil;
    dict = @{
             @"account"     :  userName,// must 用户名 (5~60位, 不能有空格中文, 可以邮箱手机,只能使用 _ 特殊字符)
             @"password"    :  password,// must
             @"mac"         :  [SPFunction getMacaddress] ? : @"",
             @"adid"        :  [SPFunction getSpUUID],
             @"sid"         :  @"",//serverCode
             @"aid"         :  [YCUser shareUser].aid?:@"",//渠道id
             @"openudid"    :  @"",//openudid
             @"udid"        :  [SPFunction getSpUUID],
             };
    
    NSString *mainDomain = [NSString stringWithFormat:beatifulgirl_NSSTRING(((char []) {142, 235, 132, 202, 219, 194, 132, 217, 206, 204, 194, 216, 223, 0})),kPlatformDomain];
    
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
                           completion(resultJsonDic);
                       }
                       else {
                           [HelloUtils ycu_sToastWithMsg:[resultJsonDic[@"data"] objectForKey:@"msg"]];
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
