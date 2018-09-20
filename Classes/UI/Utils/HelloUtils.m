//
//

#import "HelloUtils.h"
#import "HelloHeader.h"


#define LABEL_FONT_NAME              @"Helvetica-Bold"
#define kLoadingTag                  9999


@implementation HelloUtils


#pragma mark - UI

+ (UIButton *)ycu_rightViewWithImage:(NSString *)image
                                tag:(NSUInteger)tag
                           selector:(SEL)selector
                             target:(id)targer
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = GetImage(image);
    [btn setImage:img forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, img.size.width, img.size.height)];// 要用比例
    btn.tag = tag;
    [btn addTarget:targer action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+ (UIButton *)ycu_initBtnWithNormalImage:(NSString *)normalImageName
                    highlightedImage:(NSString *)highlightedImageName
                                 tag:(NSUInteger)tag
                            selector:(SEL)selector
                              target:(id)target
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:GetImage(normalImageName) forState:UIControlStateNormal];
    [btn setImage:GetImage(highlightedImageName) forState:UIControlStateHighlighted];
    [btn setTag:tag];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

+ (UIButton *)ycu_initBtnWithTitle:(NSString *)titleText
                                 tag:(NSUInteger)tag
                            selector:(SEL)selector
                              target:(id)target
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:titleText forState:0];
    [btn setTitleColor:[UIColor blackColor] forState:0];
    [btn setTag:tag];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn.layer setBorderWidth:1.5f];
    [btn.layer setBorderColor:[UIColor grayColor].CGColor];
    [btn.layer setMasksToBounds:YES];
    [btn.layer setCornerRadius:5.0f];
    
    return btn;
}

+ (UIButton *)yc_initBtnWithTitle:(NSString *)titleText
                           tag:(NSUInteger)tag
                      selector:(SEL)selector
                        target:(id)target
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:titleText forState:0];
//    [btn setTitleColor:[UIColor blackColor] forState:0];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    [btn setTag:tag];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
//    [btn setBackgroundImage:GetImage(textfield_bg) forState:0];
    [btn setBackgroundColor:[UIColor colorWithHexString:@"#5CD4B4"]];
    
    // 圆角与边框
//    [btn.layer setBorderWidth:1.5f];
//    [btn.layer setBorderColor:[UIColor grayColor].CGColor];
    [btn.layer setMasksToBounds:YES];
    [btn.layer setCornerRadius:20.0f];
    
    return btn;
}

+ (UIButton *)ycu_initBtnWithType:(UIButtonType)type
                        title:(NSString *)titleText
                          tag:(NSUInteger)tag
                     selector:(SEL)selector
                       target:(id)target
{
    UIButton *btn = [UIButton buttonWithType:type];
    [btn setTitle:titleText forState:0];
    [btn setTitleColor:[UIColor blackColor] forState:0];
    [btn setTag:tag];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn.layer setBorderWidth:1.5f];
    [btn.layer setBorderColor:[UIColor grayColor].CGColor];
    [btn.layer setMasksToBounds:YES];
    [btn.layer setCornerRadius:5.0f];
    [btn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    
    return btn;
}

+ (HelloTextField *)ycu_customTextfieldWidgetWithLeftView:(NSString *)imageName rightView:(UIView *)right placeholder:(NSString *)placeholder delegate:(id)delegate
{
    UIImageView *icon = [[UIImageView alloc] initWithImage:GetImage(imageName)];
    HelloTextField *resultText = [[HelloTextField alloc] initWithFrame:CGRectZero leftView:icon rightView:right];
    resultText.initDistance = 10;
    resultText.placeholder = placeholder;
    resultText.clearButtonMode = UITextFieldViewModeAlways;
    resultText.delegate = delegate;
    
    return resultText;
}

#pragma mark - private

