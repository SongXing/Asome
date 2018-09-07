//
//  YCBindView.m
//  YCSDK
//
//  Created by sunn on 2018/7/11.
//

#import "YCBindView.h"
#import "HelloHeader.h"

#define kYCBindPhoneInputViewTag   212
#define kYCBindCodeInputViewTag    213
#define kYCBindNameInputViewTag    214
#define kYCBindPwdInputViewTag     215
#define kYCBindGetVertifyBtnTag    216
#define kYCBindComfirmBtnTag       217
#define kYCBindBackBtnTag          218
#define kYCBindForgetResetTipsLabelTag          219
#define kYCBindForgetCheckComfirmBtnTag         220
#define kYCBindForgetResetComfirmBtnTag         221
#define kYCBindWarningKeepPlayBtnTag            222
#define kYCBindWarningMobileBtnTag              223
#define kYCBindWarningContentTag                224
#define kYCBindWarningBackBtnTag                225
#define kYCBindRightUserListBtnTag              226
#define kYCBindUserListDelBtnTag                227
#define kYCBindUserListVeiwTag                  228
#define kYCBindEyeBtnTag                        229

#define kBindListCellIdentifier             @"bind_list_identifier"

@implementation YCBindView
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
    // for space
    UIView *ssView;
    
    UIButton *loginComfirmBtn;
    
    HelloTextField *nameTF;
    HelloTextField *pwdTF;
    HelloTextField *phoneInput;
    HelloTextField *codeInput;
    HelloTextField *realNameInput;
    HelloTextField *IDCardNumInput;
    
    BOOL pwdEntity;
    BOOL userListShow;
    UIButton *eyesBtn;
    UIButton *forgetPwdBtn;
    
    UIButton *userListBtn;
    
    UIView *userListView;
    UITableView *uList;
    
    YCBindMode m_mode;
    
    CGFloat onCalWidth;
    CGFloat onCalHeight;
    
    NSString *m_phoneNum;
    NSString *m_curAccount;
    
    YCUserModel *m_tmpUser;
    NSArray *listModelArr;
}


- (instancetype)initWithMode:(YCBindMode)mode
{
    self = [super init];
    if (self) {
        m_mode = mode;
        [self _propertyInit];
        [self _widgetInit];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_bindNoteLisetner:) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}

- (instancetype)initWithMode:(YCBindMode)mode data:(NSDictionary *)dict handler:(GuestCallback)handler
{
    self = [super init];
    if (self) {
        self.guestAgainCallback = handler;
        
        m_mode = mode;
        
        [self _propertyInit];
        
        // reset cur user
        m_tmpUser = [[YCUserModel alloc] initWithDict:dict];
        
        [self _widgetInit];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_bindNoteLisetner:) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}

- (void)_propertyInit
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
    //  157/228 =  0.68859
    //    CGFloat realWidthHeightRate = curHeight/curWidth;
    //    originBgWidthOfHeight = 228.0f/157; // 原图宽高比
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
    
    keyboarHeight = keyboardInitH;
    onCalWidth = rate * curWidth;
    onCalHeight = rate * curHeight;
    if (device_is_iPhoneX) {
        onCalHeight = rate * curHeight * rate;
        onCalWidth = onCalHeight / originBgWidthOfHeight ;
    }
    
    listModelArr = [[YCDataUtils ycd_unarchNormalUser] copy];
    m_tmpUser = listModelArr.count > 0 ? listModelArr[0] : nil;
}

- (void)_widgetInit
{
    self.userInteractionEnabled = YES;
    
    [self _bgViewInit];
    
    switch (m_mode) {
        case YCBind_WarningToBind:
        case YCBind_Default:
            [self _catchMyWidget];
            break;
        case YCBind_RealNameVertify:
            [self _realNameVertifyModeInit];
            break;
        case YCBind_GuestToMobileWarning:
            [self _guestBindMobileWarningInit];
            break;
        case YCBind_Forget_CheckAccount:
            [self _forgetCheckAccountModeInit];
            break;
        case YCBind_Forget_ResetPwd:
            [self _forgetResetPwdModeInit];
            break;
        default:
            break;
    }
    
}

#pragma mark - Bg init

- (void)_bgViewInit
{
    [self setFrame:CGRectMake(0, 0, winWidth, winHeight)];
    [self setBackgroundColor:[UIColor clearColor]];
    
    // bg
    CGFloat realWidth = rate*curWidth;
    CGFloat realHeight = rate*curHeight*0.8;
    switch (m_mode) {
        case YCBind_WarningToBind:
        case YCBind_Default:
            realHeight = realWidth*0.95;
            break;
            
        default:
            break;
    }
    mainBg = [[UIImageView alloc] init];
    mainBg.userInteractionEnabled = YES;
    [self addSubview:mainBg];
    [mainBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@(0));
        make.centerY.equalTo(@(0));
        make.width.equalTo(@(realWidth));
        make.height.equalTo(@(realHeight));
    }];
    
    mainBg.backgroundColor = [UIColor colorWithHexString:kBgGrayHex];
    mainBg.layer.borderWidth = 1;
    mainBg.layer.borderColor = [UIColor colorWithHexString:kGrayHex].CGColor;
    mainBg.layer.cornerRadius = 5.0f;
}

#pragma mark - Default Init

- (void)_catchMyWidget
{
    CGFloat onCalHeight = rate*curHeight*0.8;
    CGFloat mTopPadding = 0;
    CGFloat firstGap = 26.0f/curWidth * onCalHeight;
//    CGFloat secondGap = 8.0f/curWidth * onCalHeight;
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
    
    [self _bindModeWidgetsInitWithTopPadding:mTopPadding];
}

