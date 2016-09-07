//
//  LoginNet.m
//  OA
//
//  Created by Elon Musk on 16/8/12.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "LoginNet.h"
#import "LoginModel.h"

@implementation LoginNet



+ (void)excuteLoginWithUserName:(NSString *)username password:(NSString *)password success:(SuccessBlock )success failed:(FailedBlock )failed{
    NSString *string = [NSString stringWithFormat:LOGIN,username,password];
    NSString *endUrl = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    [ElonHTTPSession requestWithRequestType:HTTPSRequestTypeGet urlString:endUrl paraments:nil completeBlock:^(NSDictionary * _Nullable object, NSError * _Nullable error) {
        NSLog(@"object =%@, error = %@",object,error);
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSLog( @"登录了几遍啊");
            LoginModel *loginModel = [LoginModel parseLoginWithDic:object];
        
            success(loginModel);
        }else{
            failed(error);
        }
    }];
}

@end
