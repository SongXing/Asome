//
//  YCBaseView.h
//  YCSDK
//
//  Created by sunn on 2018/8/13.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCBaseView : UIView

@property (nonatomic) CGFloat rate ; // 校对比值
@property (nonatomic) CGFloat curWidth ;
@property (nonatomic) CGFloat curHeight ;
@property (nonatomic) CGFloat originBgWidthOfHeight;// 背景图片宽高比
@property (nonatomic) CGFloat loginBtnWidthOfBgWidth;
@property (nonatomic) CGFloat loginBtnHeightOfBgHeight;
@property (nonatomic) CGFloat findPwdBtnWidthOfBgWidth;
@property (nonatomic) CGFloat findPwdBtnHeightOfBgHeight;
@property (nonatomic) CGFloat textFieldHeightOfBgHeight;
@property (nonatomic) CGFloat topPadding;
@property (nonatomic) CGFloat leftPadding;
@property (nonatomic) CGFloat findBtnLeftPadding;
@property (nonatomic) CGFloat anotherLeftPadding;
@property (nonatomic) CGFloat gapPadding;
@property (nonatomic) CGFloat anotherGapPadding;
@property (nonatomic) CGFloat thirdGapPadding;
@property (nonatomic) CGFloat lineTopPadding;
@property (nonatomic) CGFloat backBtnWidthAndHeight;

@property (nonatomic) CGFloat onCalWidth ;
@property (nonatomic) CGFloat onCalHeight ;

@property (nonatomic) CGFloat keyboarHeight;
@property (nonatomic) CGFloat animatedDistance;

@property (nonatomic, strong) UIImageView *mainBg;


@end