- (void)_bindModeWidgetsInitWithTopPadding:(CGFloat)mTopPadding
{
    CGFloat onCalHeight = rate*curHeight*0.8;
    CGFloat firstGap = 26.0f/curWidth * onCalHeight;
    CGFloat secondGap = 8.0f/curWidth * onCalHeight;
    CGFloat heightOfImage   = 100*rate*curWidth/228.0f/440.0f*98.0f;
    
    // back btn
    UIButton *backBtn = [HelloUtils ycu_initBtnWithNormalImage:backBtn_normal highlightedImage:backBtn_highlighted tag:kYCBindBackBtnTag selector:@selector(bindViewBtnAction:) target:self];
    [mainBg addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding/2));
        make.left.equalTo(@(leftPadding*rate*curWidth));
        make.width.equalTo(@(backBtnWidthAndHeight*rate*curWidth));
        make.height.equalTo(@(backBtnWidthAndHeight*rate*curWidth));
    }];
    
    // ----------------------------
    
    mTopPadding += firstGap + heightOfImage;
    CGFloat txtFieldWidth = loginBtnWidthOfBgWidth*rate*curWidth;
    CGFloat txtFieldHeight = textFieldHeightOfBgHeight*rate*curWidth;
    
    userListBtn = [HelloUtils ycu_rightViewWithImage:userListBtn_down tag:kYCBindRightUserListBtnTag selector:@selector(bindViewBtnAction:) target:self];
    [userListBtn setFrame:CGRectMake(-10, 0, userListBtn.frame.size.width, userListBtn.frame.size.height)];
    
    nameTF = [HelloUtils ycu_customTextfieldWidgetWithLeftView:nil rightView:userListBtn placeholder:@"请输入登录账号" delegate:self];
    [HelloUtils ycu_makeTextFieldPlaceHolderProperty:nameTF];
    nameTF.returnKeyType = UIReturnKeyNext;
    nameTF.tag = kYCLoginAccountLoginBtnTag;
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
    
    nameTF.text = m_tmpUser.account ? : @"";
    
    // ------------
    mTopPadding += secondGap + txtFieldHeight;
    
    eyesBtn = [HelloUtils ycu_rightViewWithImage:eyeBtn_off tag:kYCBindEyeBtnTag selector:@selector(bindViewBtnAction:) target:self];
    [eyesBtn setFrame:CGRectMake(0, 0, eyesBtn.frame.size.width, eyesBtn.frame.size.height)];
    
    pwdTF = [HelloUtils ycu_customTextfieldWidgetWithLeftView:nil rightView:nil placeholder:@"请输入密码" delegate:self];
    [HelloUtils ycu_makeTextFieldPlaceHolderProperty:pwdTF];
    pwdTF.returnKeyType = UIReturnKeyNext;
    pwdTF.tag = kYCBindPwdInputViewTag;
    pwdTF.secureTextEntry = pwdEntity;
    pwdTF.backgroundColor = [UIColor whiteColor];
    pwdTF.layer.cornerRadius = 5.0f;
    pwdTF.layer.borderWidth = 1.0f;
    pwdTF.layer.borderColor = [UIColor colorWithHexString:kGrayHex].CGColor;
    [mainBg addSubview:pwdTF];
    [pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding));
        make.centerX.equalTo(@(0));
        make.width.equalTo(@(txtFieldWidth));
        make.height.equalTo(@(txtFieldHeight));
    }];
    pwdTF.text = m_tmpUser.password ? : @"";
    // 如果是临时账号，则贴上密码并且不可见、不可编辑
    // 如果是正式账号，不可见、不可编辑
    if (pwdTF.text.length <= 0) {
        pwdTF.rightView = eyesBtn;
        pwdTF.endEditDistance = eyesBtn.frame.size.width - 25;
    } else {
        pwdTF.clearButtonMode = UITextFieldViewModeNever;
        pwdTF.enabled = NO;
    }
    
    mTopPadding += secondGap + txtFieldHeight;
    
    phoneInput = [HelloUtils ycu_customTextfieldWidgetWithLeftView:nil rightView:nil placeholder:@"请输入您的手机号码" delegate:self];
    [HelloUtils ycu_makeTextFieldPlaceHolderProperty:phoneInput];
    phoneInput.returnKeyType = UIReturnKeyNext;
    phoneInput.tag = kYCBindPhoneInputViewTag;
    phoneInput.backgroundColor = [UIColor whiteColor];
    phoneInput.layer.cornerRadius = 5.0f;
    phoneInput.layer.borderWidth = 1.0f;
    phoneInput.layer.borderColor = [UIColor colorWithHexString:kGrayHex].CGColor;
    [mainBg addSubview:phoneInput];
    [phoneInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding));
        make.centerX.equalTo(@(0));
        make.width.equalTo(@(txtFieldWidth));
        make.height.equalTo(@(txtFieldHeight));
    }];
    
    // ------------
    mTopPadding += secondGap + txtFieldHeight;
    
    // send vertify btn
    NSString *strFetchVertifyCode = @"获取验证码";
    NSInteger sendVertifyBtnTag = kYCBindGetVertifyBtnTag;
    UIButton *sendVertifyBtn = [HelloUtils ycu_initBtnWithType:UIButtonTypeCustom title:strFetchVertifyCode tag:sendVertifyBtnTag selector:@selector(bindViewBtnAction:) target:self];
    [sendVertifyBtn setTitle:strFetchVertifyCode forState:0];
    [sendVertifyBtn.layer setCornerRadius:0.0f];
    [sendVertifyBtn.layer setBorderWidth:0.0f];
    [sendVertifyBtn.layer setBorderColor:[UIColor colorWithHexString:kGrayHex].CGColor];
    [sendVertifyBtn setTitleColor:[UIColor colorWithHexString:kBlackHex] forState:0];
    CGSize sendVertifyCodeBtnSize = [HelloUtils ycu_calculateSizeOfLabel:sendVertifyBtn.titleLabel andWidth:1000];
    [sendVertifyBtn setFrame:CGRectMake(0, 0, sendVertifyCodeBtnSize.width, textFieldHeightOfBgHeight*rate*curWidth
                                        )];
    // input
    codeInput = [HelloUtils ycu_customTextfieldWidgetWithLeftView:nil rightView:sendVertifyBtn placeholder:@"请输入验证码" delegate:self];
    codeInput.endEditDistance = sendVertifyCodeBtnSize.width - 25 + 10.0f;
    codeInput.rightViewDistance = 10.0f;
    [HelloUtils ycu_makeTextFieldPlaceHolderProperty:codeInput];
    codeInput.tag = kYCBindCodeInputViewTag;
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
    mTopPadding += secondGap + txtFieldHeight;
    
    // login btn
    loginComfirmBtn = [HelloUtils yc_initBtnWithTitle:@"确定" tag:kYCBindComfirmBtnTag selector:@selector(bindViewBtnAction:) target:self];
    [mainBg addSubview:loginComfirmBtn];
    [loginComfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding));
        make.left.equalTo(@(anotherLeftPadding*rate*curWidth));
        make.width.equalTo(@(txtFieldWidth));
        make.height.equalTo(@(txtFieldHeight));
    }];
    loginComfirmBtn.layer.cornerRadius = 5.0f;
    loginComfirmBtn.backgroundColor = [UIColor colorWithHexString:kGreenHex];
    loginComfirmBtn.titleLabel.textColor = [UIColor colorWithHexString:kWhiteHex];
    loginComfirmBtn.layer.borderWidth = 1.0f;
    loginComfirmBtn.layer.borderColor = [UIColor colorWithHexString:kGrayHex].CGColor;
    [loginComfirmBtn.titleLabel setFont:[UIFont fontWithName:kTxtFontName size:kTxtFontBigSize]];
}

