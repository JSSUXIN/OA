//
//  ElonHTTPSession.m
//  OA
//
//  Created by Elon Musk on 16/7/12.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "ElonHTTPSession.h"
#import "ElonAppClient.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetExportSession.h>
#import <AVFoundation/AVMediaFormat.h>
#import "AFURLRequestSerialization.h"



@implementation ElonHTTPSession

+ (nullable NSURLSessionDataTask *)GET:(nonnull NSString *)urlString
                             paraments:(nullable id)paraments
                         completeBlock:(nullable completeBlock)completeBlock
{
    [ElonAppClient sharedClient].requestSerializer = [AFHTTPRequestSerializer serializer];//请求
    [ElonAppClient sharedClient].responseSerializer = [AFJSONResponseSerializer serializer];//响应

    return [[ElonAppClient sharedClient] GET:urlString
                                parameters:paraments
                                  progress:^(NSProgress * _Nonnull downloadProgress) {
                                  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                      completeBlock(responseObject,nil);
                                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                      completeBlock(nil,error);
                                  }];
}

+ (nullable NSURLSessionDataTask *)POST:(nonnull NSString *)urlString
                              paraments:(nullable id)paraments
                          completeBlock:(nullable completeBlock)completeBlock
{
    // 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误
    
    [ElonAppClient sharedClient].requestSerializer = [AFJSONRequestSerializer serializer];//请求
    [ElonAppClient sharedClient].responseSerializer = [AFHTTPResponseSerializer serializer];//响应

    return [[ElonAppClient sharedClient] POST:urlString parameters:paraments progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
                              NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                              NSLog(@"dict start ----\n%@   \n ---- end  -- ", dict);
                              // 请求成功，解析数据
                              completeBlock(responseObject,nil);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
                              // 请求失败
                              completeBlock(nil,error);

    }];
}

//-(id)AnsyGetWithUrl:(NSString*)url
//{
//    [AFHttpSessionManager manager]
//    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//    AFHTTPRequestOperation *op=[[AFHTTPRequestOperation alloc]initWithRequest:request];
//    
//    op.responseSerializer=[AFJSONResponseSerializer serializer];
//    //必须设置响应类型
//    op.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"application/json"];
//    [op start];
//    [op waitUntilFinished];
//    return [op responseObject];
//}


#pragma mark - 简化
+ (nullable NSURLSessionDataTask *)requestWithRequestType:(HTTPSRequestType)type
                                                urlString:(nonnull NSString *)urlString
                                                paraments:(nullable id)paraments
                                            completeBlock:(nullable completeBlock)completeBlock
{
    switch (type) {
        case HTTPSRequestTypeGet:
        {
            return  [ElonHTTPSession GET:urlString
                             paraments:paraments
                         completeBlock:^(NSDictionary * _Nullable object, NSError * _Nullable error) {
                             completeBlock(object,error);
                         }];
        }
        case HTTPSRequestTypePost:
            return [ElonHTTPSession POST:urlString
                             paraments:paraments
                         completeBlock:^(NSDictionary * _Nullable object, NSError * _Nullable error) {
                             completeBlock(object,error);
                         }];
    }
    
}


#pragma mark -  取消所有的网络请求

/**
 *  取消所有的网络请求
 *  a finished (or canceled) operation is still given a chance to execute its completion block before it iremoved from the queue.
 */

+(void)cancelAllRequest
{
    [[ElonAppClient sharedClient].operationQueue cancelAllOperations];
}


#pragma mark -   取消指定的url请求/
/**
 *  取消指定的url请求
 *
 *  @param requestType 该请求的请求类型
 *  @param string      该请求的完整url
 */

+(void)cancelHttpRequestWithRequestType:(NSString *)requestType
                       requestUrlString:(NSString *)string
{
    NSError * error;
    /**根据请求的类型 以及 请求的url创建一个NSMutableURLRequest---通过该url去匹配请求队列中是否有该url,如果有的话 那么就取消该请求*/
    NSString * urlToPeCanced = [[[[ElonAppClient sharedClient].requestSerializer
                                  requestWithMethod:requestType URLString:string parameters:nil error:&error] URL] path];
    
    for (NSOperation * operation in [ElonAppClient sharedClient].operationQueue.operations) {
        //如果是请求队列
        if ([operation isKindOfClass:[NSURLSessionTask class]]) {
            //请求的类型匹配
            BOOL hasMatchRequestType = [requestType isEqualToString:[[(NSURLSessionTask *)operation currentRequest] HTTPMethod]];
            //请求的url匹配
            BOOL hasMatchRequestUrlString = [urlToPeCanced isEqualToString:[[[(NSURLSessionTask *)operation currentRequest] URL] path]];
            //两项都匹配的话  取消该请求
            if (hasMatchRequestType&&hasMatchRequestUrlString) {
                [operation cancel];
            }
        }
    }
}

- (void)AFNetworkStatus
{
    
    //1.创建网络监测者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    /*枚举里面四个状态  分别对应 未知 无网络 数据 WiFi
     typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus) {
     AFNetworkReachabilityStatusUnknown          = -1,      未知
     AFNetworkReachabilityStatusNotReachable     = 0,       无网络
     AFNetworkReachabilityStatusReachableViaWWAN = 1,       蜂窝数据网络
     AFNetworkReachabilityStatusReachableViaWiFi = 2,       WiFi
     };
     */
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //这里是监测到网络改变的block  可以写成switch方便
        //在里面可以随便写事件
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络状态");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"无网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"蜂窝数据网");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi网络");
                
                break;
                
            default:
                break;
        }
        
    }] ;
}


@end
