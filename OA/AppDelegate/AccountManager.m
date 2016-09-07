//
//  AccountManager.m
//  OA
//
//  Created by Elon Musk on 16/8/3.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "AccountManager.h"

@implementation AccountManager

+ (AccountManager *)sharedManager
{
    static AccountManager *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

//-(instancetype)init{
//    self = [super init];
//    if (self) {
//        
//    }
//    return self;
//}

@end