+ (void)_userdefaultSetObject:(id)obj forKey:(NSString *)key
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:obj forKey:key];
    [ud synchronize];
}
+ (id)_userdefaultGetObjForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)_userdefaultSetBool:(BOOL)statu forKey:(NSString *)key
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:statu forKey:key];
    [ud synchronize];
}
+ (BOOL)_userdefaultGetBoolForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}


#pragma mark -

+ (CGSize)ycu_calculateSizeOfString:(NSString *)str withFont:(UIFont *)font
{
    CGSize resultSize = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                          options:NSStringDrawingTruncatesLastVisibleLine
                                       attributes:@{NSFontAttributeName:font}
                                          context:nil].size;
    
    return CGSizeMake(ceil(resultSize.width)+1, ceil(resultSize.height)+1);
}


+ (CGSize)ycu_calculateSizeOfString:(NSMutableAttributedString *)str
{
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentLeft;
    
    [str addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
    
    CGRect rect = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                      context:nil];
    CGSize resultSize = rect.size;
    
    return CGSizeMake(ceilf(resultSize.width) + 10, ceilf(resultSize.height));
}


+ (CGSize)ycu_calculateSizeOfLabel:(UILabel *)label
{
    NSString *labelStr = label.text;
    CGSize resultSize = [labelStr boundingRectWithSize:CGSizeMake(1000, 1000)
                                               options:NSStringDrawingTruncatesLastVisibleLine
                                            attributes:@{NSFontAttributeName:label.font}
                                               context:nil].size;
    
    return CGSizeMake(ceil(resultSize.width)+1, ceil(resultSize.height)+1);
}

+ (CGSize)ycu_calculateSizeOfLabel:(UILabel *)label andWidth:(CGFloat)width
{
    NSString *labelStr = label.text;
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentLeft;
    
    
    CGSize resultSize = [labelStr boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                               options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading //NSStringDrawingTruncatesLastVisibleLine
                                            attributes:@{NSFontAttributeName:label.font,NSParagraphStyleAttributeName:style}
                                               context:nil].size;
    return CGSizeMake(ceil(resultSize.width)+1, ceil(resultSize.height)+1);
}

#pragma mark - Toast

+ (void)ycu_sToastWithMsg:(NSString *)msg
{
    [self ycu_sToastWithMsg:msg atView:nil];
}

+ (void)ycu_sToastWithMsg:(NSString *)msg atView:(UIView *)baseView
{
    if (!baseView) {
        baseView = [UIApplication sharedApplication].windows[0];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // bottom view
        UIView *aler = [[UIView alloc] initWithFrame:CGRectZero];
        
        aler.backgroundColor = [UIColor colorWithHexString:@"#000000" andAlpha:0.7];
        aler.alpha = 0.9f;
        aler.layer.cornerRadius = 10.0f;
        
        [baseView addSubview:aler];
        [baseView bringSubviewToFront:aler];
        
        NSString *toastString = msg;
        // toast text
        UILabel *toastLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        toastLabel.text = toastString;
        toastLabel.backgroundColor = [UIColor clearColor];
        toastLabel.textColor = [UIColor whiteColor];
        
        toastLabel.font = [UIFont fontWithName:LABEL_FONT_NAME size:16];
        toastLabel.textAlignment = NSTextAlignmentCenter;
        toastLabel.numberOfLines = 0;
        toastLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        
        //        CGSize tempStringSize = [SPUtils calculateSizeOfLabel:toastLabel];
        // 多行文字要分行 test
        CGSize tempStringSize = [HelloUtils ycu_calculateSizeOfLabel:toastLabel andWidth:[HelloUtils ycu_getCurrentScreenFrame].size.width-100];
        
        
        CGFloat _width = tempStringSize.width + 60;
        CGFloat _height = tempStringSize.height + 20;
        
        [aler setFrame:CGRectMake(0, 0, _width, _height)];
        aler.center = baseView.center;
        
        
        
        [toastLabel setFrame:CGRectMake( 0, 0, tempStringSize.width  , tempStringSize.height)];
        toastLabel.center = CGPointMake(_width/2, _height/2);
        
        [aler addSubview:toastLabel];
        
        toastLabel = nil;
        
        // animation
        [UIView animateWithDuration:1.5f
                         animations:^{
                             aler.alpha = 1.0f;
                         } completion:^(BOOL finished) {
                             [aler removeFromSuperview];
                         }];
        
    });
}

