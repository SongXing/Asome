
#import "YCIapFunction.h"
#import "YCIapInfo.h"

#define kLocalTran_state            @"state"
#define kLocalTran_uid              @"uid"
#define kLocalTran_serverId         @"serverCode"
#define kLocalTran_orderId          @"orderId"
#define kLocalTran_productId        @"productId"
#define kLocalTran_transactionID            @"transactionID"
#define kLocalTran_transactionReciptData    @"transactionReciptData"


@implementation YCIapFunction


/*玩家进入游戏服务器的时候，调用，初始化基本对象，可以进行补单*/
+(void)startSDK
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [YCIapServerAccess defaultInstance];
        [YCIapFunction checkTransactionUnfinished];
        [YCIapData defaultData];
    });
}

#pragma mark - 直接请求Iap

+ (void)directToInAppPurchaseWithParams:(NSDictionary *)params
{    
//    NSLog(@"开始购买：");
//    NSLog(@"开始检查购买环境");
    //1 初始化 iapdata 单例数据
    [YCIapData defaultData].userID      = [YCUser shareUser].uid;
    [YCIapData defaultData].serverCode  = [YCUser shareUser].serverId;
    
    
    //2 检查是否正在购买
    if ([YCIapData defaultData].ISPURCHASING)
    {
        SP_IAP_LOG(@"there is one transaction purchasing")
        //提示原因
        [NSClassFromString(@"HelloUtils") ycu_sToastWithMsg:@"有一笔交易正在进行中"];
        POST_NOTE(NOTE_YC_PAY_FAIL)
        return;
    }
    //3 检查网络是否异常
    if (![SPFunction connectedToNetWork])
    {
        SP_IAP_LOG(@"check no net")
        [NSClassFromString(@"HelloUtils") ycu_sToastWithMsg:@"没有网络"];
        POST_NOTE(NOTE_YC_PAY_FAIL)
        return;
    }
    //4 检查是否允许购买
    if (![SKPaymentQueue canMakePayments])
    {
        SP_IAP_LOG(@"payment queue not support make payment")
        //提示原因
        [NSClassFromString(@"HelloUtils") ycu_sToastWithMsg:@"目前无法进行购买"];
        POST_NOTE(NOTE_YC_PAY_FAIL)
        return;
    }
//    NSLog(@"检查完毕，购买环境 OK ");
    
    NSString *tmpProductID  = [HelloUtils ycu_paraseObjToStr:params[YC_PRM_PAY_PRODUCT_ID]];
    
//    NSLog(@"开始检查 productID 是否存在");
    [[YCIapData defaultData] validateProductIdentifiers:[NSArray arrayWithObjects:tmpProductID, nil]
                                             completion:^{
                                                 
                                                 // 此处回调两次
                                                 
//                                                 NSLog(@" productID 检查完毕，开始正式购买");
                                                 
                                                 //如果都没有问题，开始本地化数据
                                                 [YCIapData defaultData].productID   = params[YC_PRM_PAY_PRODUCT_ID];
                                                 [YCIapData defaultData].orderId     = params[@"yc_product_order_id"];
                                                 
                                                 NSDictionary *baseInfo = @{
                                                                            kLocalTran_uid      :[YCIapData defaultData].userID,
                                                                            kLocalTran_serverId :[YCIapData defaultData].serverCode,
                                                                            kLocalTran_productId:[YCIapData defaultData].productID,
                                                                            kLocalTran_orderId  :[YCIapData defaultData].orderId};
                                                 // 3 纪录购买历史纪录
                                                 [IapDataDog saveParameterDictionaryWithDictionary:baseInfo];
                                                 
                                                 // 4 进行商品购买
                                                 
                                                 SKMutablePayment * aPayment = [[SKMutablePayment alloc] init];
                                                 aPayment.productIdentifier = [YCIapData defaultData].productID;
                                                 /**************************************************************************/
                                                 /**********************************************************************************/
                                                 NSString * paramentsStr=[NSString stringWithFormat:@"uid=%@&serverCode=%@&orderId=%@",
                                                                          [YCIapData defaultData].userID,
                                                                          [YCIapData defaultData].serverCode,
                                                                          [YCIapData defaultData].orderId];
                                                 aPayment.applicationUsername   = paramentsStr;
                                                 
                                                 [[SKPaymentQueue defaultQueue] addPayment:aPayment];
//                                                 [aPayment release];
                                                 
                                             }];
    
}

#pragma mark - 向AppStore付款成功 -

