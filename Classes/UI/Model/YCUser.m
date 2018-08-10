//
//  YCUser.m
//  YCSDK
//
//  Created by sunn on 2018/7/13.
//

#import "YCUser.h"
#import "YCSDK.h"

@implementation YCUser

#pragma mark - 可设定数据

+ (YCUser *)shareUser
{
    static YCUser *infoModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        infoModel = [[YCUser alloc] init];
        [infoModel cleanModel];
    });
    
    return infoModel;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sdkVersion = [NSString stringWithFormat:@"%@",YC_SDK_VERSION];
        self.gameOrientation = UIInterfaceOrientationLandscapeLeft;
    }
    return self;
}

- (void)setUserInfoWithRoleID:(NSString *)roleID
                    roleLevel:(NSString *)roleLevel
                     roleName:(NSString *)roleName
                     serverId:(NSString *)serverId
                   serverName:(NSString *)serverName
                     vipLevel:(NSString *)vipLevel
{
    self.roleID         = roleID;
    self.roleLevel      = roleLevel;
    self.roleName       = roleName;
    self.serverId       = serverId;
    self.serverName     = serverName;
    self.vipLevel       = vipLevel;
}

- (void)setUserConfigKey:(NSString *)key site:(NSString *)site aid:(NSString *)aid cid:(NSString *)cid
{
    self.key    = key;
    self.site   = site;
    self.aid    = aid;
    self.cid    = cid;
}

- (void)cleanModel
{
    self.uid            = @"";
    self.thirdId        = @"";
    self.roleID         = @"";
    self.roleLevel      = @"";
    self.roleName       = @"";
    self.serverId       = @"";
    self.serverName     = @"";
    self.vipLevel       = @"";
    self.account        = @"";
    self.loginTypeStr   = @"";
    self.istemp         = @"";
    self.nickname       = @"";
    self.password       = @"";
    self.sessionid      = @"";
    self.sessiontime    = @"";
    
    self.key            = @"";
    self.site           = @"";
    self.aid            = @"";
    self.cid            = @"";
}

@end
