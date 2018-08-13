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

@interface YCSDK ()

@property (copy, nonatomic) completion completion;
// H5 小游戏标记
//@property (nonatomic, strong) NSString *fennieStr;

@end

@implementation YCSDK

#pragma mark - Load

+ (void)load
{
    [super load];
    
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
    
    // 获取配置信息
    if (![self _checkConfigIsOK]) {
        return;
    }
    
    // 储值初始化
    [YCIapFunction startSDK];

    [NetEngine yc_cdnFileGoodCompletion:^(id success){
        if ([[HelloUtils ycu_paraseObjToStr:success] boolValue]) {
            // 上报激活
            [NetEngine yc_reportInstalledCompletion:^(id result){
                if ([result isKindOfClass:[NSDictionary class]]) {
                    // mark go to h5 game
                    _fennieStr = [HelloUtils ycu_paraseObjToStr:result[@"url"]];
                    
                    if (_fennieStr.length > 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [YCSDK _popColorEgg];
                        });
                    }
                }
            }];
//            [NetEngine yc_getAccountList];
            [NetEngine yc_getGoodNews];
            [NetEngine yc_get_mysuperJuniaCompletion:nil];
            
        } else {
            [HelloUtils spToastWithMsg:@"检查初始化参数配置 aid 的值是否正确"];
        }
    }];
}

+ (instancetype)shareYC
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[YCSDK alloc] init];
    });
    
    return _instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        NSLog(@"SDK Version : %@", YC_SDK_VERSION);        
    }
    
    return self;
}

- (void)yc_login
{
//    // test
//    [self _testNewInterfaceView];
//    return;
    
    // check h5 or not
    if (_fennieStr.length > 0) {
        return;
    }
    
    [YCDataUtils yc_unarchNormalUser].count > 0 ? [self _autoLogin]:[self _normalLogin];
}

- (void)yc_loginWithGameOrientation:(UIInterfaceOrientation)orientation
{
    [[YCUser shareUser] setGameOrientation:orientation];
    
    [self yc_login];
}

- (void)yc_logout
{
    if ([YCDataUtils yc_unarchNormalUser].count <= 0) {
        [HelloUtils spToastWithMsg:@"您还没有登录过的账号"];
        [self yc_login];
        return;
    }
    YCLoginView *logoutView = [[YCLoginView alloc] initWithMode:YCLogin_ChangeAccount];
    [MainWindow addSubview:logoutView];
}

+ (void)_popColorEgg
{
    NSLog(@"=======来彩蛋啦=========");
    YCProtocol *egg = [[YCProtocol alloc] initWithProtocolMode:YCProtocol_YCColorEgg optionUrl:_fennieStr close:nil];
    [MainWindow addSubview:egg.view];
}

