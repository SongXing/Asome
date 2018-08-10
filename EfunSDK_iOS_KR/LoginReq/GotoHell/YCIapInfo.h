

#import "SPCentreInfo.h"
#import "YCIapData.h"
#import "SPCentreInfo.h"
#import "SPRequestor.h"
#import "SPSecurityFunction.h"
#import "YCIapServerAccess.h"
#import "YCIapFunction.h"
#import "IapDataDog.h"

#import "HelloUtils.h"
#import "YCUser.h"
#import "HelloHeader.h"

//系统全打印
#define SP_IAP_LOG(flag)                                    if([SPCoreConfReader reader].ISPRINT){NSLog(@"_iap_log:%@",flag);}

#define SP_ONE_PURCHASE_INFO_KEY                            @"YC_ONE_PURCHASE_INFO_KEY"                         //一笔购买的本地保存KEY

#define SP_CURRENCY_CODE_DEFAULT_VALUE @"0"


/*当前交易的状态*/
#define SP_PARCHASE_WAIT_SP_SERVER_ORDERID                      @"SP_PARCHASE_WAIT_SP_SERVER_ORDERID"             //等待SP服务器返回orderid状态
#define SP_PARCHASE_GET_SP_ORDERID_WAIT_PAY_RESULT              @"SP_PARCHASE_GET_SP_ORDERID_WAIT_PAY_RESULT"     //獲取SP orderid成功，等待支付結果
#define SP_PARCHASE_APPLE_PAY_SUCCESS_WAIT_POST_RESOURT         @"APPLE_PAY_SUCCESS_WAIT_POST_RESOURT"                //苹果支付成功，开始给SP服务器验证
#define SP_PARCHASE_APPLE_PAY_FAIL_WAIT_TELL_SP_SERVER          @"SP_PARCHASE_APPLE_PAY_FAIL_WAIT_TELL_SP_SERVER" //苹果服务器支付失败，等待告知服务器结果

