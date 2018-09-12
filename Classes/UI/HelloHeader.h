//
//  HelloHeader.h
//
//
//  Created by Sunny on 17/2/6.
//

#ifndef HelloHeader_h
#define HelloHeader_h

// --
#import "HelloUtils.h"
#import "Masonry.h"
#import "YCFreeLogin.h"
#import "SPCentreInfo.h"
#import "SPFunction.h"
#import "UIImage+SPBundleImage.h"
#import "SPCommonHeader.h"
#import "SPUserInfoModel.h"
#import "UIColor+HexColor.h"
#import "SPRequestor.h"
#import "YCLoginFunction.h"
#import "YCIapFunction.h"
#import "NetEngine.h"
#import "YCUserModel.h"
#import "YCLoginView.h"
#import "YCViewConstant.h"
#import "YCBindView.h"
#import "YCPPPView.h"
#import "YCDataUtils.h"
#import "YCPPPModel.h"
#import "YCProtocol.h"
#import "YCUser.h"
#import "YCSDK.h"
#import "YCAutoLoadView.h"
#import "HelloTextField.h"
#import "UIColor+HexColor.h"
#import "YCScrollTextView.h"

#import "YCRollBgView.h"
#import "YCRollingView.h"

#import "YCBaseView.h"
#import "YCWeinanView.h"

#import "YCBeatifulGirl.h"
#import "SUPRSA.h"

#import "YCConstantConstant.h"
#import "YCOpenUDID.h"

// interfaceview select
#define bIsUseWeinanView        (@1)

// ---- constant
#define winWidth                [HelloUtils ycu_getCurrentScreenFrame].size.width
#define winHeight               [HelloUtils ycu_getCurrentScreenFrame].size.height

#define hillTopViewController   [SPFunction getCurrentViewController]
#define MainWindow              [UIApplication sharedApplication].windows[0]

// ----  imagePicker
//#define GetImage(imageName)     [UIImage sp_imageNamed:imageName]// 在iOS11.4.1设备上读取不到图片
#define GetImage(imageName)     [HelloUtils uuGetImageWithNamed:imageName]

// color
#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]


#define device_is_iPhoneX (CGSizeEqualToSize(CGSizeMake(375.f, 812.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(812.f, 375.f), [UIScreen mainScreen].bounds.size))
#define device_is_iPhone5 (CGSizeEqualToSize(CGSizeMake(320.f, 568.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(568.f, 320.f), [UIScreen mainScreen].bounds.size))


#define keyboardInitH           260.0f
#define tRotaTomeInterval       0.3f
#define tLoginedTimeInterval    2.0f

#define POST_NOTE(name)             [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];


#endif /* HelloHeader_h */
