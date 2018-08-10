//
//
//  Created by Sunny on 17/2/6.
//

#import "YCProtocol.h"
#import "YCWebView.h"

@interface YCProtocol () <UIWebViewDelegate,YCWebViewDelegate>

/**
 *  链接使用OpenURL方法后的回调
 */
@property (nonatomic, copy) void(^openComplete)(NSString *string,BOOL status);

@end

@implementation YCProtocol
{
    YCProtocolMode m_mode;
    
    CGFloat rate ; // 校对比值
    CGFloat curWidth ;
    CGFloat curHeight ;
    CGFloat originBgWidthOfHeight;// 背景图片宽高比
    
    CGFloat boxWidthOfBgWidth;
    CGFloat boxHeightOfBgHeight;
    
    CGFloat titleLabelWidthOfBgWidth;
    CGFloat titleLebelHeightOfBgHeight;
    
    CGFloat noteLabelWidthOfBgWidth;
    CGFloat noteLebelHeightOfBgHeight;
    
    CGFloat checkBoxWithOfBgWidth;
    CGFloat checkBoxHeightOfBgHeight;
    
    CGFloat titleTopPadding;
    CGFloat titleAndBoxGapPadding;
    CGFloat boxGapPadding;
    CGFloat boxAndNotePadding;
    CGFloat leftPadding;
    CGFloat titleLeftPadding;
    CGFloat noteLeftPadding;
    
    CGFloat checkboxBottomPadding;
    CGFloat checkboxRightPadding;
    CGFloat backBtnWidthAndHeight;
    
    CGFloat onCalWidth;
    CGFloat onCalHeight;
    
    BOOL isLandscape;
    BOOL checkBoxOneCheckedStatus;
    BOOL checkBoxTwoCheckedStatus;
    BOOL adwallCheckBoxStatus;
    
    BOOL _isPortrait;
    BOOL _mustChange;
    
    UIImageView *mainBg;
    
    NSString *m_webviewURL;
    NSString *m_webviewURL_addition;

//    UIWebView *m_webview;
    YCWebView *m_webview;
    UIWebView *m_webview_addition;
    UIWebView *ad_webview_01;
    UIWebView *ad_webview_02;
    UIWebView *ad_webview_03;

    UIActivityIndicatorView *m_indicator;
    UIActivityIndicatorView *m_indicator_addition;
    
    NSArray *m_adwallUrls;
    NSMutableArray *m_adWallWebArr;
    UIView *m_webviewBg;
    NSString *m_customUrl;
    
    UIWebView *customWebView;
}

- (instancetype)initWithProtocolMode:(YCProtocolMode)mode optionUrl:(NSString *)optionUrl close:(PTCloseCallback)handler
{
    self = [super init];
    if (self) {
        
        m_mode = mode;
        
        self.closeCB = handler;
        m_customUrl = optionUrl;
        
        _isPortrait = UIInterfaceOrientationIsPortrait([[YCUser shareUser] gameOrientation]);
        _mustChange = _isPortrait && device_is_iPhoneX;
        
        [self _baseValueInit];
        [self customInit];
        
    }
    return self;
}

