//
//  YCUserModel.h
//  YCSDK
//
//  Created by sunn on 2018/7/9.
//  Copyright © 2018年 sunn. All rights reserved.
//

#import <Foundation/Foundation.h>

//account = u07061836407469;
//istemp = 3;
//nickname = u07061836407469;
//password = u937933;
//sessionid = hopmdrk2v55n7br4cpvk4nneq7;
//sessiontime = 1533716420;
//uid = 40977708;

@interface YCUserModel : NSObject <NSCoding>

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

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