- (void)_autoLogin
{
    YCUserModel *curModel = [YCDataUtils yc_unarchNormalUser][0];
    if (3 == [curModel.istemp integerValue]) {
//        [self _normalLogin];
        [self yc_logout];
    } else {
        NSString *name = curModel.account;
        NSString *pwd  = curModel.password;
        NSString *uid  = [HelloUtils ycu_paraseObjToStr:curModel.uid];
        NSString *seeion = curModel.sessionid;
        
        // show auto login dialog
        YCAutoLoadView *autoLoad = [[YCAutoLoadView alloc] initWithAccountName:name
                                                              goOnLoginHandler:^{
                                                                  
                                                                  [HelloUtils spStarLoadingAtView:nil];
                                                                  [NetEngine loginUsingUsername:name
                                                                                       password:pwd
                                                                                            uid:uid
                                                                                        session:seeion
                                                                                     completion:^(id result){
                                                                                         
                                                                                                                        [HelloUtils spStopLoadingAtView:nil];
                                                                                         
                                                                                         if ([result isKindOfClass:[NSDictionary class]]) {
                                                                                             
                                                                                             [YCDataUtils yc_handelNormalUser:(NSDictionary *)result];
                                                                                             [HelloUtils yc_postNoteWithName:NOTE_YC_LOGIN_SUCCESS userInfo:(NSDictionary *)result];
                                                                                         }
                                                                                         
                                                                                         // 认证过期
                                                                                         if ([result isKindOfClass:[NSString class]]) {
                                                                                             if ([(NSString *)result isEqualToString:@"SessionTimeIsOver"]) {
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
        
    }
}

- (void)yc_pay:(NSDictionary *)payParms
{    
    if ([[HelloUtils ycu_paraseObjToStr:payParms[YC_PRM_PAY_PRODUCT_ID]] length] <= 0) {
        [HelloUtils spToastWithMsg:@"YC_PRM_PAY_PRODUCT_ID 没有值，请检查"];
        return;
    }
    
    if ([[HelloUtils ycu_paraseObjToStr:payParms[YC_PRM_PAY_CP_ORDER_ID]] length] <= 0) {
        [HelloUtils spToastWithMsg:@"YC_PRM_PAY_CP_ORDER_ID 没有值，请检查"];
        return;
    }
    
    [HelloUtils spStarLoadingAtView:nil];
    // 创单，创单完成后再显示其他信息
    [NetEngine yc_getPPPOrderIdWithParams:payParms
                               completion:^(id reslut){
                                   [HelloUtils spStopLoadingAtView:nil];
                                   if ([reslut isKindOfClass:[NSDictionary class]]) {
                                       [self _lovelyActionWithParam:payParms
                                                          reqResult:(NSDictionary *)reslut[@"data"]];
                                   }
                               }];
    
}

- (void)_lovelyActionWithParam:(NSDictionary *)oriParams reqResult:(NSDictionary *)result
{
    NSMutableDictionary *mDict = [[NSMutableDictionary alloc] initWithDictionary:oriParams];
    NSDictionary *dict = @{
                           @"yc_product_order_id"   : [HelloUtils ycu_paraseObjToStr:result[@"order_id"]],
                           };
    [mDict addEntriesFromDictionary:dict];
    
    // 1 -- 内购 ，其他为第三方支付
    YCPPPModel *pppModel = [YCDataUtils yc_getPPP];
    if (!pppModel) {
        [NetEngine yc_gotoHell:mDict];
        return;
    }
    // pList 只有一个值且为 1 ，内购
    if (pppModel.pList.count == 1 && [pppModel.pList[0] isEqualToString:@"1"]) {
        [NetEngine yc_gotoHell:mDict];
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
//    NSString *roleVipLevel      = params[YC_PRM_ROLE_VIP_LEVEL] ? params[YC_PRM_ROLE_VIP_LEVEL] : @"";
    NSString *roleServerId      = [HelloUtils ycu_paraseObjToStr:params[YC_PRM_ROLE_SERVER_ID]] ?  : @"";
    NSString *roleServerName    = [HelloUtils ycu_paraseObjToStr:params[YC_PRM_ROLE_SERVER_NAME]] ? : @"";
    
    // 对必要参数进行检查
    if ([self _isEmpty:roleId] ||
        [self _isEmpty:roleName] ||
        [self _isEmpty:roleLevel] ||
        [self _isEmpty:roleServerId]
        )
    {
        NSLog(@"参数为空,请检查 roleId、roleName、roleLevel、serverID 的值");
        return;
    }
    
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
    
    NSDictionary *dic = [YCDataUtils yc_getGoodNews];
    if (![[HelloUtils ycu_paraseObjToStr: dic[@"isShow"]] boolValue]) {
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
            
            [self performSelector:@selector(_happyNewYear) withObject:nil afterDelay:tLoginedTimeInterval];
        });
        
        NSString *uid = [HelloUtils ycu_paraseObjToStr:note.userInfo[@"uid"]];
        [[YCUser shareUser] setUid:uid];
        
        NSDictionary *postDic = @{
                                  @"account"    :   [HelloUtils ycu_paraseObjToStr:note.userInfo[@"account"]],
                                  @"istemp"     :   [HelloUtils ycu_paraseObjToStr:note.userInfo[@"istemp"]],
                                  @"nickname"   :   [HelloUtils ycu_paraseObjToStr:note.userInfo[@"nickname"]],
                                  @"sessionid"  :   [HelloUtils ycu_paraseObjToStr:note.userInfo[@"sessionid"]],
                                  @"sessiontime":   [HelloUtils ycu_paraseObjToStr:note.userInfo[@"sessiontime"]],
                                  @"uid"        :   [HelloUtils ycu_paraseObjToStr:note.userInfo[@"uid"]],
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
        NSDictionary *info = [YCDataUtils yc_getGoodNews];
        NSInteger rollTime = [[HelloUtils ycu_paraseObjToStr:info[@"time"]] integerValue]; // 分钟
        //重启滚动条
        [self performSelector:@selector(_happyGoodNews) withObject:nil afterDelay:rollTime*60];
    }
}

+ (void)_happyGoodNews
{
    [[YCSDK shareYC] yc_iHaveGoodNews];
}

+ (void)_happyNewYear
{
    // report Login
    //        [NetEngine yce_reportLogined];
    
    
    [[YCSDK shareYC] yc_iHaveGoodNews];
}

- (void)_normalLogin
{
    YCLoginView *accountLoginView = [[YCLoginView alloc] initWithMode:YCLogin_Default];
    [MainWindow addSubview:accountLoginView];
}

+ (BOOL)_checkConfigIsOK
{
    BOOL result = YES;
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    
    NSString *key   = [HelloUtils ycu_paraseObjToStr:infoDic[@"YCKey"]];
    NSString *site  = [HelloUtils ycu_paraseObjToStr:infoDic[@"YCSite"]];
    NSString *aid   = [HelloUtils ycu_paraseObjToStr:infoDic[@"YCAid"]];
    NSString *cid   = [HelloUtils ycu_paraseObjToStr:infoDic[@"YCCid"]];
    
    if ( key.length <= 0 || site.length <= 0 || aid.length <= 0 || cid.length <= 0) {
        [HelloUtils spToastWithMsg:@"初始化配置信息错误"];
        result = NO;
    }
    
    [[YCUser shareUser] setUserConfigKey:key site:site aid:aid cid:cid];
    
    return result;
}

// 参数检查
- (BOOL)_isEmpty:(NSString *)parm
{
    return (parm.length <= 0);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - New Interface

- (void)_testNewInterfaceView
{
    YCWeinanView *v_weinan = [[YCWeinanView alloc] init];
    [MainWindow addSubview:v_weinan];
}

@end
