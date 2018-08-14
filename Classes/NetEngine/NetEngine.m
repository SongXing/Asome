//
//

#import "NetEngine.h"
#import "HelloHeader.h"


static NSInteger totolTryTimeMax = 3;
static NSInteger cndMoreTime = 0;
static NSInteger installMoreTime = 0;
static NSInteger niceMoreTime = 0;
static NSInteger huhaMoreTime = 0;

@implementation NetEngine

#pragma mark - Class Method

+ (void)registerAccountWithUserName:(NSString *)username
                           password:(NSString *)password
                              email:(NSString *)email
                         completion:(void(^)())completion
{
    [YCLoginFunction doRegisterAccountWithUserName:username
                                       andPassword:password
                                          andEmail:email
                                          andPhone:nil
                                       andLoadCode:nil
                                     andDomainName:@""
                                        completion:completion];
}

+ (void)loginUsingUsername:(NSString *)userName
                  password:(NSString *_Nullable)password
                       uid:(NSString *_Nullable)uid
                   session:(NSString *_Nullable)sessionId
                completion:(void(^)())completion
{
    [YCLoginFunction doLoginWithAccount:userName
                            andPassword:password
                                    uid:uid
                                session:sessionId
                          andDomainName:@""
                             completion:completion];
}

+ (void)resetPasswordWithUserName:(NSString *)userName oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword completion:(void(^)())completion
{
    [YCLoginFunction doChangePasswordWithUserName:userName
                                  andOldPassword:oldPassword
                                  andNewPassword:newPassword
                                   andDomainName:@""
                                      completion:completion];
}

+ (void)guestLoginAndCompletion:(void (^)())completion
{
    [YCFreeLogin loginWithoutRegisterAndcompletion:completion];
}

#pragma mark - 手机相关
// 获取验证码
+ (void)sendVertifyCodeToMobile:(NSString *)mobileNum
                      situation:(NSString *)situation
                     completion:(void (^)())completion
{
    NSDictionary *dict = nil;
    dict = @{
             @"mobile"            : mobileNum,
             @"sendtype"          : situation,//固定字段
             };
    
    NSString *mainDomain = [NSString stringWithFormat:@"%@/api/sendmobilecode",kPlatformDomain];//@"https://center.play800.cn/api/sendmobilecode";
    
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
                           completion ? completion(resultJsonDic) : nil;
                       }
                       else {
                           [HelloUtils spToastWithMsg:[resultJsonDic[@"data"] objectForKey:@"msg"]];
                           completion ? completion(nil) : nil;
                       }
                   }
                   else // 请求出错
                   {
                       completion ? completion(error) : nil;
                   }
                   
               }];
}

// 手机+验证码 登录
+ (void)loginUsingMobileNum:(NSString *)mobile
                vertifyCode:(NSString *)code
                 completion:(void (^)())completion
{
    NSDictionary *dict = nil;
    dict = @{
             @"account"            : mobile,
             @"code"               : code,
             @"aid"               : [YCUser shareUser].aid ?:@"",
             @"udid"              : [SPFunction getSpUUID],
             @"mac"               : [SPFunction getMacaddress]?:@"",
             @"adid"              : [SPFunction getSpUUID],
             };
    
    NSString *mainDomain = [NSString stringWithFormat:@"%@/api/phoneLogin",kPlatformDomain];//@"https://center.play800.cn/api/mobilelogin";
    
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
                           completion ? completion(resultJsonDic) : nil;
                       }
                       else {
                           [NSClassFromString(@"HelloUtils") spToastWithMsg:[resultJsonDic[@"data"] objectForKey:@"msg"]];
                           completion ? completion(nil) : nil;
                       }
                   }
                   else // 请求出错
                   {
                       completion ? completion(error) : nil;
                   }
                   
               }];
}

