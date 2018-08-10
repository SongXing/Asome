//
//  YCBaseView.m
//  YCSDK
//

#import "YCBaseView.h"

@implementation YCBaseView
@synthesize mainBg = _mainBg;


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self propertyPrapare];
        [self bgViewInit];
    }
    return self;
}

- (void)propertyPrapare
{
    self.rate = 0.8f; // 校对比值
    self.curWidth = winWidth;
    self.curHeight = winHeight;
    
    CGFloat realWidthHeightRate = self.curWidth/self.curHeight;
    
    CGFloat originBgWidthOfHeight = 1070/1130.0f; // 原图宽高比
    
    if (realWidthHeightRate >= originBgWidthOfHeight) {
        // 若设备的宽高比大于原图宽高比，则以设备的高度为基准，重新计算宽度
        self.curWidth = self.curHeight / originBgWidthOfHeight;
    } else {
        // 若设备的宽高比小于原图宽高比，则以设备的宽度为基准，重新计算高度
        self.curHeight = self.curWidth * originBgWidthOfHeight;
    }
    
    self.onCalWidth = self.rate*self.curWidth;
    self.onCalHeight = self.rate*self.curHeight*0.8;
}

- (void)bgViewInit
{
    [self setFrame:CGRectMake(0, 0, winWidth, winHeight)];
    [self setBackgroundColor:[UIColor clearColor]];
    
    // bg
   self.mainBg = [[UIImageView alloc] init];
    self.mainBg.userInteractionEnabled = YES;
    [self addSubview:self.mainBg];
    [self.mainBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@(0));
        make.centerY.equalTo(@(0));
        make.width.equalTo(@(self.onCalWidth));
        make.height.equalTo(@(self.onCalHeight));
    }];
    
    self.mainBg.backgroundColor = [UIColor colorWithHexString:@"#F9F6F6"];
    self.mainBg.layer.borderWidth = 1;
    self.mainBg.layer.borderColor = [UIColor colorWithHexString:kGrayHex].CGColor;
    self.mainBg.layer.cornerRadius = 5.0f;
    
    // title image
    UIImageView *titleImage = [[UIImageView alloc] initWithImage:GetImage(@"logo.png")];
    [self.mainBg addSubview:titleImage];
    // 440x98
    CGFloat widthOfImage    = 100*self.rate*self.curWidth/228.0f;
    CGFloat heightOfImage   = 100*self.rate*self.curWidth/228.0f/440.0f*98.0f;
    CGFloat mTopPadding     = 26.0f/self.curWidth * self.onCalHeight;
    [titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(mTopPadding));
        make.centerX.equalTo(@(0));
        make.width.equalTo(@(widthOfImage));
        make.height.equalTo(@(heightOfImage));
    }];
}

@end
