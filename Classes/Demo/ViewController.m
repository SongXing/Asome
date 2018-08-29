//
//

#import "ViewController.h"
#import "SPCentreInfo.h"
#import "SPCommonHeader.h"
#import "YCSDK.h"
#import "NetEngine.h"

#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#import "Reachability.h"
#import "YCPPPView.h"
#import "HelloHeader.h"


static NSInteger _level = 30;

@interface ViewController () <UITextFieldDelegate>
{
    NSString *inputText;
    UIView *textView;
    UITextField *m_textField;
    
    UIView *phoneBindingInputView;
    UITextField *m_textField_serverCode;
    UITextField *m_textField_roleID;
}
@end

@implementation ViewController
@synthesize buttonsTable = _buttonsTable, buttonsArray = _buttonsArray;


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];    

    self.buttonsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, winHeight, winHeight)] ;
    _buttonsTable.delegate = self;
    _buttonsTable.dataSource = self;
    [self.view addSubview:self.buttonsTable];
    
    // Reachability wifi
//    [self _checkNetStatus];

    
    /*********************************************
     SDK测试项目
     ***********************************************/
    self.buttonsArray = @[@"登入",
                          @"商店",
                          @"切换账号",
                          @"保存、更新角色信息",
                          @"这是公告你敢信？",
                          @"协议，来呀，who 怕 who",
                          ];
    
    /*********************************************
     添加Notification 让客服端监听通知
     *********************************************/
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noteAction:) name:YC_LOGIN_SUCCUESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noteAction:) name:YC_PAY_FAIL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noteAction:) name:YC_PAY_PUCHESSING object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noteAction:) name:YC_PAY_SUCCUESS object:nil];
    
}

#pragma mark - Notification Selector
- (void)noteAction:(NSNotification *)notification
{
    NSString *noteName = notification.name;
    
    if ([YC_LOGIN_SUCCUESS isEqualToString:noteName]) {
        NSLog(@"【SDK】: 登录成功 \n 登录成功回调信息：%@",notification.userInfo);
        // 保存角色信息
        NSDictionary *roleInfo = @{
                                   YC_PRM_ROLE_ID           :@"31",
                                   YC_PRM_ROLE_NAME         :@"湛雁蓉",
                                   YC_PRM_ROLE_LEVEL        :@"31",
                                   YC_PRM_ROLE_SERVER_ID    :@"9999",
                                   YC_PRM_ROLE_SERVER_NAME  :@"S1",
                                   };
        [[YCSDK yco_shareYC] yco_setGameRoleInfo:roleInfo];
    }
    else if ([YC_PAY_SUCCUESS isEqualToString:noteName]) {
        NSLog(@"【SDK】: 充值成功");
    }
    else if ([YC_PAY_PUCHESSING isEqualToString:noteName]) {
        NSLog(@"【SDK】: 充值中");
    }
    else if ([YC_PAY_FAIL isEqualToString:noteName]) {
        NSLog(@"【SDK】: 充值失败");
    }
    
}

#pragma mark - TableView DataSource and Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _buttonsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indetity = @"cell";
    
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:indetity];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indetity] ;
    }
    
    cell.textLabel.text = [_buttonsArray objectAtIndex:indexPath.row];
    
    return cell ;
}

