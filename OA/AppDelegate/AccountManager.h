//
//  AccountManager.h
//  OA
//
//  Created by Elon Musk on 16/8/3.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountManager : NSObject

@property (nonatomic,copy) NSString *userName;
@property(copy,nonatomic)NSString *uid;
@property(assign,nonatomic) BOOL loginSucces;
@property(copy,nonatomic)  NSString *headImage;

+ (AccountManager *)sharedManager;

@end
