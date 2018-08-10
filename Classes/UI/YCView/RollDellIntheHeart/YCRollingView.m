

#import <UIKit/UIKit.h>
#import "HelloHeader.h"

@interface YCRollingView()
@property (nonatomic, copy) NSString *str, *urlStr, *targetStr, *keyStr; // 滚动的字符
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray <UILabel *> *labelsArrM;
@property (nonatomic, assign) CGFloat offsetX;
@property (nonatomic, assign) CGRect textRect;
@property (nonatomic, strong) NSArray *texA;

@end

@implementation YCRollingView
{
    dispatch_source_t ownCountingTimer;
}

- (id)initWithShowStr:(NSString *)str andURLStr:(NSString *)urlStr
{
    self = [super init];
    if (self) {
        self.str = str;
        self.urlStr = urlStr;

        
//        self.frame = CGRectMake(44 * 0.6, 0, [UIScreen mainScreen].bounds.size.width - 88 * 0.6, 44 * 0.6);
        
        self.offsetX = 0.0f;
        self.clipsToBounds = YES;
        
        self.texA = [self cutupWithTheOriginalStr:str];
        
        self.labelsArrM =[NSMutableArray array];
        [self showTheRollingView];
        
    }
    
    return self;
}

- (void)showTheRollingView
{
    
    NSArray *a = [self markStrFrames];
    // 创建两个label
    for (int i = 0; i < 2; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithHexString:@"FF6633"];
        label.font = [UIFont systemFontOfSize:14];
        //label.backgroundColor = [UIColor hexFloatColor:@"919191"];
        label.text = self.targetStr;
        [self addSubview:label];
        label.userInteractionEnabled = YES;
        
        [self.labelsArrM addObject:label];
        
        if ( self.texA.count > 0 ) {
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake([[a firstObject] floatValue], -1, [self keyWordRect:self.keyStr].size.width, [self keyWordRect:self.keyStr].size.height)];
            label1.text = self.keyStr;
            label1.font = [UIFont systemFontOfSize:16];
            label1.textColor = [UIColor blueColor];
            
            [label addSubview:label1];
            
            // 添加点击手势
            label1.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap:)];
            [label1 addGestureRecognizer:tapGesture];
        }
        
    }
    
    // 滚动动画
    [self startRolling];
}

#pragma mark - 滚动动画
- (void)startRolling
{
    CGSize maxSize = CGSizeMake(CGFLOAT_MAX, self.frame.size.height);
    self.textRect = [self.targetStr boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    // 开启定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)_starCounting
{
    NSDictionary *info = [YCDataUtils yc_getGoodNews];
    NSInteger rollTime = [[NSString stringWithFormat:@"%@",info[@"time"]] integerValue]; // 分钟
    //倒计时时间
    __block NSInteger timeOut = rollTime*60;
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
    [_timer invalidate];
    _timer = nil;
//    dispatch_cancel(ownCountingTimer);
    [self.superview removeFromSuperview];
    
    // 开始内部计时
//    [self _starCounting];
}

- (void)timerAction:(NSTimer *)timer
{
    self.offsetX =  self.offsetX - 1.5;
    // labelTwo .origin.x
    CGFloat labelTwoX = self.offsetX + self.textRect.size.width + self.frame.size.width / 4;
    
    if (self.offsetX > -self.textRect.size.width) {
        self.labelsArrM[0].frame = CGRectMake(self.offsetX, (self.frame.size.height - self.textRect.size.height) / 2, self.textRect.size.width, self.textRect.size.height);
        
        self.labelsArrM[1].frame = CGRectMake(labelTwoX, (self.frame.size.height - self.textRect.size.height) / 2, self.textRect.size.width, self.self.textRect.size.height);
    } else {
        self.offsetX = self.labelsArrM[1].frame.origin.x;
    }
    
}

#pragma mark - 销毁定时器
- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}



#pragma mark - tapGesture
- (void)labelTap:(UITapGestureRecognizer *)gesture
{
    // 跳转对应的链接
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue >= 10.0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.urlStr] options:@{} completionHandler:^(BOOL success) {
            
        }];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.urlStr]];
    }
    
}

#pragma mark - 分割字符串
- (NSArray *)cutupWithTheOriginalStr:(NSString *)originalStr
{
    NSArray *strArray = [[NSArray alloc] init];
    NSRange zfStrRange = [originalStr rangeOfString:@"充值"];
    NSRange gxStrRange = [originalStr rangeOfString:@"更新"];
    
    if (zfStrRange.length != 0) {
        strArray = [originalStr componentsSeparatedByString:@"充值"];
        
        originalStr = [originalStr stringByReplacingCharactersInRange:zfStrRange withString:@"         "];
        self.keyStr = @"充值";
        
    } else if (gxStrRange.length != 0) {
        strArray = [originalStr componentsSeparatedByString:@"更新"];
        
        originalStr = [originalStr stringByReplacingCharactersInRange:gxStrRange withString:@"         "];
        
        self.keyStr = @"更新";
    }
    
    self.targetStr = originalStr;
    
    return strArray;
}


- (NSString *)replaceStringWithRange:(NSRange)range
{
    NSMutableString *string = [NSMutableString string];
    
    for (int i = 0; i < range.length ; i++) {
        [string appendString:@" "];
    }
    
    return string;
}

- (NSArray *)markStrFrames
{
    NSMutableArray *mArray = [NSMutableArray array];
    CGSize maxSize = CGSizeMake(CGFLOAT_MAX, self.frame.size.height);
    if (self.texA.count > 0) {
        for (int i = 0; i < self.texA.count-1; i++) {
            CGRect rectW = [self.texA[i] boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
            
            CGFloat x = rectW.size.width;
            NSNumber *numb = [NSNumber numberWithFloat:x];
            [mArray addObject:numb];
        }
    }
    
    
    return mArray;
    
}

- (CGRect)keyWordRect:(NSString *)keyWordStr
{
    CGRect rectW = [keyWordStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
    
    return rectW;
}
@end
