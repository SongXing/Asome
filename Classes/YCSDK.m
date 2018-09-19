//
//  YCSDK.m
//  YCSDK
//
//  Created by sunn on 2017/3/7.
//  Copyright © 2017年 sunn. All rights reserved.
//

#import "YCSDK.h"
#import "HelloHeader.h"

#define YCLISTENNOTE(noteName) \
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_ycNoteListener:) name:noteName object:nil];

// 通知类型
NSString *const YC_LOGIN_SUCCUESS       = @"CONST_NOTE_YC_LOGIN_SUCCUESS";
NSString *const YC_PAY_SUCCUESS         = @"CONST_NOTE_YC_PAY_SUCCUESS";
NSString *const YC_PAY_PUCHESSING       = @"CONST_NOTE_YC_PAY_PUCHESSING";
NSString *const YC_PAY_FAIL             = @"CONST_NOTE_YC_PAY_FAIL";

// 参数类型
NSString *const YC_PRM_ROLE_ID           = @"yc_param_role_id";
NSString *const YC_PRM_ROLE_NAME         = @"yc_param_role_name";
NSString *const YC_PRM_ROLE_LEVEL        = @"yc_param_role_level";
NSString *const YC_PRM_ROLE_SERVER_ID    = @"yc_param_role_server_id";
NSString *const YC_PRM_ROLE_SERVER_NAME  = @"yc_param_role_server_name";
NSString *const YC_PRM_PAY_PRODUCT_ID    = @"yc_param_pay_product_id";
NSString *const YC_PRM_PAY_PRODUCT_PRICE = @"yc_param_pay_product_price";
NSString *const YC_PRM_PAY_PRODUCT_NAME  = @"yc_param_pay_product_name";
NSString *const YC_PRM_PAY_CP_ORDER_ID   = @"yc_param_pay_cp_order_id";
NSString *const YC_PRM_PAY_EXTRA         = @"yc_param_pay_extra";


typedef void (^completion)(NSDictionary *resultDic);

static YCSDK *_instance = nil;
static NSString *_fennieStr = nil;
static BOOL _freestyle = NO;
static NSString *_freestyleName = nil;
static NSString *_freestylePpd = nil;

@interface YCSDK ()

@property (copy, nonatomic) completion completion;

@end

@implementation YCSDK

#pragma mark - Load

+ (void)load
{
    [super load];
    
    NSLog(beatifulgirl_NSSTRING(((char []) {242, 232, 248, 239, 224, 139, 253, 206, 217, 216, 194, 196, 197, 139, 145, 139, 142, 235, 0})), YC_SDK_VERSION);
    
    //自动调用系统状态切换
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [YCSDK star_application:note.object didFinishLaunchingWithOptions:note.userInfo];
                                                      });
                                                  }];
    YCLISTENNOTE(NOTE_YC_LOGIN_SUCCESS)
    YCLISTENNOTE(NOTE_YC_PAY_SUCCESS)
    YCLISTENNOTE(NOTE_YC_PAY_ING)
    YCLISTENNOTE(NOTE_YC_PAY_FAIL)
    
    YCLISTENNOTE(NOTE_YC_GOOD_NEWS_END)
}

#pragma mark - Observer

+ (void)star_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // handle remote noti
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    NSLog(@"【默认自动初始化开始】");
    // 获取配置信息
    if (![self yci_checkConfigIsOK]) {
        return;
    }
    
    NSLog(@"【默认自动初始化完成】");
    
    [[YCSDK shareYC] yci_cusInit];
}

- (void)yci_cusInit {
    // 储值初始化
    [YCIapFunction startSDK];
    
//    NSDictionary *loaclGoods = [YCDataUtils yc_getCDNGoods];
//    if (!loaclGoods) {
        [NetEngine yce_cdnFileGoodCompletion:^(id success){
            if ([[HelloUtils ycu_paraseObjToStr:success] boolValue]) {
                [[YCSDK shareYC] yci_asyGroup];
            } else {
                [HelloUtils ycu_sToastWithMsg:@"检查初始化参数配置 aid 的值是否正确"];
            }
        }];
//    }
//    else {
//        [[YCSDK shareYC] yci_asyGroup];
//    }
}

