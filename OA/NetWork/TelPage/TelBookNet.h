//
//  TelBookNet.h
//  OA
//
//  Created by Elon Musk on 16/8/1.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "BaseHandler.h"

@interface TelBookNet : BaseHandler

+(void)excuteGetTelBookWithSuccess:(SuccessBlock)success failed:(FailedBlock)failed;


@end
