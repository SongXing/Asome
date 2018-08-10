//
//  HelloUtils.h
//
//  Created by Sunny on 17/2/6.
//  Copyright © 2017年 f. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class HelloTextField;

@interface HelloUtils : NSObject


#pragma mark - UI

+ (UIButton *)yc_rightViewWithImage:(NSString *)image tag:(NSUInteger)tag selector:(SEL)selector target:(id)targer;

+ (UIButton *)initBtnWithNormalImage:(NSString *)normalImageName
                    highlightedImage:(NSString *)highlightedImageName
                                 tag:(NSUInteger)tag
                            selector:(SEL)selector
                              target:(id)target;

+ (UIButton *)initBtnWithTitle:(NSString *)titleText
                           tag:(NSUInteger)tag
                      selector:(SEL)selector
                        target:(id)target;

+ (UIButton *)yc_initBtnWithTitle:(NSString *)titleText
                              tag:(NSUInteger)tag
                         selector:(SEL)selector
                           target:(id)target;

+ (UIButton *)initBtnWithType:(UIButtonType)type
                        title:(NSString *)titleText
                          tag:(NSUInteger)tag
                     selector:(SEL)selector
                       target:(id)target;

+ (HelloTextField *)customTextfieldWidgetWithLeftView:(NSString *)imageName
                                            rightView:(UIView *)right
                                          placeholder:(NSString *)placeholder
                                             delegate:(id)delegate;

#pragma mark Calculate Label Size

+ (CGSize)calculateSizeOfString:(NSMutableAttributedString *)str;
+ (CGSize)calculateSizeOfString:(NSString *)str withFont:(UIFont *)font;
+ (CGSize)calculateSizeOfLabel:(UILabel *)label;
+ (CGSize)calculateSizeOfLabel:(UILabel *)label andWidth:(CGFloat)width;

#pragma mark - Toast

+ (void)spToastWithMsg:(NSString *)msg;
+ (void)spToastWithMsg:(NSString *)msg atView:(UIView *)baseView;
// loading
+ (void)spStarLoadingAtView:(UIView *)baseView;
+ (void)spStopLoadingAtView:(UIView *)baseView;

#pragma mark - NSUserDefault

+ (void)yc_userdefault_setObj:(id)obj key:(id)key;
+ (id)yc_userdefault_getObjforKey:(id)key;


#pragma mark - Others

+ (void)makeTextFieldPlaceHolderProperty:(UITextField *)textField;

+ (NSString *)triString:(NSString *)aStr;

#pragma mark - 输入正则

+ (BOOL)validUserName:(NSString *)userName;

+ (BOOL)validEmailFormat:(UITextField *)textField;

+ (BOOL)validPassWord:(NSString *)pwd;

+ (BOOL)validCnMobileNumber:(NSString *)mobileNum;

#pragma mark - 正则不通过的提示语

+ (void)invalidNameToast;
+ (void)invalidPwdToast;
+ (void)invalidPhoneToast;
+ (void)invalidEmailToast;
+ (void)invalidVertifyCodeToast;
+ (void)disagreeAgreeementToast;

#pragma mark - 按钮倒计时

+ (void)     counttingButton:(UIButton *)sender
                   startTime:(NSInteger)timeLine
                       title:(NSString *)title
              countDownTitle:(NSString *)subTitle
                   mainColor:(UIColor *)mColor
                  countColor:(UIColor *)countColor;

#pragma mark - 调到 Safari

+ (void)yc_showSomeSenceOnSafari:(NSString *)urlStr;

#pragma mark - Post Note

#pragma mark - Post Note

+ (void)yc_postNoteWithName:(NSString *)name userInfo:(NSDictionary *)dict;


#pragma mark - YC Curent Size

+ (CGRect)ycu_getCurrentScreenFrame;

#pragma mark - Capture Image

+ (void)ycu_saveNewRegAccountToPhoto:(UIView *)curView;

+ (NSString *)ycu_paraseObjToStr:(id)obj;

@end
