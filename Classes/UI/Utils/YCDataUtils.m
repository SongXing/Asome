//
//  YCDataUtils.m
//  YCSDK
//
//  Created by sunn on 2018/7/11.
//

#import "YCDataUtils.h"
#import "HelloHeader.h"

#define kYCListMaxCount                     10

@implementation YCDataUtils

#pragma mark - CN

+ (void)ycc_saveUserInfo:(NSDictionary *)dic
{
    // dic {name:pwd}
    NSString *nameKkey = dic.allKeys[0];
    
    // curDic
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    // 改用数组保存，便于让新添加的账号放在最前面，数组里面保存字典，一个字典是一组账号和密码 @[@{},@{}]
    NSMutableArray *curUsers = [NSMutableArray arrayWithArray:[userDef objectForKey:kYCCnUsersKey]];
    NSArray *tmpArr = [curUsers copy];
    if (tmpArr.count > 0) {
        // 判断所以keys里面是否包含关系，即可添加
        NSMutableArray *tmpKeys = [[NSMutableArray alloc] initWithCapacity:tmpArr.count];
        for (NSDictionary *item in tmpArr) {  // 可变数组再遍历中不可修改，因此需要拷贝一个数组出来后遍历，再操作
            [tmpKeys addObject:item.allKeys[0]];
        }
        
        if (![tmpKeys containsObject:nameKkey]) { // 如果当前key不在 拿出来的key列表之中
            [curUsers insertObject:dic atIndex:0];//后添加的总是放在第一位
        } else {
            // 如果在，但是密码不一样了，重新保存
            NSString *pwd = dic[nameKkey];
            int idx = 0;
            for (int i = 0; i<tmpArr.count; i++) {
                if ([[[[tmpArr objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:nameKkey]) {
                    idx = i;
                    break;
                }
            }
            NSString *oriPwd = [tmpArr[idx] objectForKey:nameKkey];
            if (![oriPwd isEqualToString:pwd]) {
                [curUsers removeObjectAtIndex:idx];
                [curUsers insertObject:dic atIndex:0];
            }
        }
        
    } else {
        [curUsers insertObject:dic atIndex:0];
    }
    
    // 调整顺序，因为调用是保存完最新的账号然后再保存到list上，因此在这里直接调整顺序
    NSDictionary *latestDic = [YCDataUtils ycc_getLatestUserInfo];
    NSUInteger tmpIdx = 0;
    for (int i = 0; i<curUsers.count; i++) {
        if ([[[curUsers[i] allKeys] objectAtIndex:0] isEqualToString:latestDic.allKeys[0]]) {
            tmpIdx = i;
            break;
        }
    }
    if (tmpIdx != 0) {
        [curUsers removeObjectAtIndex:tmpIdx];
        [curUsers insertObject:latestDic atIndex:0];
    }
    
    // 限制保存50组账号密码
    if (curUsers.count > kYCListMaxCount) {
        [curUsers removeLastObject];
    }
    
    [userDef setObject:curUsers forKey:kYCCnUsersKey];
    [userDef synchronize];
}

+ (NSArray *)ycc_getAllUserInfo
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kYCCnUsersKey];
}

+ (void)ycc_saveLatestUserInfo:(NSDictionary *)dic
{
    // dic {name:pwd}
    NSString *nameKkey = dic.allKeys[0];
    nameKkey = [HelloUtils ycu_triString:nameKkey];
    
    if (!nameKkey || [nameKkey isEqualToString:@""]) {
        return;
    }
    
    // curDic
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *curUser = [NSMutableDictionary dictionaryWithDictionary:[userDef objectForKey:kYCCnLatestUserKey]];
    if (curUser.allKeys.count <= 0) {
        [userDef setObject:dic forKey:kYCCnLatestUserKey];
        [userDef synchronize];
    } else {
        
        // 直接覆盖保存，就一个
        [curUser removeAllObjects];
        [curUser addEntriesFromDictionary:dic];
        [userDef setObject:curUser forKey:kYCCnLatestUserKey];
        [userDef synchronize];
        
    }
}

+ (NSDictionary *)ycc_getLatestUserInfo
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kYCCnLatestUserKey];
}

+ (void)ycc_removeUserWithKey:(NSString *)key
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *curUsers = [NSMutableDictionary dictionaryWithDictionary:[userDef objectForKey:kYCCnUsersKey]];
    for (NSString *ckey in curUsers.allKeys) {
        if ([ckey isEqualToString:key]) {
            [curUsers removeObjectForKey:key];
            [userDef setObject:curUsers forKey:kYCCnUsersKey];
            [userDef synchronize];
        }
    }
}

+ (void)ycc_removeUserWithIndex:(NSUInteger)idx
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSMutableArray *curUsers = [NSMutableArray arrayWithArray:[userDef objectForKey:kYCCnUsersKey]];
    [curUsers removeObjectAtIndex:idx];
    [userDef setObject:curUsers forKey:kYCCnUsersKey];
    [userDef synchronize];
}

#pragma mark - 处理请求返回的用户列表

+ (void)ycd_handleGoodNews:(NSDictionary *)dict
{
    [HelloUtils ycu_userdefault_setObj:dict key:kYCGoodNewsKey];
}

+ (NSDictionary *)ycd_getGoodNews
{
    return [HelloUtils ycu_userdefault_getObjforKey:kYCGoodNewsKey];
}


