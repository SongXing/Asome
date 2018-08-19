//
//  YCConstantConstant.h
//  YCSDK
//

#ifndef YCConstantConstant_h
#define YCConstantConstant_h

// 内部通知
#define NOTE_YC_LOGIN_SUCCESS       beatifulgirl_NSSTRING(((char []) {229, 228, 255, 238, 244, 242, 232, 244, 231, 228, 236, 226, 229, 244, 248, 254, 232, 232, 238, 248, 248, 0}))
#define NOTE_YC_PAY_SUCCESS         beatifulgirl_NSSTRING(((char []) {229, 228, 255, 238, 244, 242, 232, 244, 251, 234, 242, 244, 248, 254, 232, 232, 238, 248, 248, 0}))
#define NOTE_YC_PAY_ING             beatifulgirl_NSSTRING(((char []) {229, 228, 255, 238, 244, 242, 232, 244, 251, 234, 242, 244, 226, 229, 236, 0}))
#define NOTE_YC_PAY_FAIL            beatifulgirl_NSSTRING(((char []) {229, 228, 255, 238, 244, 242, 232, 244, 251, 234, 242, 244, 248, 237, 234, 226, 231, 0}))
#define NOTE_YC_GOOD_NEWS_END       beatifulgirl_NSSTRING(((char []) {229, 228, 255, 238, 244, 242, 232, 244, 236, 228, 228, 239, 244, 229, 238, 252, 248, 244, 238, 229, 239, 0}))


#define strCdnInitUrlMayun       [NSString stringWithFormat:beatifulgirl_NSSTRING(((char []) {195, 223, 223, 219, 216, 145, 132, 132, 201, 222, 197, 207, 199, 206, 133, 196, 216, 216, 134, 200, 197, 134, 195, 202, 197, 204, 209, 195, 196, 222, 133, 202, 199, 194, 210, 222, 197, 200, 216, 133, 200, 196, 198, 132, 142, 235, 132, 207, 196, 198, 202, 194, 197, 244, 222, 217, 199, 133, 223, 211, 223, 0})),[YCUser shareUser].cid]
#define strCdn              beatifulgirl_NSSTRING(((char []) {195, 223, 223, 219, 145, 132, 132, 202, 219, 192, 133, 200, 207, 197, 133, 199, 196, 146, 156, 133, 200, 196, 198, 132, 142, 235, 132, 207, 196, 198, 202, 194, 197, 244, 222, 217, 199, 133, 223, 211, 223, 0}))
#define strHelp             beatifulgirl_NSSTRING(((char []) {142, 235, 132, 195, 206, 199, 219, 132, 194, 197, 207, 206, 211, 148, 216, 194, 223, 206, 150, 142, 235, 0}))
#define strAgreement        beatifulgirl_NSSTRING(((char []) {142, 235, 132, 222, 216, 206, 217, 219, 217, 196, 223, 196, 200, 196, 199, 133, 195, 223, 198, 199, 0}))
#define strCdnInitUrl       [NSString stringWithFormat:strCdn,[YCUser shareUser].cid]
#define strHelpCenterUrl    [NSString stringWithFormat:strHelp,kPayDomain,[YCUser shareUser].site]
#define strAgreementUrl     [NSString stringWithFormat:strAgreement,kPayDomain]

#define k_YC_URL_DATA         beatifulgirl_NSSTRING(((char []) {207, 202, 223, 202, 244, 222, 217, 199, 0}))
#define k_YC_URL_GENERAL      beatifulgirl_NSSTRING(((char []) {204, 206, 197, 206, 217, 202, 199, 244, 222, 217, 199, 0}))
#define k_YC_URL_PAY          beatifulgirl_NSSTRING(((char []) {219, 202, 210, 244, 222, 217, 199, 0}))
#define k_YC_URL_PLATFORM     beatifulgirl_NSSTRING(((char []) {219, 199, 202, 223, 205, 196, 217, 198, 244, 222, 217, 199, 0}))

#define kDataDomain         [[YCDataUtils yc_getCDNGoods] objectForKey:k_YC_URL_DATA]
#define kGeneralDomain      [[YCDataUtils yc_getCDNGoods] objectForKey:k_YC_URL_GENERAL]
#define kPayDomain          [[YCDataUtils yc_getCDNGoods] objectForKey:k_YC_URL_PAY]
#define kPlatformDomain     [[YCDataUtils yc_getCDNGoods] objectForKey:k_YC_URL_PLATFORM]


#define kSendCodeType_Login     beatifulgirl_NSSTRING(((char []) {199, 196, 204, 194, 197, 0}))
#define kSendCodeType_Reg       beatifulgirl_NSSTRING(((char []) {217, 206, 204, 0}))
#define kSendCodeType_Bind      beatifulgirl_NSSTRING(((char []) {201, 194, 197, 207, 0}))
#define kSendCodeType_Find      beatifulgirl_NSSTRING(((char []) {205, 194, 197, 207, 0}))

#define kYCCnUsersKey                       beatifulgirl_NSSTRING(((char []) {242, 232, 244, 232, 229, 244, 254, 248, 238, 249, 244, 224, 238, 242, 0}))
#define kYCCnLatestUserKey                  beatifulgirl_NSSTRING(((char []) {242, 232, 244, 232, 229, 244, 231, 234, 255, 238, 248, 255, 244, 254, 248, 238, 249, 244, 224, 238, 242, 0}))

