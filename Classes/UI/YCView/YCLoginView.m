//
//

#import "YCLoginView.h"
#import "HelloHeader.h"

#define kWowoWidth                  20.0f

#define tPlaceholder_account        PlaceHolderAccount
#define tPlaceholder_pwd            PlaceHolderPwd
#define kTVRightBtnTag              110
#define kSPRegisterBtnTag           111

#define kYCLoginPhoneInputViewTag   112
#define kYCLoginCodeInputViewTag    113
#define kYCLoginNameInputViewTag    114
#define kYCLoginPwdInputViewTag     115
#define kYCLoginNoAccountTag        116
#define kTVRightUserListBtnTag      117
#define kYCUserListVeiwTag          118
#define kYCUserListDelBtnTag        119

#define kYCLoginGetVertifyCodeTag   120
#define kYCLoginAgreeViewTag        121
#define kYCLoginCheckBoxBtnTag      122
#define kYCLoginWowBtnTag           123
#define kYCLoginPhoneRegBtnTag           124

#define kListCellIdentifier             @"cn_list_identifier"

#define strGiveMeTheHandScheme_Agree           @"agree://"
#define strGiveMeTheHand_Agree                 @"agree"

static NSInteger chimaClickTIme = 0;
static NSInteger chimaOpenTime = 3;

@implementation YCLoginView
{
    CGFloat rate ; // 校对比值
    CGFloat curWidth ;
    CGFloat curHeight ;
    CGFloat originBgWidthOfHeight;// 背景图片宽高比
    CGFloat loginBtnWidthOfBgWidth;
    CGFloat loginBtnHeightOfBgHeight;
    CGFloat findPwdBtnWidthOfBgWidth;
    CGFloat findPwdBtnHeightOfBgHeight;
    CGFloat textFieldHeightOfBgHeight;
    CGFloat topPadding;
    CGFloat leftPadding;
    CGFloat findBtnLeftPadding;
    CGFloat anotherLeftPadding;
    CGFloat gapPadding;
    CGFloat anotherGapPadding;
    CGFloat thirdGapPadding;
    CGFloat lineTopPadding;
    CGFloat backBtnWidthAndHeight;
    
    CGFloat keyboarHeight;
    CGFloat animatedDistance;
    
    UIImageView *mainBg;


    HelloTextField *nameTF;
    HelloTextField *pwdTF;
    HelloTextField *phoneInput;
    HelloTextField *codeInput;
    
    BOOL pwdEntity;
    BOOL userListShow;
    BOOL needToWarning;
    BOOL checkboxStatus;
    
    UIButton *loginComfirmBtn;
    UIButton *eyesBtn;
    UIButton *forgetPwdBtn;
    UIButton *userListBtn;
    UIButton *checkBoxBtn;
    
    UIView *userListView;
    UITableView *uList;
    
    // user list data source
    NSArray *listModelArr;
    
    YCLoginMode m_mode;
    YCLoginMode ori_mode;
    YCUserModel *curLoginUser;
    
    CGFloat onCalWidth;
    CGFloat onCalHeight;
}

- (instancetype)initWithMode:(YCLoginMode)mode
{
    self = [super init];
    if (self) {
        
        m_mode = mode;
        ori_mode = mode;
        
        [self propertyPrapare];
        [self helloInit];
        
   
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_loginNoteLisetner:) name:UIKeyboardWillShowNotification object:nil];
        
    }
    return self;
}

- (void)propertyPrapare
{
    rate = 0.8f; // 校对比值
    curWidth = winWidth;
    curHeight = winHeight;
    
    if (IS_IPAD) {
        curWidth = calculatedWidthAtIPad;
        curHeight = calculatedHeightAtIPad;
    }
    
    CGFloat realWidthHeightRate = curWidth/curHeight;
    
    originBgWidthOfHeight = 1070/1130.0f; // 原图宽高比

    if (realWidthHeightRate >= originBgWidthOfHeight) {
        // 若设备的宽高比大于原图宽高比，则以设备的高度为基准，重新计算宽度
        curWidth = curHeight / originBgWidthOfHeight;
    } else {
        // 若设备的宽高比小于原图宽高比，则以设备的宽度为基准，重新计算高度
        curHeight = curWidth * originBgWidthOfHeight;
    }
    
    loginBtnWidthOfBgWidth = 914/1070.0f;
    loginBtnHeightOfBgHeight = 172/1130.0f;
    findPwdBtnWidthOfBgWidth = 300/1070.0f;
    findPwdBtnHeightOfBgHeight = 62/1130.0f;
    textFieldHeightOfBgHeight = 140/1130.0f;//150/1130.0f;//
    topPadding = 24/1130.0f;
    leftPadding = 24/1070.0f;
    anotherLeftPadding = 78/1130.0f;
    findBtnLeftPadding = (78+80)/1130.0f;
    gapPadding = 30/1130.0f;
    anotherGapPadding = 50/1130.0f;// origin 80
    thirdGapPadding = 64/1130.0f; // origin 34
    lineTopPadding = (156+172*4+50*3+70)/1130.0f;
    backBtnWidthAndHeight = 100.0f/1130.0f;
    
    pwdEntity = YES;
    userListShow = NO;
    needToWarning = YES;
    checkboxStatus = YES;
    
    keyboarHeight = keyboardInitH;
    onCalWidth = rate * curWidth;
    onCalHeight = rate * curHeight;
    if (device_is_iPhoneX) {
        onCalHeight = rate * curHeight * rate;
        onCalWidth = onCalHeight / originBgWidthOfHeight ;
    }
    
    listModelArr = [self _fetchUserList];
}

- (void)helloInit
{
    self.userInteractionEnabled = YES;
    
    [self bgViewInit];
    
    switch (m_mode) {
        case YCLogin_ChangeAccount:
            [self _switchAccountModeInit];
            break;
        case YCLogin_Account:
        {
            [self catchMyWidget];
            [self _changeToShowAccountLogin];
        }
            break;
        case YCLogin_DirectToRegister:
        {
            [self wnDirectRegWidget];
        }
            break;
        default:
            [self catchMyWidget];
            break;
    }
}

- (void)bgViewInit
{
    [self setFrame:CGRectMake(0, 0, winWidth, winHeight)];
    [self setBackgroundColor:[UIColor clearColor]];
//    self.userInteractionEnabled = YES;
    
    // bg
    mainBg = [[UIImageView alloc] init];
    mainBg.userInteractionEnabled = YES;
    mainBg.tag = kYCLoginMainBgViewTag;
    [self addSubview:mainBg];
    [mainBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@(0));
        make.centerY.equalTo(@(0));
        make.width.equalTo(@(rate*curWidth));
        make.height.equalTo(@(rate*curHeight*0.8));
    }];

    mainBg.backgroundColor = [UIColor colorWithHexString:kBgGrayHex];
    mainBg.layer.borderWidth = 1;
    mainBg.layer.borderColor = [UIColor colorWithHexString:kGrayHex].CGColor;
    mainBg.layer.cornerRadius = 5.0f;
    
    [self _wowFunction];
}

- (void)_wowFunction
{
    // hidden btn . show cur sdk version and cid
    UIButton *wowBtn = [HelloUtils initBtnWithTitle:@"" tag:kYCLoginWowBtnTag selector:@selector(_wowActioin:) target:self];
    [wowBtn.layer setCornerRadius:0.0f];
    [wowBtn.layer setBorderWidth:0.0f];
    [wowBtn.layer setBorderColor:[UIColor clearColor].CGColor];
    [mainBg addSubview:wowBtn];
    [wowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
        make.right.equalTo(@(0));
        make.width.equalTo(@(kWowoWidth));
        make.height.equalTo(@(kWowoWidth));
    }];
}

- (void)_wowActioin:(UIButton *)sender
{
    chimaClickTIme++;
    if (chimaClickTIme == chimaOpenTime) {
        NSString *msg = [NSString stringWithFormat:@"SDK version: %@\n cid: %@",YC_SDK_VERSION,[YCUser shareUser].cid];
        [SPAlertView showAlertViewWithTitle:@"当前版本信息"
                                    message:msg
                                 completion:nil
                               buttonTitles:@"确定", nil];
        // reset
        chimaClickTIme = 0;
    }
}

