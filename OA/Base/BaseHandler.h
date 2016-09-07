//
//  BaseHandler.h
//  HNGant-HaoLan
//
//  Created by mada on 15/7/8.
//  Copyright (c) 2015年 jsyuci. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseHandler : NSObject

/**
 *  Handler处理成功时调用的Block
 */
typedef void (^SuccessBlock)(id obj);

/**
 *  Handler处理失败时调用的Block
 */
typedef void (^FailedBlock)(id obj);

@end
