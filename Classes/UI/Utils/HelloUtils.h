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

+ (UIButton *)ycu_rightViewWithImage:(NSString *)image tag:(NSUInteger)tag selector:(SEL)selector target:(id)targer;

+ (UIButton *)ycu_initBtnWithNormalImage:(NSString *)normalImageName
                    highlightedImage:(NSString *)highlightedImageName
                                 tag:(NSUInteger)tag
                            selector:(SEL)selector
                              target:(id)target;

+ (UIButton *)ycu_initBtnWithTitle:(NSString *)titleText
                           tag:(NSUInteger)tag
                      selector:(SEL)selector
                        target:(id)target;

+ (UIButton *)yc_initBtnWithTitle:(NSString *)titleText
                              tag:(NSUInteger)tag
                         selector:(SEL)selector
                           target:(id)target;

+ (UIButton *)ycu_initBtnWithType:(UIButtonType)type
                        title:(NSString *)titleText
                          tag:(NSUInteger)tag
                     selector:(SEL)selector
                       target:(id)target;

+ (HelloTextField *)ycu_customTextfieldWidgetWithLeftView:(NSString *)imageName
                                            rightView:(UIView *)right
                                          placeholder:(NSString *)placeholder
                                             delegate:(id)delegate;

#pragma mark Calculate Label Size

+ (CGSize)ycu_calculateSizeOfString:(NSMutableAttributedString *)str;
+ (CGSize)ycu_calculateSizeOfString:(NSString *)str withFont:(UIFont *)font;
+ (CGSize)ycu_calculateSizeOfLabel:(UILabel *)label;
+ (CGSize)ycu_calculateSizeOfLabel:(UILabel *)label andWidth:(CGFloat)width;

#pragma mark - Toast

+ (void)ycu_sToastWithMsg:(NSString *)msg;
+ (void)ycu_sToastWithMsg:(NSString *)msg atView:(UIView *)baseView;
// loading
+ (void)ycu_sStarLoadingAtView:(UIView *)baseView;
+ (void)ycu_sStopLoadingAtView:(UIView *)baseView;

#pragma mark - NSUserDefault

+ (void)ycu_userdefault_setObj:(id)obj key:(id)key;
+ (id)ycu_userdefault_getObjforKey:(id)key;


#pragma mark - Others

+ (void)ycu_makeTextFieldPlaceHolderProperty:(UITextField *)textField;

+ (NSString *)ycu_triString:(NSString *)aStr;

#pragma mark - 输入正则

+ (BOOL)validUserName:(NSString *)userName;

+ (BOOL)validEmailFormat:(UITextField *)textField;

+ (BOOL)validPassWord:(NSString *)pwd;

+ (BOOL)validCnMobileNumber:(NSString *)mobileNum;

#pragma mark - 正则不通过的提示语

+ (void)ycu_invalidNameToast;
+ (void)ycu_invalidPwdToast;
+ (void)ycu_invalidPhoneToast;
+ (void)ycu_invalidEmailToast;
+ (void)ycu_invalidVertifyCodeToast;
+ (void)ycu_disagreeAgreeementToast;

#pragma mark - 按钮倒计时

+ (void)     ycu_counttingButton:(UIButton *)sender
                   startTime:(NSInteger)timeLine
                       title:(NSString *)title
              countDownTitle:(NSString *)subTitle
                   mainColor:(UIColor *)mColor
                  countColor:(UIColor *)countColor;

#pragma mark - 调到 Safari

+ (void)ycu_showSomeSenceOnSafari:(NSString *)urlStr;


#pragma mark - Post Note

+ (void)ycu_postNoteWithName:(NSString *)name userInfo:(NSDictionary *)dict;


#pragma mark - YC Curent Size

+ (CGRect)ycu_getCurrentScreenFrame;

#pragma mark - Capture Image

+ (void)ycu_saveNewRegAccountToPhoto:(UIView *)curView;

#pragma mark - 对象字符串化

+ (NSString *)ycu_paraseObjToStr:(id)obj;

#pragma mark - 获取出口 IP

+ (NSString *)ycu_ipAddress;

@end
