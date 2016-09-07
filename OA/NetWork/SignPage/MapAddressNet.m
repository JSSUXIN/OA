//
//  MapAddressNet.m
//  OA
//
//  Created by Elon Musk on 16/8/9.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "MapAddressNet.h"
#import "ElonHTTPSession.h"
#import "AddressModel.h"

@implementation MapAddressNet

+(void)excuteGetAddressWithURL:(NSString *)url Success:(SuccessBlock)success failed:(FailedBlock)failed{
    [ElonHTTPSession requestWithRequestType:HTTPSRequestTypeGet urlString:url paraments:nil completeBlock:^(NSDictionary * _Nullable object, NSError * _Nullable error) {
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSLog(@"object ==%@",object);
            //            NSArray *array = [TelBookModel parseTelBookWithArray:(NSArray *)object];
            
//            NSArray *array=[AddressModel mj_objectArrayWithKeyValuesArray:object];            
            success(object);
        }else{
            NSLog(@"error ==%@",error);
            failed(error);
        }

    }];
}
@end