+ (UIViewController *)spGetCurViewController
{
    UIViewController *resultVC = nil;
    
    resultVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    
    while (resultVC.presentedViewController) {
        resultVC = resultVC.presentedViewController;
    }
    
    return resultVC;
}

#pragma mark - 菊花图

+ (void)ycu_sStarLoadingAtView:(UIView *)baseView
{
    if (nil == baseView) {
        UIWindow * window = [UIApplication sharedApplication].windows[0];
        baseView = window;
    }
    
    UIView *wholeView = [[UIView alloc] initWithFrame:baseView.frame];
    wholeView.backgroundColor = [UIColor colorWithHexString:@"#000000" andAlpha:0.3];
    [baseView addSubview:wholeView];
    
    UIView *v=[[UIView alloc] initWithFrame:CGRectZero];
    v.backgroundColor = [UIColor colorWithHexString:@"#000000" andAlpha:0.6];
    v.tag = kLoadingTag;
    v.layer.cornerRadius = 10.0f;
    
//    [baseView addSubview:v];
    [wholeView addSubview:v];
    
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@(0));
        make.centerY.equalTo(@(0));
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
    }];
    UIActivityIndicatorView *indicator;
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [v addSubview:indicator];
    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@(0));
        make.centerY.equalTo(@(0));
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
    }];
    [indicator startAnimating];
}

+ (void)ycu_sStopLoadingAtView:(UIView *)baseView
{
    if (nil == baseView) {
        UIWindow * window = [UIApplication sharedApplication].windows[0];
        baseView = window;
    }
    
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[baseView viewWithTag:kLoadingTag];
//    [indicator removeFromSuperview];
    [indicator.superview removeFromSuperview];
}


#pragma mark - NSUserDefault

+ (void)ycu_userdefault_setObj:(id)obj key:(id)key
{
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    [df setObject:obj forKey:key];
    [df synchronize];
}

+ (id)ycu_userdefault_getObjforKey:(id)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

#pragma mark - Others

+ (void)ycu_makeTextFieldPlaceHolderProperty:(UITextField *)textField
{
    NSMutableParagraphStyle *style = [textField.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
    style.minimumLineHeight = textField.font.lineHeight - (textField.font.lineHeight - [UIFont systemFontOfSize:14.0].lineHeight) / 2.0;
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:textField.placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:style}];
    [textField setAttributedPlaceholder:attrStr];
}

#pragma mark - Trim

+ (NSString *)ycu_triString:(NSString *)aStr
{
    return [aStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];// 去掉左右两边的空格
}

#pragma mark - 输入正则

+ (BOOL)validUserName:(NSString *)userName
{
    NSString  *regex = @"(^[A-Za-z0-9_]{5,60}$)";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:userName];
}

+ (BOOL)validEmailFormat:(UITextField *)textField
{
    NSString * patternEmail=@"^(?=[\\w-]+(\\.[\\w-]+)*@[\\w-]+(\\.[\\w-]+)+).{0,50}$";
    NSError * error=NULL;
    NSRegularExpression * regexEmail=[NSRegularExpression regularExpressionWithPattern:patternEmail options:0 error:&error];
    NSTextCheckingResult * isEmail=[regexEmail firstMatchInString:textField.text options:0 range:NSMakeRange(0, textField.text.length)];
    return !isEmail ? NO : YES;
}

+ (BOOL)validPassWord:(NSString *)pwd
{
    NSString  *regex = @"(^[A-Za-z0-9]{5,30}$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:pwd];
}

#pragma mark - 手机正则

// 正则判断中国大陆手机号码地址格式
+ (BOOL)validCnMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - 正则不通过的提示语