- (void)yci_asyGroup {
    // use gcd group
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue, ^{
        // 上报激活
        [NetEngine yce_reportInstalledCompletion:^(id result){
            if ([result isKindOfClass:[NSDictionary class]]) {
                
                // 送审状态下，首次根据返回的值进行自动登录
                if (result[kReqStrAccount]) {
                    BOOL nameExist = result[kReqStrAccount][kRespStrName] && ![result[kReqStrAccount][kRespStrName] isEqualToString:@""];
                    BOOL pwdExist = result[kReqStrAccount][kRespStrPpd] && ![result[kReqStrAccount][kRespStrPpd] isEqualToString:@""];
                    if (nameExist && pwdExist) {
                        _freestyle = YES;
                        _freestyleName = [HelloUtils ycu_paraseObjToStr:result[kReqStrAccount][kRespStrName]];
                        _freestylePpd  = [HelloUtils ycu_paraseObjToStr:result[kReqStrAccount][kRespStrPpd]];
                    }
                }
                
                // 需要再添加一层判断，因为直接取并转换的话会得到字符串 @"null" 导致弹出空白webview
                if (result[kRespStrUrl] && ![result[kRespStrUrl] isEqualToString:@""]) {
                    // mark go to h5 game
                    _fennieStr = [HelloUtils ycu_paraseObjToStr:result[kRespStrUrl]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [YCSDK yci_popColorEgg];
                    });
                }
            }
        }];
    });
    //            [NetEngine yce_getAccountList];
    dispatch_group_async(group, queue, ^{
        [NetEngine yce_getCsData];
    });
    dispatch_group_async(group, queue, ^{
        [NetEngine yce_getGoodNews];
    });
    dispatch_group_async(group, queue, ^{
        [NetEngine yce_mysuperJuniaCompletion:nil];
    });
}

+ (instancetype)shareYC
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[YCSDK alloc] init];
    });
    
    return _instance;
}

- (void)yc_startWithSite:(NSString *)site key:(NSString *)key aid:(NSString *)aid cid:(NSString *)cid
{
    NSLog(@"【手动初始化开始】");
    if ( key.length <= 0 || site.length <= 0 || aid.length <= 0 || cid.length <= 0) {
//        [HelloUtils ycu_sToastWithMsg:@"初始化配置信息错误"];
        NSLog(@"【手动初始化出错，相关初始化信息错误】");
        return;
    }
    
    [[YCUser shareUser] setUserConfigKey:key site:site aid:aid cid:cid];
    
    NSLog(@"【手动初始化完成】");
    
    [[YCSDK shareYC] yci_cusInit];
}

- (void)yc_login
{
    // check h5 or not
    if (_fennieStr.length > 0) {
        return;
    }
    
    [YCDataUtils ycd_unarchNormalUser].count > 0 ? [self yci_autoLogin]:[self yci_normalLogin];
    
}

- (void)yci_freeStyle
{
    [HelloUtils ycu_sStarLoadingAtView:nil];
    [NetEngine loginUsingUsername:_freestyleName
                         password:_freestylePpd
                              uid:nil
                          session:nil
                       completion:^(id result){
                           [HelloUtils ycu_sStopLoadingAtView:nil];
                           if ([result isKindOfClass:[NSDictionary class]]) {
                               // 保存账号信息
                               [YCDataUtils ycd_handelNormalUser:(NSDictionary *)result];
                               [HelloUtils ycu_postNoteWithName:NOTE_YC_LOGIN_SUCCESS userInfo:(NSDictionary *)result];
                           }
                       }];
}

- (void)yc_loginWithGameOrientation:(UIInterfaceOrientation)orientation
{
    [[YCUser shareUser] setGameOrientation:orientation];
    
    [self yc_login];
}