+ (void)ycd_handleReqUserList:(NSDictionary *)dict
{
    NSArray *everList = dict[kRespStrData];
    if (everList.count > 0) {
        NSMutableArray *mArr = [[NSMutableArray alloc] initWithCapacity:everList.count];
        
        for (NSDictionary *d in everList) {
            YCUserModel *model = [[YCUserModel alloc] initWithDict:d];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
            [mArr addObject:data];
        }
        
        // save
        NSArray *curSavedArr = [HelloUtils ycu_userdefault_getObjforKey:kYCReqUserListKey];
        if (!curSavedArr || ![curSavedArr isEqual:mArr]) {
            [HelloUtils ycu_userdefault_setObj:mArr key:kYCReqUserListKey];
        }
    }
}

+ (NSArray *)ycd_unarchUserList
{
    NSArray *curSavedArr = [HelloUtils ycu_userdefault_getObjforKey:kYCReqUserListKey];
    NSMutableArray *mArr = [[NSMutableArray alloc] initWithCapacity:curSavedArr.count];
    for (NSData *data in curSavedArr) {
        YCUserModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [mArr addObject:model];
    }
    
    return mArr;
}

+ (void)ycd_handleGuestLoginData:(NSDictionary *)dict
{
    // 转成 自定义对象
    YCUserModel *model = [[YCUserModel alloc] initWithDict:dict[kRespStrData]];
    // 自定义对象转成 data
    NSData *modelData = [NSKeyedArchiver archivedDataWithRootObject:model];
    // data 存到 userdefault 中
    [HelloUtils ycu_userdefault_setObj:modelData key:kYCGuestUserKey];
}

+ (NSArray *)ycd_unarchGuest
{
    NSData *guestData = [HelloUtils ycu_userdefault_getObjforKey:kYCGuestUserKey];
    NSMutableArray *mArr = [[NSMutableArray alloc] initWithCapacity:1];
    
    YCUserModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:guestData];
    [mArr addObject:model];
    
    return mArr;
}

#pragma mark - Normal User

+ (void)ycd_handelNormalUser:(NSDictionary *)dict
{
    NSDictionary *cur = dict[kRespStrData];
    YCUserModel *curModel = [[YCUserModel alloc] initWithDict:cur];
    NSData *curData = [NSKeyedArchiver archivedDataWithRootObject:curModel];
    
    // get List
    NSArray *savedList = [self ycd_unarchNormalUser];// model list
    NSMutableArray *mArr = nil;
    
    if (savedList.count < 1) {
        
        mArr = [[NSMutableArray alloc] initWithCapacity:1];
        [mArr addObject:curData];
        
    } else {
        BOOL isAdd = NO;
        mArr = [[NSMutableArray alloc] initWithCapacity:kYCListMaxCount];
        for (YCUserModel *model in savedList) {
            NSData *modelData = [NSKeyedArchiver archivedDataWithRootObject:model];
            [mArr addObject:modelData];
        }
        for (YCUserModel *model in savedList) {
            if ([[NSString stringWithFormat:@"%@", curModel.uid] isEqualToString:[NSString stringWithFormat:@"%@",model.uid]]) {
                // 保存过，更新替换，然后将其放在首位，以便自动登录
                NSUInteger inx = [savedList indexOfObject:model];
                [mArr removeObjectAtIndex:inx];
//                [mArr insertObject:curData atIndex:inx];
                [mArr insertObject:curData atIndex:0];
                isAdd = YES;
            }
        }
        // 如果当前账号未保存过，则添加，并放在首位
//        isAdd ? : [mArr addObject:curData];
        isAdd ? : [mArr insertObject:curData atIndex:0];
    }
    
    [HelloUtils ycu_userdefault_setObj:mArr key:kYCNormalUserListKey];
}

+ (NSArray *)ycd_unarchNormalUser
{
    NSArray *curSavedArr = [HelloUtils ycu_userdefault_getObjforKey:kYCNormalUserListKey];
    NSMutableArray *mArr = [[NSMutableArray alloc] initWithCapacity:curSavedArr.count];
    for (NSData *data in curSavedArr) {
        YCUserModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [mArr addObject:model];
    }
    
    return mArr;
}

+ (void)ycd_removeNormalUserWithIndex:(NSUInteger)idx
{
    // get cur model arr
    NSArray *savedList = [self ycd_unarchNormalUser];
    // make them to data arr
    NSMutableArray *mArr = [[NSMutableArray alloc] initWithCapacity:savedList.count];
    for (YCUserModel *model in savedList) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
        [mArr addObject:data];
    }
    // get the delete model to data
    YCUserModel *toDelModel = savedList[idx];
    NSData *toDelData = [NSKeyedArchiver archivedDataWithRootObject:toDelModel];
    // delete the data
    if ([mArr containsObject:toDelData]) {
        
        [mArr removeObject:toDelData];
    }
    
    // resave
    [HelloUtils ycu_userdefault_setObj:mArr key:kYCNormalUserListKey];
}

#pragma mark - 处理请求返回的pay数据

+ (void)ycd_handlePPP:(NSDictionary *)dict
{
    YCPPPModel *model = [[YCPPPModel alloc] initWithDictionary:dict];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    [HelloUtils ycu_userdefault_setObj:data key:kYCPPPModelKey];
}

+ (YCPPPModel *)ycd_getPPP
{
    NSData *data = [HelloUtils ycu_userdefault_getObjforKey:kYCPPPModelKey];
    YCPPPModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return model;
}

#pragma mark - 处理 CDN 信息

+ (void)ycd_handleCDNGoods:(NSDictionary *)dict
{
    [HelloUtils ycu_userdefault_setObj:dict key:kYCCDNDomains];
}

+ (NSDictionary *)ycy_getCDNGoods
{
    return [HelloUtils ycu_userdefault_getObjforKey:kYCCDNDomains];
}

@end