+ (void)resetPasswordWithAccount:(NSString *)name
                          mobile:(NSString *)mobile
                           code:(NSString *)code
                         newPwd:(NSString *)newPwd
                     completion:(void (^)())completion
{
    NSDictionary *dict = nil;
    dict = @{
             @"account"           : name,
             @"mobile"            : mobile,
             @"code"              : code,
             @"password"          : newPwd,
             };
    
    NSString *mainDomain = [NSString stringWithFormat:@"%@/api/newresetpasswd",kPlatformDomain];//@"https://center.play800.cn/api/mobilelogin";
    
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
                           completion ? completion(resultJsonDic) : nil;
                       }
                       else {
                           [NSClassFromString(@"HelloUtils") spToastWithMsg:[resultJsonDic[@"data"] objectForKey:@"msg"]];
                           completion ? completion(nil) : nil;
                       }
                   }
                   else // 请求出错
                   {
                       completion ? completion(error) : nil;
                   }
                   
               }];
}

// 手机注册
+ (void)registerWithMobileNum:(NSString *)mobileNum
                  vertifyCode:(NSString *)vertifyCode
                     password:(NSString *)pwd
                   completion:(void (^)())completion
{    
    NSDictionary *dict = nil;
    dict = @{
             @"mobile"            : mobileNum,
             @"password"          : pwd,
             @"code"              : vertifyCode,
             @"sid"               : @"",
             @"aid"               : [YCUser shareUser].aid ?:@"",
             @"udid"              : [SPFunction getSpUUID],
             @"mac"               : [SPFunction getMacaddress]?:@"",
             @"adid"              : [SPFunction getSpUUID],
             };
    
    NSString *mainDomain = [NSString stringWithFormat:@"%@/api/mobilelogin",kPlatformDomain];//@"https://center.play800.cn/api/mobilelogin";
    
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
                           completion ? completion(resultJsonDic) : nil;
                       }
                       else {
                           [NSClassFromString(@"HelloUtils") spToastWithMsg:[resultJsonDic[@"data"] objectForKey:@"msg"]];
                           completion ? completion(nil) : nil;
                       }
                   }
                   else // 请求出错
                   {
                       completion ? completion(error) : nil;
                   }
                   
               }];
}