#pragma mark - Vertify Mode

- (void)_realNameVertifyModeInit
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
    UIButton *backBtn = [HelloUtils ycu_initBtnWithNormalImage:backBtn_normal highlightedImage:backBtn_highlighted tag:kYCBindBackBtnTag selector:@selector(bindViewBtnAction:) target:self];
    [mainBg addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding/2));
        make.left.equalTo(@(leftPadding*rate*curWidth));
        make.width.equalTo(@(backBtnWidthAndHeight*rate*curWidth));
        make.height.equalTo(@(backBtnWidthAndHeight*rate*curWidth));
    }];
    
    // ----------------------------
    
    mTopPadding += firstGap + heightOfImage;
    CGFloat txtFieldWidth = loginBtnWidthOfBgWidth*rate*curWidth;
    CGFloat txtFieldHeight = textFieldHeightOfBgHeight*rate*curWidth;
    
    realNameInput = [HelloUtils ycu_customTextfieldWidgetWithLeftView:nil rightView:nil placeholder:@"请输入真实名字" delegate:self];
    [HelloUtils ycu_makeTextFieldPlaceHolderProperty:realNameInput];
    realNameInput.returnKeyType = UIReturnKeyNext;
    realNameInput.backgroundColor = [UIColor whiteColor];
    realNameInput.layer.cornerRadius = 5.0f;
    realNameInput.layer.borderWidth = 1.0f;
    realNameInput.layer.borderColor = [UIColor colorWithHexString:kGrayHex].CGColor;
    [mainBg addSubview:realNameInput];
    [realNameInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding));
        make.centerX.equalTo(@(0));
        make.width.equalTo(@(txtFieldWidth));
        make.height.equalTo(@(txtFieldHeight));
    }];
    
    // ------------
    mTopPadding += secondGap + txtFieldHeight;
    
    
    IDCardNumInput = [HelloUtils ycu_customTextfieldWidgetWithLeftView:nil rightView:nil placeholder:nil delegate:self];
    IDCardNumInput.placeholder = @"请输入身份证号码";
    [HelloUtils ycu_makeTextFieldPlaceHolderProperty:IDCardNumInput];
    IDCardNumInput.returnKeyType = UIReturnKeyDone;
    IDCardNumInput.backgroundColor = [UIColor whiteColor];
    IDCardNumInput.layer.cornerRadius = 5.0f;
    IDCardNumInput.layer.borderWidth = 1.0f;
    IDCardNumInput.layer.borderColor = [UIColor colorWithHexString:kGrayHex].CGColor;
    [mainBg addSubview:IDCardNumInput];
    [IDCardNumInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding));
        make.centerX.equalTo(@(0));
        make.width.equalTo(@(txtFieldWidth));
        make.height.equalTo(@(txtFieldHeight));
    }];
    
    mTopPadding += secondGap + txtFieldHeight;
    
    // login btn
    loginComfirmBtn = [HelloUtils yc_initBtnWithTitle:@"确定" tag:kYCBindComfirmBtnTag selector:@selector(bindViewBtnAction:) target:self];
    [mainBg addSubview:loginComfirmBtn];
    [loginComfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding));
        make.left.equalTo(@(anotherLeftPadding*rate*curWidth));
        make.width.equalTo(@(txtFieldWidth));
        make.height.equalTo(@(txtFieldHeight));
    }];
    loginComfirmBtn.layer.cornerRadius = 5.0f;
    loginComfirmBtn.backgroundColor = [UIColor colorWithHexString:kGreenHex];
    loginComfirmBtn.titleLabel.textColor = [UIColor colorWithHexString:kWhiteHex];
    loginComfirmBtn.layer.borderWidth = 1.0f;
    loginComfirmBtn.layer.borderColor = [UIColor colorWithHexString:kGrayHex].CGColor;
    [loginComfirmBtn.titleLabel setFont:[UIFont fontWithName:kTxtFontName size:kTxtFontBigSize]];
}

#pragma mark - Mobile Bind Warning

- (void)_guestBindMobileWarningInit
{
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
    
    // back btn
    UIButton *backBtn = [HelloUtils ycu_initBtnWithNormalImage:backBtn_normal highlightedImage:backBtn_highlighted tag:kYCBindWarningBackBtnTag selector:@selector(bindViewBtnAction:) target:self];
    [mainBg addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding/2));
        make.left.equalTo(@(leftPadding*rate*curWidth));
        make.width.equalTo(@(backBtnWidthAndHeight*rate*curWidth));
        make.height.equalTo(@(backBtnWidthAndHeight*rate*curWidth));
    }];
    
    mTopPadding += firstGap + heightOfImage;
    
    UILabel *contentLB = [[UILabel alloc] initWithFrame:CGRectZero];
    NSString *oriStr = @"亲爱的玩家,游客模式下无法有效的保证游戏数据的安全,为保障您的虚拟财产安全,强烈建议您:绑定手机";
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:oriStr];
    [attStr addAttribute:NSFontAttributeName
                   value:[UIFont fontWithName:kTxtFontName size:kTxtFontBigSize]
                   range:NSMakeRange(0, oriStr.length)];