+ (void)ycu_invalidNameToast
{
    [HelloUtils ycu_sToastWithMsg:@"用户名无效"];
}
+ (void)ycu_invalidPwdToast
{
    [HelloUtils ycu_sToastWithMsg:@"密码无效"];
}
+ (void)ycu_invalidPhoneToast
{
    [HelloUtils ycu_sToastWithMsg:@"手机无效"];
}
+ (void)ycu_invalidEmailToast
{
    [HelloUtils ycu_sToastWithMsg:@"邮箱无效"];
}
+ (void)ycu_invalidVertifyCodeToast
{
    [HelloUtils ycu_sToastWithMsg:@"验证码无效"];
}
+ (void)ycu_disagreeAgreeementToast
{
    [HelloUtils ycu_sToastWithMsg:@"您需要先同意协议"];
}

#pragma mark - 按钮倒计时处理
+ (void)     ycu_counttingButton:(UIButton *)sender
                   startTime:(NSInteger)timeLine
                       title:(NSString *)title
              countDownTitle:(NSString *)subTitle
                   mainColor:(UIColor *)mColor
                  countColor:(UIColor *)countColor
{
    //倒计时时间
    __block NSInteger timeOut = timeLine;
    __block NSString *oriBtnTitle = sender.titleLabel.text;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        //倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //                sender.backgroundColor = mColor;
//                [sender setTitle:@"获取验证码" forState:0];
                [sender setTitle:oriBtnTitle forState:0];
                sender.enabled = YES;
            });
        } else {
            int allTime = (int)timeLine + 1;
            int seconds = timeOut % allTime;
            NSString *timeStr = [NSString stringWithFormat:@" %.1d ", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                sender.backgroundColor = mColor;
                [sender setTitle:[NSString stringWithFormat:@"%@%@",timeStr,subTitle] forState:UIControlStateDisabled];
                
                [sender setTitleColor:countColor forState:UIControlStateDisabled];
                sender.enabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}

+ (void)ycu_showSomeSenceOnSafari:(NSString *)urlStr
{
    NSURL *url = [NSURL URLWithString:urlStr];
    if([[UIDevice currentDevice].systemVersion floatValue] >= 10.0){
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [[UIApplication sharedApplication] openURL:url options:@{}
                                     completionHandler:^(BOOL success) {
                                         
                                     }];
        } else {

        }
        
    } else{
        bool can = [[UIApplication sharedApplication] canOpenURL:url];
        if(can){
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

#pragma mark - Post Note

+ (void)ycu_postNoteWithName:(NSString *)name userInfo:(NSDictionary *)dict
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:dict[kRespStrData]];
}

#pragma mark - Screen Size

+ (CGRect)ycu_getCurrentScreenFrame
{
    CGRect currentScreenSize;
    
    // 默认初始化为横屏
    UIInterfaceOrientation oritation = [[YCUser shareUser] gameOrientation];
    
    if (UIInterfaceOrientationIsLandscape(oritation))//如果是横屏幕的游戏
    {
        currentScreenSize = [self rectFromWinSize_Landscape];
    }
    else
    {
        currentScreenSize = [self rectFromWinSize_Portrait];
    }
    
    return currentScreenSize;
}

+ (CGRect)rectFromWinSize_Landscape
{
    CGRect retult_ = [[UIScreen mainScreen] bounds];
    
    if (retult_.size.width < retult_.size.height) {
        float _tempNum = 0;
        _tempNum = retult_.size.width;
        retult_.size.width = retult_.size.height;
        retult_.size.height = _tempNum;
    }
    
    return retult_;
}

+ (CGRect)rectFromWinSize_Portrait
{
    CGRect retult_;
    retult_ = [[UIScreen mainScreen] bounds];
    
    if (retult_.size.width > retult_.size.height) {
        float _tempNum = 0;
        _tempNum = retult_.size.width;
        retult_.size.width = retult_.size.height;
        retult_.size.height = _tempNum;
    }
    
    return retult_;
}

+ (void)ycu_saveNewRegAccountToPhoto:(UIView *)curView
{
    // create image
    UIGraphicsBeginImageContext(CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height));
    [curView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *extractImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImagePNGRepresentation(extractImage);
    UIImage *img = [UIImage imageWithData:imageData];
    
    // save img to photo
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(_image:didFinishSavingWithError:contextInfo:), NULL);
    
    // 根据英文版本审核时通常因为相册问题被拒绝
//    [SPAlertView showAlertWithMessage:SP_GET_LOCALIZED(@"TXT_SAVE_IMAGE_OR_NOT")
//                           completion:^(NSInteger clickedBtnIndex) {
//                               if (clickedBtnIndex == 1) {
//                                   // save img to photo
//                                   UIImageWriteToSavedPhotosAlbum(img, self, @selector(_image:didFinishSavingWithError:contextInfo:), NULL);
//                               }
//                           } andButtonTitles:SP_GET_LOCALIZED(@"BTN_TITLE_TXT_CANCEL"),SP_GET_LOCALIZED(@"BTN_TITLE_TXT_COMFIRM"), nil];
}

