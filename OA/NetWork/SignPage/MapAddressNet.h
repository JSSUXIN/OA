//
//  MapAddressNet.h
//  OA
//
//  Created by Elon Musk on 16/8/9.
//  Copyright © 2016年 panyongchao. All rights reserved.
//

#import "BaseHandler.h"

@interface MapAddressNet : BaseHandler

+(void)excuteGetAddressWithURL:(NSString *)url Success:(SuccessBlock)success failed:(FailedBlock)failed;

@end
