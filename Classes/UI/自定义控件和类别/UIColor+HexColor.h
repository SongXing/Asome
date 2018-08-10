//
//  UIColor+HexColor.h
//  YCSDK
//
//  Created by sunn on 2017/6/27.
//  Copyright © 2017年 sunn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColor)

// 颜色转换：iOS中（以#开头）十六进制的颜色转换为UIColor(RGB)
+ (UIColor *) colorWithHexString:(NSString *)color;

// 加上 alpha 值
+ (UIColor *) colorWithHexString: (NSString *)color andAlpha:(CGFloat)alpha;

@end
