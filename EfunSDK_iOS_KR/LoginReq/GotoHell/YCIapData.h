
/*
 单例，用来保存购买过程中的全部的内存数据。
（1）一开始购买时候，游戏传递过来的值
    userid
    playerid
    servercode
    productid
    remark
    roleLevel
    roleName
(2)从服务器获取的订单号
    orderid
(3)苹果交易信息
    transactionID
    transactionReceiptData
 
 单例有两个BOOL状态纪录值
    ISPURCHASING ，是否正在交易，由用户点击触发的
    ISREPURCHASE ，是否正在补单，由苹果Framework或者SDK触发的补单中的流程
 
 单例由两个NSInteger 
    POST_TIME           向服务器post验证的次数
    APPLE_PAY_FAIL_CODE 苹果支付失败的状态纪录
 */

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "YCIapInfo.h"

typedef void(^IapCallback)(void);

@interface YCIapData : NSObject
<SKPaymentTransactionObserver,SKProductsRequestDelegate>

//游戏内部直接传递过来的参数
@property (atomic,copy) NSString * userID; //1 用户ID
@property (atomic,copy) NSString * playerID; //2 playerID
@property (atomic,copy) NSString * serverCode; //3 服务器code
@property (atomic,copy) NSString * productID; //4 商品ID
@property (atomic,copy) NSString * remarkStr; //5 remark值
@property (atomic,copy) NSString * roleLevel; //6 角色等级
@property (atomic,copy) NSString * roleName; //7角色名称

//访问服务器获取的参数orderID
@property (atomic,copy) NSString * orderId; //8 服务器给的订单号

//购买成功以后获取的交易信息
@property (atomic,copy) NSString * transactionID; //9 交易订单号
@property (atomic,copy) NSData   * transactionReciptData; //10 交易的验证信息

//一些状态，计数器的属性
@property (atomic       ) BOOL      ISPURCHASING; //是否有交易正在进行
@property (atomic       ) BOOL      ISREPURCHASE; //是否正在重启交易中
@property (atomic       ) BOOL      WHETHER_USE_REQUESTDATA;
@property (atomic       ) NSInteger POST_TIME; //向服务器post验证的次数
@property (atomic       ) NSInteger APPLE_PAY_FAIL_CODE; //支付失败的code纪录

//當前交易的幣種
@property (atomic,strong) NSString * currencyCode;
@property (atomic,strong) NSString * currentLocalPrice;
//@property (atomic,strong) NSArray  * iapProductArr;

// 验证完毕的回调
@property (nonatomic, strong) IapCallback checkCallback;

/*获取单例*/
+(YCIapData *)defaultData;

// 验证内购商品的可用性
- (void)validateProductIdentifiers:(NSArray *)productIdentifiers completion:(void(^)())comletion;

/*清除内存中的参数纪录，全部置为nil*/
-(void)clearMemoryData;

@end
