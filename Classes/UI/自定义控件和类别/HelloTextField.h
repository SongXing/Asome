//
//  HelloTextField.h
//
//  Created by Sunny on 17/2/8.
//

#import <UIKit/UIKit.h>

@interface HelloTextField : UITextField

@property (nonatomic, assign) CGFloat initDistance;
@property (nonatomic, assign) CGFloat endEditDistance;
@property (nonatomic, assign) CGFloat leftViewDistance;
@property (nonatomic, assign) CGFloat rightViewDistance;

- (instancetype)initWithFrame:(CGRect)frame
                     leftView:(UIImageView *)left
                    rightView:(UIView *)right;

@end
