//
//  YCWeinanView.m
//  YCSDK
//
//  Created by sunn on 2018/8/13.
//  Copyright © 2018年 . All rights reserved.
//

#import "YCWeinanView.h"
#import "HelloHeader.h"

#define kWeinanGuestBtnTag              210
#define kWeinanAccountLoginBtnTag       211
#define kWeinanAccountRegBtnTag         212

@implementation YCWeinanView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)justInit
{
    if ([super init]) {
        [self _createItemds];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dismissView) name:NOTE_YC_LOGIN_SUCCESS object:nil];
    }
    return self;
}

- (void)changeToAccountLogin
{
    [self _accountLogin];
}

- (void)_createItemds
{
    CGFloat mbgW = self.rate*self.curWidth;
    CGFloat mbgH = self.rate*self.curHeight*0.35f;
    
    // resize
    self.mainBg.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.8f];//[UIColor whiteColor];
    [self.mainBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@(0));
        make.centerY.equalTo(@(0));
        make.width.equalTo(@(mbgW));
        make.height.equalTo(@(mbgH));
    }];
    
    // btns
    NSArray *tags = @[@kWeinanGuestBtnTag, @kWeinanAccountLoginBtnTag, @kWeinanAccountRegBtnTag];
    NSArray *imgNames = @[@"wn_btn_guest.png", @"wn_btn_account_login.png", @"wn_btn_account_reg"];
    NSArray *titles = @[@"游客模式", @"账号登录", @"账号注册"];
    for (int i = 0; i < tags.count; i++) {
        
        UIView *v_btnbg = [[UIView alloc] init];
        [self.mainBg addSubview: v_btnbg];
        [v_btnbg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(0));
            make.left.equalTo(@(i * mbgW/3));
            make.width.equalTo(@(mbgW/3));
            make.height.equalTo(@(mbgH));
        }];
        
        UIButton *btn = [HelloUtils ycu_initBtnWithNormalImage:imgNames[i]
                                          highlightedImage:imgNames[i]
                                                       tag:[tags[i] integerValue]
                                                  selector:@selector(_weinanBtnAction:)
                                                    target:self];
        [v_btnbg addSubview:btn];
        CGFloat btnWidth = self.rate*self.curHeight* 0.4f * 1/2.0f;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(@(0));
//            make.left.equalTo(@(i * mbgW/3));
//            make.width.equalTo(@(mbgW/3));
//            make.height.equalTo(@(mbgH));
            make.centerX.equalTo(@(0));
            make.centerY.equalTo(@(-10));
            make.width.equalTo(@(btnWidth));
            make.height.equalTo(@(btnWidth));
        }];
        
        
        UILabel *lb = [[UILabel alloc] init];
        lb.text = titles[i];
        lb.textColor = [UIColor blackColor];
        lb.textAlignment = NSTextAlignmentCenter;
        lb.font = [UIFont fontWithName:kTxtFontName size:kTxtFontSize];
        [v_btnbg addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@(-10));
            make.left.equalTo(v_btnbg.mas_left);
            make.width.equalTo(@(mbgW/3));
            make.height.equalTo(@(20));
        }];
    }
}

- (void)_weinanBtnAction:(UIButton *)sender
{
    switch (sender.tag) {
        case kWeinanGuestBtnTag:
            [self _guestLogin];
            break;
        case kWeinanAccountLoginBtnTag:
            [self _accountLogin];
            break;
        case kWeinanAccountRegBtnTag:
            [self _accountReg];
            break;
        default:
            break;
    }
}

- (void)_guestLogin
{
    [HelloUtils ycu_sStarLoadingAtView:nil];
    [NetEngine guestLoginAndCompletion:^(id result){
        [HelloUtils ycu_sStopLoadingAtView:nil];
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                BOOL showWarning = [[NSString stringWithFormat:@"%@",result[@"data"][@"remind"]] boolValue];
                if (showWarning) {
                    YCBindView *warnView = [[YCBindView alloc] initWithMode:YCBind_GuestToMobileWarning data:(NSDictionary *)result[@"data"] handler:^{
                        [YCDataUtils ycd_handelNormalUser:(NSDictionary *)result];
                        [HelloUtils ycu_postNoteWithName:NOTE_YC_LOGIN_SUCCESS userInfo:(NSDictionary *)result];
//                        [self removeFromSuperview];
                    }];
                    
                    [UIView animateWithDuration:tRotaTomeInterval
                                     animations:^{
//                                         selfs.mainBg.alpha = 0.0f;
                                         [self addSubview:warnView];
                                     }];
                    return;
                } else {
                    [YCDataUtils ycd_handelNormalUser:(NSDictionary *)result];
                    [HelloUtils ycu_postNoteWithName:NOTE_YC_LOGIN_SUCCESS userInfo:(NSDictionary *)result];
//                    [self removeFromSuperview];
                }
                
            });
        }
    }];
}

- (void)_accountLogin
{
    YCLoginView *v_accountLogin = [[YCLoginView alloc] initWithMode:YCLogin_Account];
    [self addSubview:v_accountLogin];
}

- (void)_accountReg
{
    YCLoginView *v_reg = [[YCLoginView alloc] initWithMode:YCLogin_DirectToRegister];
    [self addSubview:v_reg];
}

#pragma mark - Dismiss Listener

- (void)dismissView
{
    if (self) {
        [self removeFromSuperview];
    }
}

@end
