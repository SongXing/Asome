
#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface YCIapServerAccess : NSObject

@property (nonatomic, strong) dispatch_queue_t _Nonnull iapPostQueue;
@property (nonatomic, strong) dispatch_queue_t _Nonnull iapGetCurrencyQueue;


+ (instancetype _Nonnull)defaultInstance;

// 发货
+ (void)postToServerCheckTransactionAndSentGameColdWithUserId:(NSString * _Nonnull)userId
                                                andServerCode:(NSString * _Nonnull)serverCode
                                                   andOrderId:(NSString * _Nonnull)orderId
                                              andCurrencyCode:(NSString * _Nonnull)currencyCode
                                                andLocalPrice:(NSString * _Nonnull)localPrice
                                             andTransactionId:(NSString * _Nonnull)transactionId
                                                  receiptData:(NSData * _Nonnull)receiptData;

// 程序自验证
+ (void)_verifyTransactionBase64Str:(NSString *)base64Str;

@end
