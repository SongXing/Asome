//
//  AppDelegate.m
//

#import "AppDelegate.h"
#import "YCSDK.h"
#import "ViewController.h"
#import "SPFunction.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //打印打开
    NSString *context = @"shgHKHFKwewerKJSSNNIsjjZIwZAM9corFIW2ryTzcWI0Pou13eeLKjDkr7Zubcap5nNLWWY1xKX4ZqBJwKuCMrBRc4uPVIHct7EFxlcCgRpidsHHJKhjkjafbeudsahfaHKJSHJKFBKSBBjbkjbjbdskhfawe4889y8hdahfuhaiuhdbcbjkbkbvkjbkajsbdeweUUIHKB889ehuhuewhSHGHGH";
    
    NSString *keyPath=[NSHomeDirectory()stringByAppendingPathComponent:@"Library"];
    NSString *printFileName = @"sp_print_file.txt";
    NSString *printfPath = [keyPath stringByAppendingFormat:@"/Caches/%@",printFileName];
    [context writeToFile:printfPath atomically:NO encoding:NSUTF8StringEncoding error:nil];

    
    // handle buge number
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//       
//    
//    // 注册推送消息监听
//#ifdef __IPHONE_8_0
//    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
//        [application registerForRemoteNotifications];
//        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:
//                                                       UIUserNotificationTypeNone|
//                                                       UIUserNotificationTypeBadge|
//                                                       UIUserNotificationTypeSound categories:nil]];
//    } else {
//        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
//    }
//#else
//    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
//#endif
    
    
    [[YCSDK shareYC] yc_startWithSite:@"testadads_ios" key:@"489445b1f7a61270d31c0ea2b130497d" aid:@"910077090078118" cid:@"5"];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    ViewController *viewController = [[ViewController alloc] init];
    self.window.rootViewController = viewController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    /*********************************************
     处理程式被第三方app启动
     *********************************************/
//    return [YCSDK application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    return YES;
}

#pragma mark - Push registed Delegate Method
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    /*********************************************
     处理推送的注册
     *********************************************/
    NSString *tokenStr = [NSString stringWithFormat:@"%@",deviceToken];
    NSLog(@"获取设备的deviceToken: %@",tokenStr);
}

#pragma mark - 处理本地、远程推送消息红点提示
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    application.applicationIconBadgeNumber = 0;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    application.applicationIconBadgeNumber = 0;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    application.applicationIconBadgeNumber = 0;
}



@end
