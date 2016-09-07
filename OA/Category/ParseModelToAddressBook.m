//
//  ParseModelToAddressBook.m
//  OA
//
//  Created by Elon Musk on 16/8/26.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "ParseModelToAddressBook.h"
#import "UsersModel.h"


@interface ParseModelToAddressBook ()

@end

@implementation ParseModelToAddressBook

//通过uid,获取详细model
+ (UsersModel *)searchAddressModelWithUserId:(NSString *)uid{
    
    UsersModel *userModel = [[UsersModel alloc]init];
    
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                        NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"users.archiver"];
    
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    for (UsersModel *model in arr) {
        if ([uid isEqualToString:model.userId]) {
            userModel = model;
        }
    }
    
    return userModel;
    
}



@end