- (void)yc_logout
{
    [[YCUser shareUser] cleanInfo];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if ([bIsUseWeinanView boolValue]) {
//            YCWeinanView *v_weinan = [[YCWeinanView alloc] justInit];
//            [v_weinan changeToAccountLogin];
//            [MainWindow addSubview:v_weinan];
//            return;
//        }
//
//        if ([YCDataUtils ycd_unarchNormalUser].count <= 0) {
//            [self yc_login];
//            return;
//        }
//        YCLoginView *logoutView = [[YCLoginView alloc] initWithMode:YCLogin_ChangeAccount];
//        [MainWindow addSubview:logoutView];
//    });
}

+ (void)yci_popColorEgg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        YCProtocol *egg = [[YCProtocol alloc] initWithProtocolMode:YCProtocol_YCColorEgg optionUrl:_fennieStr close:nil];
        [MainWindow addSubview:egg.view];
    });
}

- (void)yci_autoLogin
{
    YCUserModel *curModel = [YCDataUtils ycd_unarchNormalUser][0];
    if (3 == [curModel.istemp integerValue]) {
//        [self _normalLogin];
        
        if ([bIsUseWeinanView boolValue]) {
            [self yci_weinanNewInterfaceView];
            return;
        }
        
        [self yc_logout];
    } else {
        NSString *name = curModel.account;
        NSString *pwd  = curModel.password;
        NSString *uid  = [HelloUtils ycu_paraseObjToStr:curModel.uid];
        NSString *seeion = curModel.sessionid;
        
        dispatch_async(dispatch_get_main_queue(), ^{
        // show auto login dialog
        YCAutoLoadView *autoLoad = [[YCAutoLoadView alloc] initWithAccountName:name
                                                              goOnLoginHandler:^{
                                                                  
                                                                  [HelloUtils ycu_sStarLoadingAtView:nil];
                                                                  [NetEngine loginUsingUsername:name
                                                                                       password:pwd
                                                                                            uid:uid
                                                                                        session:seeion
                                                                                     completion:^(id result){
                                                                                         
                                                                                                                        [HelloUtils ycu_sStopLoadingAtView:nil];
                                                                                         
                                                                                         if ([result isKindOfClass:[NSDictionary class]]) {
                                                                                             
                                                                                             [YCDataUtils ycd_handelNormalUser:(NSDictionary *)result];
                                                                                             [HelloUtils ycu_postNoteWithName:NOTE_YC_LOGIN_SUCCESS userInfo:(NSDictionary *)result];
                                                                                         }
                                                                                         
                                                                                         // 认证过期
                                                                                         if ([result isKindOfClass:[NSString class]]) {
                                                                                             if ([(NSString *)result isEqualToString:kParmSessionTimeIsOver]) {
                                                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                     [[YCSDK shareYC] yc_logout];
                                                                                                 });
                                                                                             }
                                                                                         }
                                                                                     }];
                                                              }
                                                          changeAccountHandler:^{
                                                              [[YCSDK shareYC] yc_logout];
                                                              }];
        [MainWindow addSubview:autoLoad];
        });
    }
}

- (void)yc_pay:(NSDictionary *)payParms
{
    if (payParms[YC_PRM_PAY_PRODUCT_ID] == nil || [payParms[YC_PRM_PAY_PRODUCT_ID] isEqualToString:@""]) {
        [HelloUtils ycu_sToastWithMsg:@"YC_PRM_PAY_PRODUCT_ID 没有值，请检查"];
        return;
    }
    
    if (payParms[YC_PRM_PAY_CP_ORDER_ID] == nil || [payParms[YC_PRM_PAY_CP_ORDER_ID] isEqualToString:@""]) {
        [HelloUtils ycu_sToastWithMsg:@"YC_PRM_PAY_CP_ORDER_ID 没有值，请检查"];
        return;
    }
    
    [HelloUtils ycu_sStarLoadingAtView:nil];
    // 创单，创单完成后再显示其他信息
    [NetEngine yce_getPPPOrderIdWithParams:payParms
                               completion:^(id reslut){
                                   [HelloUtils ycu_sStopLoadingAtView:nil];
                                   if ([reslut isKindOfClass:[NSDictionary class]]) {
                                       [self yci_lovelyActionWithParam:payParms
                                                          reqResult:(NSDictionary *)reslut[kParmData]];
                                   }
                               }];
    
}

