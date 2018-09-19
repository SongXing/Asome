//
//  YCAutoLoadVIew.m
//  YCSDK
//
//  Created by sunn on 2018/7/19.
//

#import "YCAutoLoadView.h"
#import "HelloHeader.h"

#define kYCAutoMainBgViewTag  501
#define kYCAutoChangeBtnTag   502

#define kInfoHeight           50.0f
//#define kAutoTxtFontSize      20.0f
#define kMaxNameLength        10

#define kSpecHeight            80.0f

@implementation YCAutoLoadView
{
    UIImageView *mainBg;
    NSString *accountName;
    dispatch_source_t _timer;
    
//    UIInterfaceOrientationPortrait
    BOOL _isPortrait;
    BOOL _isNeedToDoMoreAction;
}

- (instancetype)initWithAccountName:(NSString *)name
                   goOnLoginHandler:(GoonCallback)loginHandler
               changeAccountHandler:(GoonCallback)changeHandler
{
    self = [super init];
    if (self) {
        self.loginCallback  = loginHandler;
        self.changeCallback = changeHandler;
        accountName = [self _handleLongName:name];
        
        [self _propertyInit];
        [self bgViewInit];
        [self randerContent];
    }
    return self;
}

- (instancetype)initWhenItsLoginSuccess
{
    self = [super init];
    if (self) {
        [self _propertyInit];
        [self bgViewInit];
        [self randerLoginedContent];
    }
    return self;
}

- (void)_propertyInit
{
    _isPortrait = UIInterfaceOrientationIsPortrait([[YCUser shareUser] gameOrientation]);
    _isNeedToDoMoreAction = _isPortrait && device_is_iPhoneX;
}

- (NSString *)_handleLongName:(NSString *)name
{
    if (name.length <= kMaxNameLength) {
        return name;
    }
    
    NSString *preStr = [name substringToIndex:3];
    NSString *endStr = [name substringFromIndex:name.length-3];
    NSString *resultStr = [NSString stringWithFormat:@"%@****%@",preStr,endStr];
    return resultStr;
}

- (void)bgViewInit
{
    
    [self setFrame:CGRectMake(0, 0, winWidth, winHeight)];
    [self setBackgroundColor:[UIColor clearColor]];
    
    // bg
    mainBg = [[UIImageView alloc] init];
    mainBg.userInteractionEnabled = YES;
    mainBg.tag = kYCAutoMainBgViewTag;
    [self addSubview:mainBg];
    
    CGFloat atWidth =  _isPortrait ? winWidth *5/6 : winWidth * 2/3;
    
    [mainBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@(0));
        make.top.equalTo(@(-kInfoHeight));
        make.width.equalTo(@(atWidth));
        make.height.equalTo(@(kInfoHeight));
    }];
    
    mainBg.backgroundColor = [UIColor colorWithHexString:@"#000000" andAlpha:0.5];//[UIColor colorWithHexString:kBgGrayHex];
    mainBg.layer.borderWidth = 1;
    mainBg.layer.borderColor = [UIColor colorWithHexString:kGrayHex].CGColor;
    mainBg.layer.cornerRadius = 10.0f;
    
    [UIView animateWithDuration:tRotaTomeInterval
                     animations:^{
//                         mainBg.transform = CGAffineTransformMakeTranslation(0, -kInfoHeight);//从下面弹出
                         mainBg.transform = CGAffineTransformMakeTranslation(0, _isNeedToDoMoreAction ? kSpecHeight : kInfoHeight);//从上面弹出
                     }];
}

- (void)randerContent
{
    // 账号 xxx 正在登錄
//    NSString *hintText = [NSString stringWithFormat:SP_GET_LOCALIZED(@"TXT_ACCOUNT_XXX_LOGINING"),accountName];
    NSString *hintText = [NSString stringWithFormat:@"欢迎 %@ 登录游戏",accountName];
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    loadingLabel.text = hintText;
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.textColor = [UIColor whiteColor];
    [loadingLabel setFont:[UIFont fontWithName:kTxtFontName size:_isPortrait ? kTxtFontSize : kTxtFontBigSize]];
    CGSize txtSize = [HelloUtils ycu_calculateSizeOfLabel:loadingLabel];
    [mainBg addSubview:loadingLabel];
    [loadingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@( _isPortrait ? -60 : -30));
        make.centerY.equalTo(@(0));
        make.width.equalTo(@(txtSize.width));
        make.height.equalTo(@(txtSize.height));
    }];
    
    // 倒計時 3s
    UILabel *countingLabel = [self _startWithTime:3.0f
                                            title:@""
                                   countDownTitle:@""
                                        mainColor:[UIColor clearColor]
                                       countColor:[UIColor clearColor]];
    countingLabel.textAlignment = NSTextAlignmentCenter;
    [countingLabel setFont:[UIFont fontWithName:kTxtFontName size:_isPortrait ? kTxtFontSize : kTxtFontBigSize]];
    [loadingLabel addSubview:countingLabel];
    [countingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loadingLabel.mas_right);
        make.centerY.equalTo(@(0));
        make.width.equalTo(@(40));
        make.height.equalTo(@(txtSize.height));
    }];
    
    // 切換賬號按鈕