//检查手机绑定状态
+ (void)checkMobileBindStatusWithNun:(NSString *_Nonnull)mobileNum
                          completion:(void(^)())completion
{
    NSDictionary *dict = nil;
    dict = @{
             @"account"            : mobileNum,
             };
    
    NSString *mainDomain = [NSString stringWithFormat:@"%@/api/getMobilePhone",kPlatformDomain];//@"https://center.play800.cn/api/checkbind";
    
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
//                           NSLog(@"---result = %@", resultJsonDic);
                           [HelloUtils spToastWithMsg:[resultJsonDic[@"data"] objectForKey:@"msg"]];
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

//绑定手机
+ (void)allAccountBindMobilePhone:(NSString *)mobileNum
                         password:(NSString *)pwd
                          account:(NSString *)account
                      vertifyCode:(NSString *)vertifyCode
                       completion:(void (^)())completion

{
    NSDictionary *dict = nil;
    dict = @{
             @"account"           : account,
             @"password"          : pwd,
             @"mobile"            : mobileNum,
             @"code"              : vertifyCode,
             };
    
    NSString *mainDomain = [NSString stringWithFormat:@"%@/api/newbindmobile",kPlatformDomain];//@"https://center.play800.cn/api/mobilelogin";
    
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

#pragma mark-

+ (void)bindingGuestAccountWithUserName:(NSString *)username
                               password:(NSString *)password
                                  email:(NSString *)email
                             completion:(void(^)())completion
{
    [YCFreeLogin bindingFreeAccountWithUserName:username
                                    andPassword:password
                                       andEmail:email
                                     andLoginId:nil
                                  andThirdPlate:@"mac"
                                     completion:completion];
}


#pragma mark - 获取支付方式

+ (void)yc_get_mysuperJuniaCompletion:(void (^)())completion
{
    NSDictionary * dict = @{
                            @"aid"      :   [YCUser shareUser].aid?:@"",                // option
                            };    
    
    NSString *mainDomain = [NSString stringWithFormat:@"%@/api/getPayType",kPayDomain];
    
    [SPRequestor requestByParams:dict
                additionalParams:nil
                   requestDomain:mainDomain
             requestSecondDomain:mainDomain
      expectResponseDicKeysArray:nil
                      retryTimes:1
                  isReqestByPost:YES
               ComplitionHandler:^(NSURLResponse *response, NSDictionary *resultJsonDic, NSError *jsonParseErr, NSString *resultStr, NSData *resultRawData, NSError *error) {
                   
                   niceMoreTime++;
                   
                   //成功格式：{"result":0,"data":{"status":false,"uid":"27041656"}}
                   //失败格式：{"result":1,"data":{"errorcode":1100,"msg":"\u53c2\u6570\u9519\u8bef"}}
                   if (!error && !jsonParseErr) {
                       NSString *result = [NSString stringWithFormat:@"%@",resultJsonDic[@"result"]];
                       if (0 == [result intValue]) {
//                           NSLog(@"---调起支付成功--- \n %@",resultJsonDic);
                           [YCDataUtils yc_handlePPP:resultJsonDic[@"data"]];
                       } else {
//                           NSLog(@"---调起支付失败--- \n resultDic = %@",resultJsonDic);
                       }
                       niceMoreTime = 0;
                   } else {
                       if (niceMoreTime <= totolTryTimeMax) {
                           // 再次请求
                           [NetEngine yc_get_mysuperJuniaCompletion:nil];
                       } else {
                           niceMoreTime = 0;
                           [HelloUtils spToastWithMsg:@"请求超时"];
                       }
                   }
                   
               }];
}


#pragma mark - 激活上报

+ (void)yc_reportInstalledCompletion:(void(^)())completion
{
    NSDictionary * dict = nil;
    @try {
        dict = @{

                 @"mac"      : [SPFunction getMacaddress] ? : @"",
                 @"device"   : [SPFunction getSpUUID],
                 @"modeltype"       : @"iOS",
                 @"gameversion"     : [SPFunction getBundleVersion],
                 @"device_model"    : [SPFunction getDeviceType],
                 @"device_resolution"    :   @"",
                 @"device_version"  :   [SPFunction getSystemVersion],
                 @"device_net"      : @"",
                 
                 
                 @"adid"     :   [SPFunction getSpUUID],
                 @"aid"      :   [YCUser shareUser].aid ? : @"",
                 @"index"    :   [SPFunction getSpUUID],
                 
                 };
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@", [NSString stringWithFormat:@"!!!ERROR Dic At reportInstalled:\n %@ \n %@", dict, exception.description]);
    }
    
    
    NSString *mainDomain = [NSString stringWithFormat:@"%@/sdklog/activate_log",kDataDomain];
    
    [SPRequestor requestByParams:dict
                additionalParams:nil
                   requestDomain:mainDomain
             requestSecondDomain:mainDomain
      expectResponseDicKeysArray:nil
                      retryTimes:1
                  isReqestByPost:YES
               ComplitionHandler:^(NSURLResponse *response, NSDictionary *resultJsonDic, NSError *jsonParseErr, NSString *resultStr, NSData *resultRawData, NSError *error) {
                   
                   installMoreTime++;

                   if (!error && !jsonParseErr) {
                       NSString *result = [NSString stringWithFormat:@"%@",resultJsonDic[@"result"]];
                       if (0 == [result intValue]) {
//                           NSLog(@"【activate_log】: %@",resultJsonDic);
                           // 标记
                           completion(resultJsonDic);
                       } else {
                           completion(nil);
                       }
                       
                       installMoreTime = 0;
                   } else {
                       if (installMoreTime <= totolTryTimeMax) {
                           // 再次请求
//                           NSLog(@"request more %ld",(long)installMoreTime);
                           [NetEngine yc_reportInstalledCompletion:completion];
                       } else {
                           installMoreTime = 0;
                           [HelloUtils spToastWithMsg:@"请求超时"];
                           completion(nil);
                       }
                   }
                   
               }];
}

#pragma mark - 登录日志上报

+ (void)yce_reportLogined
{
    NSDictionary * dict = nil;
    @try {
        dict = @{
                 @"uid"      : [YCUser shareUser].uid ?:@"",
                 @"username" : [YCUser shareUser].account ?:@"",
                 @"sid"      : [YCUser shareUser].serverId ?:@"",
                 @"roleid"   : [YCUser shareUser].roleID ?:@"",
                 @"rolename" : [YCUser shareUser].roleName ?:@"",
                 @"level"    : [YCUser shareUser].roleLevel ?:@"",
                 @"gold"     : @"",
                 @"mac"      : [SPFunction getMacaddress] ? : @"",
                 @"device"   : [SPFunction getSpUUID],
                 @"modeltype"       : @"iOS",
                 @"gameversion"     : [SPFunction getBundleVersion],
                 @"device_model"    : [SPFunction getDeviceType],
                 @"device_resolution"    :   @"",
                 @"device_version"  :   [SPFunction getSystemVersion],
                 @"device_net"      : @"",
                 @"onlinetime"  : @"",
                 
                 @"adid"     :   [SPFunction getSpUUID],
                 @"aid"      :   [YCUser shareUser].aid ? : @"",
                 @"index"    :   [SPFunction getSpUUID],
                 
                 };
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@", [NSString stringWithFormat:@"!!!ERROR Dic At yce_reportLogined:\n %@ \n %@", dict, exception.description]);
    }
    
    
    NSString *mainDomain = [NSString stringWithFormat:@"%@/sdklog/login_log",kDataDomain];
    
    [SPRequestor requestByParams:dict
                additionalParams:nil
                   requestDomain:mainDomain
             requestSecondDomain:mainDomain
      expectResponseDicKeysArray:nil
                      retryTimes:1
                  isReqestByPost:YES
               ComplitionHandler:^(NSURLResponse *response, NSDictionary *resultJsonDic, NSError *jsonParseErr, NSString *resultStr, NSData *resultRawData, NSError *error) {
                   
                   if (!error && !jsonParseErr) {
                       NSString *result = [NSString stringWithFormat:@"%@",resultJsonDic[@"result"]];
                       if (0 == [result intValue]) {
//                           NSLog(@"---登录上报成功---");
                       } else {
//                           NSLog(@"---登录上报失败--- \n resultDic = %@",resultJsonDic);
                       }
                   }
                   
               }];
}

#pragma mark - 获取账号列表

+ (void)yc_getAccountList
{
    NSDictionary * dict = @{
                            @"adid"     :   [SPFunction getSpUUID],             // must
                            };    
    
    NSString *mainDomain = [NSString stringWithFormat:@"%@/api/getAllUser",kPlatformDomain];
    
    [SPRequestor requestByParams:dict
                additionalParams:nil
                   requestDomain:mainDomain
             requestSecondDomain:mainDomain
      expectResponseDicKeysArray:nil
                      retryTimes:1
                  isReqestByPost:YES
               ComplitionHandler:^(NSURLResponse *response, NSDictionary *resultJsonDic, NSError *jsonParseErr, NSString *resultStr, NSData *resultRawData, NSError *error) {
                   
                   if (!error && !jsonParseErr) {
                       NSString *result = [NSString stringWithFormat:@"%@",resultJsonDic[@"result"]];
                       if (0 == [result intValue]) {
//                           NSLog(@"---获取用户列表成功---\n %@",resultJsonDic);
                           
                           [YCDataUtils yc_handleReqUserList:resultJsonDic];

                       } else {
//                           NSLog(@"---获取用户列表失败--- \n resultDic = %@",resultJsonDic);
                       }
                   }
                   
               }];
}


#pragma mark - 获取公告信息

+ (void)yc_getGoodNews
{
    NSDictionary * dict = @{
                            @"aid"      :   [YCUser shareUser].aid ? : @"",                // option
                            };
    
    NSString *mainDomain = [NSString stringWithFormat:@"%@/api/notice",kPlatformDomain];
    
    [SPRequestor requestByParams:dict
                additionalParams:nil
                   requestDomain:mainDomain
             requestSecondDomain:mainDomain
      expectResponseDicKeysArray:nil
                      retryTimes:1
                  isReqestByPost:YES
               ComplitionHandler:^(NSURLResponse *response, NSDictionary *resultJsonDic, NSError *jsonParseErr, NSString *resultStr, NSData *resultRawData, NSError *error) {
                   
                   huhaMoreTime++;
                   
                   if (!error && !jsonParseErr) {
                       NSString *result = [NSString stringWithFormat:@"%@",resultJsonDic[@"result"]];
                       if (0 == [result intValue]) {
//                           NSLog(@"---获取游戏公告成功---\n %@",resultJsonDic);
                           
                           [YCDataUtils yc_handleGoodNews:resultJsonDic[@"data"]];
                           
                       } else {
//                           NSLog(@"---获取游戏公告失败--- \n resultDic = %@",resultJsonDic);
                       }
                       huhaMoreTime = 0;
                   } else {
                       if (huhaMoreTime <= totolTryTimeMax) {
                           // 再次请求
                           NSLog(@"request more %ld",(long)huhaMoreTime);
                           [NetEngine yc_getGoodNews];
                       } else {
                           huhaMoreTime = 0;
                           [HelloUtils spToastWithMsg:@"请求超时"];
                       }
                   }
                   
               }];
}

#pragma mark - 获取第三方支付链接

+ (void)yc_getPPPOrderIdWithParams:(NSDictionary *)dict completion:(void (^)())completion
{
    NSDictionary * aDict = @{
                            @"uid"          :   [YCUser shareUser].uid,             // must
                            @"site"         :   [YCUser shareUser].site,
                            @"version"      :   [YCUser shareUser].sdkVersion,
                            @"cp_order_id"  :   [HelloUtils ycu_paraseObjToStr:dict[YC_PRM_PAY_CP_ORDER_ID]] ? : @"",
                            @"aid"          :   [YCUser shareUser].aid ?:@"",
                            @"roleid"       :   [YCUser shareUser].roleID ? :@"",
                            @"rolename"     :   [YCUser shareUser].roleName ? :@"",
                            @"serverid"     :   [YCUser shareUser].serverId ? :@"",
                            @"money"        :   [HelloUtils ycu_paraseObjToStr:dict[YC_PRM_PAY_PRODUCT_PRICE]] ? :@"",
                            @"adid"         :   [SPFunction getSpUUID],
                            @"mac"          :   [SPFunction getMacaddress],
                            @"device_type"  :   [SPFunction getDeviceType],
                            @"productid"    :   [HelloUtils ycu_paraseObjToStr:dict[YC_PRM_PAY_PRODUCT_ID]],
                            @"ext"          :   [HelloUtils ycu_paraseObjToStr:dict[YC_PRM_PAY_EXTRA]] ? : @"",
                            };
    
    NSString *mainDomain = [NSString stringWithFormat:@"%@/api/getPayOrder",kPayDomain];
    
    [SPRequestor requestByParams:aDict
                additionalParams:nil
                   requestDomain:mainDomain
             requestSecondDomain:mainDomain
      expectResponseDicKeysArray:nil
                      retryTimes:1
                  isReqestByPost:YES
               ComplitionHandler:^(NSURLResponse *response, NSDictionary *resultJsonDic, NSError *jsonParseErr, NSString *resultStr, NSData *resultRawData, NSError *error) {
                   
                   if (!error && !jsonParseErr) {
                       NSString *result = [NSString stringWithFormat:@"%@",resultJsonDic[@"result"]];
                       if (0 == [result intValue]) {
//                           NSLog(@"---获取订单成功---\n %@",resultJsonDic);
                           completion(resultJsonDic);
                       } else {
//                           NSLog(@"---获取订单失败--- \n resultDic = %@",resultJsonDic);
                           [HelloUtils spToastWithMsg:[resultJsonDic[@"data"] objectForKey:@"msg"]];
                           completion(nil);
                       }
                   } else {
                       completion(error);
                   }
                   
               }];
}

+ (void)yc_getPPPLinkWithParams:(NSDictionary *)dict
                     completion:(void(^)())completion
{
    NSString *mainDomain = [NSString stringWithFormat:@"%@/api/getPayUrl",kPayDomain];//@"https://recharge.play800.cn/api/getPayUrl";
    
    [SPRequestor requestByParams:dict
                additionalParams:nil
                   requestDomain:mainDomain
             requestSecondDomain:mainDomain
      expectResponseDicKeysArray:nil
                      retryTimes:1
                  isReqestByPost:YES
               ComplitionHandler:^(NSURLResponse *response, NSDictionary *resultJsonDic, NSError *jsonParseErr, NSString *resultStr, NSData *resultRawData, NSError *error) {
                   
                   if (!error && !jsonParseErr) {
                       NSString *result = [NSString stringWithFormat:@"%@",resultJsonDic[@"result"]];
                       if (0 == [result intValue]) {
//                           NSLog(@"---获取第三方支付链接成功---\n %@",resultJsonDic);
                           completion(resultJsonDic);
                       } else {
//                           NSLog(@"---获取第三方支付链接失败--- \n resultDic = %@",resultJsonDic);
                           [HelloUtils spToastWithMsg:[resultJsonDic[@"data"] objectForKey:@"msg"]];
                           completion(nil);
                       }
                   } else {
                       completion(error);
                   }
                   
               }];
}


#pragma mark - IAP

+ (void)yc_gotoHell:(NSDictionary *)dict
{
    [YCIapFunction directToInAppPurchaseWithParams:dict];
}

#pragma mark - CDN

+ (void)yc_cdnFileGoodCompletion:(void (^)())completion
{
    NSString *mainDomain = strCdnInitUrl;
    
    [SPRequestor requestByParams:@{}
                additionalParams:nil
                   requestDomain:mainDomain
             requestSecondDomain:mainDomain
      expectResponseDicKeysArray:nil
                      retryTimes:1
                  isReqestByPost:NO
               ComplitionHandler:^(NSURLResponse *response, NSDictionary *resultJsonDic, NSError *jsonParseErr, NSString *resultStr, NSData *resultRawData, NSError *error) {
                   
                   cndMoreTime++;
                   
                   if (!error && resultJsonDic.count > 0) {
                       
                       if ([resultJsonDic[@"url_address"] count] > 0) {
                           [YCDataUtils yc_handleCDNGoods:resultJsonDic[@"url_address"]];
                           completion ? completion(@"YES"):nil;

                       } else {
                           completion ? completion(@"NO"):nil;

                       };
                       cndMoreTime = 0;
                       
                   } else {
                       
                       if (cndMoreTime <= totolTryTimeMax) {
                           // 再次请求
                           NSLog(@"request more %ld",(long)cndMoreTime);
                           [NetEngine yc_cdnFileGoodCompletion:nil];
                       } else {
                           cndMoreTime = 0;
                           [HelloUtils spToastWithMsg:@"请求超时"];
                           completion ? completion(@"NO"):nil;
                       }
                   }
                   
               }];
}

#pragma mark - 发货

+ (void)yc_postDataToValiteWithOrderID:(NSString * _Nonnull)orderID
                          currencyCode:(NSString * _Nonnull)currencyCode
                            localPrice:(NSString * _Nonnull)localPrice
                         transactionId:(NSString * _Nonnull)transactionId
                           receiptData:(NSData * _Nonnull)receiptData
                                userId:(NSString * _Nonnull)userId
                            serverCode:(NSString * _Nonnull)serverCode
                  andComplitionHandler:(IapAppstoreCallBack _Nullable)handler
{
    NSString *base64Str = [SPFunction encode:(uint8_t *)receiptData.bytes length:receiptData.length];
    
    NSDictionary *dic;
    @try
    {
        dic = @{
                @"uid"              : userId,
                @"order_id"         : orderID,
                @"transaction_id"   : transactionId,
                @"apple_receipt"    : base64Str,
                };
    }
    @catch (NSException *exception)
    {
        SP_FUNCTION_LOG(exception.description);
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [HelloUtils spToastWithMsg:[NSString stringWithFormat:@"!!!ERROR Dic At postDataToValiteWithOrderID:\n %@ \n %@", dic, exception.description]];
                       });
    }
    
    NSString *mainDomain = [NSString stringWithFormat:@"%@/api/verifyReceipt",kPayDomain];
    NSArray * expectResponseDicKeysArray = nil;
    
    [SPRequestor requestByParams:dic
                additionalParams:nil
                   requestDomain:mainDomain
             requestSecondDomain:mainDomain
      expectResponseDicKeysArray:expectResponseDicKeysArray
                      retryTimes:1
                  isReqestByPost:YES
               ComplitionHandler:^(NSURLResponse *response, NSDictionary *resultJsonDic, NSError *jsonParseErr, NSString *resultStr, NSData *resultRawData, NSError *error) {                   
                   
                   NSString *tmpResultCode = nil;
                   NSString *tmpOrderID = nil;
                   
                   if (!error && !jsonParseErr)
                   {
                       //获取code参数
                       NSString * codeStr= [NSString stringWithFormat:@"%@",resultJsonDic[@"result"]];
                       
                       if ( 0 == codeStr.intValue )// 成功
                       {
//                           NSLog(@"-----验证、发货成功-------");
                       }

//                       NSLog(@"---直接提交验证完了，发货成功或不成功服务器去处理就完了----");
//                       NSLog(@"验证结果：%@",resultJsonDic[@"data"][@"msg"]);
                   }
                   
                   if (error) {
//                       NSLog(@"%@",error.description);
                   }
                   
                   if (handler) {
                       handler(tmpResultCode, tmpOrderID, resultJsonDic, error);
                   }
               }];
}

