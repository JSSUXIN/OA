//
//  YCAppClient.h
//  OA
//
//  Created by Elon Musk on 16/7/12.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface ElonAppClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end