- (void)catchMyWidget
{
    CGFloat onCalHeight = rate*curHeight*0.8;
    CGFloat mTopPadding = 0;
    CGFloat firstGap = 26.0f/curWidth * onCalHeight;
    CGFloat secondGap = 8.0f/curWidth * onCalHeight;
    mTopPadding += firstGap;
    
    // title image
    UIImageView *titleImage = [[UIImageView alloc] initWithImage:GetImage(@"logo.png")];
    [mainBg addSubview:titleImage];
    // 440x98
    CGFloat widthOfImage    = 100*rate*curWidth/228.0f;
    CGFloat heightOfImage   = 100*rate*curWidth/228.0f/440.0f*98.0f;
    [titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding));
        make.centerX.equalTo(@(0));
        make.width.equalTo(@(widthOfImage));
        make.height.equalTo(@(heightOfImage));
    }];
    
    // back btn
    UIButton *backBtn = [HelloUtils initBtnWithNormalImage:backBtn_normal highlightedImage:backBtn_highlighted tag:kLoginDamnBackBtnTag selector:@selector(loginViewBtnAction:) target:self];
    [mainBg addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding/2));
        make.left.equalTo(@(leftPadding*rate*curWidth));
        make.width.equalTo(@(backBtnWidthAndHeight*rate*curWidth));
        make.height.equalTo(@(backBtnWidthAndHeight*rate*curWidth));
    }];
    
    if (YCLogin_FastToDefault == m_mode) {
        backBtn.hidden = NO;
    } else {
        backBtn.hidden = YES;
    }
    
    // ----------------------------
    
    mTopPadding += firstGap + heightOfImage;
    
    // text input
    UIView *phoneView = [[UIView alloc] initWithFrame:CGRectZero];
    phoneView.tag = kYCLoginPhoneInputViewTag;
    phoneView.backgroundColor = [UIColor whiteColor];
    phoneView.layer.cornerRadius = 5.0f;
    phoneView.layer.borderWidth = 1.0f;
    phoneView.layer.borderColor = [UIColor colorWithHexString:kGrayHex].CGColor;
    [mainBg addSubview:phoneView];
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding));
        make.centerX.equalTo(@(0));
        make.width.equalTo(@(loginBtnWidthOfBgWidth*rate*curWidth));
        make.height.equalTo(@(textFieldHeightOfBgHeight*rate*curWidth));
    }];
    
    // pick btn
    NSInteger pickBtnTag = 10098;
    UIButton * pickBtn = [HelloUtils initBtnWithTitle:@"+86" tag:pickBtnTag selector:@selector(loginViewBtnAction:) target:self];
    [pickBtn.layer setCornerRadius:0.0f];
    [pickBtn.layer setBorderWidth:0.0f];
    [pickBtn.layer setBorderColor:[UIColor clearColor].CGColor];
    [pickBtn setTitleColor:[UIColor colorWithHexString:kBlackHex] forState:0];
    pickBtn.userInteractionEnabled = NO;
    [phoneView addSubview:pickBtn];
    [pickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
        make.left.equalTo(@(0));
        make.bottom.equalTo(@(0));
        make.right.equalTo(@(-loginBtnWidthOfBgWidth*rate*curWidth*0.8));
    }];
    // seperate line
    UILabel *seperateLine = [self _createSeperateLine];
    [phoneView addSubview:seperateLine];
    [seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@(0));
        make.left.equalTo(pickBtn.mas_right);
        make.width.equalTo(@(1.0f));
        make.height.equalTo(@(30-10));
    }];
    
    phoneInput = [HelloUtils customTextfieldWidgetWithLeftView:nil rightView:nil placeholder:@"请输入您的手机号码" delegate:self];
    [HelloUtils makeTextFieldPlaceHolderProperty:phoneInput];
    phoneInput.returnKeyType = UIReturnKeyNext;
    [phoneView addSubview:phoneInput];
    [phoneInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
        make.left.equalTo(@(loginBtnWidthOfBgWidth*rate*curWidth*0.2+5));
        make.bottom.equalTo(@(0));
        make.right.equalTo(@(0));
    }];
    
    // ------------
    mTopPadding += secondGap + textFieldHeightOfBgHeight*rate*curWidth;
    
    
    // send vertify btn
    NSString *strFetchVertifyCode = @"获取验证码";
    NSInteger sendVertifyBtnTag = kYCLoginGetVertifyCodeTag;
    UIButton *sendVertifyBtn = [HelloUtils initBtnWithType:UIButtonTypeCustom title:strFetchVertifyCode tag:sendVertifyBtnTag selector:@selector(loginViewBtnAction:) target:self];
    [sendVertifyBtn setTitle:strFetchVertifyCode forState:0];
    [sendVertifyBtn.layer setCornerRadius:0.0f];
    [sendVertifyBtn.layer setBorderWidth:0.0f];
    [sendVertifyBtn.layer setBorderColor:[UIColor colorWithHexString:kGrayHex].CGColor];
    [sendVertifyBtn setTitleColor:[UIColor colorWithHexString:kBlackHex] forState:0];
    [sendVertifyBtn.titleLabel setFont:[UIFont fontWithName:kTxtFontName size:kTxtFontSize]];
    CGSize sendVertifyCodeBtnSize = [HelloUtils calculateSizeOfLabel:sendVertifyBtn.titleLabel andWidth:1000];
    [sendVertifyBtn setFrame:CGRectMake(0, 0, sendVertifyCodeBtnSize.width, textFieldHeightOfBgHeight*rate*curWidth
                                        )];
    
    // input

    codeInput = [HelloUtils customTextfieldWidgetWithLeftView:nil rightView:sendVertifyBtn placeholder:@"请输入验证码" delegate:self];
    codeInput.endEditDistance = sendVertifyCodeBtnSize.width - 25 + 10.0f;
    codeInput.rightViewDistance = 10.0f;
    [HelloUtils makeTextFieldPlaceHolderProperty:codeInput];
    codeInput.returnKeyType = UIReturnKeyDone;
    [mainBg addSubview:codeInput];
    [codeInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding));
        make.centerX.equalTo(@(0));
        make.width.equalTo(@(loginBtnWidthOfBgWidth*rate*curWidth));
        make.height.equalTo(@(textFieldHeightOfBgHeight*rate*curWidth));
    }];
    codeInput.backgroundColor = [UIColor whiteColor];
    codeInput.layer.cornerRadius = 5.0f;
    codeInput.layer.borderWidth = 1.0f;
    codeInput.layer.borderColor = [UIColor colorWithHexString:kGrayHex].CGColor;
    
    // --------------
    mTopPadding += secondGap + textFieldHeightOfBgHeight*rate*curWidth;
    
    // login btn
    loginComfirmBtn = [HelloUtils yc_initBtnWithTitle:@"进入游戏" tag:kYCLoginMobileFastLoginBtnTag selector:@selector(loginViewBtnAction:) target:self];
    [mainBg addSubview:loginComfirmBtn];
    [loginComfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding));
        make.left.equalTo(@(anotherLeftPadding*rate*curWidth));
        make.width.equalTo(@(loginBtnWidthOfBgWidth*rate*curWidth));
        make.height.equalTo(@(textFieldHeightOfBgHeight*rate*curWidth));
    }];
    loginComfirmBtn.layer.cornerRadius = 5.0f;
    loginComfirmBtn.backgroundColor = [UIColor colorWithHexString:kGreenHex];
    loginComfirmBtn.titleLabel.textColor = [UIColor colorWithHexString:kWhiteHex];
    loginComfirmBtn.layer.borderWidth = 1.0f;
    loginComfirmBtn.layer.borderColor = [UIColor colorWithHexString:kGrayHex].CGColor;
    [loginComfirmBtn.titleLabel setFont:[UIFont fontWithName:kTxtFontName size:kTxtFontBigSize]];
    
    
    CGSize txtSize = CGSizeZero;
    // 游客登录按钮
    UIButton *guestBtn = [HelloUtils initBtnWithTitle:@"游客登录" tag:kYCLoginGuestBtnTag selector:@selector(loginViewBtnAction:) target:self];
    [guestBtn.layer setBorderWidth:0.0f];
    [guestBtn.layer setBorderColor:[UIColor clearColor].CGColor];
    [guestBtn.layer setCornerRadius:0.0f];
    [guestBtn setTitleColor:[UIColor colorWithHexString:kGreenHex] forState:0];
    [guestBtn.titleLabel setFont:[UIFont fontWithName:kTxtFontName size:kTxtFontSize]];
    [mainBg addSubview:guestBtn];
    txtSize = [HelloUtils calculateSizeOfLabel:guestBtn.titleLabel];
    [guestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-textFieldHeightOfBgHeight/3*rate*curWidth));
        make.left.equalTo(loginComfirmBtn.mas_left);
        make.width.equalTo(@(txtSize.width));
        make.height.equalTo(@(txtSize.height));
    }];
    
    
    // 账号登录按钮
    UIButton *accountLoginBtn = [HelloUtils initBtnWithTitle:@"账号登录" tag:kYCLoginAccountLoginBtnTag selector:@selector(loginViewBtnAction:) target:self];
    [accountLoginBtn.layer setBorderWidth:0.0f];
    [accountLoginBtn.layer setBorderColor:[UIColor clearColor].CGColor];
    [accountLoginBtn.layer setCornerRadius:0.0f];
    [accountLoginBtn setTitleColor:[UIColor colorWithHexString:kGreenHex] forState:0];
    [accountLoginBtn.titleLabel setFont:[UIFont fontWithName:kTxtFontName size:kTxtFontSize]];
    [mainBg addSubview:accountLoginBtn];
    txtSize = [HelloUtils calculateSizeOfLabel:accountLoginBtn.titleLabel];
    [accountLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-textFieldHeightOfBgHeight/3*rate*curWidth));
        make.centerX.equalTo(@(0));
        make.width.equalTo(@(txtSize.width));
        make.height.equalTo(@(txtSize.height));
    }];
    
    // 帮助中心按钮
    UIButton *helpCenterBtn = [HelloUtils initBtnWithTitle:@"帮助中心" tag:kYCLoginHelpCenterBtnTag selector:@selector(loginViewBtnAction:) target:self];
    [helpCenterBtn.layer setBorderWidth:0.0f];
    [helpCenterBtn.layer setBorderColor:[UIColor clearColor].CGColor];
    [helpCenterBtn.layer setCornerRadius:0.0f];
    [helpCenterBtn setTitleColor:[UIColor colorWithHexString:kGreenHex] forState:0];
    [helpCenterBtn.titleLabel setFont:[UIFont fontWithName:kTxtFontName size:kTxtFontSize]];
    [mainBg addSubview:helpCenterBtn];
    txtSize = [HelloUtils calculateSizeOfLabel:helpCenterBtn.titleLabel];
    [helpCenterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-textFieldHeightOfBgHeight/3*rate*curWidth));
        make.right.equalTo(loginComfirmBtn.mas_right);
        make.width.equalTo(@(txtSize.width));
        make.height.equalTo(@(txtSize.height));
    }];
}

