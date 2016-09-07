//
//  TelBookModel.m
//  OA
//
//  Created by Elon Musk on 16/8/1.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "TelBookModel.h"
#import "UsersModel.h"

@implementation TelBookModel

+(NSDictionary*)objectClassInArray
{
    return @{@"users":[UsersModel class]};
}

//- (instancetype)initWithCoder:(NSCoder *)coder
//{
//    if (self=[super init]) {
//        _deptName = [coder decodeObjectForKey:@"deptName"];
//        _users = [coder decodeObjectForKey:@"users"];
//        _expanded = [coder decodeBoolForKey:@"expanded"];
//    }
//    return self;
//}
//
////归档方法
//- (void)encodeWithCoder:(NSCoder *)coder
//{
//    [coder encodeObject:_deptName forKey:@"deptName"];
//    [coder encodeObject:_users forKey:@"users"];
//    [coder encodeBool:_expanded forKey:@"expanded"];
//}

MJCodingImplementation
@end
