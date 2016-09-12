//
//  IndexNet.m
//  OA
//
//  Created by Elon Musk on 16/7/29.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "IndexNet.h"
#import "ElonHTTPSession.h"
#import "IndexPictureModel.h"
#import "NoticeNewsModel.h"


@implementation IndexNet

+(void)excuteGetPictureWithSuccess:(SuccessBlock)success failed:(FailedBlock)failed{
        NSString *urlEndString = @"News/ImgNews";
    [ElonHTTPSession requestWithRequestType:HTTPSRequestTypeGet urlString:HTTP_CONECT(BASE_URL, urlEndString) paraments:nil completeBlock:^(NSDictionary * _Nullable object, NSError * _Nullable error) {
        NSLog(@"object = %@, error = %@",object,error);
        if ([object isKindOfClass:[NSArray class]]) {
            NSArray *array = [IndexPictureModel mj_objectArrayWithKeyValuesArray:object];
            success(array);
        }else{
            failed(error);
        }
    }];
}


+(void)excuteGetNoticeWithStartPage:(NSInteger )startPage
                            endPage:(NSInteger)endpage
                            Success:(SuccessBlock)success
                             failed:(FailedBlock)failed{
    NSString *urlEndString = [NSString stringWithFormat:@"News/tzgg?ULoginName=%@&ps=%ld&pe=%ld",[AccountManager sharedManager].userName,(long)startPage,(long)endpage];
    NSString *strEnd=[urlEndString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [ElonHTTPSession requestWithRequestType:HTTPSRequestTypeGet urlString:HTTP_CONECT(BASE_URL, strEnd) paraments:nil completeBlock:^(NSDictionary * _Nullable object, NSError * _Nullable error) {
        NSLog(@"%@",object);
        if ([object isKindOfClass:[NSArray class]]) {
            NSArray *array = [NoticeNewsModel mj_objectArrayWithKeyValuesArray:object];
            success(array);
        }else{
            failed(error);
        }
    }];
}

+(void)excuteGetNewsWithStartPage:(NSInteger )startPage
                            endPage:(NSInteger)endpage
                            Success:(SuccessBlock)success
                             failed:(FailedBlock)failed{
    NSString *urlEndString = [NSString stringWithFormat:@"News/news?ULoginName=%@&ps=%ld&pe=%ld",[AccountManager sharedManager].userName,(long)startPage,(long)endpage];
    NSString *strEnd=[urlEndString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [ElonHTTPSession requestWithRequestType:HTTPSRequestTypeGet urlString:HTTP_CONECT(BASE_URL, strEnd) paraments:nil completeBlock:^(NSDictionary * _Nullable object, NSError * _Nullable error) {
        if ([object isKindOfClass:[NSArray class]]) {
            NSArray *array = [NoticeNewsModel mj_objectArrayWithKeyValuesArray:object];
            success(array);
        }else{
            failed(error);
        }
    }];
}

@end