#define kYCReqUserListKey                   beatifulgirl_NSSTRING(((char []) {242, 232, 244, 249, 206, 218, 244, 254, 216, 206, 217, 244, 231, 194, 216, 223, 244, 224, 206, 210, 0}))
#define kYCGuestUserKey                     beatifulgirl_NSSTRING(((char []) {242, 232, 244, 236, 222, 206, 216, 223, 244, 254, 216, 206, 217, 244, 224, 206, 210, 0}))
#define kYCNormalUserListKey                beatifulgirl_NSSTRING(((char []) {242, 232, 244, 229, 196, 217, 198, 202, 199, 244, 254, 216, 206, 217, 244, 231, 194, 216, 223, 244, 224, 206, 210, 0}))
#define kYCPPPModelKey                      beatifulgirl_NSSTRING(((char []) {242, 232, 244, 251, 251, 251, 244, 230, 196, 207, 206, 199, 244, 224, 206, 210, 0}))

#define kYCCDNDomains                       beatifulgirl_NSSTRING(((char []) {242, 232, 244, 232, 239, 229, 244, 239, 196, 198, 202, 194, 197, 216, 0}))
#define kYCGoodNewsKey                      beatifulgirl_NSSTRING(((char []) {242, 232, 244, 236, 196, 196, 207, 244, 229, 206, 220, 216, 244, 224, 206, 210, 0}))

#define kYCConfigKey        beatifulgirl_NSSTRING(((char []) {242, 232, 224, 206, 210, 0}))
#define kYCConfigSite       beatifulgirl_NSSTRING(((char []) {242, 232, 248, 194, 223, 206, 0}))
#define kYCConfigAid        beatifulgirl_NSSTRING(((char []) {242, 232, 234, 194, 207, 0}))
#define kYCConfigCid        beatifulgirl_NSSTRING(((char []) {242, 232, 232, 194, 207, 0}))

// 参数类型
//#define strConstOutSide_LOGIN_SUCCUESS       beatifulgirl_NSSTRING(((char []) {232, 228, 229, 248, 255, 244, 229, 228, 255, 238, 244, 242, 232, 244, 231, 228, 236, 226, 229, 244, 248, 254, 232, 232, 254, 238, 248, 248, 0}))
//#define strConstOutSide_PAY_SUCCUESS         beatifulgirl_NSSTRING(((char []) {232, 228, 229, 248, 255, 244, 229, 228, 255, 238, 244, 242, 232, 244, 251, 234, 242, 244, 248, 254, 232, 232, 254, 238, 248, 248, 0}))
//#define strConstOutSide_PAY_PUCHESSING       beatifulgirl_NSSTRING(((char []) {232, 228, 229, 248, 255, 244, 229, 228, 255, 238, 244, 242, 232, 244, 251, 234, 242, 244, 251, 254, 232, 227, 238, 248, 248, 226, 229, 236, 0}))
//#define strConstOutSide_PAY_FAIL             beatifulgirl_NSSTRING(((char []) {232, 228, 229, 248, 255, 244, 229, 228, 255, 238, 244, 242, 232, 244, 251, 234, 242, 244, 237, 234, 226, 231, 0}))
//
//#define strConstOutSide_PRM_ROLE_ID             beatifulgirl_NSSTRING(((char []) {210, 200, 244, 219, 202, 217, 202, 198, 244, 217, 196, 199, 206, 244, 194, 207, 0}))
//#define strConstOutSide_PRM_ROLE_NAME           beatifulgirl_NSSTRING(((char []) {210, 200, 244, 219, 202, 217, 202, 198, 244, 217, 196, 199, 206, 244, 197, 202, 198, 206, 0}))
//#define strConstOutSide_PRM_ROLE_LEVEL          beatifulgirl_NSSTRING(((char []) {210, 200, 244, 219, 202, 217, 202, 198, 244, 217, 196, 199, 206, 244, 199, 206, 221, 206, 199, 0}))
//#define strConstOutSide_PRM_ROLE_SERVER_ID      beatifulgirl_NSSTRING(((char []) {210, 200, 244, 219, 202, 217, 202, 198, 244, 217, 196, 199, 206, 244, 216, 206, 217, 221, 206, 217, 244, 194, 207, 0}))
//#define strConstOutSide_PRM_ROLE_SERVER_NAME    beatifulgirl_NSSTRING(((char []) {210, 200, 244, 219, 202, 217, 202, 198, 244, 217, 196, 199, 206, 244, 216, 206, 217, 221, 206, 217, 244, 197, 202, 198, 206, 0}))
//#define strConstOutSide_PRM_PAY_PRODUCT_ID      beatifulgirl_NSSTRING(((char []) {210, 200, 244, 219, 202, 217, 202, 198, 244, 219, 202, 210, 244, 219, 217, 196, 207, 222, 200, 223, 244, 194, 207, 0}))
//#define strConstOutSide_PRM_PAY_PRODUCT_PRICE   beatifulgirl_NSSTRING(((char []) {210, 200, 244, 219, 202, 217, 202, 198, 244, 219, 202, 210, 244, 219, 217, 196, 207, 222, 200, 223, 244, 219, 217, 194, 200, 206, 0}))
//#define strConstOutSide_PRM_PAY_PRODUCT_NAME    beatifulgirl_NSSTRING(((char []) {210, 200, 244, 219, 202, 217, 202, 198, 244, 219, 202, 210, 244, 219, 217, 196, 207, 222, 200, 223, 244, 197, 202, 198, 206, 0}))
//#define strConstOutSide_PRM_PAY_CP_ORDER_ID     beatifulgirl_NSSTRING(((char []) {210, 200, 244, 219, 202, 217, 202, 198, 244, 219, 202, 210, 244, 200, 219, 244, 196, 217, 207, 206, 217, 244, 194, 207, 0}))
//#define strConstOutSide_PAY_EXTRA               beatifulgirl_NSSTRING(((char []) {210, 200, 244, 219, 202, 217, 202, 198, 244, 219, 202, 210, 244, 206, 211, 223, 217, 202, 0}))




#endif /* YCConstantConstant_h */
