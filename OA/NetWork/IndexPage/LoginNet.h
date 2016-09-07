//
//  LoginNet.h
//  OA
//
//  Created by Elon Musk on 16/8/12.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "BaseHandler.h"
#import "ElonHTTPSession.h"

@interface LoginNet : BaseHandler

+ (void)excuteLoginWithUserName:(NSString *)username password:(NSString *)password success:(SuccessBlock )success failed:(FailedBlock )failed;


@end