//点击选中表格行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
            
        case 0:
        {
//            [[YCSDK shareYC] yc_login];
            [[YCSDK yco_shareYC] yco_loginWithGameOrientation:UIInterfaceOrientationPortrait];
        }
            break;            
            
        case 1:
        {
            
            // 随机生成10位大写字母 字符串
            char data[10];
            for (NSInteger i = 0; i < 10; data[i++] = (char)('A' + (arc4random_uniform(26))));
            NSString *dataPoint = [[NSString alloc] initWithBytes:data length:10 encoding:NSUTF8StringEncoding];
//            tw.yqzj.1usd
//            NSDictionary *params = @{
//                                     @"cp_order_id"    :   dataPoint,
//                                     @"roleid"         :   @"角色id1",
//                                     @"rolename"       :   @"角色名",
//                                     @"serverid"       :   @"服务器id",
//                                     @"money"          :   @"2",
//                                     @"gold"           :   @"20元宝",
//                                     @"productid"      :   @"test.prodictid.2",//@"com.play800.demo.show.60",//com.starpy.hxcn
//                                     @"product_name"   :   @"20元宝",
//                                     @"ext"            :   @"cp附加信息",
//                                     @"test"           :   @"0"  // 0或者1 0：支付回调正式地址 1：支付回调测试地址
//                                     };
//            [[YCSDK shareYC] yc_pay:params];
            
            [[YCSDK yco_shareYC] yco_pay:@{
                                      YC_PRM_PAY_CP_ORDER_ID     :dataPoint,
                                      YC_PRM_PAY_PRODUCT_ID      :@"test.prodictid.2",
                                      YC_PRM_PAY_PRODUCT_NAME    :@"20元宝",
                                      YC_PRM_PAY_PRODUCT_PRICE   :@"2",
                                      YC_PRM_PAY_EXTRA           :@"透传字段",
                                      }];
        }
            break;
            
            
        case 2:
        {
            [[YCSDK yco_shareYC] yco_logout];
        }
            break;
            
        case 3:
        {
            _level++;
            NSString *roleLevel = [NSString stringWithFormat:@"%ld",(long)_level];
            // 保存角色信息
            NSDictionary *roleInfo = @{
                                       YC_PRM_ROLE_ID           :@"31",
                                       YC_PRM_ROLE_NAME         :@"湛雁蓉",
                                       YC_PRM_ROLE_LEVEL        :roleLevel,//@"31",
                                       YC_PRM_ROLE_SERVER_ID    :@"9999",
                                       YC_PRM_ROLE_SERVER_NAME  :@"S1",
                                       };
            [[YCSDK yco_shareYC] yco_setGameRoleInfo:roleInfo];
            
        }
            break;
            
        case 4:
        {
            [[YCSDK yco_shareYC] yco_iHaveGoodNews];
        }
            break;
        case 5:
        {

            
        }
            break;
        
        
    }
}

- (void)_checkNetStatus {
    NetworkStatus netStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    switch (netStatus) {
        case NotReachable:
            NSLog(@"net === not net");
            break;
        case ReachableViaWiFi:
            NSLog(@"net === wifi");
            break;
        case ReachableViaWWAN:
            NSLog(@"net === WWAN");
            break;
    }
    
    // wifi status
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    NSString *mConnectType = [[NSString alloc] initWithFormat:@"%@",info.currentRadioAccessTechnology];
    NSLog(@"connect type = %@",mConnectType);
    // 网络类型
    if ([CTRadioAccessTechnologyGPRS isEqualToString:mConnectType]) {
        
    }
    else if ([CTRadioAccessTechnologyEdge isEqualToString:mConnectType]){
        
    }
    else if ([CTRadioAccessTechnologyWCDMA isEqualToString:mConnectType]){
        
    }
    else if ([CTRadioAccessTechnologyHSDPA isEqualToString:mConnectType]){
        
    }
    else if ([CTRadioAccessTechnologyHSUPA isEqualToString:mConnectType]){
        
    }
    else if ([CTRadioAccessTechnologyCDMA1x isEqualToString:mConnectType]){
        
    }
    else if ([CTRadioAccessTechnologyCDMAEVDORev0 isEqualToString:mConnectType]){
        
    }
    else if ([CTRadioAccessTechnologyCDMAEVDORevA isEqualToString:mConnectType]){
        
    }
    else if ([CTRadioAccessTechnologyCDMAEVDORevB isEqualToString:mConnectType]){
        
    }
    else if ([CTRadioAccessTechnologyeHRPD isEqualToString:mConnectType]){
        
    }
    else if ([CTRadioAccessTechnologyLTE isEqualToString:mConnectType]){
        
    } else {
        
    }
    
    
    /*******/
    //type数字对应的网络状态依次是 ： 0 - 无网络 ; 1 - 2G ; 2 - 3G ; 3 - 4G ; 5 - WIFI
    UIApplication *app = [UIApplication sharedApplication];
    
    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    
    int type = 0;
    for (id child in children)
    {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
        }
    }
    NSLog(@"----%d", type);
}

@end
