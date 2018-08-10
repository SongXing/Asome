//
//  HelloTextField.m
//
//  Created by Sunny on 17/2/8.
//

#import "HelloTextField.h"

@implementation HelloTextField

- (instancetype)initWithFrame:(CGRect)frame leftView:(UIImageView *)left rightView:(UIView *)right
{
    self = [super initWithFrame:frame];
    if (self) {
        self.leftView = left;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.rightView = right;
        self.rightViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

// left view padding
- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += self.leftViewDistance;
    return iconRect;
}
// right view padding
- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super rightViewRectForBounds:bounds];
    iconRect.origin.x -= self.rightViewDistance;
    return iconRect;
}

// text area
- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+self.initDistance, bounds.origin.y, bounds.size.width-25-self.initDistance - self.endEditDistance, bounds.size.height);// 25 是关闭按钮的位置
    return inset;
}

// mouse position
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+self.initDistance, bounds.origin.y, bounds.size.width-25-self.initDistance - self.endEditDistance, bounds.size.height);
    return inset;
}



@end