- (void)_baseValueInit
{
    curWidth = winWidth;
    curHeight = winHeight;
    
    isLandscape = curWidth > curHeight ? YES : NO;
    checkBoxOneCheckedStatus = checkBoxTwoCheckedStatus = adwallCheckBoxStatus = NO;
    
    CGFloat oriBgWidth = isLandscape ? 2208.0f : 1242.0f;
    CGFloat oriBgHeight = isLandscape ? 1242.0f : 2208.0f;
    
    originBgWidthOfHeight = oriBgWidth/oriBgHeight; // 原图宽高比
    
    rate = 1;  // 校对比值
    
    boxWidthOfBgWidth = isLandscape ? 937.0f/oriBgWidth : 1031.0f/oriBgWidth;
    boxHeightOfBgHeight = isLandscape ? 700.0f/oriBgHeight : 660.0f/oriBgHeight;
    
    titleLabelWidthOfBgWidth = isLandscape ? 992.0f/oriBgWidth : 1019.0f/oriBgWidth;
    titleLebelHeightOfBgHeight = isLandscape ? 78.0f/oriBgHeight : 81.0f/oriBgHeight;
    
    noteLabelWidthOfBgWidth = isLandscape ? 1273.0f/oriBgWidth : 1024.0f/oriBgWidth ;
    noteLebelHeightOfBgHeight = isLandscape ? 59.0f/oriBgHeight : 48.0f/oriBgHeight;
    
//    checkBoxWithOfBgWidth = 88.0f/oriBgWidth;
    checkBoxHeightOfBgHeight = 100.0f/oriBgHeight;
    backBtnWidthAndHeight = 100.0f/oriBgWidth;
    
    onCalWidth = rate * curWidth;
    onCalHeight = rate * curHeight;
    
    titleTopPadding = isLandscape ? 110.0f/oriBgHeight : 270.0f/oriBgHeight;
    titleLeftPadding = isLandscape ? 608.0f/oriBgWidth : 106.0f/oriBgWidth;
    noteLeftPadding = isLandscape ? 466.0f/oriBgWidth : 106.0f/oriBgWidth;
    titleAndBoxGapPadding = isLandscape ? 84.0f/oriBgHeight : 128.0f/oriBgHeight;
    boxGapPadding = isLandscape ? 78.0f/oriBgWidth : 62.0f/oriBgHeight;
    
    boxAndNotePadding = isLandscape ? 76.0f/oriBgHeight : 138.0f/oriBgHeight;
    leftPadding = isLandscape ? 128.0f/oriBgWidth : 106.0f/oriBgWidth;
    
    checkboxBottomPadding = 24.0f/oriBgHeight;
    
    
    
    m_webviewURL = @"";
    m_webviewURL_addition = @"";
    
    m_indicator = [self _crateIndicator];
    m_indicator_addition = [self _crateIndicator];
    
    m_adwallUrls = [[NSArray alloc] init];
    
    m_adWallWebArr = [[NSMutableArray alloc] init];
}

- (void)customInit
{
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];

    [self _ycWebMode];
}

#pragma mark - YC
- (void)_ycWebMode
{
    [self topItemInit];
    
    UIView *baseView = [[UIView alloc] init];
    [self.view addSubview:baseView];
    [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(_mustChange ? iphoneX_landscape_left+topItemHeight :topItemHeight));
        make.left.equalTo(@(0));
        make.bottom.equalTo(@(0));
        make.right.equalTo(@(0));
    }];
    
    [self _webviewAddedToBaseView:baseView URL:m_customUrl];
}

#pragma mark - CustomService

- (void)topItemInit
{
    UIImageView *topBar = [[UIImageView alloc] initWithImage:GetImage(bottom_bg)];
    topBar.backgroundColor = [UIColor colorWithHexString:kBlackHex];
    [topBar setUserInteractionEnabled:YES];
    [topBar setAlpha:0.8f];
    [self.view addSubview:topBar];
    [topBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@( _mustChange ? iphoneX_landscape_left : 0));
        make.left.equalTo(@(0));
        make.height.equalTo(@(topItemHeight));
        make.right.equalTo(@(0));
    }];
    
    // back btn
    UIButton *backBtn = [HelloUtils initBtnWithNormalImage:backBtnName_normal highlightedImage:backBtnName_highlighted tag:kProtocolBackBtnTag selector:@selector(btnsAction:) target:self];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(_mustChange ? iphoneX_landscape_left+5 :5));
        make.left.equalTo(@(10));
        make.height.equalTo(@(30));
        make.width.equalTo(@(30));
    }];
    
    // colse btn
    UIButton *closeBtn = [HelloUtils initBtnWithNormalImage:closeBtnName_normal highlightedImage:closeBtnName_highlighted tag:kProtocolCloseBtnTag selector:@selector(btnsAction:) target:self];
    [self.view addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(_mustChange ? iphoneX_landscape_left+5 :5));
        make.right.equalTo(@(-10));
        make.height.equalTo(@(30));// 58(w)x100(h)
        make.width.equalTo(@(30*58/100.0f));
    }];
}

#pragma mark - Small Widget

