

#import "YCIapData.h"
#import "YCIapInfo.h"

@implementation YCIapData


//游戏内部直接传递过来的参数
@synthesize userID;
@synthesize playerID;
@synthesize serverCode;
@synthesize productID;
@synthesize remarkStr;
@synthesize roleLevel;
@synthesize roleName;

//访问服务器获取的参数orderID
@synthesize orderId;

//购买成功以后获取的交易信息
@synthesize transactionID;
@synthesize transactionReciptData;

//一些状态，计数器的属性
@synthesize ISPURCHASING;
@synthesize ISREPURCHASE;
@synthesize POST_TIME;
@synthesize APPLE_PAY_FAIL_CODE;

@synthesize currencyCode;
@synthesize currentLocalPrice;


@synthesize checkCallback;

#pragma mark -

//初始化所有参数
-(id)init
{
    self=[super init];
    if (self) {
        //******
        self.userID                = nil;
        self.playerID              = nil;
        self.serverCode            = nil;
        self.productID             = nil;
        self.remarkStr             = nil;
        self.roleLevel             = nil;
        self.roleName              = nil;
        //******
        self.orderId           = nil;
        //******
        self.transactionID         = nil;
        self.transactionReciptData = nil;
        //******
        self.ISPURCHASING          = NO;
        self.ISREPURCHASE          = NO;
        self.WHETHER_USE_REQUESTDATA=NO;
        self.POST_TIME             = 0; //初始化post次数为0
        
        self.currencyCode      = SP_CURRENCY_CODE_DEFAULT_VALUE;
        self.currentLocalPrice = SP_CURRENCY_CODE_DEFAULT_VALUE;
//        self.iapProductArr         = nil;
    }
    return self;
}
//获取到单例
+(YCIapData *)defaultData
{
    static YCIapData * iapDataCenter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        iapDataCenter = [[YCIapData alloc]init];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:iapDataCenter]; // 开始监听交易过程
    });
    return iapDataCenter;
}

#pragma mark -
#pragma mark 清除所有参数
#pragma mark -

-(void)clearMemoryData
{
    //******
    self.userID                = nil;
    self.playerID              = nil;
    self.serverCode            = nil;
    self.productID             = nil;
    self.remarkStr             = nil;
    self.roleLevel             = nil;
    self.roleName              = nil;
    //******
    self.orderId           = nil;
    //******
    self.transactionID         = nil;
    self.transactionReciptData = nil;
    
    self.currencyCode       = SP_CURRENCY_CODE_DEFAULT_VALUE;
    self.currentLocalPrice  = SP_CURRENCY_CODE_DEFAULT_VALUE;
}


#pragma mark - 獲取蘋果商品结果


- (void)validateProductIdentifiers:(NSArray *)productIdentifiers completion:(void (^)())comletion
{
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc]
                                           initWithProductIdentifiers:[NSSet setWithArray:productIdentifiers]];
    productsRequest.delegate = [YCIapData defaultData];
    [productsRequest start];
    
    self.checkCallback = comletion;
}

// SKProductsRequestDelegate protocol method
- (void)productsRequest:(SKProductsRequest *)request
     didReceiveResponse:(SKProductsResponse *)response
{
    if (response.products.count >= 1) {
        self.checkCallback();
    } else {
        [HelloUtils ycu_sToastWithMsg:[NSString stringWithFormat:@" %@ 是无效的商品ID",response.invalidProductIdentifiers[0]]];
    }
}


#pragma mark - 监视AppStore支付结果

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{

    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
            {
                
                [self dismissPurchasingView];
                //如果ispurchasing==no说明是正在进行补单。
                if ([YCIapData defaultData].ISPURCHASING == NO)
                {
                    //如果是在补单过程中，苹果第二次自发的交易，什么也不做
                    if (ISREPURCHASE)
                    {

                    }
                    ISREPURCHASE=YES;
                    SP_IAP_LOG(@"******************************")
                    SP_IAP_LOG(@"paymentQueue start re_purchase,begin read data to memory from local(SKPaymentTransactionStatePurchased)")
                    SP_IAP_LOG(@"******************************")
                    //查看本地有没有上次的信息纪录，如果有上次的纪录，初始化成员变量返回YES，如果没有，返回NO
                    BOOL DOES_HAVE_LOCAL_DATA = [YCIapFunction setDataFromLocal];
                    //如果有记录，并且初始化过数据了，开始下一步服务器验证
                    if (DOES_HAVE_LOCAL_DATA)
                    {
                        ISPURCHASING=YES;
                        SP_IAP_LOG(@"get data from loacl success , set state YES")
                        [YCIapFunction completeTransaction:transaction];
                    }
                    //如果没有，结束交易，清除数据（此方法可能是多余的,但是执行一次没有坏处）
                    else
                    {
                        
                        
                        [YCIapFunction completeTransaction:transaction];
                        
                        SP_IAP_LOG(@"get data from local fail,finish transaction,clear data(local and momery)")
                        //移出交易
                        [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                        //清除数据
                        [IapDataDog removeIapData];
                    }
                }
                //如果是用户点击购买的情况。
                else
                {
                    //如果是在补单过程中，苹果第二次自发的交易，什么也不做
                    if (ISREPURCHASE)
                    {

                    }
                    [YCIapFunction completeTransaction:transaction];
                }
            };break;
                
            case SKPaymentTransactionStateFailed:{
                [self dismissPurchasingView];
                [YCIapFunction failedTransaction:transaction];//自定义方法
            };break;
                
            case SKPaymentTransactionStatePurchasing:
            {
                [self showPurchasingView];
                //广播交易成功消息
                POST_NOTE(NOTE_YC_PAY_ING)
                SP_IAP_LOG(@"one is purchasing (SKPaymentTransactionStatePurchasing)")
            };break;
                
            default:
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];//保险
                break;
        }
    }
}

- (void)showPurchasingView
{
    [HelloUtils ycu_sStarLoadingAtView:nil];
}

- (void)dismissPurchasingView
{
    [HelloUtils ycu_sStopLoadingAtView:nil];
}

@end
