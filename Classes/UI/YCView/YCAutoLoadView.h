//
//  YCAutoLoadVIew.h
//  YCSDK
//
//  Created by sunn on 2018/7/19.
//

#import <UIKit/UIKit.h>

typedef void(^GoonCallback)(void);

@interface YCAutoLoadView : UIView

@property (nonatomic, copy) GoonCallback loginCallback;
@property (nonatomic, copy) GoonCallback changeCallback;

- (instancetype)initWithAccountName:(NSString *)name goOnLoginHandler:(GoonCallback)loginHandler changeAccountHandler:(GoonCallback)changeHandler;

- (instancetype)initWhenItsLoginSuccess;

@end
