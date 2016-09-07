//
//  ParseModelToAddressBook.h
//  OA
//
//  Created by Elon Musk on 16/8/26.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UsersModel.h"

@interface ParseModelToAddressBook : NSObject

+ (UsersModel *)searchAddressModelWithUserId:(NSString *)uid;

@end
