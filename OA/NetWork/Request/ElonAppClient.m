//
//  YCAppClient.m
//  OA
//
//  Created by Elon Musk on 16/7/12.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "ElonAppClient.h"

static NSString * const APIBaseURLString = @"http://jssuxin.net:90";


@implementation ElonAppClient

+ (instancetype)sharedClient
{
    static ElonAppClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedClient = [[ElonAppClient alloc] initWithBaseURL:[NSURL URLWithString:APIBaseURLString]];
        
    });
    
    return _sharedClient;
}


-(instancetype)initWithBaseURL:(NSURL *)url
{
    if (self = [super initWithBaseURL:url]) {
        /**设置请求超时时间*/
        self.requestSerializer.timeoutInterval = 5;
        /**设置相应的缓存策略*/
        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        /**分别设置请求以及相应的序列化器*/

        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
//        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];

        /**复杂的参数类型 需要使用json传值-设置请求内容的类型*/
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        /**设置接受的类型*/
        [self.responseSerializer setAcceptableContentTypes:
         [NSSet setWithObjects:@"application/json", nil]];
            }
    
    return self;
}


@end
