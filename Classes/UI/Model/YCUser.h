//
//  YCUser.h
//  YCSDK
//
//  Created by sunn on 2018/7/13.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YCUser : NSObject

/**
 *  平台用户数据
 */
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *istemp;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *sessionid;
@property (nonatomic, copy) NSString *sessiontime;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, assign) BOOL remind;


/**
 *  游戏角色数据
 */
@property (copy, nonatomic) NSString *thirdId;
@property (copy, nonatomic) NSString *loginTypeStr;
@property (copy, nonatomic) NSString *roleID;
@property (copy, nonatomic) NSString *roleLevel;
@property (copy, nonatomic) NSString *roleName;
@property (copy, nonatomic) NSString *serverId;
@property (copy, nonatomic) NSString *serverName;
@property (copy, nonatomic) NSString *vipLevel;

/**
 *  初始化配置数据
 */
@property (copy, nonatomic) NSString *key;
@property (copy, nonatomic) NSString *site;
@property (copy, nonatomic) NSString *aid;
@property (copy, nonatomic) NSString *cid;

@property (copy, nonatomic) NSString *sdkVersion;

// 横竖屏设置
@property (nonatomic, assign) UIInterfaceOrientation gameOrientation;

/**
 *  model的单例
 *
 *  @return 单例的对象
 */
+ (YCUser *)shareUser;

- (void)setUserInfoWithRoleID:(NSString *)roleID
                    roleLevel:(NSString *)roleLevel
                     roleName:(NSString *)roleName
                     serverId:(NSString *)serverId
                   serverName:(NSString *)serverName
                     vipLevel:(NSString *)vipLevel;

- (void)setUserConfigKey:(NSString *)key
                    site:(NSString *)site
                     aid:(NSString *)aid
                     cid:(NSString *)cid;

- (void)cleanModel;

- (void)cleanInfo;

@end