- (void)_webviewAddedToBaseView:(UIView *)baseView URL:(NSString *)url
{
    m_webview = [self ai_createUIWebViewAndAddToParentViewWithRect:baseView.frame urlStirng:url cornerRadius:0];
    [baseView addSubview:m_webview];
    [m_webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
        make.left.equalTo(@(0));
        make.bottom.equalTo(@(0));
        make.right.equalTo(@(0));
    }];
    // indicator
    [m_webview addSubview:m_indicator];
    [m_indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
        make.left.equalTo(@(0));
        make.bottom.equalTo(@(0));
        make.right.equalTo(@(0));
    }];
    
}

- (YCWebView *)ai_createUIWebViewAndAddToParentViewWithRect:(CGRect)rect urlStirng:(NSString *)urlString cornerRadius:(CGFloat)radius
{
    UIViewAutoresizing autoresizingMask;
    autoresizingMask = UIViewAutoresizingFlexibleWidth;
    autoresizingMask |= UIViewAutoresizingFlexibleHeight;
    
    //创建WebView对象展示H5网页
    YCWebView *resultWebView;
    resultWebView = [[YCWebView alloc] init];
    resultWebView.scalesPageToFit = YES;
    resultWebView.webViewDelegate = self;
    resultWebView.dataDetectorTypes = YES;
    resultWebView.autoresizingMask = autoresizingMask;
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [resultWebView loadRequest:request];
    return resultWebView;
}


- (UIActivityIndicatorView *)_crateIndicator
{
    UIActivityIndicatorView *result;
    result = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [result setFrame:CGRectMake(0, 0, 40, 40)];
    return result;
}

#pragma mark - Btn Actions

- (void)btnsAction:(UIButton *)sender
{
    switch (sender.tag) {
        case kProtocolBackBtnTag:
        {
            //  有前连接就返回，没有就关闭
            if ([m_webview canGoBack]) {
                [m_webview goBack];
            } else {
                [self _closeBtnClick];
            }

        }
            break;
        case kProtocolCloseBtnTag:
        {
            [self _closeBtnClick];
        }
            break;
            
        case kSpaceProtocolBackBtnTag:
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - webView delegate method

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self _indicatorSartAnimate];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self _indicatorStopAnimate];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //在此处截取链接获取支付结果
    NSString *absoluteString = request.URL.absoluteString;
    
    NSLog(@"absoluteString == %@",absoluteString);
    
    if ([absoluteString hasPrefix:@"支付成功后跳转的链接"]) {
        //在此处提示支付成功的支付结果
//        NSLog(@"在此处提示支付成功的支付结果");
        return NO;
    } else if ([absoluteString hasPrefix:@"支付失败后跳转的链接"]) {
        //在此处提示支付失败的支付结果
//        NSLog(@"支付失败后跳转的链接");
        return NO;
    } else if ([absoluteString hasPrefix:@"支付取消后跳转的链接"]) {
        //在此处提示支付取消的支付结果
//        NSLog(@"支付取消后跳转的链接");
        return NO;
    }
    
    if ([request.URL.absoluteString hasPrefix:@"http://wxjscalloc"]){
        [self _closeBtnClick];
    }
    
    return YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

}

#pragma mark - Indicator

- (void)_indicatorSartAnimate
{
    [m_indicator startAnimating];
    [m_indicator_addition startAnimating];
}

- (void)_indicatorStopAnimate
{
    [m_indicator stopAnimating];
    [m_indicator_addition stopAnimating];
}

#pragma mark - Private Method
+ (void)openURL:(NSURL *)object complete:(void(^)(BOOL))complete
{
    UIApplication *application = nil;
    application = [UIApplication sharedApplication];
    SEL selector = @selector(openURL:options:completionHandler:);
    if ([UIApplication instancesRespondToSelector:selector])
    {
#ifdef __IPHONE_10_0
        [application openURL:object
                     options:[NSDictionary dictionary]
           completionHandler:complete];
#else
        if (complete) {
            complete([application openURL:object]);
        }
#endif
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        if (complete) {
            complete([application openURL:object]);
        }
#pragma clang diagnostic pop
    }
}
- (BOOL)isOpenAppSpecialURLValue:(NSString *)string
{
    if ([string hasPrefix:@"http://"]) {
        return NO;
    } else if ([string hasPrefix:@"https://"]) {
        return NO;
    }
    return YES;
}

#pragma mark - Add

 - (void)_closeBtnClick
{
    if (self.closeCB) {
        self.closeCB();
    }
    [self.view removeFromSuperview];
}

@end
