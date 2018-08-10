

#import "SPLoginFunction.h"



@implementation SPLoginFunction (BindNormalAccount)

+(void)getVerificationCodeWithAccount:(NSString *)account
                          andPassword:(NSString *)password
                          andPhoneNum:(NSString *)phoneNum
                             andEmail:(NSString *)email
                        andDomainName:(NSString *)domain
                         andForceCode:(NSString *)forceCode
                           completion:(void(^)())completion
{


    
}

+ (void)getVerificationCodeWithAccount:(NSString *)account
                           andPassword:(NSString *)password
                           andPhoneNum:(NSString *)phoneNum
                         andDomainName:(NSString *)domain
                            completion:(void(^)())completion
{
    [SPLoginFunction getVerificationCodeWithAccount:account
                                          andPassword:password
                                          andPhoneNum:phoneNum
                                             andEmail:nil
                                        andDomainName:domain];
}

+ (void)bindAccountConfirm:(NSString *)account
               andPassword:(NSString *)password
                  andEmail:(NSString *)email
             andDomainName:(NSString *)domain
                completion:(void(^)())completion
{
    [SPLoginFunction getVerificationCodeWithAccount:account
                                          andPassword:password
                                          andPhoneNum:nil
                                             andEmail:email
                                        andDomainName:domain];
}

+ (void)bindAccountWithAccount:(NSString *)account
                       andCode:(NSString *)code
                      andPhone:(NSString *)phoneNum
                      andEmail:(NSString *)email
                 andDomainName:(NSString *)domain
                    completion:(void(^)())completion
{


}

+ (void)findPasswordWithAccount:(NSString *)account
                       andPhone:(NSString *)phoneNum
                       andEmail:(NSString *)email
                  andDomainName:(NSString *)domain
                     completion:(void(^)())completion
{

}

+ (void)bindAccountNoConfirm:(NSString *)account
                 andPassword:(NSString *)password
                    andEmail:(NSString *)email
               andDomainName:(NSString *)domain
                  completion:(void(^)())completion
{
    

    
}
@end