- (void)wnDirectRegWidget
{
    CGFloat onCalHeight = rate*curHeight*0.8;
    CGFloat mTopPadding = 0;
    CGFloat firstGap = 26.0f/curWidth * onCalHeight;
    CGFloat secondGap = 8.0f/curWidth * onCalHeight;
    mTopPadding += firstGap;
    
    // title image
    UIImageView *titleImage = [[UIImageView alloc] initWithImage:GetImage(@"logo.png")];
    [mainBg addSubview:titleImage];
    // 440x98
    CGFloat widthOfImage    = 100*rate*curWidth/228.0f;
    CGFloat heightOfImage   = 100*rate*curWidth/228.0f/440.0f*98.0f;
    [titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding));
        make.centerX.equalTo(@(0));
        make.width.equalTo(@(widthOfImage));
        make.height.equalTo(@(heightOfImage));
    }];
    
    // back btn
    UIButton *backBtn = [HelloUtils initBtnWithNormalImage:backBtn_normal highlightedImage:backBtn_highlighted tag:kLoginDamnBackBtnTag selector:@selector(loginViewBtnAction:) target:self];
    [mainBg addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding/2));
        make.left.equalTo(@(leftPadding*rate*curWidth));
        make.width.equalTo(@(backBtnWidthAndHeight*rate*curWidth));
        make.height.equalTo(@(backBtnWidthAndHeight*rate*curWidth));
    }];
    
    // ----------------------------
    
    mTopPadding += firstGap + heightOfImage;
    
    // text input
    nameTF = [HelloUtils customTextfieldWidgetWithLeftView:nil
                                                 rightView:userListBtn
                                               placeholder:@"请输入登录账号"
                                                  delegate:self];
    [HelloUtils makeTextFieldPlaceHolderProperty:nameTF];
    nameTF.returnKeyType = UIReturnKeyNext;
    nameTF.tag = kYCLoginNameInputViewTag;
    nameTF.backgroundColor = [UIColor whiteColor];
    nameTF.layer.cornerRadius = 5.0f;
    nameTF.layer.borderWidth = 1.0f;
    nameTF.layer.borderColor = [UIColor colorWithHexString:kGrayHex].CGColor;
    [mainBg addSubview:nameTF];
    [nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding));
        make.centerX.equalTo(@(0));
        make.width.equalTo(@(loginBtnWidthOfBgWidth*rate*curWidth));
        make.height.equalTo(@(textFieldHeightOfBgHeight*rate*curWidth));
    }];
    
    // ------------
    mTopPadding += secondGap + textFieldHeightOfBgHeight*rate*curWidth;
    
    eyesBtn = [HelloUtils yc_rightViewWithImage:eyeBtn_off tag:kYCLoginEyeBtnTag selector:@selector(loginViewBtnAction:) target:self];
    [eyesBtn setFrame:CGRectMake(0, 0, eyesBtn.frame.size.width, eyesBtn.frame.size.height)];
    
    pwdTF = [HelloUtils customTextfieldWidgetWithLeftView:nil
                                                rightView:eyesBtn
                                              placeholder:@"请输入密码"
                                                 delegate:self];
    pwdTF.endEditDistance = eyesBtn.frame.size.width - 25;
    [HelloUtils makeTextFieldPlaceHolderProperty:pwdTF];
    pwdTF.returnKeyType = UIReturnKeyDone;
    pwdTF.tag = kYCLoginPwdInputViewTag;
    pwdTF.secureTextEntry = pwdEntity;
    pwdTF.backgroundColor = [UIColor whiteColor];
    pwdTF.layer.cornerRadius = 5.0f;
    pwdTF.layer.borderWidth = 1.0f;
    pwdTF.layer.borderColor = [UIColor colorWithHexString:kGrayHex].CGColor;
    [mainBg addSubview:pwdTF];
    [pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding));
        make.centerX.equalTo(@(0));
        make.width.equalTo(@(loginBtnWidthOfBgWidth*rate*curWidth));
        make.height.equalTo(@(textFieldHeightOfBgHeight*rate*curWidth));
    }];
    
    // --------------
    mTopPadding += secondGap + textFieldHeightOfBgHeight*rate*curWidth;
    
    // login btn
    loginComfirmBtn = [HelloUtils yc_initBtnWithTitle:@"进入游戏" tag:kYCLoginMobileFastLoginBtnTag selector:@selector(loginViewBtnAction:) target:self];
    [mainBg addSubview:loginComfirmBtn];
    [loginComfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding));
        make.left.equalTo(@(anotherLeftPadding*rate*curWidth));
        make.width.equalTo(@(loginBtnWidthOfBgWidth*rate*curWidth));
        make.height.equalTo(@(textFieldHeightOfBgHeight*rate*curWidth));
    }];
    loginComfirmBtn.layer.cornerRadius = 5.0f;
    loginComfirmBtn.backgroundColor = [UIColor colorWithHexString:kGreenHex];
    loginComfirmBtn.titleLabel.textColor = [UIColor colorWithHexString:kWhiteHex];
    loginComfirmBtn.layer.borderWidth = 1.0f;
    loginComfirmBtn.layer.borderColor = [UIColor colorWithHexString:kGrayHex].CGColor;
    [loginComfirmBtn.titleLabel setFont:[UIFont fontWithName:kTxtFontName size:kTxtFontBigSize]];
    
    [self _makeAgreeViewContent];
    
    //
    UIButton *phoneRegBtn = [HelloUtils initBtnWithTitle:@"手机注册" tag:kYCLoginPhoneRegBtnTag selector:@selector(loginViewBtnAction:) target:self];
    [phoneRegBtn.layer setBorderWidth:0.0f];
    [phoneRegBtn.layer setBorderColor:[UIColor clearColor].CGColor];
    [phoneRegBtn.layer setCornerRadius:0.0f];
    [phoneRegBtn setTitleColor:[UIColor colorWithHexString:kGreenHex] forState:0];
    [phoneRegBtn.titleLabel setFont:[UIFont fontWithName:kTxtFontName size:kTxtFontSize]];
    [mainBg addSubview:phoneRegBtn];
    CGSize txtSize = [HelloUtils calculateSizeOfLabel:phoneRegBtn.titleLabel];
//    UIView *agrv = (UIView *)[self viewWithTag:kYCLoginAgreeViewTag];
    [phoneRegBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(agrv.mas_centerY);
        make.bottom.equalTo(@(-5));
        make.right.equalTo(@(-10));
        make.width.equalTo(@(txtSize.width));
        make.height.equalTo(@(txtSize.height));
    }];
}

#pragma mark - Change Account Mode

- (void)_curLoginUserInit
{
    if ([self _fetchUserList].count > 0) {
        curLoginUser = [self _fetchUserList][0];
    }
}

- (void)_switchAccountModeInit
{
    [self _curLoginUserInit];
    
    CGFloat txtFieldWidth = loginBtnWidthOfBgWidth*rate*curWidth;
    CGFloat txtFieldHeight = textFieldHeightOfBgHeight*rate*curWidth;
    
    CGFloat onCalHeight = rate*curHeight*0.8;
    CGFloat mTopPadding = 0;
    CGFloat firstGap = 26.0f/curWidth * onCalHeight;
    CGFloat secondGap = 8.0f/curWidth * onCalHeight;
    mTopPadding += firstGap;
    
    // title image
    UIImageView *titleImage = [[UIImageView alloc] initWithImage:GetImage(@"logo.png")];
    [mainBg addSubview:titleImage];
    // 440x98
    CGFloat widthOfImage    = 100*rate*curWidth/228.0f;
    CGFloat heightOfImage   = 100*rate*curWidth/228.0f/440.0f*98.0f;
    [titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding));
        make.centerX.equalTo(@(0));
        make.width.equalTo(@(widthOfImage));
        make.height.equalTo(@(heightOfImage));
    }];
    
    // ----------------------------
    
    mTopPadding += firstGap + heightOfImage;
    
    // 账号下拉
    userListBtn = [HelloUtils yc_rightViewWithImage:userListBtn_down tag:kTVRightUserListBtnTag selector:@selector(loginViewBtnAction:) target:self];
    [userListBtn setFrame:CGRectMake(-10, 0, userListBtn.frame.size.width, userListBtn.frame.size.height)];
    
    // text input
    nameTF = [HelloUtils customTextfieldWidgetWithLeftView:nil
                                                 rightView:userListBtn
                                               placeholder:@"请输入登录账号"
                                                  delegate:self];
    [HelloUtils makeTextFieldPlaceHolderProperty:nameTF];
    nameTF.returnKeyType = UIReturnKeyNext;
    nameTF.tag = kYCLoginNameInputViewTag;
    nameTF.backgroundColor = [UIColor whiteColor];
    nameTF.layer.cornerRadius = 5.0f;
    nameTF.layer.borderWidth = 1.0f;
    nameTF.layer.borderColor = [UIColor colorWithHexString:kGrayHex].CGColor;
    [mainBg addSubview:nameTF];
    [nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding));
        make.centerX.equalTo(@(0));
        make.width.equalTo(@(txtFieldWidth));
        make.height.equalTo(@(txtFieldHeight));
    }];
    // 填充最近登录的账号
    YCUserModel *firObj = listModelArr.count > 0 ? listModelArr[0] : nil;
    nameTF.text = firObj ? firObj.account : @"";
    // 只提供下拉选项，不提供编辑选项