+(void)completeTransaction:(SKPaymentTransaction *)transaction
{
    //验证字符串,通过新的方式获取到receiptData
    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData * receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    
    
    if ([transaction.transactionIdentifier isEqualToString:@""]
        || transaction.transactionIdentifier == nil) {
        [HelloUtils ycu_sToastWithMsg:@"苹果返回的 transactionId 是空的"];
        POST_NOTE(NOTE_YC_PAY_FAIL)
        return;
    }
    
    NSString * parameterStr = transaction.payment.applicationUsername;
    if (parameterStr==nil || [parameterStr isEqualToString:@""])
    {
        [HelloUtils ycu_sToastWithMsg:@"苹果返回的 applicationUsername 是空的,与发起购买传入的数据不正确"];
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        POST_NOTE(NOTE_YC_PAY_FAIL)
        return;
    }
    
    NSDictionary * parameterDic = [self getParameterFromStr:parameterStr];// 此步骤会有一个问题，发了付款之后,在这个方法里面取值有个小问题，subtringwithrangw
    
    if(![parameterDic.allKeys containsObject:@"uid"] ||
       ![parameterDic.allKeys containsObject:@"serverCode"] ||
       ![parameterDic.allKeys containsObject:@"orderId"] )
    {
        [HelloUtils ycu_sToastWithMsg:@"苹果返回的 applicationUsername 数据中有空值,与发起购买传入的数据不正确"];
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        POST_NOTE(NOTE_YC_PAY_FAIL)
        return;
    }
    //是否更新缓存和本地交易记录
    if([[parameterDic objectForKey:@"orderId"] isEqualToString:[YCIapData defaultData].orderId])
    {
        //更新缓存＋购买参数
        [YCIapData defaultData].transactionID           = transaction.transactionIdentifier;
        [YCIapData defaultData].transactionReciptData   = receiptData;
 
        NSDictionary *baseInfo = @{
                                   kLocalTran_state             : SP_PARCHASE_APPLE_PAY_SUCCESS_WAIT_POST_RESOURT,
                                   kLocalTran_uid               : [YCIapData defaultData].userID,
                                   kLocalTran_serverId          : [YCIapData defaultData].serverCode,
                                   kLocalTran_productId         : [YCIapData defaultData].productID,
                                   kLocalTran_orderId           : [YCIapData defaultData].orderId,
                                   kLocalTran_transactionID          : [YCIapData defaultData].transactionID ,
                                   kLocalTran_transactionReciptData  : [YCIapData defaultData].transactionReciptData,
                                   };

        // 3 纪录购买历史纪录
        [IapDataDog saveParameterDictionaryWithDictionary:baseInfo];
        
        NSLog(@"finish transaction");
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        
        //设置状态为YES
        //****************************** 苹果付款收到票据完成，传票据给服务端进行验证并发放游戏币 **********************
        [YCIapData defaultData].ISPURCHASING = NO;
        [YCIapServerAccess      postToServerCheckTransactionAndSentGameColdWithUserId:[parameterDic objectForKey:@"uid"]
                                                                        andServerCode:[parameterDic objectForKey:@"serverCode"]
                                                                           andOrderId:[parameterDic objectForKey:@"orderId"]
                                                                      andCurrencyCode:@"currencyCode"//[SPIapData defaultData].currencyCode
                                                                        andLocalPrice:@"localPrice"//[SPIapData defaultData].currentLocalPrice
                                                                     andTransactionId:transaction.transactionIdentifier
                                                                          receiptData:receiptData];
        
        POST_NOTE(NOTE_YC_PAY_SUCCESS)
        
        // test
//        NSString *base64Str = [SPFunction encode:(uint8_t *)receiptData.bytes length:receiptData.length];
//        [YCIapServerAccess _verifyTransactionBase64Str:base64Str];
    }
    else
    {
        [HelloUtils ycu_sToastWithMsg:@"跟当前单例eoi不相同，需要保存本次信息"];        
        // 临时
        [IapDataDog removeIapData];
        [YCIapData defaultData].ISPURCHASING = NO;
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
    
}

+(NSDictionary *)getParameterFromStr:(NSString *)parameterStr
{
    NSArray * parameterArray        = [parameterStr componentsSeparatedByString:@"&"];
    if (!parameterArray) {
        return nil;
    }
    
    NSMutableDictionary * paraDic   = [[NSMutableDictionary alloc] init];
    for (NSString * oneParameterStr in parameterArray)
    {
        NSRange dengyuhaoRange=[oneParameterStr rangeOfString:@"="];
        NSString * paraKeyStr=[oneParameterStr substringWithRange:NSMakeRange(0, dengyuhaoRange.location)];//报错报在这里
        NSString * paraValueStr=[oneParameterStr substringWithRange:NSMakeRange(dengyuhaoRange.location+1, oneParameterStr.length-dengyuhaoRange.location-1)];
        [paraDic addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:paraValueStr,paraKeyStr, nil]];
    }
    return paraDic;
}


#pragma mark - 向AppStore支付失败以后

+(void)failedTransaction:(SKPaymentTransaction *)transaction
{
    //设置购买状态
    [YCIapData defaultData].ISPURCHASING=NO;
    [YCIapData defaultData].ISREPURCHASE=NO;

    //更新数据
    SP_IAP_LOG(@"queue finish transaction")
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];

    //提示玩家失败原因
    if ([YCIapData defaultData].APPLE_PAY_FAIL_CODE == SKErrorPaymentCancelled)
    {
        [HelloUtils ycu_sToastWithMsg:@"AppStore支付失败，用户取消了购买"];
    }
    else
    {
        [HelloUtils ycu_sToastWithMsg:@"AppStore支付失败，苹果支付异常"];
    }
    
    //发送购买失敗的广播
    POST_NOTE(NOTE_YC_PAY_FAIL)
}

