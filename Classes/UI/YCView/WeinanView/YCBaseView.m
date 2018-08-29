//
//  YCBaseView.m
//  YCSDK
//
//  Created by sunn on 2018/8/13.
//  Copyright © 2018年 . All rights reserved.
//

#import "YCBaseView.h"
#import "HelloHeader.h"

@implementation YCBaseView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self ycb_popertyInit];
        [self ycb_baseViewInit];
    }
    return self;
}

- (void)ycb_popertyInit
{
    self.rate = 0.8f; // 校对比值
    self.curWidth = winWidth;
    self.curHeight = winHeight;
    
    if (IS_IPAD) {
        self.curWidth = calculatedWidthAtIPad;
        self.curHeight = calculatedHeightAtIPad;
    }
    
    CGFloat realWidthHeightRate = self.curWidth/self.curHeight;
    
    self.originBgWidthOfHeight = 1070/1130.0f; // 原图宽高比
    
    if (realWidthHeightRate >= self.originBgWidthOfHeight) {
        // 若设备的宽高比大于原图宽高比，则以设备的高度为基准，重新计算宽度
        self.curWidth = self.curHeight / self.originBgWidthOfHeight;
    } else {
        // 若设备的宽高比小于原图宽高比，则以设备的宽度为基准，重新计算高度
        self.curHeight = self.curWidth * self.originBgWidthOfHeight;
    }
    
    self.loginBtnWidthOfBgWidth = 914/1070.0f;
    self.loginBtnHeightOfBgHeight = 172/1130.0f;
    self.findPwdBtnWidthOfBgWidth = 300/1070.0f;
    self.findPwdBtnHeightOfBgHeight = 62/1130.0f;
    self.textFieldHeightOfBgHeight = 140/1130.0f;//150/1130.0f;//
    self.topPadding = 24/1130.0f;
    self.leftPadding = 24/1070.0f;
    self.anotherLeftPadding = 78/1130.0f;
    self.findBtnLeftPadding = (78+80)/1130.0f;
    self.gapPadding = 30/1130.0f;
    self.anotherGapPadding = 50/1130.0f;// origin 80
    self.thirdGapPadding = 64/1130.0f; // origin 34
    self.lineTopPadding = (156+172*4+50*3+70)/1130.0f;
    self.backBtnWidthAndHeight = 100.0f/1130.0f;
    
    self.keyboarHeight = keyboardInitH;
    self.onCalWidth = self.rate * self.curWidth;
    self.onCalHeight = self.rate * self.curHeight;
    if (device_is_iPhoneX) {
        self.onCalHeight    = self.rate * self.curHeight * self.rate;
        self.onCalWidth     = self.onCalHeight / self.originBgWidthOfHeight ;
    }
}

- (void)ycb_baseViewInit
{
    [self setFrame:CGRectMake(0, 0, winWidth, winHeight)];
    [self setBackgroundColor:[UIColor clearColor]];
    
    // bg
    self.mainBg = [[UIImageView alloc] init];
    self.mainBg.userInteractionEnabled = YES;
    self.mainBg.tag = kYCBaseMainBgViewTag;
    [self addSubview:self.mainBg];
//    [self.mainBg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(@(0));
//        make.centerY.equalTo(@(0));
//        make.width.equalTo(@(self.rate*self.curWidth));
//        make.height.equalTo(@(self.rate*self.curHeight*0.8));
//    }];
    
    self.mainBg.backgroundColor = [UIColor colorWithHexString:kBgGrayHex];
    self.mainBg.layer.borderWidth = 1;
    self.mainBg.layer.borderColor = [UIColor colorWithHexString:kGrayHex].CGColor;
    self.mainBg.layer.cornerRadius = 5.0f;
}

@end
