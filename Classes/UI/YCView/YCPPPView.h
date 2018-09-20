//
//  YCPPPView.h
//  YCSDK
//
//  Created by sunn on 2018/7/11.
//

#import <UIKit/UIKit.h>
@class YCPPPModel;
@interface YCPPPView : UIView

- (instancetype)initWithProvision:(NSDictionary *)dict;

- (instancetype)initWithProvision:(NSDictionary *)dict withModle:(YCPPPModel *)model;

@end