//    [attStr addAttribute:NSForegroundColorAttributeName
//                   value:[UIColor colorWithHexString:kGreenHex]
//                   range:NSMakeRange(oriStr.length-4, 4)];
    contentLB.attributedText = attStr;
    contentLB.numberOfLines = 0;
    contentLB.tag = kYCBindWarningContentTag;
    [mainBg addSubview:contentLB];
    CGSize txtSize = [HelloUtils ycu_calculateSizeOfLabel:contentLB andWidth:txtFieldWidth];
    [contentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding));
        make.centerX.equalTo(@(0));
        make.width.equalTo(@(txtSize.width));
        make.height.equalTo(@(txtSize.height));
    }];
    
    // ------
    mTopPadding += secondGap*2 + txtSize.height;
    
    // login btn
    loginComfirmBtn = [HelloUtils yc_initBtnWithTitle:@"绑定手机" tag:kYCBindWarningMobileBtnTag selector:@selector(bindViewBtnAction:) target:self];
    [mainBg addSubview:loginComfirmBtn];
    [loginComfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding));
        make.left.equalTo(@(anotherLeftPadding*rate*curWidth));
        make.width.equalTo(@(txtFieldWidth));
        make.height.equalTo(@(txtFieldHeight));
    }];
    loginComfirmBtn.layer.cornerRadius = 5.0f;
    loginComfirmBtn.backgroundColor = [UIColor colorWithHexString:kGreenHex];
    loginComfirmBtn.titleLabel.textColor = [UIColor colorWithHexString:kWhiteHex];
    loginComfirmBtn.layer.borderWidth = 1.0f;
    loginComfirmBtn.layer.borderColor = [UIColor colorWithHexString:kGrayHex].CGColor;
    [loginComfirmBtn.titleLabel setFont:[UIFont fontWithName:kTxtFontName size:kTxtFontBigSize]];
    
    // ---
    UIButton *keepplayingBtn = [HelloUtils ycu_initBtnWithTitle:@"不，我要试玩" tag:kYCBindWarningKeepPlayBtnTag selector:@selector(bindViewBtnAction:) target:self];
    [keepplayingBtn.layer setBorderWidth:0.0f];
    [keepplayingBtn.layer setBorderColor:[UIColor clearColor].CGColor];
    [keepplayingBtn.layer setCornerRadius:0.0f];
    [keepplayingBtn setTitleColor:[UIColor colorWithHexString:kGreenHex] forState:0];
    [keepplayingBtn.titleLabel setFont:[UIFont fontWithName:kTxtFontName size:kTxtFontSize]];
    [mainBg addSubview:keepplayingBtn];
    CGSize keepplayingBtnSize = [HelloUtils ycu_calculateSizeOfLabel:keepplayingBtn.titleLabel andWidth:1000];
    [keepplayingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-textFieldHeightOfBgHeight/3*rate*curWidth));
        make.right.equalTo(loginComfirmBtn.mas_right);
        make.width.equalTo(@(keepplayingBtnSize.width));
        make.height.equalTo(@(keepplayingBtnSize.height));
    }];
    
}


#pragma mark - Forget Input Mobile Number

- (void)_forgetCheckAccountModeInit
{
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
    
    // back btn
    UIButton *backBtn = [HelloUtils ycu_initBtnWithNormalImage:backBtn_normal highlightedImage:backBtn_highlighted tag:kYCBindBackBtnTag selector:@selector(bindViewBtnAction:) target:self];
    [mainBg addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding/2));
        make.left.equalTo(@(leftPadding*rate*curWidth));
        make.width.equalTo(@(backBtnWidthAndHeight*rate*curWidth));
        make.height.equalTo(@(backBtnWidthAndHeight*rate*curWidth));
    }];
    
    mTopPadding += firstGap + heightOfImage;
    
    nameTF = [HelloUtils ycu_customTextfieldWidgetWithLeftView:nil rightView:nil placeholder:nil delegate:self];
    nameTF.tag = kYCBindNameInputViewTag;
    nameTF.placeholder = @"请输入登录账号或手机号";
    [HelloUtils ycu_makeTextFieldPlaceHolderProperty:nameTF];
    nameTF.returnKeyType = UIReturnKeyDone;
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
    
    // ------
    mTopPadding += secondGap*2 + txtFieldHeight;
    
    // login btn
    loginComfirmBtn = [HelloUtils yc_initBtnWithTitle:@"确定" tag:kYCBindForgetCheckComfirmBtnTag selector:@selector(bindViewBtnAction:) target:self];
    [mainBg addSubview:loginComfirmBtn];
    [loginComfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding));
        make.left.equalTo(@(anotherLeftPadding*rate*curWidth));
        make.width.equalTo(@(txtFieldWidth));
        make.height.equalTo(@(txtFieldHeight));
    }];
    loginComfirmBtn.layer.cornerRadius = 5.0f;
    loginComfirmBtn.backgroundColor = [UIColor colorWithHexString:kGreenHex];
    loginComfirmBtn.titleLabel.textColor = [UIColor colorWithHexString:kWhiteHex];
    loginComfirmBtn.layer.borderWidth = 1.0f;
    loginComfirmBtn.layer.borderColor = [UIColor colorWithHexString:kGrayHex].CGColor;
    [loginComfirmBtn.titleLabel setFont:[UIFont fontWithName:kTxtFontName size:kTxtFontBigSize]];
    
    // 帮助中心按钮
    UIButton *helpCenterBtn = [HelloUtils ycu_initBtnWithTitle:@"帮助中心" tag:kYCLoginHelpCenterBtnTag selector:@selector(bindViewBtnAction:) target:self];
    [helpCenterBtn.layer setBorderWidth:0.0f];
    [helpCenterBtn.layer setBorderColor:[UIColor clearColor].CGColor];
    [helpCenterBtn.layer setCornerRadius:0.0f];
    [helpCenterBtn setTitleColor:[UIColor colorWithHexString:kGreenHex] forState:0];
    [helpCenterBtn.titleLabel setFont:[UIFont fontWithName:kTxtFontName size:kTxtFontSize]];
    [mainBg addSubview:helpCenterBtn];
    CGSize txtSize = [HelloUtils ycu_calculateSizeOfLabel:helpCenterBtn.titleLabel];
    [helpCenterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-textFieldHeightOfBgHeight/2*rate*curWidth));
        make.centerX.equalTo(@(0));
        make.width.equalTo(@(txtSize.width));
        make.height.equalTo(@(txtSize.height));
    }];
}

#pragma mark - Forget Reset Pwd Mode


- (void)_changeToForgetResetPwdMode
{
    m_mode = YCBind_Forget_ResetPwd;    
    [self _makeCheckViewInVisible];
 
    if ([self viewWithTag:kYCBindForgetResetTipsLabelTag]) {
        
        [self _openResetViewWidget];
        
        return;
    }
    
    CGFloat onCalHeight = rate*curHeight*0.8;
    CGFloat mTopPadding = 0;
    CGFloat firstGap = 26.0f/curWidth * onCalHeight;
//    CGFloat secondGap = 8.0f/curWidth * onCalHeight;
    mTopPadding += firstGap;
    
    [self _makeForgetResetPwdWidgetWithTopPadding:mTopPadding];
}

