//
//

typedef NS_OPTIONS(NSUInteger, YCViewMode)
{
    YCViewMode_Default,
    YCViewMode_HadLogin,
    YCViewMode_GuestScreenShot,
    YCViewMode_Account,
    YCViewMode_Mobile,
};

#define kGreenHex       @"#8BC34A"
#define kBlackHex       @"#101010"
#define kWhiteHex       @"#FFFFFF"
#define kGrayHex        @"#BBBBBB"

#define kTxtFontName    @"Helvetica"
#define kTxtFontSize    12.0f

#import <UIKit/UIKit.h>
#import "HelloHeader.h"

@interface YCBaseView : UIView

@property (nonatomic, assign) CGFloat rate;
@property (nonatomic, assign) CGFloat curWidth;
@property (nonatomic, assign) CGFloat curHeight;
@property (nonatomic, assign) CGFloat onCalWidth;
@property (nonatomic, assign) CGFloat onCalHeight;
@property (nonatomic, copy)   UIImageView *mainBg;

//- (instancetype)initWithMode:(YCViewMode)mode;

@end
