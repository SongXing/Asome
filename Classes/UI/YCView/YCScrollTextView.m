//
//  YCScrollTextView.m
//  YCSDK
//
//  Created by sunn on 2018/7/25.
//

#import "YCScrollTextView.h"
#import "HelloHeader.h"

#define kScrollHeight           50.0f
#define kCloseBtnWidth          30*58/100.0f

#define K_MAIN_VIEW_SCROLL_HEIGHT           50.0f
#define K_MAIN_VIEW_TEME_INTERVAL           0.35         //计时器间隔时间(单位秒)
#define K_MAIN_VIEW_SCROLLER_SPACE          20          //每次移动的距离
#define K_MAIN_VIEW_SCROLLER_LABLE_WIDTH    280  //字体宽度
#define K_MAIN_VIEW_SCROLLER_LABLE_MARGIN   100   //前后间隔距离

#define K_MAIN_VIEW_SCROLL_TEXT_TAG     300
#define kYCScrollCloseBtnTag            301
#define kFilterKeyword_UpdataBtnTag     302
#define kFilterKeyword_ChargeBtnTag     303

#define strGiveMeTheHandScheme_Updata           @"wowo://"
#define strGiveMeTheHand_Updata                 @"wowo"
#define strGiveMeTheHandScheme_Charge           @"wawa://"
#define strGiveMeTheHand_Charge                 @"wawa"

@implementation YCScrollTextView
{
    NSTimer           *timer;
    UIScrollView      *scrollViewText;
    dispatch_source_t ownCountingTimer;
    NSString          *filterKeyword_Updata;
    NSString          *filterKeyword_Charge;
    
    NSMutableArray    *lableArr;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self _propertyInit];
        
        [self bgViewInit];
        [self initView];
    }
    return self;
}

- (void)_propertyInit
{
    self.rollTimeTotal = 120;
    filterKeyword_Updata = @"欧元";
    filterKeyword_Charge = @"充值";
    
    lableArr = [[NSMutableArray alloc] init];
}

- (void)bgViewInit
{
    
    [self setFrame:CGRectMake(0, 0, winWidth, kScrollHeight)];
    [self setBackgroundColor:[UIColor colorWithHexString:@"#000000" andAlpha:0.5]];
    
    // close btn
    UIButton *closeBtn = [HelloUtils initBtnWithNormalImage:closeBtnName_normal highlightedImage:closeBtnName_highlighted tag:kYCScrollCloseBtnTag selector:@selector(_scrollBtnAction:) target:self];
    [self addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(5));
        make.right.equalTo(@(-10));
        make.height.equalTo(@(30));// 58(w)x100(h)
        make.width.equalTo(@(kCloseBtnWidth));
    }];
    
}

//初始化数据
- (void)initView
{
    if (!self.arrData) {
        self.arrData = @[
                         @{
                             @"newsId"   :@"201507070942261935",
                             @"newsImg"  :@"http://bg.fx678.com/HTMgr/upload/UpFiles/20150707/sy_2015070709395519.jpg",
                             @"newsTitle" : @"三大理由欧元任性抗跌，峰会将为希腊定调,还有你说什么"
                             },
                         @{
                             @"newsId"   :@201507070929021220,
                             @"newsImg"   :@"http://bg.fx678.com/HTMgr/upload/UpFiles/20150707/sy_2015070709273545.jpg",
                             @"newsTitle" :@"欧盟峰会或保卫战充值"
                             },
//                         @{
//                             @"newsId"    :@201507070656471857,
//                             @"newsImg"   :@"http://bg.fx678.com/HTMgr/upload/UpFiles/20150707/2015070706533134.jpg",
//                             @"newsTitle" :@"希腊困局欧元不怕，油价服软暴跌8%"
//                             }
                         ];
    }
    
    //文字滚动
    [self initScrollText];
    
    //开启滚动
    [self startScroll];
}

//文字滚动初始化
- (void)initScrollText
{
    //获取滚动条
    scrollViewText = (UIScrollView *)[self viewWithTag:K_MAIN_VIEW_SCROLL_TEXT_TAG];
    if(!scrollViewText) {
        scrollViewText = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-30-kCloseBtnWidth, K_MAIN_VIEW_SCROLL_HEIGHT)];
        scrollViewText.showsHorizontalScrollIndicator = NO;   //隐藏水平滚动条
        scrollViewText.showsVerticalScrollIndicator = NO;     //隐藏垂直滚动条
        scrollViewText.tag = K_MAIN_VIEW_SCROLL_TEXT_TAG;
        [scrollViewText setBackgroundColor:[UIColor clearColor]];
        
