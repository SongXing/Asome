//
//  YCScrollTextView.h
//  YCSDK
//
//  Created by sunn on 2018/7/25.
//

#import <UIKit/UIKit.h>

@interface YCScrollTextView : UIView 

@property (nonatomic, strong) NSArray *arrData;
@property (nonatomic, assign) NSUInteger  rollTimeTotal;

- (void)stopSrolling;

@end