//    m_mode == YCLogin_ChangeAccount ?
//    nameTF.userInteractionEnabled = NO;
    
    
    // ------
    mTopPadding += secondGap*6 + txtFieldHeight;
    
    // login btn
    loginComfirmBtn = [HelloUtils yc_initBtnWithTitle:@"进入游戏" tag:kYCLoginMobileFastLoginBtnTag selector:@selector(loginViewBtnAction:) target:self];
    [mainBg addSubview:loginComfirmBtn];
    [loginComfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding));
        make.left.equalTo(@(anotherLeftPadding*rate*curWidth));
        make.width.equalTo(@(loginBtnWidthOfBgWidth*rate*curWidth));
        make.height.equalTo(@(textFieldHeightOfBgHeight*rate*curWidth));
    }];
    loginComfirmBtn.layer.cornerRadius = 5.0f;
    loginComfirmBtn.backgroundColor = [UIColor colorWithHexString:kGreenHex];
    loginComfirmBtn.titleLabel.textColor = [UIColor colorWithHexString:kWhiteHex];
    loginComfirmBtn.layer.borderWidth = 1.0f;
    loginComfirmBtn.layer.borderColor = [UIColor colorWithHexString:kGrayHex].CGColor;
    [loginComfirmBtn.titleLabel setFont:[UIFont fontWithName:kTxtFontName size:kTxtFontBigSize]];
    
    
    CGSize txtSize = CGSizeZero;
    // btn
    UIButton *guestBtn = [HelloUtils initBtnWithTitle:@"更换登录方式" tag:kYCLoginChangeAccountBtnTag selector:@selector(loginViewBtnAction:) target:self];
    [guestBtn.layer setBorderWidth:0.0f];
    [guestBtn.layer setBorderColor:[UIColor clearColor].CGColor];
    [guestBtn.layer setCornerRadius:0.0f];
    [guestBtn setTitleColor:[UIColor colorWithHexString:kGreenHex] forState:0];
    [guestBtn.titleLabel setFont:[UIFont fontWithName:kTxtFontName size:kTxtFontSize]];
    [mainBg addSubview:guestBtn];
    txtSize = [HelloUtils calculateSizeOfLabel:guestBtn.titleLabel];
    [guestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-textFieldHeightOfBgHeight/2*rate*curWidth));
        make.centerX.equalTo(@(0));
        make.width.equalTo(@(txtSize.width));
        make.height.equalTo(@(txtSize.height));
    }];
    
}


#pragma mark - weinan 模式下的手机注册账号并登陆

- (void)_justHiddenGeneratedPhoneRegElements
{
    [[self viewWithTag:kYCLoginPhoneRegBtnTag] setHidden:NO];
    
    [[self viewWithTag:kYCLoginPhoneInputViewTag] setHidden:YES];
    [[self viewWithTag:kYCLoginGetVertifyCodeTag] setHidden:YES];
    phoneInput.hidden = YES;
    codeInput.hidden = YES;
}

- (void)_justShowGeneratedPhoneRegElements
{
    [[self viewWithTag:kYCLoginPhoneInputViewTag] setHidden:NO];
    [[self viewWithTag:kYCLoginGetVertifyCodeTag] setHidden:NO];
    phoneInput.hidden = NO;
    codeInput.hidden = NO;
}

- (void)_weinanPhoneRegMode
{
    [[self viewWithTag:kYCLoginPhoneRegBtnTag] setHidden:YES];
 
    [self _clearTextfield];
    
    if ([self viewWithTag:kYCLoginPhoneInputViewTag]) {
        [self _justShowGeneratedPhoneRegElements];
        return;
    }
    
    CGFloat onCalHeight = rate*curHeight*0.8;
    CGFloat mTopPadding = 0;
    CGFloat firstGap = 26.0f/curWidth * onCalHeight;
    CGFloat secondGap = 8.0f/curWidth * onCalHeight;
    mTopPadding += firstGap;
    
    // 440x98
//    CGFloat widthOfImage    = 100*rate*curWidth/228.0f;
    CGFloat heightOfImage   = 100*rate*curWidth/228.0f/440.0f*98.0f;
    // ----------------------------
    
    mTopPadding += firstGap + heightOfImage;
    
    // text input
    UIView *phoneView = [[UIView alloc] initWithFrame:CGRectZero];
    phoneView.tag = kYCLoginPhoneInputViewTag;
    phoneView.backgroundColor = [UIColor whiteColor];
    phoneView.layer.cornerRadius = 5.0f;
    phoneView.layer.borderWidth = 1.0f;
    phoneView.layer.borderColor = [UIColor colorWithHexString:kGrayHex].CGColor;
    [mainBg addSubview:phoneView];
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding));
        make.centerX.equalTo(@(0));
        make.width.equalTo(@(loginBtnWidthOfBgWidth*rate*curWidth));
        make.height.equalTo(@(textFieldHeightOfBgHeight*rate*curWidth));
    }];
    
    // pick btn
    NSInteger pickBtnTag = 10098;
    UIButton * pickBtn = [HelloUtils initBtnWithTitle:@"+86" tag:pickBtnTag selector:@selector(loginViewBtnAction:) target:self];
    [pickBtn.layer setCornerRadius:0.0f];
    [pickBtn.layer setBorderWidth:0.0f];
    [pickBtn.layer setBorderColor:[UIColor clearColor].CGColor];
    [pickBtn setTitleColor:[UIColor colorWithHexString:kBlackHex] forState:0];
    pickBtn.userInteractionEnabled = NO;
    [phoneView addSubview:pickBtn];
    [pickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
        make.left.equalTo(@(0));
        make.bottom.equalTo(@(0));
        make.right.equalTo(@(-loginBtnWidthOfBgWidth*rate*curWidth*0.8));
    }];
    // seperate line
    UILabel *seperateLine = [self _createSeperateLine];
    [phoneView addSubview:seperateLine];
    [seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@(0));
        make.left.equalTo(pickBtn.mas_right);
        make.width.equalTo(@(1.0f));
        make.height.equalTo(@(30-10));
    }];
    
    phoneInput = [HelloUtils customTextfieldWidgetWithLeftView:nil rightView:nil placeholder:@"请输入您的手机号码" delegate:self];
    [HelloUtils makeTextFieldPlaceHolderProperty:phoneInput];
    phoneInput.returnKeyType = UIReturnKeyNext;
    [phoneView addSubview:phoneInput];
    [phoneInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
        make.left.equalTo(@(loginBtnWidthOfBgWidth*rate*curWidth*0.2+5));
        make.bottom.equalTo(@(0));
        make.right.equalTo(@(0));
    }];
    
    // ------------
    mTopPadding += secondGap + textFieldHeightOfBgHeight*rate*curWidth;
    
    
    // send vertify btn
    NSString *strFetchVertifyCode = @"获取验证码";
    NSInteger sendVertifyBtnTag = kYCLoginGetVertifyCodeTag;
    UIButton *sendVertifyBtn = [HelloUtils initBtnWithType:UIButtonTypeCustom title:strFetchVertifyCode tag:sendVertifyBtnTag selector:@selector(loginViewBtnAction:) target:self];
    [sendVertifyBtn setTitle:strFetchVertifyCode forState:0];
    [sendVertifyBtn.layer setCornerRadius:0.0f];
    [sendVertifyBtn.layer setBorderWidth:0.0f];
    [sendVertifyBtn.layer setBorderColor:[UIColor colorWithHexString:kGrayHex].CGColor];
    [sendVertifyBtn setTitleColor:[UIColor colorWithHexString:kBlackHex] forState:0];
    [sendVertifyBtn.titleLabel setFont:[UIFont fontWithName:kTxtFontName size:kTxtFontSize]];
    CGSize sendVertifyCodeBtnSize = [HelloUtils calculateSizeOfLabel:sendVertifyBtn.titleLabel andWidth:1000];
    [sendVertifyBtn setFrame:CGRectMake(0, 0, sendVertifyCodeBtnSize.width, textFieldHeightOfBgHeight*rate*curWidth
                                        )];
    
    // input
    
    codeInput = [HelloUtils customTextfieldWidgetWithLeftView:nil rightView:sendVertifyBtn placeholder:@"请输入验证码" delegate:self];
    codeInput.endEditDistance = sendVertifyCodeBtnSize.width - 25 + 10.0f;
    codeInput.rightViewDistance = 10.0f;
    [HelloUtils makeTextFieldPlaceHolderProperty:codeInput];
    codeInput.returnKeyType = UIReturnKeyDone;
    [mainBg addSubview:codeInput];
    [codeInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding));
        make.centerX.equalTo(@(0));
        make.width.equalTo(@(loginBtnWidthOfBgWidth*rate*curWidth));
        make.height.equalTo(@(textFieldHeightOfBgHeight*rate*curWidth));
    }];
    codeInput.backgroundColor = [UIColor whiteColor];
    codeInput.layer.cornerRadius = 5.0f;
    codeInput.layer.borderWidth = 1.0f;
    codeInput.layer.borderColor = [UIColor colorWithHexString:kGrayHex].CGColor;
}

