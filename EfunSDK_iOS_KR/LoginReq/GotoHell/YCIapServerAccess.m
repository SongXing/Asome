

#import "YCIapServerAccess.h"
#import "YCIapInfo.h"
#import <Foundation/Foundation.h>

@implementation YCIapServerAccess
@synthesize iapGetCurrencyQueue;
@synthesize iapPostQueue;

static YCIapServerAccess *_instance;

- (instancetype)init
{
    iapGetCurrencyQueue = dispatch_queue_create("comv.py.iapGetCurrencyBarrierQuere", DISPATCH_QUEUE_SERIAL);
    iapPostQueue = dispatch_queue_create("comv.py.iapPostBarrierQuere", DISPATCH_QUEUE_SERIAL);
    return [super init];
}

+ (instancetype)defaultInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[YCIapServerAccess alloc] init];
    });
    return _instance;
}

+(void)postToServerCheckTransactionAndSentGameColdWithUserId:(NSString * _Nonnull)userId
                                                   andServerCode:(NSString * _Nonnull)serverCode
                                                  andOrderId:(NSString * _Nonnull)orderId
                                                 andCurrencyCode:(NSString * _Nonnull)currencyCode
                                                   andLocalPrice:(NSString * _Nonnull)localPrice
                                                andTransactionId:(NSString * _Nonnull)transactionId
                                                     receiptData:(NSData * _Nonnull)receiptData
{
    dispatch_barrier_async(_instance.iapPostQueue,^{
        dispatch_async(dispatch_get_main_queue(), ^{
    
            [self _postToServerCheckTransactionAndSentGameColdWithUserId:userId
                                                           andServerCode:serverCode
                                                              andOrderId:orderId
                                                         andCurrencyCode:currencyCode
                                                           andLocalPrice:localPrice
                                                        andTransactionId:transactionId
                                                             receiptData:receiptData];
        });
    });
}


+(void)_postToServerCheckTransactionAndSentGameColdWithUserId:(NSString *)userId
                                                andServerCode:(NSString *)serverCode
                                                   andOrderId:(NSString *)orderId
                                              andCurrencyCode:(NSString *)currencyCode
                                                andLocalPrice:(NSString * )localPrice
                                             andTransactionId:(NSString *)transactionId
                                                  receiptData:(NSData *)receiptData
{
    [NetEngine yc_postDataToValiteWithOrderID:orderId
                                 currencyCode:currencyCode
                                   localPrice:localPrice
                                transactionId:transactionId
                                  receiptData:receiptData
                                       userId:userId
                                   serverCode:serverCode
                         andComplitionHandler:^(NSString * _Nullable code, NSString * _Nullable orderID, NSDictionary * _Nullable dic, NSError * _Nullable error) {
                             NSLog(@"验证与发货过程客户端不需要管，等着服务端去发游戏币就完了事");
                             [IapDataDog removeIapData];
                         }];
}

// 程序自验证
+ (void)_verifyTransactionBase64Str:(NSString *)base64Str
{
//    _verifyBase64Str = base64Str;
    static NSString *curReqUrl = @"https://buy.itunes.apple.com/verifyReceipt";
    static NSString *sandboxUrl = @"https://sandbox.itunes.apple.com/verifyReceipt";
    
    NSDictionary *requestDict = @{
                                  @"receipt-data":base64Str //直接使用 string 验证
                                  };
    
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:curReqUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
    [req setHTTPMethod:@"POST"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestDict options:NSJSONWritingPrettyPrinted error:nil];
    [req setHTTPBody:jsonData];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:queue
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                               
                               if (connectionError) {
                                   NSLog(@"error:%@",connectionError);
                               } else {
                                   NSError *error;
                                   NSDictionary *jsonResp = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   if (!jsonResp) {
                                       NSLog(@"jsonresp error:%@",error);
                                   } else {
                                       NSLog(@"bingo:%@",jsonResp);
                                       
                                       NSString *respStatus = jsonResp[@"status"];
                                       switch (respStatus.intValue) {
                                               case 21000:
                                           {
                                               // The App Store could not read the JSON object you provided.
                                           }
                                               break;
                                               case 21002:
                                           {
                                               // The data in the receipt-data property was malformed or missing.
                                               NSLog(@"receipt-data 畸形或丢失");
                                           }
                                               break;
                                               case 21003:
                                           {
                                               // The receipt could not be authenticated.
                                           }
                                               break;
                                               case 21004:
                                           {
                                               // The shared secret you provided does not match the shared secret on file for your account.
                                               // Only returned for iOS 6 style transaction receipts for auto-renewable subscriptions.
                                           }
                                               break;
                                               case 21005:
                                           {
                                               // The receipt server is not currently available.
                                           }
                                               break;
                                               case 21006:
                                           {
                                               // This receipt is valid but the subscription has expired. When this status code is returned to your server, the receipt data is also decoded and returned as part of the response.
                                               // Only returned for iOS 6 style transaction receipts for auto-renewable subscriptions.
                                           }
                                               break;
                                               case 21007:
                                           {
                                               // This receipt is from the test environment, but it was sent to the production environment for verification. Send it to the test environment instead.
                                               NSLog(@"沙盒环境的订单，将要前往沙盒环境服务器验证");
                                               curReqUrl = sandboxUrl;
                                               [self _verifyTransactionBase64Str:base64Str];
                                           }
                                               break;
                                               case 21008:
                                           {
                                               // This receipt is from the production environment, but it was sent to the test environment for verification. Send it to the production environment instead.
                                               
                                           }
                                               break;
                                               case 0:
                                           {
                                               // 成功
                                               /* 此时检测拿到的 inapp 数组是否有数据，若是空的，则 refresh 后再次验证 */
//                                               if (!jsonResp[@"receipt"][@"in_app"]) {
//                                                   if (_verifyCount < 1) {
//                                                       // 2. 如有，则 refresh，需要用户再次输入密码==再次扣款，苹果确认该笔订单已支付，然后将信息添加到服务器对应的订单（可能存在数据延迟的情况，例如苹果未收到玩家的扣款等）
//                                                       [_instance _refreshTransaction];
//                                                       NSLog(@"****** begin refresh transaction *****");
//                                                   }
//                                               }
                                           }
                                               break;
                                               
                                           default:
                                               break;
                                       }
                                       
                                       
                                   }
                               }
                           }];
    
}

@end
