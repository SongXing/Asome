//
//  YCViewConstant.h
//  YCSDK
//
//  Created by sunn on 2018/7/11.
//

#ifndef YCViewConstant_h
#define YCViewConstant_h

#define kGreenHex       @"#8BC34A"
#define kBlackHex       @"#101010"
#define kWhiteHex       @"#FFFFFF"
#define kGrayHex        @"#BBBBBB"
#define kBgGrayHex      @"#F8FAFD"//@"#F9F6F6"

//#define arrWonderfulWordColor (@[@"#F1FAFD",@"#F2FAAD",@"#F3FAFD",@"#F4BAFD",@"#F5FBBD",@"#F6FDDD",@"#F7FAFF"])
//#define kBgGrayHex arrWonderfulWordColor[arc4random() % ([arrWonderfulWordColor count])]

#define kTxtFontName    @"Helvetica"
#define kTxtFontSize    device_is_iPhone5?12.0f:14.0f
#define kTxtFontBigSize device_is_iPhone5?14.0f:18.0f

//#define strCdnInitUrl       [NSString stringWithFormat:@"https://bundle.oss-cn-hangzhou.aliyuncs.com/%@/domain_url.txt",[YCUser shareUser].cid]
#define strCdnInitUrl       [NSString stringWithFormat:@"http://apk.cdn.lo97.com/%@/domain_url.txt",[YCUser shareUser].cid]
#define strHelpCenterUrl    [NSString stringWithFormat:@"%@/help/index?site=%@",kPayDomain,[YCUser shareUser].site]
#define strAgreementUrl     [NSString stringWithFormat:@"%@/userprotocol.html",kPayDomain]


#define k_YC_URL_DATA         @"data_url"
#define k_YC_URL_GENERAL      @"general_url"
#define k_YC_URL_PAY          @"pay_url"
#define k_YC_URL_PLATFORM     @"platform_url"

#define kDataDomain         [[YCDataUtils yc_getCDNGoods] objectForKey:k_YC_URL_DATA]
#define kGeneralDomain      [[YCDataUtils yc_getCDNGoods] objectForKey:k_YC_URL_GENERAL]
#define kPayDomain          [[YCDataUtils yc_getCDNGoods] objectForKey:k_YC_URL_PAY]
#define kPlatformDomain     [[YCDataUtils yc_getCDNGoods] objectForKey:k_YC_URL_PLATFORM]

// tags

#define kYCBaseMainBgViewTag        1169
#define kYCLoginMainBgViewTag       1170

#define kMainGameCenterBtnTag       9000
#define kProtocolCloseBtnTag        9001
#define kProtocolBackBtnTag         9002
#define kMainLoginBtnTag            9003
#define kMainFbLoginBtnTag          9004
#define kMainGoogleLoginBtnTag      9005
#define kMainGuestLoginBtnTag       9006
#define kLoginBackBtnTag            9007
#define kLoginDamnBackBtnTag        9107
#define kLoginComfirmBtnTag         9008
#define kLoginSignInBtnTag          9009
#define kLoginResetPwdBtnTag        9010
#define kLoginFindPwdBtnTag         9011
#define kRegisterComfirmBtnTag      9012
#define kRegisterBackBtnTag         9013
#define kRegisterResetComfirmBtnTag     9014
#define kRegisterFindComfirmBtnTag      9015

#define kAlertCancelBtnTag              9016
#define kAlertComfirmBtnTag             9017

#define kAgreeCheckOneBtnTag            9018
#define kAgreeCheckTwoBtnTag            9019
#define kAdwallBackBtnTag               9020
#define kAdwallCloseBtnTag              9021
#define kAdwallCheckBtnTag              9022

#define kRegisterBindComfirmBtnTag          9023
#define kSpaceProtocolBackBtnTag            9024

#define kYCLoginHelpCenterBtnTag            9026
#define kYCLoginMobileFastLoginBtnTag       9027
#define kYCLoginGuestBtnTag                 9028
#define kYCLoginAccountLoginBtnTag          9029
#define kYCLoginRegisterAccountBtnTag       9030
#define kYCLoginForgetPwdBtnTag             9031
#define kYCLoginBindMobilePhoneBtnTag       9032
#define kYCLoginEyeBtnTag                   9033
#define kYCLoginChangeAccountBtnTag         9034

// protocol
// custom service
#define topItemHeight               40.0f
// iPhone X padding
#define iphoneX_landscape_left      44.0f
#define iphoneX_landscape_right     44.0f
#define iphoneX_landscape_bottom    21.0f

// ipad resize 如此处理是为了在ipad上界面不至于被拉伸的太严重，仍旧保持比例  736 414 (iphone 8 Plus 的物理尺寸)
#define calculatedWidthAtIPad       736.0f
#define calculatedHeightAtIPad      414.0f

#define closeBtnName_normal             @"sdk_btn_close.png"
#define closeBtnName_highlighted        @"sdk_btn_close.png"
#define backBtnName_normal              @"sdk_btn_back.png"
#define backBtnName_highlighted         @"sdk_btn_back_d.png"
#define bottom_bg                       @"sdk_bottom_bg.png"
#define checkbox_unChecked              @"sdk_checkbox.png"
#define checkbox_checked                @"sdk_checkbox_2.png" // 88*100
#define backBtn_normal                  @"sdk_btn_back.png"
#define backBtn_highlighted             @"sdk_btn_back_d.png"
#define eyeBtn_on                       @"py_eye_focus.png"
#define eyeBtn_off                      @"py_eye_normal.png"
#define termBtn_check                   @"btn_image_select.png"
#define termBtn_uncheck                 @"btn_image_unselect.png"
#define seperateline                    @"sdk_i_link.png" // 914*5
#define userListBtn_down                @"btn_arrow_down.png"
#define user_list_close_btn_name        @"btn_list_close.png"



#define kSendCodeType_Login     @"login"
#define kSendCodeType_Reg       @"reg"
#define kSendCodeType_Bind      @"bind"
#define kSendCodeType_Find      @"find"

#endif /* YCViewConstant_h */
