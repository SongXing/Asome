//
//  YCPPPModel.h
//  YCSDK
//
//  Created by sunn on 2018/7/13.
//

#import <Foundation/Foundation.h>

@interface YCPPPModel : NSObject <NSCoding>
@property (nonatomic, copy) NSArray *detailList;
@property (nonatomic, copy) NSArray *pList;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end

@interface PPPDetailModel : NSObject <NSCoding>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pType;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
