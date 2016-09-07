//
//  TelBookNet.m
//  OA
//
//  Created by Elon Musk on 16/8/1.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "TelBookNet.h"
#import "ElonHTTPSession.h"
#import "TelBookModel.h"
#import "UsersModel.h"

@implementation TelBookNet

+(void)excuteGetTelBookWithSuccess:(SuccessBlock)success failed:(FailedBlock)failed{
    NSString *urlEndString = @"AddressBook/Books";
    [ElonHTTPSession requestWithRequestType:HTTPSRequestTypeGet urlString:HTTP_CONECT(BASE_URL, urlEndString) paraments:nil completeBlock:^(NSDictionary * _Nullable object, NSError * _Nullable error) {
        if ([object isKindOfClass:[NSArray class]]) {
            NSLog(@"object ==%@",object);
            
            [UsersModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"userId":@"id",
                         @"postName":@"postName",
                         @"mobile":@"mobile",
                         @"phone":@"phone",
                         @"headImg":@"headImg",
                         @"name":@"name"};
            }];
            
            NSArray *array=[TelBookModel mj_objectArrayWithKeyValuesArray:object];
            success(array);
        }else{
            NSLog(@"error ==%@",error);
            failed(error);
        }
    }];
}
@end