#pragma mark - 切换模式

- (void)_doSomeMagicToFastLogin
{
    [self removeFromSuperview];

    YCLoginView *logoutView = [[YCLoginView alloc] initWithMode:YCLogin_ChangeAccount];
    [MainWindow addSubview:logoutView];
}

- (void)_doSomeMagicToAccountLogin
{
    [self _clearTextfield];
    
    m_mode = YCLogin_Account;
    
    // 关闭Mobile登录页的选项
    [[self viewWithTag:kYCLoginPhoneInputViewTag] setHidden:YES];
    [[self viewWithTag:kYCLoginCodeInputViewTag] setHidden:YES];
    [[self viewWithTag:kYCLoginHelpCenterBtnTag] setHidden:YES];
    [[self viewWithTag:kYCLoginAccountLoginBtnTag] setHidden:YES];
    [[self viewWithTag:kYCLoginGuestBtnTag] setHidden:YES];
    [[self viewWithTag:kYCLoginAgreeViewTag] setHidden:YES];
    
    [self _openAccountLoginElement];
}

// 打开账号登录页的选项
- (void)_openAccountLoginElement
{
    [[self viewWithTag:kYCLoginEyeBtnTag] setHidden:YES];
    
    [[self viewWithTag:kLoginBackBtnTag] setHidden:NO];
    [[self viewWithTag:kYCLoginNameInputViewTag] setHidden:NO];
    [[self viewWithTag:kYCLoginPwdInputViewTag] setHidden:NO];
    [[self viewWithTag:kYCLoginRegisterAccountBtnTag] setHidden:NO];
    [[self viewWithTag:kYCLoginBindMobilePhoneBtnTag] setHidden:NO];
    [[self viewWithTag:kYCLoginNoAccountTag] setHidden:NO];
    
    [self _forgetBtnShow];
}

- (void)_forgetBtnShow
{
    // ----- 忘记密码
    forgetPwdBtn = [HelloUtils initBtnWithTitle:@"忘记密码？" tag:kYCLoginForgetPwdBtnTag selector:@selector(loginViewBtnAction:) target:self];
    [forgetPwdBtn.layer setBorderWidth:0.0f];
    [forgetPwdBtn.layer setBorderColor:[UIColor clearColor].CGColor];
    [forgetPwdBtn.layer setCornerRadius:0.0f];
    [forgetPwdBtn setTitleColor:[UIColor colorWithHexString:kGreenHex] forState:0];
    [forgetPwdBtn.titleLabel setFont:[UIFont fontWithName:kTxtFontName size:kTxtFontSize]];
    CGSize forgetPwdBtnSize = [HelloUtils calculateSizeOfLabel:forgetPwdBtn.titleLabel andWidth:1000];
    // 使用HelloTextField的右视图
    [forgetPwdBtn setFrame:CGRectMake(0, 0, forgetPwdBtnSize.width, forgetPwdBtnSize.height)];
    
    pwdTF.rightView = forgetPwdBtn;
    pwdTF.endEditDistance = forgetPwdBtn.frame.size.width - 25;
}

// 编辑清空
- (void)_clearTextfield
{
    nameTF.text     = @"";
    pwdTF.text      = @"";
    phoneInput.text = @"";
    codeInput.text  = @"";
}

- (void)_doSomeMagicToRegister
{
    [self _clearTextfield];
    
    m_mode = YCLogin_Register;
    [[self viewWithTag:kYCLoginRegisterAccountBtnTag] setHidden:YES];
    [[self viewWithTag:kYCLoginBindMobilePhoneBtnTag] setHidden:YES];
    [[self viewWithTag:kYCLoginNoAccountTag] setHidden:YES];
    [[self viewWithTag:kYCLoginForgetPwdBtnTag] setHidden:YES];
    
    if ([self viewWithTag:kYCLoginAgreeViewTag]) {
        [[self viewWithTag:kYCLoginAgreeViewTag] setHidden:NO];
    } else {
        [self _makeAgreeViewContent];
    }
    
    if ([self viewWithTag:kYCLoginEyeBtnTag]) {
        [[self viewWithTag:kYCLoginEyeBtnTag] setHidden:NO];
        return;
    }
    
    eyesBtn = [HelloUtils yc_rightViewWithImage:eyeBtn_off tag:kYCLoginEyeBtnTag selector:@selector(loginViewBtnAction:) target:self];
    [eyesBtn setFrame:CGRectMake(0, 0, eyesBtn.frame.size.width, eyesBtn.frame.size.height)];
    pwdTF.rightView = eyesBtn;
    pwdTF.secureTextEntry = pwdEntity;
    pwdTF.endEditDistance = eyesBtn.frame.size.width - 25;
}

- (void)_makeAgreeViewContent
{
    // 用户协议
    UIView *agreeView = [[UIView alloc] initWithFrame:CGRectZero];
    agreeView.userInteractionEnabled = YES;
    agreeView.tag = kYCLoginAgreeViewTag;
    agreeView.backgroundColor = [UIColor clearColor];
    [mainBg addSubview:agreeView];
    [agreeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-5));
        make.centerX.equalTo(@(0));
        make.width.equalTo(@(loginBtnWidthOfBgWidth*rate*curWidth));
        make.height.equalTo(@(textFieldHeightOfBgHeight*rate*curWidth));
    }];
    
    [self _addAgreeContentToView:agreeView];
}

- (void)_doSomeMagicToMobileLogin
{
    m_mode = YCLogin_Mobile;
    
    [[self viewWithTag:kLoginBackBtnTag] setHidden:YES];
    [[self viewWithTag:kYCLoginNameInputViewTag] setHidden:YES];
    [[self viewWithTag:kYCLoginPwdInputViewTag] setHidden:YES];
    [[self viewWithTag:kYCLoginRegisterAccountBtnTag] setHidden:YES];
    [[self viewWithTag:kYCLoginBindMobilePhoneBtnTag] setHidden:YES];
    [[self viewWithTag:kYCLoginNoAccountTag] setHidden:YES];
    [[self viewWithTag:kYCLoginAgreeViewTag] setHidden:YES];
    
    [self _openMobileLoginElement];
}

- (void)_openMobileLoginElement
{
    [[self viewWithTag:kYCLoginPhoneInputViewTag] setHidden:NO];
    [[self viewWithTag:kYCLoginCodeInputViewTag] setHidden:NO];
    [[self viewWithTag:kYCLoginHelpCenterBtnTag] setHidden:NO];
    [[self viewWithTag:kYCLoginAccountLoginBtnTag] setHidden:NO];
    [[self viewWithTag:kYCLoginGuestBtnTag] setHidden:NO];
}