- (void)_makeForgetResetPwdWidgetWithTopPadding:(CGFloat)mTopPadding
{
    CGFloat txtFieldWidth = loginBtnWidthOfBgWidth*rate*curWidth;
    CGFloat txtFieldHeight = textFieldHeightOfBgHeight*rate*curWidth;
    
    CGFloat onCalHeight = rate*curHeight*0.8;

    CGFloat firstGap = 26.0f/curWidth * onCalHeight;
    CGFloat secondGap = 8.0f/curWidth * onCalHeight;

   
    //    // 440x98
    CGFloat heightOfImage   = 100*rate*curWidth/228.0f/440.0f*98.0f;
    
    mTopPadding += firstGap + heightOfImage;
    
    UILabel *contentLB = [[UILabel alloc] initWithFrame:CGRectZero];
    contentLB.tag = kYCBindForgetResetTipsLabelTag;
    NSString *oriStr = [NSString stringWithFormat:@"您的密保手机是 %@ ,请查收",m_phoneNum];//@"您的密保手机是181****7527,请查收";
    contentLB.text = oriStr;
    contentLB.textAlignment = NSTextAlignmentLeft;
    [contentLB setFont:[UIFont fontWithName:kTxtFontName size:10.0f]];
    [mainBg addSubview:contentLB];
    CGSize txtSize = [HelloUtils ycu_calculateSizeOfLabel:contentLB andWidth:txtFieldWidth];
    [contentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding));
        make.centerX.equalTo(@(0));
        //        make.width.equalTo(@(txtSize.width));
        make.width.equalTo(@(txtFieldWidth));
        make.height.equalTo(@(txtSize.height));
    }];
    
    // ------
    mTopPadding += secondGap + txtSize.height;
    
    pwdTF = [HelloUtils ycu_customTextfieldWidgetWithLeftView:nil rightView:nil placeholder:nil delegate:self];
    pwdTF.placeholder = @"请输入新密码";
    [HelloUtils ycu_makeTextFieldPlaceHolderProperty:pwdTF];
    pwdTF.returnKeyType = UIReturnKeyNext;
    pwdTF.tag = kYCBindPwdInputViewTag;
    pwdTF.secureTextEntry = pwdEntity;
    pwdTF.backgroundColor = [UIColor whiteColor];
    pwdTF.layer.cornerRadius = 5.0f;
    pwdTF.layer.borderWidth = 1.0f;
    pwdTF.layer.borderColor = [UIColor colorWithHexString:kGrayHex].CGColor;
    [mainBg addSubview:pwdTF];
    [pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding));
        make.centerX.equalTo(@(0));
        make.width.equalTo(@(txtFieldWidth));
        make.height.equalTo(@(txtFieldHeight));
    }];
    
    mTopPadding += secondGap + txtFieldHeight;
    
    // send vertify btn
    NSString *strFetchVertifyCode = @"获取验证码";
    NSInteger sendVertifyBtnTag = kYCBindGetVertifyBtnTag;
    UIButton *sendVertifyBtn = [HelloUtils ycu_initBtnWithType:UIButtonTypeCustom title:strFetchVertifyCode tag:sendVertifyBtnTag selector:@selector(bindViewBtnAction:) target:self];
    [sendVertifyBtn setTitle:strFetchVertifyCode forState:0];
    [sendVertifyBtn.layer setCornerRadius:0.0f];
    [sendVertifyBtn.layer setBorderWidth:0.0f];
    [sendVertifyBtn.layer setBorderColor:[UIColor colorWithHexString:kGrayHex].CGColor];
    [sendVertifyBtn setTitleColor:[UIColor colorWithHexString:kBlackHex] forState:0];
    [sendVertifyBtn.titleLabel setFont:[UIFont fontWithName:kTxtFontName size:kTxtFontSize]];
    CGSize sendVertifyCodeBtnSize = [HelloUtils ycu_calculateSizeOfLabel:sendVertifyBtn.titleLabel andWidth:1000];
    [sendVertifyBtn setFrame:CGRectMake(0, 0, sendVertifyCodeBtnSize.width, textFieldHeightOfBgHeight*rate*curWidth
                                        )];
    
    // input
    codeInput = [HelloUtils ycu_customTextfieldWidgetWithLeftView:nil rightView:sendVertifyBtn placeholder:@"请输入验证码" delegate:self];
    codeInput.endEditDistance = sendVertifyCodeBtnSize.width - 25 + 10.0f;
    codeInput.rightViewDistance = 10.0f;
    [HelloUtils ycu_makeTextFieldPlaceHolderProperty:codeInput];
    codeInput.tag = kYCBindCodeInputViewTag;
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
    
    //------
    mTopPadding += secondGap*2 + txtFieldHeight;
 
    // login btn
    UIButton * resetComfirmBtn = [HelloUtils yc_initBtnWithTitle:@"确定" tag:kYCBindForgetResetComfirmBtnTag selector:@selector(bindViewBtnAction:) target:self];
    [mainBg addSubview:resetComfirmBtn];
    [resetComfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding));
        make.left.equalTo(@(anotherLeftPadding*rate*curWidth));
        make.width.equalTo(@(txtFieldWidth));
        make.height.equalTo(@(txtFieldHeight));
    }];
    resetComfirmBtn.layer.cornerRadius = 5.0f;
    resetComfirmBtn.backgroundColor = [UIColor colorWithHexString:kGreenHex];
    resetComfirmBtn.titleLabel.textColor = [UIColor colorWithHexString:kWhiteHex];
    resetComfirmBtn.layer.borderWidth = 1.0f;
    resetComfirmBtn.layer.borderColor = [UIColor colorWithHexString:kGrayHex].CGColor;
    [resetComfirmBtn.titleLabel setFont:[UIFont fontWithName:kTxtFontName size:kTxtFontBigSize]];
}

- (void)_forgetResetPwdModeInit
{
    
    CGFloat onCalHeight = rate*curHeight*0.8;
    CGFloat mTopPadding = 0;
    CGFloat firstGap = 26.0f/curWidth * onCalHeight;
//    CGFloat secondGap = 8.0f/curWidth * onCalHeight;
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
    UIButton *backBtn = [HelloUtils ycu_initBtnWithNormalImage:backBtn_normal highlightedImage:backBtn_highlighted tag:kYCBindBackBtnTag selector:@selector(bindViewBtnAction:) target:self];
    [mainBg addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding/2));
        make.left.equalTo(@(leftPadding*rate*curWidth));
        make.width.equalTo(@(backBtnWidthAndHeight*rate*curWidth));
        make.height.equalTo(@(backBtnWidthAndHeight*rate*curWidth));
    }];
    
    
    [self _makeForgetResetPwdWidgetWithTopPadding:mTopPadding];
}

#pragma mark - CheckViewVisible