#pragma mark 补单情况

#define _ASSERT_VAL_STR_(str) (!(str==nil) && ![str isEqualToString:@""])

//开启游戏，初始化paymentQueue代理以后，自动补单了，就开始初始化数据0
+(BOOL)setDataFromLocal
{
    
    return NO;
}

/*有两种情况：一，支付成功，向服务器验证；二，支付失败，向服务器通知
此时有十个或者九个参数*/
+(void)checkTransactionUnfinished
{
    NSLog(@"checkTransactionUnfinished");

    //从本地读取数据：从本地获取数据
    NSDictionary * lastTransactionInfodic   = [IapDataDog getParameterDictionary]; // 此处有问题，即充值后因为某种原因中断了，再次补发的时候此处获取到的数据为 nil
    if (!lastTransactionInfodic || lastTransactionInfodic.count <= 0) {
        return;
    }


    NSString * aStateStr                    = [lastTransactionInfodic objectForKey:kLocalTran_state];
    NSString * aUserID                      = [lastTransactionInfodic objectForKey:kLocalTran_uid];

    NSString * aServerCode                  = [lastTransactionInfodic objectForKey:kLocalTran_serverId];

    NSString * aProductID                   = [lastTransactionInfodic objectForKey:kLocalTran_productId];
    NSString * aOrderID                     = [lastTransactionInfodic objectForKey:kLocalTran_orderId];
    NSData * aTransactionReciptData         = [lastTransactionInfodic objectForKey:kLocalTran_transactionReciptData];
    NSString * aTransactionID               = [lastTransactionInfodic objectForKey:kLocalTran_transactionID];

    //系统打印
//    NSString * systemFlag=[NSString stringWithFormat:@"get info from local: %@",lastTransactionInfodic];
//    NSLog(@"%@",systemFlag);

    //如果有記錄，並且參數值都不是空。
    
    if (
        [aStateStr isEqualToString:SP_PARCHASE_APPLE_PAY_SUCCESS_WAIT_POST_RESOURT] &&
        !(lastTransactionInfodic==nil) &&
        !(aUserID==nil) && ![aUserID isEqualToString:@""] &&
        !(aServerCode==nil) && ![aServerCode isEqualToString:@""] &&
        !(aProductID==nil) && ![aProductID isEqualToString:@""]&&
        !(aOrderID==nil) && ![aOrderID isEqualToString:@""]&&
        !(aTransactionReciptData==nil) &&
        !(aTransactionID==nil) && ![aTransactionID isEqualToString:@""]
        )
    {
        if (!
            ([aStateStr isEqualToString:SP_PARCHASE_APPLE_PAY_SUCCESS_WAIT_POST_RESOURT] &&
             !(lastTransactionInfodic==nil) &&
             !(aUserID==nil) && ![aUserID isEqualToString:@""] &&
             !(aServerCode==nil) && ![aServerCode isEqualToString:@""] &&
             !(aProductID==nil) && ![aProductID isEqualToString:@""]&&
             !(aOrderID==nil) && ![aOrderID isEqualToString:@""]&&
             !(aTransactionReciptData==nil) &&
             !(aTransactionID==nil) && ![aTransactionID isEqualToString:@""])
            ) {

//            NSLog( @"checkTransactionUnfinished函数。参数不完整" );

        }

//        NSLog(@"last pay success post server fail,begin init data from localto memory");

        [YCIapData defaultData].ISPURCHASING=YES;
        //清理成员变量
        [[YCIapData defaultData] clearMemoryData];

        //给成员变量赋值
        _ASSERT_VAL_STR_(aUserID)   ? [YCIapData defaultData].userID              = aUserID : nil;
        _ASSERT_VAL_STR_(aServerCode) ? [YCIapData defaultData].serverCode      = aServerCode : nil;
        _ASSERT_VAL_STR_(aProductID) ? [YCIapData defaultData].productID        = aProductID : nil;
        _ASSERT_VAL_STR_(aOrderID) ? [YCIapData defaultData].orderId            = aOrderID : nil;
        aTransactionReciptData ? [YCIapData defaultData].transactionReciptData  = aTransactionReciptData : nil;
        _ASSERT_VAL_STR_(aTransactionID) ? [YCIapData defaultData].transactionID         = aTransactionID : nil;


        //开始补单
//        NSLog(@"init memory from local success,begin post server check and sent game gold");

        [YCIapServerAccess      postToServerCheckTransactionAndSentGameColdWithUserId:[YCIapData defaultData].userID
                                                                        andServerCode:[YCIapData defaultData].serverCode
                                                                           andOrderId:[YCIapData defaultData].orderId
                                                                      andCurrencyCode:@"currencyCode"
                                                                        andLocalPrice:@"localPrice"
                                                                     andTransactionId:[YCIapData defaultData].transactionID
                                                                          receiptData:[YCIapData defaultData].transactionReciptData];

    }
}


@end