+ (void)yc_pppIsFeelBetterWithOrderId:(NSString *)orderId
                           completion:(void (^)())completion
{
//    https://recharge.iwantang.com/api/queryPayResult?site=testadads_ios&sign=FC48EC9AE92729F3E041599F66304CD4&order_id=tes1532487353_334_41477897_2190&json=1&time=1532487360578&version=1.0.0.0
    
    NSDictionary *dic = @{
                          @"order_id"         : orderId,
                          @"json"             : @"1", //通过该字段去获取最终的json对象，否则就是一个网页信息
                          };
    
    NSString *mainDomain = [NSString stringWithFormat:@"%@/api/queryPayResult",kPayDomain];
    
    
    [SPRequestor requestByParams:dic
                additionalParams:nil
                   requestDomain:mainDomain
             requestSecondDomain:mainDomain
      expectResponseDicKeysArray:nil
                      retryTimes:1
                  isReqestByPost:YES
               ComplitionHandler:^(NSURLResponse *response, NSDictionary *resultJsonDic, NSError *jsonParseErr, NSString *resultStr, NSData *resultRawData, NSError *error) {
                   
                   if (!error && resultJsonDic.count > 0) {
                       completion ? completion(resultJsonDic) : nil;
                       
                   } else {                       
                       [HelloUtils spToastWithMsg:@"请求超时"];
                       completion ? completion(nil):nil;                       
                   }
               }];
}

@end