//    UIButton *changeBtn = [HelloUtils initBtnWithTitle:SP_GET_LOCALIZED(@"BTN_TITLE_CHANGE_LOGIN_TYPE") tag:kYCAutoChangeBtnTag selector:@selector(_btnActions:) target:self];
    UIButton *changeBtn = [HelloUtils ycu_initBtnWithTitle:@"切换账号" tag:kYCAutoChangeBtnTag selector:@selector(_btnActions:) target:self];
    [changeBtn.layer setBorderWidth:0.0f];
    [changeBtn.layer setBorderColor:[UIColor clearColor].CGColor];
    [changeBtn.layer setCornerRadius:0.0f];
    [changeBtn setTitleColor:[UIColor colorWithHexString:kGreenHex] forState:0];
    [changeBtn.titleLabel setFont:[UIFont fontWithName:kTxtFontName size:_isPortrait ? kTxtFontSize : kTxtFontBigSize]];
    [mainBg addSubview:changeBtn];
    CGSize titleSize = [HelloUtils ycu_calculateSizeOfLabel:changeBtn.titleLabel];
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-30));
        make.centerY.equalTo(@(0));
        make.width.equalTo(@(titleSize.width));
        make.height.equalTo(@(titleSize.height));
    }];
}

- (void)randerLoginedContent
{
    YCUserModel *curModel = [YCDataUtils ycd_unarchNormalUser][0];
//    NSString *hintText = [NSString stringWithFormat:SP_GET_LOCALIZED(@"TXT_ACCOUNT_XXX_WELCOMEBACK"),[self _handleLongName:curModel.account]];
    NSString *hintText = [NSString stringWithFormat:@"%@ 欢迎回来",[self _handleLongName:curModel.account]];
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    loadingLabel.text = hintText;
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.textColor = [UIColor whiteColor];
    [loadingLabel setFont:[UIFont fontWithName:kTxtFontName size:_isPortrait ? kTxtFontSize : kTxtFontBigSize]];
    CGSize txtSize = [HelloUtils ycu_calculateSizeOfLabel:loadingLabel];
    [mainBg addSubview:loadingLabel];
    [loadingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@(0));//正式登录后文本居中
        make.centerY.equalTo(@(0));
        make.width.equalTo(@(txtSize.width));
        make.height.equalTo(@(txtSize.height));
    }];
    
    [self performSelector:@selector(_dismissView) withObject:nil afterDelay:tLoginedTimeInterval];
}

#pragma mark - Counting Label
- (UILabel *)_startWithTime:(NSInteger)timeLine
                      title:(NSString *)title
             countDownTitle:(NSString *)subTitle
                  mainColor:(UIColor *)mColor
                 countColor:(UIColor *)color
{
    __block UILabel *label = [[UILabel alloc] init];
    //倒计时时间
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        //倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                label.backgroundColor = mColor;
                [label setText:@""];
                
                [self _pleaseGoonSir];
            });
        } else {
            int allTime = (int)timeLine + 1;
            int seconds = timeOut % allTime;
            NSString *timeStr = [NSString stringWithFormat:@"(%.1ds)", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                label.backgroundColor = color;
                label.textColor = [UIColor whiteColor];
                [label setText:[NSString stringWithFormat:@"%@%@",timeStr,subTitle]];
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
    
    return label;
}

#pragma mark - Action

- (void)_pleaseGoonSir
{
    [self _dismissView];
    self.loginCallback ? self.loginCallback():nil;
}

- (void)_btnActions:(UIButton *)sender
{
    dispatch_cancel(_timer);// 取消定时器事件, 同 dispatch_source_cancel(_timer);
    _timer = nil;
    
    [self _dismissView];
    self.changeCallback ? self.changeCallback():nil;
}

- (void)_dismissView
{
    [UIView animateWithDuration:tRotaTomeInterval
                     animations:^{
                         mainBg.transform = CGAffineTransformMakeTranslation(0, _isNeedToDoMoreAction ? -kSpecHeight : -kInfoHeight);
                     } completion:^(BOOL finished) {
                         finished ? [self removeFromSuperview]:nil;
                     }];
}


@end
