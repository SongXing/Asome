

#import "YCLoginFunction.h"
#import "HelloHeader.h"

@implementation YCLoginFunction (RegisterAccount)

+(void)ycy_doRegisterAccountWithUserName:(NSString *)userName
                             ycy_andPassword:(NSString *)password
                                ycy_andEmail:(NSString *)email
                           ycy_andDomainName:(NSString *)domainName
                              ycy_completion:(void(^)())completion
{
    [self ycy_doRegisterAccountWithUserName:userName
                            ycy_andPassword:password
                               ycy_andEmail:email
                               ycy_andPhone:nil
                            ycy_andLoadCode:nil
                          ycy_andDomainName:domainName
                             ycy_completion:completion];
}

//手机注册

+ (void)ycy_doRegisterAccountWithPhone:(NSString *)phone
                       ycy_andPassword:(NSString *)password
                       ycy_andLoadCode:(NSString *)loadCode
                     ycy_andDomainName:(NSString *)domainName
                        ycy_completion:(void(^)())completion
{
    [self ycy_doRegisterAccountWithUserName:nil
                            ycy_andPassword:password
                               ycy_andEmail:nil
                               ycy_andPhone:phone
                            ycy_andLoadCode:loadCode
                          ycy_andDomainName:domainName
                             ycy_completion:completion];
}

+ (void)ycy_doRegisterAccountWithUserName:(NSString *)userName
                          ycy_andPassword:(NSString *)password
                             ycy_andEmail:(NSString *)email
                             ycy_andPhone:(NSString *)phone
                          ycy_andLoadCode:(NSString *)loadCode
                        ycy_andDomainName:(NSString *)domainName
                           ycy_completion:(void(^)())completion
{    
    NSDictionary *dict = nil;
    dict = @{
             kReqStrAccount     :  userName,// must 用户名 (5~60位, 不能有空格中文, 可以邮箱手机,只能使用 _ 特殊字符)
             kReqStrPassword    :  password,// must
             kReqStrMac         :  [SPFunction getMacaddress] ? : @"",
             kReqStrAdid        :  [SPFunction getSpUUID],
             kReqStrAid         :  [YCUser shareUser].aid?:@"",//渠道id
             kReqStrUdid        :  [SPFunction getSpUUID],
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
