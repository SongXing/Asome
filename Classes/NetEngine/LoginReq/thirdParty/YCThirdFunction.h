//
//

#import <Foundation/Foundation.h>


@interface YCThirdFunction : NSObject

+(void)ycy_doThirdLoginWithThirdId:(NSString *)thirdId
                 andThirdPlate:(NSString *)thirdPlate
                 andDomainName:(NSString *)domainName
                 andOtherBlock:(void(^)())block;


+(void)ycy_doAccountBindingWithUserName:(NSString *)userName
                        andPassword:(NSString *)password
                           andEmail:(NSString *)email
                         andLoginId:(NSString *)loginId
                      andThirdPlate:(NSString *)thirdPlate
                      andDomainName:(NSString *)domainName
                      andOtherBlock:(void(^)())block;


@end