- (void)_makeCheckViewInVisible
{
    [[self viewWithTag:kYCBindNameInputViewTag] setHidden:YES];
    [[self viewWithTag:kYCLoginHelpCenterBtnTag] setHidden:YES];
    [[self viewWithTag:kYCBindForgetCheckComfirmBtnTag] setHidden:YES];
}

- (void)_makeResetViewInVisible
{
    [[self viewWithTag:kYCBindForgetResetTipsLabelTag] setHidden:YES];
    [[self viewWithTag:kYCBindPwdInputViewTag] setHidden:YES];
    [[self viewWithTag:kYCBindCodeInputViewTag] setHidden:YES];
    [[self viewWithTag:kYCBindForgetResetComfirmBtnTag] setHidden:YES];
}

- (void)_openCheckViewWidget
{
    m_mode = YCBind_Forget_CheckAccount;
    
    [self _makeResetViewInVisible];
    
    [[self viewWithTag:kYCBindNameInputViewTag] setHidden:NO];
    [[self viewWithTag:kYCLoginHelpCenterBtnTag] setHidden:NO];
    [[self viewWithTag:kYCBindForgetCheckComfirmBtnTag] setHidden:NO];
}

- (void)_openResetViewWidget
{
    m_mode = YCBind_Forget_ResetPwd;
    
    [self _makeCheckViewInVisible];
    
    [[self viewWithTag:kYCBindForgetResetTipsLabelTag] setHidden:NO];
    [[self viewWithTag:kYCBindPwdInputViewTag] setHidden:NO];
    [[self viewWithTag:kYCBindCodeInputViewTag] setHidden:NO];
    [[self viewWithTag:kYCBindForgetResetComfirmBtnTag] setHidden:NO];
}

#pragma mark - Warning Visible

- (void)_makeWarningInVisible
{
    [[self viewWithTag:kYCBindWarningContentTag] setHidden:YES];
    [[self viewWithTag:kYCBindWarningMobileBtnTag] setHidden:YES];
    [[self viewWithTag:kYCBindWarningKeepPlayBtnTag] setHidden:YES];
}

- (void)_makeWarningVisible
{
    [[self viewWithTag:kYCBindWarningContentTag] setHidden:NO];
    [[self viewWithTag:kYCBindWarningMobileBtnTag] setHidden:NO];
    [[self viewWithTag:kYCBindWarningKeepPlayBtnTag] setHidden:NO];
}

- (void)_makeBindModeInVisible
{
    [[self viewWithTag:kYCBindBackBtnTag] setHidden:YES];
    [[self viewWithTag:kYCLoginAccountLoginBtnTag] setHidden:YES];
    [[self viewWithTag:kYCBindPwdInputViewTag] setHidden:YES];
    [[self viewWithTag:kYCBindPhoneInputViewTag] setHidden:YES];
    [[self viewWithTag:kYCBindCodeInputViewTag] setHidden:YES];
    [[self viewWithTag:kYCBindComfirmBtnTag] setHidden:YES];
}

- (void)_makeBindModeVisible
{
    [[self viewWithTag:kYCBindBackBtnTag] setHidden:NO];
    [[self viewWithTag:kYCLoginAccountLoginBtnTag] setHidden:NO];
    [[self viewWithTag:kYCBindPwdInputViewTag] setHidden:NO];
    [[self viewWithTag:kYCBindPhoneInputViewTag] setHidden:NO];
    [[self viewWithTag:kYCBindCodeInputViewTag] setHidden:NO];
    [[self viewWithTag:kYCBindComfirmBtnTag] setHidden:NO];
}

- (void)_makeBindWidget
{
    m_mode = YCBind_WarningToBind;
    // make bg rect large
    [self _largeMainBgSize];
    
    if ([self viewWithTag:kYCBindPhoneInputViewTag]) {
        
        [self _makeBindModeVisible];
        return;
    }
    
    CGFloat onCalHeight = rate*curHeight*0.8;
    CGFloat mTopPadding = 0;
    CGFloat firstGap = 26.0f/curWidth * onCalHeight;
//    CGFloat secondGap = 8.0f/curWidth * onCalHeight;
    mTopPadding += firstGap;
    
    [self _bindModeWidgetsInitWithTopPadding:mTopPadding];
}

- (void)_largeMainBgSize
{
    CGFloat realWidth = rate*curWidth;
    CGFloat realHeight = realWidth*0.95;
    CGRect viewFrame = CGRectMake(mainBg.frame.origin.x, mainBg.frame.origin.y, realWidth, realHeight);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:tRotaTomeInterval];
    [mainBg setFrame:viewFrame];
    [UIView commitAnimations];
    mainBg.center = self.center;
}

- (void)_zoomMainBgSize
{
    CGFloat realWidth = rate*curWidth;
    CGFloat realHeight = rate*curHeight*0.8;
    [UIView animateWithDuration:tRotaTomeInterval
                     animations:^{
                         [mainBg setFrame:CGRectMake(0, 0, realWidth, realHeight)];
                         mainBg.center = self.center;
                     }];
}




#pragma mark - Button Action

