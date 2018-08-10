//
//  Created by Sunny on 17/2/6.
//

#import <Foundation/Foundation.h>
#import "HelloHeader.h"

typedef NS_OPTIONS(NSUInteger, YCProtocolMode)
{
    YCProtocol_YCWebMode,
    YCProtocol_YCAgreement,
};

typedef void(^PTCloseCallback)();

@interface YCProtocol : UIViewController
@property (nonatomic, copy) PTCloseCallback closeCB;

- (instancetype)initWithProtocolMode:(YCProtocolMode)mode optionUrl:(NSString *)optionUrl close:(PTCloseCallback)handler;


@end