- (void)_changeToShowAccountLogin
{
    [self _doSomeMagicToAccountLogin];
    
    if ([self viewWithTag:kYCLoginNoAccountTag]) {
        return;
    }
    
    CGFloat onCalHeight = rate*curHeight*0.8;
    CGFloat mTopPadding = 0;
    CGFloat firstGap = 26.0f/curWidth * onCalHeight;
    CGFloat secondGap = 8.0f/curWidth * onCalHeight;
    mTopPadding += firstGap;
    // 440x98
//    CGFloat widthOfImage    = 100*rate*curWidth/228.0f;
    CGFloat heightOfImage   = 100*rate*curWidth/228.0f/440.0f*98.0f;
    
    // back btn
    UIButton *backBtn = [HelloUtils initBtnWithNormalImage:backBtn_normal highlightedImage:backBtn_highlighted tag:kLoginBackBtnTag selector:@selector(loginViewBtnAction:) target:self];
    [mainBg addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding/2));
        make.left.equalTo(@(leftPadding*rate*curWidth));
        make.width.equalTo(@(backBtnWidthAndHeight*rate*curWidth));
        make.height.equalTo(@(backBtnWidthAndHeight*rate*curWidth));
    }];
    
    
    // ----------------------------
    
    mTopPadding += firstGap + heightOfImage;
    
    userListBtn = [HelloUtils yc_rightViewWithImage:userListBtn_down tag:kTVRightUserListBtnTag selector:@selector(loginViewBtnAction:) target:self];
    [userListBtn setFrame:CGRectMake(-10, 0, userListBtn.frame.size.width, userListBtn.frame.size.height)];
    
    // text input
    nameTF = [HelloUtils customTextfieldWidgetWithLeftView:nil
                                                 rightView:userListBtn
                                               placeholder:@"请输入登录账号"
                                                  delegate:self];
    [HelloUtils makeTextFieldPlaceHolderProperty:nameTF];
    nameTF.returnKeyType = UIReturnKeyNext;
    nameTF.tag = kYCLoginNameInputViewTag;
    nameTF.backgroundColor = [UIColor whiteColor];
    nameTF.layer.cornerRadius = 5.0f;
    nameTF.layer.borderWidth = 1.0f;
    nameTF.layer.borderColor = [UIColor colorWithHexString:kGrayHex].CGColor;
    [mainBg addSubview:nameTF];
    [nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding));
        make.centerX.equalTo(@(0));
        make.width.equalTo(@(loginBtnWidthOfBgWidth*rate*curWidth));
        make.height.equalTo(@(textFieldHeightOfBgHeight*rate*curWidth));
    }];
    
    YCUserModel *firstUser = listModelArr.count > 0 ? listModelArr[0] : nil;
    nameTF.text = firstUser ? firstUser.account : @"";
    
    // ------------
    mTopPadding += secondGap + textFieldHeightOfBgHeight*rate*curWidth;
    
    // ----- 忘记密码
    forgetPwdBtn = [HelloUtils initBtnWithTitle:@"忘记密码？" tag:kYCLoginForgetPwdBtnTag selector:@selector(loginViewBtnAction:) target:self];
    [forgetPwdBtn.layer setBorderWidth:0.0f];
    [forgetPwdBtn.layer setBorderColor:[UIColor clearColor].CGColor];
    [forgetPwdBtn.layer setCornerRadius:0.0f];
    [forgetPwdBtn setTitleColor:[UIColor colorWithHexString:kGreenHex] forState:0];
    [forgetPwdBtn.titleLabel setFont:[UIFont fontWithName:kTxtFontName size:kTxtFontSize]];
    CGSize forgetPwdBtnSize = [HelloUtils calculateSizeOfLabel:forgetPwdBtn.titleLabel andWidth:1000];
    // 使用HelloTextField的右视图
    [forgetPwdBtn setFrame:CGRectMake(0, 0, forgetPwdBtnSize.width, forgetPwdBtnSize.height)];
    
    pwdTF = [HelloUtils customTextfieldWidgetWithLeftView:nil
                                                rightView:forgetPwdBtn
                                              placeholder:@"请输入密码"
                                                 delegate:self];
    pwdTF.endEditDistance = forgetPwdBtnSize.width-25;
    [HelloUtils makeTextFieldPlaceHolderProperty:pwdTF];
    pwdTF.returnKeyType = UIReturnKeyDone;
    pwdTF.tag = kYCLoginPwdInputViewTag;
    pwdTF.secureTextEntry = pwdEntity;
    pwdTF.backgroundColor = [UIColor whiteColor];
    pwdTF.layer.cornerRadius = 5.0f;
    pwdTF.layer.borderWidth = 1.0f;
    pwdTF.layer.borderColor = [UIColor colorWithHexString:kGrayHex].CGColor;
    [mainBg addSubview:pwdTF];
    [pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding));
        make.centerX.equalTo(@(0));
        make.width.equalTo(@(loginBtnWidthOfBgWidth*rate*curWidth));
        make.height.equalTo(@(textFieldHeightOfBgHeight*rate*curWidth));
    }];
    
    
    
    // --------------
    // 没有账号?
    UILabel *noAccountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    noAccountLabel.text = @"没有账号?";
    [noAccountLabel setFont:[UIFont fontWithName:kTxtFontName size:kTxtFontSize]];
    CGSize noAccountLabelSize = [HelloUtils calculateSizeOfLabel:noAccountLabel andWidth:1000];
    noAccountLabel.tag = kYCLoginNoAccountTag;
    [mainBg addSubview:noAccountLabel];
    [noAccountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-textFieldHeightOfBgHeight/3*rate*curWidth));
        make.left.equalTo(loginComfirmBtn.mas_left);
        make.width.equalTo(@(noAccountLabelSize.width));
        make.height.equalTo(@(noAccountLabelSize.height));
    }];
    
    // 快速注册按钮
    UIButton *guestBtn = [HelloUtils initBtnWithTitle:@"快速注册" tag:kYCLoginRegisterAccountBtnTag selector:@selector(loginViewBtnAction:) target:self];
    [guestBtn.layer setBorderWidth:0.0f];
    [guestBtn.layer setBorderColor:[UIColor clearColor].CGColor];
    [guestBtn.layer setCornerRadius:0.0f];
    [guestBtn setTitleColor:[UIColor colorWithHexString:kGreenHex] forState:0];
    [guestBtn.titleLabel setFont:[UIFont fontWithName:kTxtFontName size:kTxtFontSize]];
    [mainBg addSubview:guestBtn];
    CGSize guestBtnSize = [HelloUtils calculateSizeOfLabel:guestBtn.titleLabel andWidth:1000];
    [guestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-textFieldHeightOfBgHeight/3*rate*curWidth));
        make.left.equalTo(noAccountLabel.mas_right);
        make.width.equalTo(@(guestBtnSize.width));
        make.height.equalTo(@(guestBtnSize.height));
    }];
    
    // 绑定手机按钮
    UIButton *helpCenterBtn = [HelloUtils initBtnWithTitle:@"绑定手机" tag:kYCLoginBindMobilePhoneBtnTag selector:@selector(loginViewBtnAction:) target:self];
    [helpCenterBtn.layer setBorderWidth:0.0f];
    [helpCenterBtn.layer setBorderColor:[UIColor clearColor].CGColor];
    [helpCenterBtn.layer setCornerRadius:0.0f];
    [helpCenterBtn setTitleColor:[UIColor colorWithHexString:kGreenHex] forState:0];
    [helpCenterBtn.titleLabel setFont:[UIFont fontWithName:kTxtFontName size:kTxtFontSize]];
    [mainBg addSubview:helpCenterBtn];
    CGSize helpCenterBtnSize = [HelloUtils calculateSizeOfLabel:helpCenterBtn.titleLabel andWidth:1000];
    [helpCenterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-textFieldHeightOfBgHeight/3*rate*curWidth));
        make.right.equalTo(loginComfirmBtn.mas_right);
        make.width.equalTo(@(helpCenterBtnSize.width));
        make.height.equalTo(@(helpCenterBtnSize.height));
    }];
}




#pragma mark - Btn Actions

- (void)usePhoneAndCodeLogin {
    NSString *mobileNum = phoneInput.text;
    NSString *code = [HelloUtils triString:codeInput.text];
    if (![HelloUtils validCnMobileNumber:mobileNum]) {
        [HelloUtils invalidPhoneToast];
        return;
    }
    if (code.length <= 0) {
        [HelloUtils invalidVertifyCodeToast];
        return;
    }
    
    [NetEngine loginUsingMobileNum:mobileNum
                       vertifyCode:code
                        completion:^(id result){
                            if ([result isKindOfClass:[NSDictionary class]]) {
                                // 保存账号信息
                                [YCDataUtils yc_handelNormalUser:(NSDictionary *)result];
                                [HelloUtils yc_postNoteWithName:NOTE_YC_LOGIN_SUCCESS userInfo:(NSDictionary *)result];
                                [self removeFromSuperview];
                            }
                        }];
}

- (void)useAccountAndPwdLogin {
    NSString *name = nameTF.text;
    NSString *pass = pwdTF.text;
    name = [HelloUtils triString:name];
    pass = [HelloUtils triString:pass];
    if (![HelloUtils validUserName:name]) {
        [HelloUtils invalidNameToast];
        return;
    }
    if (![HelloUtils validPassWord:pass]) {
        [HelloUtils invalidPwdToast];
        return;
    }
    [HelloUtils spStarLoadingAtView:nil];
    [NetEngine loginUsingUsername:name
                         password:pass
                              uid:nil
                          session:nil
                       completion:^(id result){
                           [HelloUtils spStopLoadingAtView:nil];
                           if ([result isKindOfClass:[NSDictionary class]]) {
                               // 保存账号信息
                               [YCDataUtils yc_handelNormalUser:(NSDictionary *)result];
                               [HelloUtils yc_postNoteWithName:NOTE_YC_LOGIN_SUCCESS userInfo:(NSDictionary *)result];
                               [self removeFromSuperview];
                           }
                       }];
}

- (void)useAccounAndPwdRegister {
    NSString *name = nameTF.text;
    NSString *pass = pwdTF.text;
    if (![HelloUtils validUserName:name]) {
        [HelloUtils invalidNameToast];
        return;
    }
    if (![HelloUtils validPassWord:pass]) {
        [HelloUtils invalidPwdToast];
        return;
    }
    if (!checkboxStatus) {
        [HelloUtils disagreeAgreeementToast];
        return;
    }
    
    [HelloUtils spStarLoadingAtView:nil];
    [NetEngine registerAccountWithUserName:name
                                  password:pass
                                     email:@""
                                completion:^(id result){
                                    [HelloUtils spStopLoadingAtView:nil];
                                    if ([result isKindOfClass:[NSDictionary class]]) {
                                        
                                        // save a photo to user
                                        pwdTF.secureTextEntry = NO;
                                        [HelloUtils ycu_saveNewRegAccountToPhoto:self];
                                        
                                        [YCDataUtils yc_handelNormalUser:(NSDictionary *)result];
                                        [HelloUtils yc_postNoteWithName:NOTE_YC_LOGIN_SUCCESS userInfo:(NSDictionary *)result];
                                        [self removeFromSuperview];
                                    }
                                }];
}