- (void)bindViewBtnAction:(UIButton *)sender
{
    switch (sender.tag) {
        case kYCBindWarningBackBtnTag:
        {
            [UIView animateWithDuration:tRotaTomeInterval
                             animations:^{
                                 UIView *supBg = [self.superview viewWithTag:kYCLoginMainBgViewTag];
                                 supBg.alpha = 1.0f;
                                 [self removeFromSuperview];
                             }];
        }
            break;
        case kYCBindBackBtnTag:
        {
            [self _textFieldResignFirstResponer];
            switch (m_mode) {
                case YCBind_Forget_ResetPwd:
                {
                    [self _openCheckViewWidget];
                }
                    break;
                case YCBind_WarningToBind:
                {
                    [self _makeBindModeInVisible];
                    [self _makeWarningVisible];
                    [self _zoomMainBgSize];
                }
                    break;

                default:
                {
                    [UIView animateWithDuration:tRotaTomeInterval
                                     animations:^{
                                         UIView *supBg = [self.superview viewWithTag:kYCLoginMainBgViewTag];
                                         supBg.alpha = 1.0f;
                                         [self removeFromSuperview];
                                     }];
                }
                    break;
            }
            
        }
            break;
        case kYCBindGetVertifyBtnTag:
        {
            
            NSString *mobilePhoneNum = [HelloUtils ycu_triString:phoneInput.text];
            if (![HelloUtils validCnMobileNumber:mobilePhoneNum]) {
                [HelloUtils ycu_invalidPhoneToast];
                return;
            }
            NSString *codeSendType = @"";
            switch (m_mode) {
                case YCBind_Forget_ResetPwd:
                    codeSendType = kSendCodeType_Find;
                    break;
                default:
                    codeSendType = kSendCodeType_Bind;
                    break;
            }
            
            [NetEngine sendVertifyCodeToMobile:mobilePhoneNum
                                     situation:codeSendType
                                    completion:^(id reslut){
                                        if ([reslut isKindOfClass:[NSDictionary class]]) {
                                            [HelloUtils ycu_counttingButton:sender
                                                              startTime:59.0f
                                                                  title:@""
                                                         countDownTitle:@"s"
                                                              mainColor:[UIColor whiteColor]
                                                             countColor:[UIColor lightGrayColor]];
                                        }
                                    }];
        }
            break;
        case kYCBindComfirmBtnTag:
        {            
            switch (m_mode) {
                case YCBind_WarningToBind:
                case YCBind_Default:
                {
                    NSString *name      = [HelloUtils ycu_triString:nameTF.text];
                    NSString *pwd       = [HelloUtils ycu_triString:pwdTF.text];
                    NSString *mobile    = [HelloUtils ycu_triString:phoneInput.text];
                    NSString *code      = [HelloUtils ycu_triString:codeInput.text];
                    if (![HelloUtils validUserName:name]) {
                        [HelloUtils ycu_invalidNameToast];
                        return;
                    }
//                    if (![HelloUtils validPassWord:pwd]) {
                    if (pwd.length <= 0) {
                        [HelloUtils ycu_invalidPwdToast];return;
                    }
                    if (![HelloUtils validCnMobileNumber:mobile]) {
                        [HelloUtils ycu_invalidPhoneToast];return;
                    }
                    if (code.length <= 0) {
                        [HelloUtils ycu_invalidVertifyCodeToast];
                    }
                    [NetEngine allAccountBindMobilePhone:mobile
                                                password:pwd
                                                 account:name
                                             vertifyCode:code
                                              completion:^(id result){
                                                  
                                                  if ([result isKindOfClass:[NSDictionary class]]) {
                                                      
                                                      [self.superview removeFromSuperview];
                                                      // 绑定成功后算登录成功，记住账号发送登录成功通知
                                                      [YCDataUtils ycd_handelNormalUser:(NSDictionary *)result];
                                                      [HelloUtils ycu_postNoteWithName:NOTE_YC_LOGIN_SUCCESS userInfo:(NSDictionary *)result];
                                                  }
                                              }];
                }
                    break;
                case YCBind_RealNameVertify:
                {
                    
                    
                }
                    break;
                
                    
                default:
                    break;
            }
            
        }
            break;
        case kYCBindForgetCheckComfirmBtnTag:
        {
            switch (m_mode) {
                case YCBind_Forget_CheckAccount:
                {
                    NSString *name = [HelloUtils ycu_triString:nameTF.text];// 或账号，或手机号
                    if (![HelloUtils validUserName:name]) {
                        [HelloUtils ycu_invalidNameToast];
                        return;
                    }
                    [NetEngine checkMobileBindStatusWithNun:name
                                                 completion:^(id result){
                                                     if ([result isKindOfClass:[NSDictionary class]]) {
                                                         NSString *phoneNum = result[kRespStrData][kRespStrMobilephone];
                                                         NSString *account = result[kRespStrData][kRespStrUsername];
                                                         m_phoneNum = phoneNum.copy;
                                                         m_curAccount = account.copy;
                                                         [self _changeToForgetResetPwdMode];
                                                     }
                                                 }];
                }
                    break;
                case YCBind_Forget_ResetPwd:
                {
                    NSString *newPwd = [HelloUtils ycu_triString:pwdTF.text];
                    NSString *code   = [HelloUtils ycu_triString:codeInput.text];
//                    if (![HelloUtils validPassWord:newPwd]) {
                    if (newPwd.length <= 0) {
                        [HelloUtils ycu_invalidPwdToast];
                        return;
                    }
//                    if (![HelloUtils validUserName:code]) {
                    if (code.length <= 0) {
                        [HelloUtils ycu_invalidVertifyCodeToast];
                        return;
                    }
                    NSString *name      = m_curAccount;
                    NSString *mobile    = m_phoneNum;
                    [NetEngine resetPasswordWithAccount:name
                                                 mobile:mobile
                                                   code:code
                                                 newPwd:newPwd
                                             completion:^(id result){
                                                 
                                                 [self.superview removeFromSuperview];
                                                 
                                                 YCLoginView *view = [[YCLoginView alloc] initWithMode:YCLogin_Account];
                                                 [MainWindow addSubview:view];
                                             }];
                }
                    break;
                default:
                    break;
            }
            
        }
            break;
        case kYCBindForgetResetComfirmBtnTag:
        {
            NSString *newPwd = [HelloUtils ycu_triString:pwdTF.text];
            NSString *code   = [HelloUtils ycu_triString:codeInput.text];
//            if (![HelloUtils validPassWord:newPwd]) {
            if (newPwd.length <= 0) {
                [HelloUtils ycu_invalidPwdToast];
                return;
            }
//            if (![HelloUtils validUserName:code]) {
            if (code.length <= 0) {
                [HelloUtils ycu_invalidVertifyCodeToast];
                return;
            }
            NSString *name      = m_curAccount;
            NSString *mobile    = m_phoneNum;
            [NetEngine resetPasswordWithAccount:name
                                         mobile:mobile
                                           code:code
                                         newPwd:newPwd
                                     completion:^(id result){
                                         
                                         if ([result isKindOfClass:[NSDictionary class]]) {
                                             [self.superview removeFromSuperview];
                                             
                                             YCLoginView *view = [[YCLoginView alloc] initWithMode:YCLogin_Account];
                                             [MainWindow addSubview:view];
                                         }
                                     }];
        }
            break;
        case kYCLoginHelpCenterBtnTag:
        {
            [HelloUtils ycu_showSomeSenceOnSafari:strHelpCenterUrl];
        }
            break;
        case kYCBindWarningMobileBtnTag:
        {
            [self _makeWarningInVisible];
            [self _makeBindWidget];
        }
            break;
        case kYCBindWarningKeepPlayBtnTag:
        {
            // 回调，以便减少请求并发送通知回调给CP
            if (self.guestAgainCallback) {
                self.guestAgainCallback();
                [self removeFromSuperview];
            }
        }
            break;
        case kYCBindRightUserListBtnTag:
        {
            if ([listModelArr count] < 1) {
                [HelloUtils ycu_sToastWithMsg:@"没有已保存的账号"];
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
        case kYCBindUserListDelBtnTag:
        {
            UITableViewCell *cell = (UITableViewCell *)[sender superview];
            NSIndexPath *indexPath = [uList indexPathForCell:cell];
            [self _removeUserWithIndex:indexPath.row];
        }
            break;
        case kYCBindEyeBtnTag:
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
        default:
            break;
    }
}

#pragma mark - Account List Action

- (void)_userListViewShow
{
    [self _userListBtnRotaToShow];
    
    userListView = [[UIView alloc] initWithFrame:CGRectZero];
    userListView.backgroundColor = [UIColor whiteColor];
    userListView.tag = kYCBindUserListVeiwTag;
    [userListView setFrame:CGRectMake(0, 0, winWidth, winHeight)];
    userListView.backgroundColor = [UIColor clearColor];
    
    // 改用蒙版，添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cn_tapAction:)];
    tap.delegate = self;
    [userListView addGestureRecognizer:tap];
    
    UIWindow * window = [UIApplication sharedApplication].windows[0];
    [window addSubview:userListView];
    
//    CGFloat realWidth = rate*curWidth;
//    CGFloat realHeight = realWidth*0.95;
//    CGFloat topPadding = nameTF.frame.origin.y + txtFieldHeight + realWidth*0.15f/2;
    
    CGFloat onCalHeight = rate*curHeight*0.8;
    CGFloat secondGap = 5.0f/curWidth * onCalHeight;
    CGFloat txtFieldHeight = textFieldHeightOfBgHeight*rate*curWidth;
    CGFloat topPadding = nameTF.frame.origin.y + txtFieldHeight*2 - secondGap;

    
    // add table view
    uList = [[UITableView alloc] initWithFrame:CGRectZero];
    uList.layer.borderWidth = 1.0f;
    uList.layer.borderColor = [UIColor colorWithHexString:kGrayHex].CGColor;
    [userListView addSubview:uList];
    [uList mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (m_mode == YCBind_WarningToBind) {
            make.top.equalTo(@(topPadding));
        } else {
            make.top.equalTo(nameTF.mas_bottom);//TODO 在guest登录后的绑定页面中，位置不正确
        }
        make.centerX.equalTo(@(0));
        make.width.equalTo(@(loginBtnWidthOfBgWidth*rate*curWidth));
        make.height.equalTo(@(100));
    }];
    // datasource,delegate
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
    static NSString *identifier = kBindListCellIdentifier;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] ;
        
        UIButton *delBtn = [HelloUtils ycu_initBtnWithNormalImage:user_list_close_btn_name highlightedImage:nil tag:kYCBindUserListDelBtnTag selector:@selector(bindViewBtnAction:) target:self];
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
    
    m_tmpUser = listModelArr[indexPath.row];
    nameTF.text = m_tmpUser.account;
    pwdTF.text = m_tmpUser.password ? : @"";
    
    if (pwdTF.text.length <= 0) {
        pwdTF.rightView = eyesBtn;
        pwdTF.endEditDistance = eyesBtn.frame.size.width - 25;
        pwdTF.enabled = YES;
    } else {
        pwdTF.rightView = nil;
        pwdTF.clearButtonMode = UITextFieldViewModeNever;
        pwdTF.enabled = NO;
    }
    
    // close
    [self _userListViewClose];
    
}

