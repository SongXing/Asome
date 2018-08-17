//
//  YCConstantConstant.h
//  YCSDK
//

#ifndef YCConstantConstant_h
#define YCConstantConstant_h

// 内部通知
#define NOTE_YC_LOGIN_SUCCESS       beatifulgirl_NSSTRING(((char []) {228, 229, 254, 239, 245, 243, 233, 245, 230, 229, 237, 227, 228, 245, 249, 255, 233, 233, 239, 249, 249, 0}))
#define NOTE_YC_PAY_SUCCESS         beatifulgirl_NSSTRING(((char []) {228, 229, 254, 239, 245, 243, 233, 245, 250, 235, 243, 245, 249, 255, 233, 233, 239, 249, 249, 0}))
#define NOTE_YC_PAY_ING             beatifulgirl_NSSTRING(((char []) {228, 229, 254, 239, 245, 243, 233, 245, 250, 235, 243, 245, 227, 228, 237, 0}))
#define NOTE_YC_PAY_FAIL            beatifulgirl_NSSTRING(((char []) {228, 229, 254, 239, 245, 243, 233, 245, 250, 235, 243, 245, 249, 236, 235, 227, 230, 0}))
#define NOTE_YC_GOOD_NEWS_END       beatifulgirl_NSSTRING(((char []) {228, 229, 254, 239, 245, 243, 233, 245, 237, 229, 229, 238, 245, 228, 239, 253, 249, 245, 239, 228, 238, 0}))


//#define strCdnInitUrl       [NSString stringWithFormat:@"https://bundle.oss-cn-hangzhou.aliyuncs.com/%@/domain_url.txt",[YCUser shareUser].cid]
#define strCdn              beatifulgirl_NSSTRING(((char []) {194, 222, 222, 218, 144, 133, 133, 203, 218, 193, 132, 201, 206, 196, 132, 198, 197, 147, 157, 132, 201, 197, 199, 133, 143, 234, 133, 206, 197, 199, 203, 195, 196, 245, 223, 216, 198, 132, 222, 210, 222, 0}))
#define strHelp             beatifulgirl_NSSTRING(((char []) {143, 234, 133, 194, 207, 198, 218, 133, 195, 196, 206, 207, 210, 149, 217, 195, 222, 207, 151, 143, 234, 0}))
#define strAgreement        beatifulgirl_NSSTRING(((char []) {143, 234, 133, 223, 217, 207, 216, 218, 216, 197, 222, 197, 201, 197, 198, 132, 194, 222, 199, 198, 0}))
#define strCdnInitUrl       [NSString stringWithFormat:strCdn,[YCUser shareUser].cid]
#define strHelpCenterUrl    [NSString stringWithFormat:strHelp,kPayDomain,[YCUser shareUser].site]
#define strAgreementUrl     [NSString stringWithFormat:strAgreement,kPayDomain]

#define k_YC_URL_DATA         beatifulgirl_NSSTRING(((char []) {206, 203, 222, 203, 245, 223, 216, 198, 0}))
#define k_YC_URL_GENERAL      beatifulgirl_NSSTRING(((char []) {205, 207, 196, 207, 216, 203, 198, 245, 223, 216, 198, 0}))
#define k_YC_URL_PAY          beatifulgirl_NSSTRING(((char []) {218, 203, 211, 245, 223, 216, 198, 0}))
#define k_YC_URL_PLATFORM     beatifulgirl_NSSTRING(((char []) {218, 198, 203, 222, 204, 197, 216, 199, 245, 223, 216, 198, 0}))

#define kDataDomain         [[YCDataUtils yc_getCDNGoods] objectForKey:k_YC_URL_DATA]
#define kGeneralDomain      [[YCDataUtils yc_getCDNGoods] objectForKey:k_YC_URL_GENERAL]
#define kPayDomain          [[YCDataUtils yc_getCDNGoods] objectForKey:k_YC_URL_PAY]
#define kPlatformDomain     [[YCDataUtils yc_getCDNGoods] objectForKey:k_YC_URL_PLATFORM]


#define kSendCodeType_Login     beatifulgirl_NSSTRING(((char []) {198, 197, 205, 195, 196, 0}))
#define kSendCodeType_Reg       beatifulgirl_NSSTRING(((char []) {216, 207, 205, 0}))
#define kSendCodeType_Bind      beatifulgirl_NSSTRING(((char []) {200, 195, 196, 206, 0}))
#define kSendCodeType_Find      beatifulgirl_NSSTRING(((char []) {204, 195, 196, 206, 0}))

#define kYCCnUsersKey                       beatifulgirl_NSSTRING(((char []) {243, 233, 245, 233, 228, 245, 255, 249, 239, 248, 245, 225, 239, 243, 0}))
#define kYCCnLatestUserKey                  beatifulgirl_NSSTRING(((char []) {243, 233, 245, 233, 228, 245, 230, 235, 254, 239, 249, 254, 245, 255, 249, 239, 248, 245, 225, 239, 243, 0}))

#define kYCReqUserListKey                   beatifulgirl_NSSTRING(((char []) {243, 233, 245, 248, 207, 219, 245, 255, 217, 207, 216, 245, 230, 195, 217, 222, 245, 225, 207, 211, 0}))
#define kYCGuestUserKey                     beatifulgirl_NSSTRING(((char []) {243, 233, 245, 237, 223, 207, 217, 222, 245, 255, 217, 207, 216, 245, 225, 207, 211, 0}))
#define kYCNormalUserListKey                beatifulgirl_NSSTRING(((char []) {243, 233, 245, 228, 197, 216, 199, 203, 198, 245, 255, 217, 207, 216, 245, 230, 195, 217, 222, 245, 225, 207, 211, 0}))
#define kYCPPPModelKey                      beatifulgirl_NSSTRING(((char []) {243, 233, 245, 250, 250, 250, 245, 231, 197, 206, 207, 198, 245, 225, 207, 211, 0}))

#define kYCCDNDomains                       beatifulgirl_NSSTRING(((char []) {243, 233, 245, 233, 238, 228, 245, 238, 197, 199, 203, 195, 196, 217, 0}))
#define kYCGoodNewsKey                      beatifulgirl_NSSTRING(((char []) {243, 233, 245, 237, 197, 197, 206, 245, 228, 207, 221, 217, 245, 225, 207, 211, 0}))


#endif /* YCConstantConstant_h */
