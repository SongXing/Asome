
#import "YCRollBgView.h"
#import "HelloHeader.h"

static float bgViewH = 44 * 0.6;

@interface YCRollBgView ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign) BOOL isPortrait;
@property (nonatomic, strong) YCRollingView *rollingView;
@property (nonatomic, strong) UIImageView *iamgeV;
@property (nonatomic, strong) UIButton *rightBtn;
@end

@implementation YCRollBgView

- (id)init
{
    self = [super init];
    if (self) {
        _isShow = NO;
        self.isPortrait = UIInterfaceOrientationIsPortrait([[YCUser shareUser] gameOrientation]);
    }
    
    return self;
}

- (BOOL)isShow;
{
    return _isShow;
}

- (void)show
{
    // 适配iPhoneX。横屏，所有各留44
    // 竖版，上方留44
    if (device_is_iPhoneX) {
        if (self.isPortrait) {
            self.frame = CGRectMake(0, iphoneX_landscape_left, [UIScreen mainScreen].bounds.size.width, bgViewH);
        } else {
            self.frame = CGRectMake(iphoneX_landscape_left, 0, [UIScreen mainScreen].bounds.size.width-iphoneX_landscape_left*2, bgViewH);
        }
    } else {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, bgViewH);
    }
    
    self.backgroundColor = [UIColor whiteColor];
    self.alpha = 0.6;
    
    // 添加左右UI
    [self addLeftandRigthUI];
    
}

- (void)addLeftandRigthUI
{
    self.iamgeV = [[UIImageView alloc] initWithImage:GetImage(@"p_horn.png")];
    self.iamgeV.frame = CGRectMake(0, 0, bgViewH, bgViewH);
    
    [self addSubview:self.iamgeV];
    
    
//    data = "";
//    isShow = 0;
//    time = "";
//    url = "";
    NSDictionary *dic = [YCDataUtils ycd_getGoodNews];
    NSString *adStr = dic[kRespStrData];
    NSString *urlStr = dic[kRespStrUrl];
    self.rollingView = [[YCRollingView alloc] initWithShowStr:adStr andURLStr:urlStr];

    [self addSubview:self.rollingView];
    [self.rollingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iamgeV.mas_right);
        make.right.equalTo(@(-bgViewH));
        make.bottom.equalTo(@(0));
        make.top.equalTo(@(0));
    }];
    
    
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _rightBtn.frame = CGRectMake(bgViewH + self.rollingView.frame.size.width, 0, bgViewH, bgViewH);;
    [_rightBtn setBackgroundImage:GetImage(@"p_rollclose.png") forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightBtn];
    _rightBtn.adjustsImageWhenHighlighted = NO;
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@(0));
        make.right.equalTo(@(0));
        make.width.equalTo(@(bgViewH));
        make.height.equalTo(@(bgViewH));
    }];
    
    _isShow = YES;
    
}

- (void)rightBtnClick:(UIButton *)sender
{
    _isShow = NO;
    [self.iamgeV removeFromSuperview];
    [self.rightBtn removeFromSuperview];
    [self.rollingView removeFromSuperview];
    [self removeFromSuperview];
    
    // 添加倒计时通知
    POST_NOTE(NOTE_YC_GOOD_NEWS_END);
}

@end
