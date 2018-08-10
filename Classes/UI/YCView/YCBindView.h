//
//  YCBindView.h
//  YCSDK
//
//  Created by sunn on 2018/7/11.
//

#import <UIKit/UIKit.h>

typedef void(^GuestCallback)(void);

typedef NS_OPTIONS(NSUInteger, YCBindMode)
{
    YCBind_Default = 0,
    YCBind_Account = 1,
    YCBind_GuestToMobileWarning = 2,
    YCBind_RealNameVertify,
    YCBind_Forget_CheckAccount,
    YCBind_Forget_ResetPwd,
    YCBind_WarningToBind,
};

@interface YCBindView : UIView <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, copy) GuestCallback guestAgainCallback;

- (instancetype)initWithMode:(YCBindMode)mode;

- (instancetype)initWithMode:(YCBindMode)mode data:(NSDictionary *)dict handler:(GuestCallback)handler;

@end