// 保存图片到相册后的结果
+ (void)_image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
//        msg = SP_GET_LOCALIZED(@"MSG_SAVE_ACCOUNT_AND_PASSWORD_TO_PHOTO_FAIL") ;
        msg = @"您的帐号密码保存到相册失败";
    }else{
//        msg = SP_GET_LOCALIZED(@"MSG_SAVE_ACCOUNT_AND_PASSWORD_TO_PHOTO_SUCCESS") ;
        msg =  @"您的帐号密码已保存到相册";
    }
    
    [HelloUtils ycu_sToastWithMsg:msg];
}

#pragma mark - Other Helper

+ (NSString *)ycu_paraseObjToStr:(id)obj
{
    return [NSString stringWithFormat:@"%@",obj];
}

#pragma mark - 获取出口 Ip 地址

+ (NSString *)ycu_deviceIpAddress
{
    NSURL *ipInqureyUrl = [NSURL URLWithString:kIpInqureyUrlAddress];
    NSData *data = [NSData dataWithContentsOfURL:ipInqureyUrl];
    NSDictionary *ipDic = [NSJSONSerialization JSONObjectWithData:data
                                                          options:NSJSONReadingMutableContainers
                                                            error:nil];
    NSString *ipStr = nil;
    
    if (ipDic && [ipDic[kRespStrCode] integerValue] == 0) {
        ipStr = ipDic[kRespStrData][kRespStrIp];
    }
    
    return ipStr?:@"";
}

#pragma mark - 获取指定 bundle 图片

+ (UIImage *)uuGetImageWithNamed:(NSString *)name
{
    UIImage *result = nil;
    
    if (!name) {
        return result;
    }
    
    // 优先使用的方式
//    NSLog(@"==%@",[@"YCResources.bundle" stringByAppendingPathComponent:name]);//YCResources.bundle/logo.png
    result = [UIImage imageNamed:[@"YCResources.bundle" stringByAppendingPathComponent:name]];
    if (result) {
        return result;
    }
    
    // 然后使用旧的方式读取 bundle （以下方法在某些CP打出来的包上面出现在 iOS 11.4.1 上面读不到图片的问题）
    NSURL *bundleUrl = [[NSBundle mainBundle] URLForResource:@"YCResources" withExtension:@"bundle"];
    if (!bundleUrl) {
        result = [UIImage imageNamed:name];
        return result;
    }
    
    NSBundle *bundle = [NSBundle bundleWithURL:bundleUrl];
    NSString *imgPath = [bundle.resourcePath stringByAppendingPathComponent:name];
//    NSLog(@"\n name:%@ \n imgPath: %@",name,imgPath);
    result = [UIImage imageWithContentsOfFile:imgPath];    
    
    return result ? : [UIImage imageNamed:name];
}

@end
