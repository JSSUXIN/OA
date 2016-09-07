//
//  LoginModel.h
//  OA
//
//  Created by Elon Musk on 16/8/12.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginModel : NSObject

@property(copy,nonatomic)  NSString *uid;
@property(copy,nonatomic)  NSString *name;
@property(copy,nonatomic)  NSString *realName;
@property(copy,nonatomic)  NSString *sex;
@property(copy,nonatomic)  NSString *birthday;
@property(copy,nonatomic)  NSString *mail;
@property(copy,nonatomic)  NSString *mobile;
@property(copy,nonatomic)  NSString *tel;
@property(copy,nonatomic)  NSString *qq;
@property(copy,nonatomic)  NSString *ipAddress;
@property(copy,nonatomic)  NSString *imageUrl;


+(LoginModel *)parseLoginWithDic:(NSDictionary *)dic;
@end