- (void)loginViewBtnAction:(UIButton *)sender
{
    switch (sender.tag) {
        case kYCLoginPhoneRegBtnTag:
        {
            [self _weinanPhoneRegMode];
        }
            break;
        case kYCLoginHelpCenterBtnTag:
        {
            [HelloUtils yc_showSomeSenceOnSafari:strHelpCenterUrl];
        }
            break;
        case kYCLoginMobileFastLoginBtnTag:
        {
            switch (m_mode) {
                case YCLogin_FastToDefault:
                case YCLogin_Default:
                {
                    [self usePhoneAndCodeLogin];
                }
                    break;
                case YCLogin_Account:
                {
                    [self useAccountAndPwdLogin];
                }
                    break;
                case YCLogin_DirectToRegister:
                case YCLogin_Register:
                {
                    [self viewWithTag:kYCLoginPhoneRegBtnTag].hidden?[self usePhoneAndCodeLogin]:[self useAccounAndPwdRegister];
                }
                    break;
                case YCLogin_ChangeAccount:
                {
                    if (![HelloUtils validUserName:nameTF.text]) {
                        [HelloUtils spToastWithMsg:@"请选择要登录的账号"];
                        return;
                    }
                    [HelloUtils spStarLoadingAtView:nil];
                    [NetEngine loginUsingUsername:curLoginUser.account
                                         password:curLoginUser.password
                                              uid:[NSString stringWithFormat:@"%@",curLoginUser.uid]
                                          session:curLoginUser.sessionid
                                       completion:^(id result){

                                           [HelloUtils spStopLoadingAtView:nil];
                                           if ([result isKindOfClass:[NSDictionary class]]) {
                                               
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                               
                                               // 先判定是否要显示绑定警告框，如果要，则显示警告框，如果不要，则直接游客登录
                                                   BOOL showWarning = [[NSString stringWithFormat:@"%@",result[@"data"][@"remind"]] boolValue];
                                                   if (showWarning) {
                                                       YCBindView *warnView = [[YCBindView alloc] initWithMode:YCBind_GuestToMobileWarning data:(NSDictionary *)result[@"data"] handler:^{
                                                           [YCDataUtils yc_handelNormalUser:(NSDictionary *)result];
                                                           [HelloUtils yc_postNoteWithName:NOTE_YC_LOGIN_SUCCESS userInfo:(NSDictionary *)result];
                                                           [self removeFromSuperview];
                                                       }];
                                                       
                                                       [UIView animateWithDuration:tRotaTomeInterval
                                                                        animations:^{
                                                                            mainBg.alpha = 0.0f;
                                                                            [self addSubview:warnView];
                                                                        }];
                                                       return;
                                                   } else {
                                                       [YCDataUtils yc_handelNormalUser:(NSDictionary *)result];
                                                       [HelloUtils yc_postNoteWithName:NOTE_YC_LOGIN_SUCCESS userInfo:(NSDictionary *)result];
                                                       [self removeFromSuperview];
                                                   }
                                                   
                                               });
                                           }
                                       }];
                }
                    break;
                default:
                    break;
            }
            
        }
            break;
        case kYCLoginGuestBtnTag:
        {
//            根据回调的数据来确定是否展开临时账号绑定正式账号的选项
//            1、先登录
//            2、回调，true--显示警告，绑定--绑定登录，不--回调给开发商 ，false -不显示，回调给开发商
            
            [HelloUtils spStarLoadingAtView:nil];
            [NetEngine guestLoginAndCompletion:^(id result){
                [HelloUtils spStopLoadingAtView:nil];
                if ([result isKindOfClass:[NSDictionary class]]) {
                    
                    // 先判定是否要显示绑定警告框，如果要，则显示警告框，如果不要，则直接游客登录
//                    NSLog(@"===%@",result);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        BOOL showWarning = [[NSString stringWithFormat:@"%@",result[@"data"][@"remind"]] boolValue];
                        if (showWarning) {
                            YCBindView *warnView = [[YCBindView alloc] initWithMode:YCBind_GuestToMobileWarning data:(NSDictionary *)result[@"data"] handler:^{
                                [YCDataUtils yc_handelNormalUser:(NSDictionary *)result];
                                [HelloUtils yc_postNoteWithName:NOTE_YC_LOGIN_SUCCESS userInfo:(NSDictionary *)result];
                                [self removeFromSuperview];
                            }];
                            
                            [UIView animateWithDuration:tRotaTomeInterval
                                             animations:^{
                                                 mainBg.alpha = 0.0f;
                                                 [self addSubview:warnView];
                                             }];
                            return;
                        } else {
                            [YCDataUtils yc_handelNormalUser:(NSDictionary *)result];
                            [HelloUtils yc_postNoteWithName:NOTE_YC_LOGIN_SUCCESS userInfo:(NSDictionary *)result];
                            [self removeFromSuperview];
                        }
                        
                    });
                    
                }
            }];
        }
            break;
        case kYCLoginAccountLoginBtnTag:
        {
            switch (m_mode) {
                case YCLogin_Account:
                    [self _doSomeMagicToRegister];
                    break;
                case YCLogin_FastToDefault:
                case YCLogin_Default:
                    [self _changeToShowAccountLogin];
                    break;
                default:
                    break;
            }
        }
            break;
        // 获取验证码
        case kYCLoginGetVertifyCodeTag:
        {
            NSString *mobilePhoneNum = phoneInput.text;
            mobilePhoneNum = [HelloUtils triString:mobilePhoneNum];
            if (![HelloUtils validCnMobileNumber:mobilePhoneNum]) {
                [HelloUtils invalidPhoneToast];
                return;
            }
            [NetEngine sendVertifyCodeToMobile:mobilePhoneNum
                                     situation:kSendCodeType_Login
                                    completion:^(id reslut){
                                        if ([reslut isKindOfClass:[NSDictionary class]]) {
                                            [HelloUtils counttingButton:sender
                                                              startTime:59.0f
                                                                  title:@""
                                                         countDownTitle:@"s"
                                                              mainColor:[UIColor whiteColor]
                                                             countColor:[UIColor lightGrayColor]];
                                        }
                                    }];
        }
            break;
        case kLoginBackBtnTag:
        {
            [self _textFieldResignFirstResponer];
            
            switch (m_mode) {
                case YCLogin_Account:
                {
                    if ([self.superview isKindOfClass:[YCWeinanView class]]) {
                        [self removeFromSuperview];
                        break;
                    }
                    [self _doSomeMagicToMobileLogin];
                }
                    
                    break;
                case YCLogin_Register:
                    [self _doSomeMagicToAccountLogin];
                    break;
                    
                    
                default:
                    break;
            }
        }
            break;
        case kLoginDamnBackBtnTag:
        {
            NSLog(@"dddaaaammmmnnn");
            if ([self.superview isKindOfClass:[YCWeinanView class]]) {
                
                // 通过“手机注册”按钮是否显示作为判断返回
                if ([self viewWithTag:kYCLoginPhoneRegBtnTag].hidden) {
                    [self _justHiddenGeneratedPhoneRegElements];
                    break;
                }
                
                [self removeFromSuperview];
                break;
            }
            [self _doSomeMagicToFastLogin];
        }
            break;
        case kYCLoginForgetPwdBtnTag:
        {
            [self _toBindViewWithMode:YCBind_Forget_CheckAccount];
        }
            break;
        case kYCLoginBindMobilePhoneBtnTag:
        {
            [self _toBindViewWithMode:YCBind_Default];
        }
            break;
        case kYCLoginRegisterAccountBtnTag:
        {
            [self _doSomeMagicToRegister];
        }
            break;
        case kYCLoginEyeBtnTag:
        {
            pwdTF.secureTextEntry = !pwdEntity;
            pwdEntity = !pwdEntity;
            if (pwdEntity) {
                [eyesBtn setImage:GetImage(eyeBtn_off) forState:0];
            } else {
                [eyesBtn setImage:GetImage(eyeBtn_on) forState:0];
            }
        }
            break;
        case kYCLoginChangeAccountBtnTag:
        {
            [self removeFromSuperview];
            
            YCLoginView *fastLogin = [[YCLoginView alloc] initWithMode:YCLogin_FastToDefault];
            [MainWindow addSubview:fastLogin];
            
        }
            break;
        case kTVRightUserListBtnTag:
        {
            if ([[self _fetchUserList] count] < 1) {
                [HelloUtils spToastWithMsg:@"没有已保存的账号"];
                return;
            }
            
            userListShow = !userListShow;
            if (userListShow) {
                [self _userListViewShow];
            } else {
                [self _userListViewClose];
            }
        }
            break;
        case kYCUserListDelBtnTag:
        {
            UITableViewCell *cell = (UITableViewCell *)[sender superview];
            NSIndexPath *indexPath = [uList indexPathForCell:cell];
            [self _removeUserWithIndex:indexPath.row];
        }
            break;
        default:
            break;
    }
}

#pragma mark - User List Method