//        scrollViewText.userInteractionEnabled = NO;
        
        //清除子控件
        for (UIView *view in [scrollViewText subviews]) {
            [view removeFromSuperview];
        }
        
        //添加到当前视图
        [self addSubview:scrollViewText];
    }
    
    CGFloat tempWidth = 0.0f;
    
    if (self.arrData) {
        
        CGFloat offsetX = 0 ,i = 0;
        
        
        //设置滚动文字
    
        for (NSDictionary *dicTemp in self.arrData) {
            
            UIFont *txtFont = [UIFont systemFontOfSize:18];
            UILabel *labText = [[UILabel alloc] initWithFrame:CGRectZero];
            labText.userInteractionEnabled = YES;
            NSString *txtStr = dicTemp[@"newsTitle"];
            
            // 思路：使用富文本，并在关键词处添加一个透明的按钮
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:txtStr];
            // 默认属性
            [attStr addAttribute:NSFontAttributeName
                           value:txtFont
                           range:NSMakeRange(0, attStr.length)];
            [attStr addAttribute:NSForegroundColorAttributeName
                           value:[UIColor whiteColor]
                           range:NSMakeRange(0, attStr.length)];
            
            
            
            NSRange keyRange = [txtStr rangeOfString:filterKeyword_Updata];
            
            if (keyRange.location != NSNotFound) {
                // 改变大小
                [attStr addAttribute:NSFontAttributeName
                               value:[UIFont systemFontOfSize:20.0f]
                               range:keyRange];
                [attStr addAttribute:NSForegroundColorAttributeName
                               value:[UIColor redColor]
                               range:keyRange];
                
                CGSize befSize = CGSizeZero;
                NSString *beforeKeyStr = [txtStr substringToIndex:keyRange.location];
                
                befSize = [HelloUtils calculateSizeOfString:beforeKeyStr withFont:txtFont];
                
                NSMutableAttributedString *keyStr = [[NSMutableAttributedString alloc] initWithString:filterKeyword_Updata];
                [keyStr addAttribute:NSFontAttributeName
                               value:txtFont
                               range:NSMakeRange(0, keyStr.length)];
                CGSize keySize = [HelloUtils calculateSizeOfString:keyStr];
                CGRect keyBtnFrame = CGRectMake(befSize.width, labText.frame.origin.y, keySize.width, keySize.height);
                
                
                // 增加透明 btn
                UIButton *keyBtn = [HelloUtils yc_initBtnWithTitle:@""
                                                               tag:kFilterKeyword_UpdataBtnTag
                                                          selector:@selector(_scrollBtnAction:)
                                                            target:self];
                [keyBtn.layer setBorderWidth:0.0f];
                [keyBtn.layer setBorderColor:[UIColor clearColor].CGColor];
                [keyBtn.layer setCornerRadius:0.0f];
                [keyBtn setBackgroundColor:[UIColor greenColor]];
                [keyBtn setFrame:keyBtnFrame];
                [labText insertSubview:keyBtn atIndex:0];
                // position

                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapAction:)];
                [labText addGestureRecognizer:tap];
                
            }
            
            NSRange chaRange = [txtStr rangeOfString:filterKeyword_Charge];
            if ( chaRange.location != NSNotFound) {
                // 改变大小
                [attStr addAttribute:NSFontAttributeName
                               value:[UIFont systemFontOfSize:20.0f]
                               range:chaRange];
                [attStr addAttribute:NSForegroundColorAttributeName
                               value:[UIColor redColor]
                               range:chaRange];
                
                // 修改，并更换为 btn
                UIButton *keyBtn = [HelloUtils yc_initBtnWithTitle:filterKeyword_Charge
                                                               tag:kFilterKeyword_ChargeBtnTag
                                                          selector:@selector(_scrollBtnAction:)
                                                            target:self];
                [labText addSubview:keyBtn];
            }
            
            
            labText.attributedText = attStr;
            labText.backgroundColor = [UIColor clearColor];
            
//            CGSize lbSize = [HelloUtils calculateSizeOfLabel:labText];
            CGSize lbSize = [HelloUtils calculateSizeOfString:attStr];
            
            [labText setFrame:CGRectMake(winWidth + i * (tempWidth + K_MAIN_VIEW_SCROLLER_LABLE_MARGIN), 0, lbSize.width, K_MAIN_VIEW_SCROLL_HEIGHT)];

            offsetX += labText.frame.origin.x;
            
            tempWidth = lbSize.width;
            
            //添加到滚动视图
            [scrollViewText addSubview:labText];
            
            [lableArr addObject:labText];
            
            i++;
        }
        
        //设置滚动区域大小
        [scrollViewText setContentSize:CGSizeMake(offsetX, 0)];
    }
}