- (void)_removeUserWithIndex:(NSInteger)index
{
    // remove in userdefault
    [YCDataUtils ycd_removeNormalUserWithIndex:index];
    // refresh list
    listModelArr =  [YCDataUtils ycd_unarchUserList].copy;
    [uList reloadData];
    
    if (listModelArr.count <= 0) {
        nameTF.text = @"";
        [self _userListViewClose];
    }
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
    [IDCardNumInput resignFirstResponder];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyNext) {
        [textField resignFirstResponder];

        switch (m_mode) {
            case YCBind_WarningToBind:
            case YCBind_Default:
            {
                if ([textField isEqual:nameTF]) {
                    [pwdTF becomeFirstResponder];
                }
                if ([textField isEqual:pwdTF]) {
                    [phoneInput becomeFirstResponder];
                }
                if ([textField isEqual:phoneInput]) {
                    [codeInput becomeFirstResponder];
                }
            }
                break;
            case YCBind_RealNameVertify:
            {
                if ([textField isEqual:realNameInput]) {
                    [IDCardNumInput becomeFirstResponder];
                }
            }
                break;
            case YCBind_Forget_ResetPwd:
            {
                if ([textField isEqual:pwdTF]) {
                    [codeInput becomeFirstResponder];
                }
            }
                break;
                
            default:
                break;
        }
        
        if ([textField isEqual:nameTF]) {
            [pwdTF becomeFirstResponder];
        }
    }
    
    if (textField.returnKeyType == UIReturnKeyDone) {
        [textField resignFirstResponder];

        [self bindViewBtnAction:loginComfirmBtn];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGFloat midline = textField.frame.origin.y + 0.5 * textField.frame.size.height;
    CGRect viewRect = self.frame;
    CGFloat heightFraction = (midline - viewRect.origin.y) / viewRect.size.height;
    
    if (heightFraction < 0.0) {
        heightFraction = 0.0;
    } else if (heightFraction > 1.0) {
        heightFraction = 1.0;
    }
    
    animatedDistance = floor(keyboarHeight * heightFraction);
    
//    CGRect viewFrame = self.frame;
    CGRect viewFrame = mainBg.frame;
    viewFrame.origin.y -= animatedDistance;
//    [self _animationWithView:self frame:viewFrame duration:tRotaTomeInterval];
    [self _animationWithView:mainBg frame:viewFrame duration:tRotaTomeInterval];//这里要改变的是mainbg的位置，如果改变self的位置，会导致mainbg变回原来大小
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    CGRect viewFrame = self.frame;
    CGRect viewFrame = mainBg.frame;
    viewFrame.origin.y += animatedDistance;
//    [self _animationWithView:self frame:viewFrame duration:tRotaTomeInterval];
    [self _animationWithView:mainBg frame:viewFrame duration:tRotaTomeInterval];
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

- (void)_bindNoteLisetner:(NSNotification *)note
{
    if ([note.name isEqualToString:UIKeyboardWillShowNotification]) {
        NSDictionary *userInfo = note.userInfo;
        NSValue *aValue = userInfo[UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        keyboarHeight = keyboardRect.size.height;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