- (void)_userListViewShow
{
    [self _userListBtnRotaToShow];
    
    userListView = [[UIView alloc] initWithFrame:CGRectZero];
    userListView.backgroundColor = [UIColor whiteColor];
    userListView.tag = kYCUserListVeiwTag;
    [userListView setFrame:CGRectMake(0, 0, winWidth, winHeight)];
    userListView.backgroundColor = [UIColor clearColor];
    
    // 改用蒙版，添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cn_tapAction:)];
    tap.delegate = self;
    [userListView addGestureRecognizer:tap];
    
    UIWindow * window = [UIApplication sharedApplication].windows[0];
    [window addSubview:userListView];
    
    // add table view
    uList = [[UITableView alloc] initWithFrame:CGRectZero];
    uList.layer.borderWidth = 1.0f;
    uList.layer.borderColor = [UIColor colorWithHexString:kGrayHex].CGColor;
    [userListView addSubview:uList];
    [uList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameTF.mas_bottom);
        make.centerX.equalTo(@(0));
        make.width.equalTo(@(loginBtnWidthOfBgWidth*rate*curWidth));
        make.height.equalTo(@(100));
    }];
    // datasource,delegate
//    listModelArr = [self _fetchUserList];
    uList.delegate = self;
    uList.dataSource = self;
    uList.rowHeight = 30.0f;
    uList.bounces = NO;
}

- (void)_userListViewClose
{
    // close
    [userListView removeFromSuperview];
    [self _userListBtnRotaToClose];
    userListShow = !userListShow;
}

- (void)cn_tapAction:(UITapGestureRecognizer *)tap
{
    [self _userListViewClose];
}

#pragma mark - userListBtn Animation

- (void)_userListBtnRotaToShow
{
    [UIView animateWithDuration:tRotaTomeInterval
                     animations:^{
                         userListBtn.transform = CGAffineTransformMakeRotation(M_PI);
                     }];
}

- (void)_userListBtnRotaToClose
{
    [UIView animateWithDuration:tRotaTomeInterval
                     animations:^{
                         userListBtn.transform = CGAffineTransformMakeRotation(-M_PI*2);
                     }];
}

#pragma mark - Tap Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:uList] || [touch.view isDescendantOfView:userListBtn]) {
        return NO;
    }
    return YES;
}


#pragma mark - Table View Delegate  -- CN

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listModelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = kListCellIdentifier;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] ;
        
        UIButton *delBtn = [HelloUtils initBtnWithNormalImage:user_list_close_btn_name highlightedImage:nil tag:kYCUserListDelBtnTag selector:@selector(loginViewBtnAction:) target:self];
        [delBtn setFrame:CGRectMake(loginBtnWidthOfBgWidth*rate*curWidth-40, 0, uList.rowHeight, uList.rowHeight)];
        [cell addSubview:delBtn];
        
    }
    
    YCUserModel *model = listModelArr[indexPath.row];
    cell.textLabel.text = model.nickname;
    
    return cell ;
}

//点击选中表格行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // change cur account
    
    YCUserModel *model = listModelArr[indexPath.row];
    nameTF.text = model.nickname;
    
    curLoginUser = model;
    
    // close
    [self _userListViewClose];
    
}

- (void)_removeUserWithIndex:(NSInteger)index
{
    // remove in userdefault
    [YCDataUtils yc_removeNormalUserWithIndex:index];
    // refresh list
    listModelArr =  [self _fetchUserList].copy;
    [uList reloadData];
    
    if (listModelArr.count <= 0) {
        nameTF.text = @"";
        [self _userListViewClose];
    }
}


#pragma mark - To Bind View Method

- (void)_toBindViewWithMode:(YCBindMode)mode
{
    YCBindView *bindView = [[YCBindView alloc] initWithMode:mode];
    [UIView animateWithDuration:tRotaTomeInterval
                     animations:^{
                         mainBg.alpha = 0.0f;
                         [self addSubview:bindView];
                     }];
}

#pragma mark - Touches
// keybord down
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self _textFieldResignFirstResponer];
}

- (void)_textFieldResignFirstResponer
{
    [nameTF resignFirstResponder];
    [pwdTF resignFirstResponder];
    [phoneInput resignFirstResponder];
    [codeInput resignFirstResponder];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyNext) {
        [textField resignFirstResponder];
        
        switch (m_mode) {
            case YCLogin_Default:
            {
                if ([textField isEqual:phoneInput]) {
                    [codeInput becomeFirstResponder];
                }
            }
                break;
            case YCLogin_Register:
            case YCLogin_Account:
            {
                if ([textField isEqual:nameTF]) {
                    [pwdTF becomeFirstResponder];
                }
            }
                break;
            
                
            default:
                break;
        }
        
        
    }
    
    if (textField.returnKeyType == UIReturnKeyDone) {
        [textField resignFirstResponder];
        // comfirm btn down
        [self loginViewBtnAction:loginComfirmBtn];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGFloat midline = 0;
    // 因为 phoneInput codeInput 是加在另一个 view 上的，因此取 surper view 的值
//    if ([textField isEqual:phoneInput] || [textField isEqual:codeInput]) {
//        midline = [textField superview].frame.origin.y + 0.5 * [textField superview].frame.size.height;
//    } else {
//        midline = textField.frame.origin.y + 0.5 * textField.frame.size.height;
//    }
    midline = textField.frame.origin.y + 0.5 * textField.frame.size.height;
    CGRect viewRect = self.frame;
    CGFloat heightFraction = (midline - viewRect.origin.y) / viewRect.size.height;
    
    if (heightFraction < 0.0) {
        heightFraction = 0.0;
    } else if (heightFraction > 1.0) {
        heightFraction = 1.0;
    }
    
    animatedDistance = floor(keyboarHeight * heightFraction);
    
    CGRect viewFrame = self.frame;
    viewFrame.origin.y -= animatedDistance;
    [self _animationWithView:self frame:viewFrame duration:tRotaTomeInterval];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.frame;
    viewFrame.origin.y += animatedDistance;
    [self _animationWithView:self frame:viewFrame duration:tRotaTomeInterval];
}

- (void)_animationWithView:(UIView *)view frame:(CGRect)viewFrame duration:(NSTimeInterval)duration
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:duration];
    [view setFrame:viewFrame];
    [UIView commitAnimations];
}


#pragma mark - Noti

- (void)_loginNoteLisetner:(NSNotification *)note
{
   if ([note.name isEqualToString:UIKeyboardWillShowNotification]) {
       NSDictionary *userInfo = note.userInfo;
       NSValue *aValue = userInfo[UIKeyboardFrameEndUserInfoKey];
       CGRect keyboardRect = [aValue CGRectValue];
       keyboarHeight = keyboardRect.size.height;
    }
}

#pragma mark - Private

- (UILabel *)_createSeperateLine
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor colorWithHexString:kBlackHex];
    return label;
}

- (NSArray *)_fetchUserList
{
    return [YCDataUtils yc_unarchNormalUser];
}

#pragma mark - 用户协议

- (void)_addAgreeContentToView:(UIView *)baseview
{
    // 条款
    // 条款的勾选按钮
    checkBoxBtn = [HelloUtils initBtnWithNormalImage:termBtn_check
                                    highlightedImage:nil
                                                 tag:kYCLoginCheckBoxBtnTag
                                            selector:@selector(_changeBoxImage)
                                              target:self];
    [baseview addSubview:checkBoxBtn];
    
    [checkBoxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.centerY.equalTo(@(0));
        make.width.equalTo(@(20));
        make.height.equalTo(@(20));
    }];
    
    
//    UIFont *txtFont = [UIFont fontWithName:kTxtFontName size:kTxtFontSize];
    UIFont *txtFont = [UIFont fontWithName:kTxtFontName size:10.0f];
    UITextView *labText = [[UITextView alloc] initWithFrame:CGRectZero];
    
    NSString *txtStr = @"阅读并同意《用户服务协议》";
    NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] initWithString:txtStr];
    // 默认属性
    [mStr addAttribute:NSFontAttributeName
                 value:txtFont
                 range:NSMakeRange(0, mStr.length)];
    [mStr addAttribute:NSForegroundColorAttributeName
                 value:[UIColor colorWithHexString:kBlackHex]
                 range:NSMakeRange(0, mStr.length)];
    
    NSString *filterStr = @"《用户服务协议》";
    NSRange range = [txtStr rangeOfString:filterStr];
    
    if (range.location != NSNotFound) {
        // 添加超链接
        [mStr addAttribute:NSLinkAttributeName
                     value:strGiveMeTheHandScheme_Agree
                     range:range];
        // 修改超链接颜色
        labText.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:kGreenHex]};
    }
    
    labText.attributedText = mStr;
    labText.backgroundColor = [UIColor clearColor];
    
    labText.editable = NO;
    labText.delegate = self;
    labText.scrollEnabled = NO;
    labText.selectable = YES;
    
    
//    CGSize lbSize = [HelloUtils calculateSizeOfString:labText.text withFont:txtFont];
    
    [baseview addSubview:labText];
    [labText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(checkBoxBtn.mas_right);
//        make.centerY.equalTo(@(0));
        make.bottom.equalTo(baseview.mas_bottom);
        make.right.equalTo(@(0));
//        make.height.equalTo(@(30));
    }];
}


#pragma mark - UITextView Delegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    if ([[URL scheme] isEqualToString:strGiveMeTheHand_Agree]) {
        [HelloUtils yc_showSomeSenceOnSafari:strAgreementUrl];
        return NO;
    }
    return YES;
}

- (void)_changeBoxImage
{
    checkboxStatus = !checkboxStatus;
    if (checkboxStatus) {
        [checkBoxBtn setImage:GetImage(termBtn_check) forState:0];
    } else {
        [checkBoxBtn setImage:GetImage(termBtn_uncheck) forState:0];
    }
}


#pragma mark - Dealloc

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
