//
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, YCLoginMode)
{
    YCLogin_Default = 0,
    YCLogin_Account = 1,
    YCLogin_Mobile = YCLogin_Default,
    YCLogin_Register = 2,
    YCLogin_ChangeAccount,
    YCLogin_FastToDefault,
    YCLogin_DirectToRegister,
};

@interface YCLoginView : UIView <UITextFieldDelegate, UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UITextViewDelegate>

- (instancetype)initWithMode:(YCLoginMode)mode;

@end