//开始滚动
- (void)startScroll
{
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:K_MAIN_VIEW_TEME_INTERVAL target:self selector:@selector(setScrollText) userInfo:nil repeats:YES];
//        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
    
    [timer fire];
    [self _starCounting];
}

- (void)_starCounting
{
    //倒计时时间
    __block NSInteger timeOut = self.rollTimeTotal;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    ownCountingTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(ownCountingTimer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(ownCountingTimer, ^{
        //倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(ownCountingTimer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stopSrolling];
            });
        } else {
            timeOut--;
        }
    });
    dispatch_resume(ownCountingTimer);
}

- (void)stopSrolling
{
    [timer invalidate];
    timer = nil;
    dispatch_cancel(ownCountingTimer);
    [self removeFromSuperview];
}

//滚动处理
- (void)setScrollText
{
    CGFloat startX = winWidth;
    
    [UIView animateWithDuration:K_MAIN_VIEW_TEME_INTERVAL * 2 animations:^{
        CGRect rect;
        CGFloat offsetX = 0.0 , i = 0;
        
        for (UILabel *lab in scrollViewText.subviews) {
            rect = lab.frame;
            offsetX = rect.origin.x - K_MAIN_VIEW_SCROLLER_SPACE;
            if (offsetX < -(lab.frame.size.width + K_MAIN_VIEW_SCROLLER_LABLE_MARGIN)) {
                offsetX = startX;
                lab.alpha = 0.0f;
                [UIView animateWithDuration:K_MAIN_VIEW_TEME_INTERVAL
                                 animations:^{
                                     
                                 }
                                 completion:^(BOOL finished) {
                                     if (finished) {
                                         
                                         // 如果前面还有，则加上前面的长度
                                         
                                         lab.frame = CGRectMake(offsetX, rect.origin.y, rect.size.width, rect.size.height);
                                         [UIView animateWithDuration:0.1f
                                                               delay:0.1f
                                                             options:UIViewAnimationOptionCurveEaseInOut
                                                          animations:^{
                                                              lab.alpha = 1.0f;
                                                          } completion:nil];
                                         
                                     }
                                 }];
            } else {
                lab.frame = CGRectMake(offsetX, rect.origin.y, rect.size.width, rect.size.height);
            }
            
            i++;
        }
        
    }];
    
}

#pragma mark - Actions

- (void)_scrollBtnAction:(UIButton *)sender
{
    switch (sender.tag) {
        case kYCScrollCloseBtnTag:
        {
            NSLog(@"关闭公告");
            [self stopSrolling];
        }
            break;
        case kFilterKeyword_UpdataBtnTag:
        {
            NSLog(@"点击了更新");
        }
            break;
        case kFilterKeyword_ChargeBtnTag:
        {
            NSLog(@"点击了充值");
        }
            break;
        default:
            break;
    }
}

- (void)_tapAction:(UITapGestureRecognizer *)tap
{
    NSLog(@"tappppp");
}



- (void)_tpTest
{
    UIFont *txtFont = [UIFont systemFontOfSize:18];
    UITextView *labText = [[UITextView alloc] initWithFrame:CGRectZero];
    
    NSString *txtStr = @"三大理由欧元任性抗跌，欧元区峰会将为希腊定调";
    NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] initWithString:txtStr];
    // 默认属性
    [mStr addAttribute:NSFontAttributeName
                 value:txtFont
                 range:NSMakeRange(0, mStr.length)];
    [mStr addAttribute:NSForegroundColorAttributeName
                 value:[UIColor whiteColor]
                 range:NSMakeRange(0, mStr.length)];
    
    NSString *filterStr = @"欧元";
    NSRange range = [txtStr rangeOfString:filterStr];
    NSLog(@"range = %@",NSStringFromRange(range));
    if (range.location != NSNotFound) {
        // 添加超链接
        [mStr addAttribute:NSLinkAttributeName
                     value:strGiveMeTheHandScheme_Charge
                     range:range];
        // 修改超链接颜色
        labText.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor redColor]};
        
        // 改变大小
        [mStr addAttribute:NSFontAttributeName
                     value:[UIFont systemFontOfSize:20.0f]
                     range:range];
    }
    
    labText.attributedText = mStr;
    labText.backgroundColor = [UIColor clearColor];
    
    labText.editable = NO;
//    labText.delegate = self;
    labText.scrollEnabled = NO;
    labText.selectable = YES;
    
    
    CGSize lbSize = [HelloUtils calculateSizeOfString:labText.text withFont:txtFont];
    NSLog(@"size = %@",NSStringFromCGSize(lbSize));
    
    [labText setFrame:CGRectMake(0, 50, lbSize.width, K_MAIN_VIEW_SCROLL_HEIGHT)];
    
    //添加到滚动视图
    [self addSubview:labText];
}

@end
