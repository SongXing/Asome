

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface YCIapFunction : NSObject

+(void)startSDK;

//检查没有完成的交易
+(void)checkTransactionUnfinished;

#pragma mark - 订单已经创建好，直接请求内购

+ (void)directToInAppPurchaseWithParams:(NSDictionary *)params;

//交易成功以后
+(void)completeTransaction:(SKPaymentTransaction *)transaction;

//交易失败以后
+(void)failedTransaction:(SKPaymentTransaction *)transaction;

//开启游戏，初始化paymentQueue代理以后，自动补单了，就开始初始化数据0
+(BOOL)setDataFromLocal;


@end