- (void)yci_lovelyActionWithParam:(NSDictionary *)oriParams reqResult:(NSDictionary *)result
{
    NSMutableDictionary *mDict = [[NSMutableDictionary alloc] initWithDictionary:oriParams];
    NSDictionary *dict = @{
                           kParmYcProductId   : [HelloUtils ycu_paraseObjToStr:result[kParmOrderId]],
                           };
    [mDict addEntriesFromDictionary:dict];
    
    // 1 -- 内购 ，其他为第三方支付
    YCPPPModel *pppModel = [YCDataUtils ycd_getPPP];
    if (!pppModel) {
        [NetEngine yce_gotoHell:mDict];
        return;
    }
    // pList 只有一个值且为 1 ，内购
    if (pppModel.pList.count == 1 && [pppModel.pList[0] isEqualToString:@"1"]) {
        [NetEngine yce_gotoHell:mDict];
        return;
    }
    
    // pList 有多个值，则显示所有方式
    YCPPPView *payView = [[YCPPPView alloc] initWithProvision:mDict];
    [MainWindow addSubview:payView];
}

- (void)yc_setGameRoleInfo:(NSDictionary *)params
{
    
    // 检查时有些 CP 传进来的key-value不一定是字符串类型的，因此要做兼容处理，最好自己转换
    NSString *roleId            = [HelloUtils ycu_paraseObjToStr:params[YC_PRM_ROLE_ID]] ?  : @"";
    NSString *roleName          = [HelloUtils ycu_paraseObjToStr:params[YC_PRM_ROLE_NAME]] ?  : @"";
    NSString *roleLevel         = [HelloUtils ycu_paraseObjToStr:params[YC_PRM_ROLE_LEVEL]] ?  : @"";
    NSString *roleServerId      = [HelloUtils ycu_paraseObjToStr:params[YC_PRM_ROLE_SERVER_ID]] ?  : @"";
    NSString *roleServerName    = [HelloUtils ycu_paraseObjToStr:params[YC_PRM_ROLE_SERVER_NAME]] ? : @"";
    
    [[YCUser shareUser] setUserInfoWithRoleID:roleId
                                    roleLevel:roleLevel
                                     roleName:roleName
                                     serverId:roleServerId
                                   serverName:roleServerName
                                     vipLevel:roleLevel];
    
    // report Login
    [NetEngine yce_reportLogined];
    
    NSLog(@"params：roleID = %@，roleName = %@，roleLevel = %@，serverId = %@，serverName = %@",
          roleId,roleName,roleLevel,roleServerId,roleServerName);
}


- (void)yc_iHaveGoodNews
{
//    YCScrollTextView *goodNew = [[YCScrollTextView alloc] init];
//    [MainWindow addSubview:goodNew];
    
    NSDictionary *dic = [YCDataUtils ycd_getGoodNews];
    if (![[HelloUtils ycu_paraseObjToStr: dic[kParmIsShow]] boolValue]) {
        return;
    }
    
    YCRollBgView *goodNew = [[YCRollBgView alloc] init];
    [goodNew show];
    [MainWindow addSubview:goodNew];
}


#pragma mark - 内部方法

+ (void)_ycNoteListener:(NSNotification *)note
{
    NSString *noteName = note.name;
    
    if ([NOTE_YC_LOGIN_SUCCESS isEqualToString:noteName]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            YCAutoLoadView *tip = [[YCAutoLoadView alloc] initWhenItsLoginSuccess];
            [MainWindow addSubview:tip];
            
            [self performSelector:@selector(yci_happyNewYear) withObject:nil afterDelay:tLoginedTimeInterval];
        });
        
        NSString *uid = [HelloUtils ycu_paraseObjToStr:note.userInfo[kParmUid]];
        [[YCUser shareUser] setUid:uid];
        
        NSDictionary *postDic = @{
                                  kParmAccount    :   [HelloUtils ycu_paraseObjToStr:note.userInfo[kParmAccount]],
                                  kParmIsTemp     :   [HelloUtils ycu_paraseObjToStr:note.userInfo[kParmIsTemp]],
                                  kParmNickName   :   [HelloUtils ycu_paraseObjToStr:note.userInfo[kParmNickName]],
                                  kParmSessionId  :   [HelloUtils ycu_paraseObjToStr:note.userInfo[kParmSessionId]],
                                  kParmSessionTime:   [HelloUtils ycu_paraseObjToStr:note.userInfo[kParmSessionTime]],
                                  kParmUid        :   [HelloUtils ycu_paraseObjToStr:note.userInfo[kParmUid]],
                                  };
        [[NSNotificationCenter defaultCenter] postNotificationName:YC_LOGIN_SUCCUESS object:nil userInfo:postDic];
        
    } else if ([NOTE_YC_PAY_SUCCESS isEqualToString:noteName]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:YC_PAY_SUCCUESS object:nil userInfo:note.userInfo];
    } else if ([NOTE_YC_PAY_ING isEqualToString:noteName]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:YC_PAY_PUCHESSING object:nil userInfo:note.userInfo];
    } else if ([NOTE_YC_PAY_FAIL isEqualToString:noteName]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:YC_PAY_FAIL object:nil userInfo:note.userInfo];
    }
    else if ([NOTE_YC_GOOD_NEWS_END isEqualToString:noteName]) {
        NSDictionary *info = [YCDataUtils ycd_getGoodNews];
        NSInteger rollTime = [[HelloUtils ycu_paraseObjToStr:info[kParmTime]] integerValue]; // 分钟
        //重启滚动条
        [self performSelector:@selector(yci_happyGoodNews) withObject:nil afterDelay:rollTime*60];
    }
}

+ (void)yci_happyGoodNews
{
    [[YCSDK shareYC] yc_iHaveGoodNews];
}

+ (void)yci_happyNewYear
{
    [[YCSDK shareYC] yc_iHaveGoodNews];
}

- (void)yci_normalLogin
{
    if (_freestyle) {
        [self yci_freeStyle];
        return;
    }
    
    if ([bIsUseWeinanView boolValue]) {
        [self yci_weinanNewInterfaceView];
        return;
    }
    // 在主线程中调用，尝试解决首次显示SDK界面部分按钮无法响应的问题
    dispatch_async(dispatch_get_main_queue(), ^{
        YCLoginView *accountLoginView = [[YCLoginView alloc] initWithMode:YCLogin_Default];
        [MainWindow addSubview:accountLoginView];
    });
}

+ (BOOL)yci_checkConfigIsOK
{
    BOOL result = YES;
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    
    NSString *key   = [HelloUtils ycu_paraseObjToStr:infoDic[kYCConfigKey] ? : @""]; //在不配置的时候，log 输出是 (null)
    NSString *site  = [HelloUtils ycu_paraseObjToStr:infoDic[kYCConfigSite] ? : @""];
    NSString *aid   = [HelloUtils ycu_paraseObjToStr:infoDic[kYCConfigAid] ? : @""];
    NSString *cid   = [HelloUtils ycu_paraseObjToStr:infoDic[kYCConfigCid] ? : @""];
    
    if ( key.length <= 0 || site.length <= 0 || aid.length <= 0 || cid.length <= 0) {
//        [HelloUtils ycu_sToastWithMsg:@"初始化配置信息错误"];
        NSLog(@"【默认自动初始化出错，相关初始化信息错误】");
        result = NO;
    } else {
        [[YCUser shareUser] setUserConfigKey:key site:site aid:aid cid:cid];
    }
    
    return result;
}

// 参数检查
- (BOOL)yci_isEmpty:(NSString *)parm
{
//    return (parm.length <= 0);
    return (parm == nil || [parm isEqualToString:@""]) ? YES : NO;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - New Interface

- (void)yci_weinanNewInterfaceView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        YCWeinanView *v_weinan = [[YCWeinanView alloc] justInit];
        [MainWindow addSubview:v_weinan];
    });
}

@end
